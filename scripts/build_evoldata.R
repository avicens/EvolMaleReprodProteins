#Loading arguments
args<-commandArgs(TRUE)
if(length(args)!=4){
  cat("Usage: Rscript build_evoldata.R <genedir> <outputFile>\n")
  cat("\t<genedir>: Path to gene folders\n")
  cat("\t<outputFile>: Path to outputfile\n")
  cat("\t<tissueData>: The list of tissue enriched genes\n")

  q()
}

#Saving arguments
genedir<-args[1]
outputFile<-args[2]
tissueData<-args[3]
tissueName<-args[4]


genelist<-list.files(genedir)
genenames<-data.frame(gene=genelist)

library(data.table)
tisdf<-fread(tissueData,select=c(1,3,16))
tisdata<-merge(genenames, tisdf, by.x="gene",by.y="Gene")
tisdata$Tissue<-rep(tissueName,nrow(tisdata))
names(tisdata)[3]<-"Expression"

#Add columns with number of sequences and sequence length
library(stringr)
nseqs<-as.numeric()
seqlength<-as.numeric()

for (i in 1:length(genelist)){
  
  myfile<-readLines(paste(genedir,"/",genelist[i],"/paml/","M0/out",sep=""))
  
  nseqs[i]<-as.numeric(sapply(strsplit(myfile[4],split = " "),"[",5))
  seqlength[i]<-as.numeric(sapply(strsplit(myfile[4]," "),tail,1))
  
}


#Get columns with evolutionary rates (dN, dS, dN/dS)
dN<-as.numeric()
dS<-as.numeric()
dNdS<-as.numeric()

for (i in 1:length(genelist)){
  
  myfile<-readLines(paste(genedir,"/",genelist[i],"/paml/","M0/out",sep=""))
  
  dN[i]<-as.numeric(str_sub(grep("dN:",myfile,value = T), start=-6))
  dS[i]<-as.numeric(str_sub(grep("dS:",myfile,value = T), start=-7))
  dNdS[i]<-as.numeric(str_sub(grep("omega",myfile,value = T), start=-7))
}


##Get columns with results from selection models (M8 vs M8a)
lhM8=as.numeric()
lhM8a=as.numeric()

for (i in 1:length(genelist)){
  
  myfileM8a<-readLines(paste(genedir,"/",genelist[i],"/paml/","M8a/out",sep=""))
  lhM8a[i]<-as.numeric(sapply(strsplit(myfileM8a[grep("lnL",myfileM8a)],split=": |    "),"[",4))
  
  myfileM8<-readLines(paste(genedir,"/",genelist[i],"/paml/","M8/out",sep=""))
  lhM8[i]<-as.numeric(sapply(strsplit(myfileM8[grep("lnL",myfileM8)],split=": |    "),"[",4))
    
}

lrt<-2*(lhM8-lhM8a)
pval<-1-pchisq(lrt,1) #Likelihood ratio test
padj<-p.adjust(lrt,method="fdr", n=length(lrt)) #Correct p-value for multiple testing

#Positive selection (yes/no)
psgenes<-character()

for (i in 1:length(genelist)) {
  if (padj[i] < 0.05) {
    psgenes[i]="yes"
  }
  else {psgenes[i] = "no"}
  
}

#Number of sites under positive selection
pss<-as.numeric()

for (i in 1:length(genelist)){
  myfile_lrtM8<-readLines(paste(genedir,"/",genelist[i],"/",genelist[i],"_paml.out",sep=""))
  pss[i]<-length(grep("selected",myfile_lrtM8))
}

evoldata<-cbind(genenames,nseqs,seqlength,dN,dS,dNdS,lhM8a,lhM8,lrt, padj, psgenes,pss)
m<-merge(tisdata,evoldata, by= "gene")
write.table(m, file=outputFile, quote=FALSE, sep="\t", row.names=FALSE,col.names=TRUE)
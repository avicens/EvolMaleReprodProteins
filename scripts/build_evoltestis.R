genedir<-"/home/uvi/be/avs/lustre/evolution_male_reprod_proteomes/genes/testis"
genelist<-list.files(genedir)
evoltestis<-data.frame(gene=genelist)

library(stringr)
#Add columns with number of sequences and sequence length
nseqs<-as.numeric()
seqlength<-as.numeric()

for (i in 1:length(genelist)){
  
  myfile<-readLines(paste(genedir,"/",genelist[i],"/paml/","M0/out",sep=""))
  
  nseqs[i]<-as.numeric(sapply(strsplit(myfile[4],split = " "),"[",5))
  seqlength[i]<-as.numeric(sapply(strsplit(myfile[4]," "),tail,1))
  
}

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

lrt<-1-pchisq(2*(lhM8-lhM8a),1) #Likelihood ratio test
padj<-p.adjust(lrt,method="fdr", n=length(lrt)) #Correct p-value for multiple testing


psgenes<-character()

for (i in 1:nrow(evoldata)) {
  if (padj[i] < 0.05) {
    psgenes[i]="yes"
  }
  else {psgenes[i] = "no"}
  
}

#Number of sites under positive selection
pss<-as.numeric()

for (i in 1:length(genelist)){
  myfile_lrtM8<-readLines(paste(genedir,"/",genelist[i],"/paml/",genelist[i],"_M8_M8a.out",sep=""))
  pss[i]<-length(grep("selected",myfile_lrtM8))
}

evoldata<-cbind(evoldata, lhM8a,lhM8,lrt, padj, psgenes,pss)
psgenes<-character()

for (i in 1:nrow(evoltestis)) {
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

evoltestis<-cbind(evoltestis,nseqs,seqlength,dN,dS,dNdS,lhM8,lhM8a,lrt,padj,psgenes,pss)
evoltestis$tissue<-rep("testis",nrow(evoltestis))

testis_df<-read.table("data/testis.tsv",sep="\t",header=T)
evoltestis$expression<-testis_df[testis_df$Gene %in% evoltestis$gene,3]

m<-merge(evoltestis,testis_df[c(1,3)],by.x="gene", by.y="Gene")
colnames(m)[14]="expression"
evoltestis<-m
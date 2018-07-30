genedir<-"/home/uvi/be/avs/lustre/evolution_male_reprod_proteomes/genes"
genelist<-list.files(genedir)
evoltissues<-data.frame(gene=genelist)

library(stringr)
#Add columns with number of sequences and sequence length
nseqs<-as.numeric()
seqlength<-as.numeric()

for (i in 1:length(genelist)){
  
  myfile<-readLines(paste(genedir,"/",genelist[i],"/paml/","M0/out",sep=""))
  
  nseqs[i]<-as.numeric(sapply(strsplit(myfile[4],split = " "),"[",5))
  seqlength[i]<-as.numeric(sapply(strsplit(myfile[4]," "),tail,1))
  
}

evoltissues<-cbind(evoltissues,nseqs,seqlength)

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

evoltissues<-cbind(evoltissues,dN,dS,dNdS)

##Get columns with results from selection models (M8 vs M8a)
lhM8=as.numeric()
lhM8a=as.numeric()

for (i in 1:length(genelist)){
  
  myfileM8a<-readLines(paste(genedir,"/",genelist[i],"/paml/","M8a/out",sep=""))
  lhM8a[i]<-as.numeric(sapply(strsplit(myfileM8a[grep("lnL",myfileM8a)],split=": |    "),"[",4))
  
  myfileM8<-readLines(paste(genedir,"/",genelist[i],"/paml/","M8/out",sep=""))
  lhM8[i]<-as.numeric(sapply(strsplit(myfileM8[grep("lnL",myfileM8)],split=": |    "),"[",4))
  
  
}

lrtM8M8a<-1-pchisq(2*(lhM8-lhM8a),1) #Likelihood ratio test

evoltissues<-cbind(evoltissues, lhM8a,lhM8,lrtM8M8a)

#Positive selection (yes/no)
psgenes<-character()

for (i in 1:nrow(evoltissues)) {
  if (lrtM8M8a[i] < 0.05) {
    psgenes[i]="yes"
  }
  else {psgenes[i] = "no"}
  
}

#Number of sites under positive selection
pssM8<-as.numeric()

for (i in 1:length(genelist)){
  myfile_lrtM8<-readLines(paste(genedir,"/",genelist[i],"/paml/",genelist[i],"_M8_M8a.out",sep=""))
  pssM8[i]<-length(grep("selected",myfile_lrtM8))
}

evoltissues<-cbind(evoltissues,psgenes,pssM8)

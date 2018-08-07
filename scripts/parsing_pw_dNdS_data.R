###R script: Parsing_pw_dNdS_data
###Parsing and plooting pairwise dN/dS estimates between human and several primate species
###Alberto Vicens

####FUNCTIONS####
#globaldnds
#Add dN/dS estimates to the table with dN and dS values per species 
globaldnds<-function(dndstable,dndsout) {
  
  for (i in seq(3,11,by=2)) {
    dnds<-dndstable[,i]/dndstable[,i+1]
    dndstable<-cbind(dndstable,dnds)
    colnames(dndstable)[ncol(dndstable)]=paste("dNdS.with.",sapply(strsplit(colnames(dndstable[i]),split=".",fixed=T),"[",3),sep="")
  }
  
  #Replace infinite and outliers (dN/dS > 5) by NA
  dndstable = lapply(dndstable, function(x) {
    if(any(is.infinite(x))) {
      x[is.infinite(x)] = NA
    }
    x[is.na(x)] = NA
    x[x>5] = NA
    return(x)
  })
  dndstable<-as.data.frame(dndstable)
  assign(dndsout,dndstable,envir=.GlobalEnv)
}



#Load data frames
pw_dnds_seminal<-read.table("Dropbox/evolution_male_reprod_proteomes/data/pairwise_dNdS_seminal.txt",sep="\t",header=T)
pw_dnds_prostate<-read.table("Dropbox/evolution_male_reprod_proteomes/data/pairwise_dNdS_prostate.txt",sep="\t",header=T)
pw_dnds_epididymis<-read.table("Dropbox/evolution_male_reprod_proteomes/data/pairwise_dNdS_epididymis.txt",sep="\t",header=T)
pw_dnds_testis<-read.table("Dropbox/evolution_male_reprod_proteomes/data/pairwise_dNdS_testis.txt",sep="\t",header=T)

#Obtain global dN/dS ratios
globaldnds(pw_dnds_seminal,"dnds_seminal")
globaldnds(pw_dnds_prostate,"dnds_prostate")
globaldnds(pw_dnds_epididymis,"dnds_epididymis")
globaldnds(pw_dnds_testis,"dnds_testis")

#Boxplots
species=c("Bonobo","Chimpanzee","Gorilla","Orangutan","Gibbon") #Vector with species name

par(mfrow=c(2,2))
boxplot(dnds_seminal[,c(13:17)],names=species,ylab="pairwise dN/dS estimates",cexlab=0.8,main="Seminal vesicle")
boxplot(dnds_prostate[,c(13:17)],names=species,ylab="pairwise dN/dS estimates",cexlab=0.8,main="Prostate")
boxplot(dnds_epididymis[,c(13:17)],names=species,ylab="pairwise dN/dS estimates",cexlab=0.8,main="Epididymis")
boxplot(dnds_testis[,c(13:17)],names=species,ylab="pairwise dN/dS estimates",cexlab=0.8,main="Testis")

#Venn diagram of genes with dN/dS > 1

highdnds=list()
for (i in c(1:5)) {
  highdnds[i]<-subset(dnds_testis,dnds_testis[i+12] >= 1,select=Gene.name)
}

names(highdnds)=species
vd<-venn(highdnds,snames = species,ilab=T,cexil=1,zcolor="style",ilabels = T)

###Function extract.high.dnds
#Extract dN/ds values > 1 from the species in the dataset specified and plot and Venn-Diagram plot
extract.high.dnds<-function(dndstab,sp,dndslist) {

highdnds=list()
for (i in c(1:5)) {
  highdnds[i]<-subset(dndstab,dndstab[i+12] >= 1,select=Gene.name)
}

names(highdnds)=species
assign(dndslist,highdnds,envir=.GlobalEnv)
vd<-venn(highdnds,snames = sp,ilab=T,cexil=1,zcolor="style",ilabels = T)
}

extract.high.dnds(dnds_testis,species,"highdnds_seminal")
extract.high.dnds(dnds_testis,species,"highdnds_prostate")
extract.high.dnds(dnds_testis,species,"highdnds_epididymis")
extract.high.dnds(dnds_testis,species,"highdnds_testis")


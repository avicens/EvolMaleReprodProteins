load("data/evoldata")

#Generate data frames for each tissue
epid_df<-read.table("data/tissue_specificity_rna_epididymis.tsv",header=T,sep="\t")
epid_dnds<-evoldata[evoldata$gene %in% epid_df[,1],]
epid_dnds$tissue<-rep("epididymis",nrow(epid_dnds))
epid_dnds$expression<-epid_df[epid_df$Gene %in% evoldata$gene,16]
rm(epid_df)

prost_df<-read.table("data/tissue_specificity_rna_prostate.tsv",header=T,sep="\t")
prost_dnds<-evoldata[evoldata$gene %in% prost_df[,1],]
prost_dnds$tissue<-rep("prostate",nrow(prost_dnds))
prost_dnds$expression<-prost_df[prost_df$Gene %in% evoldata$gene,16]
rm(prost_df)

semin_df<-read.table("data/tissue_specificity_rna_seminal.tsv",header=T,sep="\t")
semin_dnds<-evoldata[evoldata$gene %in% semin_df[,1],]
semin_dnds$tissue<-rep("semfluid",nrow(semin_dnds))
semin_dnds$expression<-semin_df[semin_df$Gene %in% evoldata$gene,16]
rm(semin_df)

#Concatenate data frames
tissues_dnds<-rbind(epid_dnds,prost_dnds,semin_dnds)
tissues_dnds$tissue<-as.factor(tissues_dnds$tissue)

#Plot comapring global dN/dS among tissues
library(ggpubr)

mat<-combn(levels(tissues_dnds$tissue),2)
comp<-lapply(seq_len(ncol(mat)),function(i) mat[,i])
dnds_plot<-ggboxplot(tissues_dnds,x = "tissue", y ="dNdS",color="dNdS", palette="jco",xlab=F,ylab="Global dN/dS") + stat_compare_means(comparisons= comp, label="p.signif")

#Plot comparing global dN/dS among expression categories of each tissue
epidmat<-combn(levels(epid_dnds$expression),2)

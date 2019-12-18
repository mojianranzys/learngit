#!/usr/bin/Rscript
#print("move blood_vcf to ffpe_vcf")
args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
data_id <- unlist(strsplit(sample,"_"))[5]
type <- unlist(strsplit(sample,"_"))[3]
file  <- system(paste0("ls ",path,"*genotype_1_1.csv"),intern=T)
#print(file)
csv_df <- read.csv(file, header=FALSE,skip = 1, fileEncoding="GB18030",fill=TRUE, row.names=NULL)
select_df <- csv_df[csv_df[,14] ==0 & csv_df[,18] !=0,]
result <- mean(select_df[,21])
cat("This",data_id,type,"污染率:",result,"\n")

#!/usr/bin/Rscript
#print("move blood_vcf to ffpe_vcf")
args <- commandArgs(TRUE)
path <- args[1]
path_cf <- args[2]
input <- strsplit(path,"/")[[1]][4]
input_cf <- strsplit(path_cf,"/")[[1]][4]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
data_id <- unlist(strsplit(sample,"_"))[5]
sample_cf <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path_cf),"/")[[1]][2])
data_id_cf <- unlist(strsplit(sample_cf,"_"))[5]
type <- unlist(strsplit(sample,"_"))[3]
type_cf <- unlist(strsplit(sample_cf,"_"))[3]
file  <- system(paste0("ls ",path,"*genotype_1_1.csv"),intern=T)
file_cf  <- system(paste0("ls ",path_cf,"*genotype_1_1.csv"),intern=T)
csv_df <- read.csv(file, header=FALSE,skip = 1, fileEncoding="GB18030",fill=TRUE, row.names=NULL)
csv_cf_df <- read.csv(file_cf, header=FALSE,skip = 1, fileEncoding="GB18030",fill=TRUE, row.names=NULL)
select_df <- csv_df[csv_df[,14] ==0 & csv_df[,18] !=0,]
select_df_cf <- csv_cf_df[csv_cf_df[,14] ==0 & csv_cf_df[,18] !=0,]
result <- mean(select_df[,21])
result_cf <- mean(select_df_cf[,21])
cat("This",data_id,type,"污染率:",result,"\n")
cat("This",data_id_cf,type_cf,"污染率:",result_cf,"\n")

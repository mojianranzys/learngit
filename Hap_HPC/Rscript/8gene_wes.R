#!/usr/bin/Rscript
library(stringr)

args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
print(input)
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
print(sample)
order_id <- paste0(strsplit(sample,"_")[[1]][2],"_",strsplit(sample,"_")[[1]][5])
print(order_id)
new_snv <- paste0(path,"NEW-Annokb-",order_id,".snv-wesplus.csv")
print(new_snv)
new_indel <- paste0(path,"NEW-Annokb-",order_id,".indel-wesplus.csv")
gene8_csv <- paste0("/haplox/users/zhaoys/Script/gene8_wes.csv")
csv_df <- read.csv(gene8_csv, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="GBK")
out_snv_file <- gsub("NEW","Gene8",new_snv)
out_indel_file <- gsub("NEW","Gene8",new_indel)
if(file.exists(new_snv)){
    snv_df <- read.csv(new_snv, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    result_snv <- snv_df[snv_df[, "gene"] %in% csv_df[,1],]
    write.csv(result_snv,file=out_snv_file, fileEncoding="GBK",row.names=FALSE, na=" ", quote = F)
    system(paste0("mv ",path,"Gene8-Annokb-",order_id,".snv-wesplus.csv ",path,"Gene8-Annokb-",order_id,".snv-wesplus_genes8.csv "))
}
if(file.exists(new_indel)){
    indel_df <- read.csv(new_indel, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    result_indel <- indel_df[indel_df[, "gene"] %in% csv_df[,1],]
    write.csv(result_indel,file=out_indel_file, fileEncoding="GBK",row.names=FALSE, na=" ", quote = F)
    system(paste0("mv ",path,"Gene8-Annokb-",order_id,".indel-wesplus.csv ",path,"Gene8-Annokb-",order_id,".indel-wesplus_genes8.csv "))
}

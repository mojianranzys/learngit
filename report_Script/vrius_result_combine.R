#!/usr/bin/Rscript
library(stringr)
args <- commandArgs(TRUE)
path <- args[1]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
virus_dir <- paste0(path,"virus/")
virus_txt <- paste0(virus_dir,"virus_tumor_normal_result.txt")
virus_df <- read.table(virus_txt, header=TRUE, fileEncoding="GB18030",fill=TRUE)
out_virus <- paste0(virus_dir,sample,"_virus_tumor_normal_result.csv")
write.csv(virus_df,file=out_virus,row.names=FALSE, na="", quote = F)


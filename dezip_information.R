#!/usr/bin/Rscript
library(stringr)

args <- commandArgs(TRUE)
csv_df5 <- NULL
sampleSheet <- paste0("/haplox/users/zhaoys/data/brain_cancer/brain_cancer_dezip.csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
out_csv <- paste0("/haplox/users/zhaoys/data/brain_cancer/brain_dezip_rawfqz.csv")
rawrfqz <- NULL
if(nrow(csv_df)>=1){
  for(i in seq(nrow(csv_df))){
    if(csv_df[i,10]==0){
      oss_dir <- paste0("oss://sz-hapseq/rawrfqz/", "20", substr(csv_df[i,1], 1, 4), "/",csv_df[i,1], "/",csv_df[i,2])
    }else{
      oss_dir <- paste0("oss://sz-hapseq/rawrfqz/", "20", substr(csv_df[i,1], 1, 4), "/",csv_df[i,1], "_clinic/",csv_df[i,2])
    }
    cmd <- paste0("ossutil ls ",oss_dir)
    rawrfqz_all <- system(cmd,intern=T)
    myStrsplit <- function(x, split_para){
      unlist(strsplit(x, split=split_para))[8]
    }
    rawrfqz <- c(rawrfqz,unlist(lapply(rawrfqz_all[grepl("oss://.*\\/S\\d+.*.rfq.xz", rawrfqz_all)], myStrsplit, split_para="\\s+")))
    #    print(rawrfqz)
  }
}
rawrfqz <- gsub("oss://sz-hapseq","",rawrfqz)
result <- cbind(rawrfqz,rawrfqz,1)
write.csv(result,file=out_csv, fileEncoding="GBK",row.names=FALSE, na=" ", quote = F)


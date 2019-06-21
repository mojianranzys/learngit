#!usr/bin/Rscript
library(stringr)
args <- commandArgs(TRUE)
samplesheet <- paste0("/haplox/users/zhaoys/Script/shougang/shougang_wes.csv")
csv_df <- read.csv(samplesheet, header=TRUE, stringsAsFactors = FALSE, na=" ", fileEncoding="GBK")
out_csv <- paste0("/haplox/users/zhaoys/Script/shougang/shougang_ossdir.csv")
rawfq_R1 <- NULL
rawfq_R2 <- NULL
if(nrow(csv_df)>=1){
  for(i in seq(nrow(csv_df))){
    oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(csv_df[i,1], 1, 4), "/",csv_df[i,1], "_clinic/",csv_df[i,2])
    cmd <- paste0("ossutil ls ",oss_dir)
    rawfq <- system(cmd,intern=T)
    myStrsplit <- function(x, split_para){
      unlist(strsplit(x, split=split_para))[8]
    }
    rawfq_R1 <- c(rawfq_R1,unlist(lapply(rawfq[grepl("oss://.*\\/S\\d+.*R1.*.fastq.gz", rawfq)], myStrsplit, split_para="\\s+")))
    rawfq_R2 <- c(rawfq_R2,unlist(lapply(rawfq[grepl("oss://.*\\/S\\d+.*R2.*.fastq.gz", rawfq)], myStrsplit, split_para="\\s+")))
    rawfq_combine <- cbind(rawfq_R1,rawfq_R2)
  }
}
result <- cbind(csv_df,rawfq_combine)
write.csv(result,file=out_csv, fileEncoding="GBK",row.names=FALSE, na=" ", quote = F)

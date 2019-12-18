#!/usr/bin/Rscript
library(stringr)
sampleSheet <- paste0("/haplox/users/zhaoys/Hap_HPC/HPCH_02_09_check_451plus_samplesheet_END.csv")
csv_df <- read.csv(sampleSheet, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="GBK")
out_csv <- paste0("/haplox/users/zhaoys/Hap_HPC/HCH201802_09_451_rawfq_dir.csv")
rawfq_all <- NULL
result <- NULL
if(nrow(csv_df)>=1){
  for(i in seq(nrow(csv_df))){
    if(csv_df[i,11]==0){
      oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(csv_df[i,1], 1, 4), "/",csv_df[i,1], "/",csv_df[i,2])
    }
    if(csv_df[i,11]!=0){
      oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(csv_df[i,1], 1, 4), "/",csv_df[i,1], "_clinic/",csv_df[i,2])
    }
    cmd <- paste0("ossutil ls ",oss_dir)
    print(cmd)
    rawfq_all <- system(cmd,intern=T)
    myStrsplit <- function(x, split_para){
      unlist(strsplit(x, split=split_para))[8]
    }
    rawfq_R1 <- unlist(lapply(rawfq_all[grepl("oss://.*\\/S\\d+.*R1.*.fastq.gz", rawfq_all)], myStrsplit, split_para="\\s+"))
    print(rawfq_R1)
    rawfq_R2 <- unlist(lapply(rawfq_all[grepl("oss://.*\\/S\\d+.*R2.*.fastq.gz", rawfq_all)], myStrsplit, split_para="\\s+"))
    ref <- "oss://sz-hapbin/ctdna_pipeline/clinical/ucsc.hg19/ucsc.hg19.fasta"
    sample <- csv_df[i,2]
    project_name <- csv_df[i,2]
    tmp <- cbind(rawfq_R1,rawfq_R2,ref,sample,project_name)
    result <- rbind(result,tmp)
  }
}
write.csv(result,file=out_csv, fileEncoding="GBK",row.names=FALSE, na="", quote = F)



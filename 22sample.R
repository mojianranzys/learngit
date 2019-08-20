#!usr/bin/Rscript
library(stringr)
args <- commandArgs(TRUE)
#input <- args[1]
samplesheet <- paste0("C:/Users/user/Desktop/上机信息v6.0_20190613_share.csv")
samplesheet2 <- paste0("C:/Users/user/Desktop/北大国际段然IIS项目原始数据拷贝-患者名单.csv")
csv_df <- read.csv(samplesheet, header=FALSE, stringsAsFactors = FALSE, na=" ", fileEncoding="GBK")
csv_df2 <- read.csv(samplesheet2,header=TRUE, stringsAsFactors = FALSE, na=" ", fileEncoding="GBK")
out_csv <- gsub("北大国际段然IIS项目","北大国际段然IIS项目_上机信息",samplesheet2)
result <- csv_df[csv_df[,4] %in% csv_df2$受检者,]
write.csv(result,file=out_csv, fileEncoding="GBK",row.names=FALSE, na=" ", quote = F)
###
samplesheet3 <- paste0("/haplox/users/zhaoys/data/brain_cancer/brain_cancer_information.csv")
csv_df3 <- read.csv(samplesheet3, header=FALSE, stringsAsFactors = FALSE, na=" ", fileEncoding="GBK")
out_csv2 <- paste0("/haplox/users/zhaoys/data/brain_cancer/brain_cancer_ossdir.csv")
rawfq_R1 <- NULL
rawfq_R2 <- NULL
if(nrow(csv_df3)>=1){
  for(i in seq(nrow(csv_df))){
    oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(csv_df3[i,1], 1, 4), "/",csv_df3[i,1], "_clinic/",csv_df3[i,2])
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
result <- cbind(csv_df3,rawfq_combine)
write.csv(result,file=out_csv2, fileEncoding="GBK",row.names=FALSE, na=" ", quote = F)

#!/usr/bin/Rscript
library(stringr)
args <- commandArgs(TRUE)
input <- args[1]
sampleSheet <- paste0("/haplox/users/zhaoys/Script/dezip/",input,".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
#print(csv_df[,2])
out_csv <- paste0("/haplox/users/zhaoys/Script/dezip/",input,"_up_oss.csv")
rawrfqz <- NULL
if(nrow(csv_df)>=1){
  for(i in seq(nrow(csv_df))){
    if(csv_df[i,11]==0){
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
  }
}
for(j in seq(length(rawrfqz))){
  print(rawrfqz[j][1])
  system(paste0("ossutil restore ",rawrfqz[j][1]))
}
rawrfqz <- gsub("oss://sz-hapseq","",rawrfqz)
result <- cbind(rawrfqz,rawrfqz,1)
write.csv(result,file=out_csv, fileEncoding="GBK",row.names=FALSE, na="", quote = F)
if(nrow(csv_df) >=1){
  for(i in seq(nrow(csv_df))){
    oss_download <- paste0("/haplox/users/zhaoys/Script/dezip/download_",input,".sh")
    sink(oss_download,append=TRUE)
    if(csv_df[i,11]==0){
      cat(paste0("###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201907/tmp_workflow_repaq-xz-rawfq_1_",input,"/tmp/repaq-xz-rawfq_node_2/ --include ",
                 csv_df[i,2],"*fastq.gz oss://sz-hapseq/rawfq/","20", substr(csv_df[i,1], 1, 4), "/", csv_df[i,1], "/","\n",step=""))
    }else{
      cat(paste0("###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201907/tmp_workflow_repaq-xz-rawfq_1_",input,"/tmp/repaq-xz-rawfq_node_2/ --include ",
                 csv_df[i,2],"*fastq.gz oss://sz-hapseq/rawfq/","20", substr(csv_df[i,1], 1, 4), "/", gsub("\n","",csv_df[i,1]), "_clinic/","\n",step=""))
    }
    sink()
  }  
}
system(paste0("ossutil cp -r ",out_csv, " oss://sz-hapbin/users/zhaoys/dezip_csv/"))
cat(paste0("oss://sz-hapbin/users/zhaoys/dezip_csv/",input,"_up_oss.csv","\n"))
cat("the instance_count :",length(rawrfqz),"\n")

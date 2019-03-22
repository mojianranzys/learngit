#!/usr/bin/Rscript
library(stringr)
sampleSheet <- paste0("/haplox/users/zhaoys/colon/colon_48sample_undezip.csv")
csv_df <- read.csv(sampleSheet, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="GBK")
#print(csv_df[,32])
#print(csv_df[,3])
oss_dir <- paste0("oss://sz-hapseq/rawrfqz/", "20", substr(csv_df[,32], 1, 4), "/", gsub("\n","",csv_df[,32]),  "_clinic/")
#print(oss_dir)
out_csv <- paste0("/haplox/users/zhaoys/colon/colon_48sample_up_oss.csv")

cmd_csv <- paste0("/haplox/users/zhaoys/colon/cmd_colon_48sample.csv")
sink(cmd_csv)
cat(paste0("ossutil ls ", oss_dir,"\n",step=""))
sink()

cmd_df <- read.csv(cmd_csv, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
#print(cmd_df[,1])
rawrfqz_df <- NULL
dir_df <- NULL
for(j in seq(nrow(cmd_df))){
    rawrfqz <- system(cmd_df[j,1], intern = TRUE)
#    print(rawrfqz)
    myStrsplit <- function(x, split_para){
        unlist(strsplit(x, split=split_para))[8]
        }
    rawrfqz_df <- c(rawrfqz_df,unlist(lapply(rawrfqz[grepl("oss://.*_clinic\\/S\\d+.*.rfq.xz", rawrfqz)], myStrsplit, split_para="\\s+")))
}
rawrfqz_df <- unique(rawrfqz_df)
#print(rawrfqz_df)
if(nrow(csv_df) >=1){
    for(i in seq(nrow(csv_df))){
        out_df <- rawrfqz_df[grepl(csv_df[i,3],rawrfqz_df) & grepl(csv_df[i,32],rawrfqz_df)]
        print(out_df)
        oss_restore <- paste0("/haplox/users/zhaoys/colon/restore_colon_48sample.sh")
        oss_download <- paste0("/haplox/users/zhaoys/colon/download_colon_48sample.sh")
        sink(oss_restore,append =TRUE)
        cat(paste0("###\n","ossutil restore ",out_df,"\n",step=""))
        sink()
        dir <- gsub("oss://sz-hapseq","",out_df)
        dir_df <- c(dir_df,dir)
#        print(dir_df)
        sink(oss_download,append = TRUE)
        cat(paste0("###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201903/tmp_workflow_repaq-xz-rawfq_1_colon_48sample/tmp/repaq-xz-rawfq_node_2/ --include *",
        csv_df[i,3],"*fastq.gz oss://sz-hapseq/rawfq/","20", substr(csv_df[i,32], 1, 4), "/", gsub("\n","",csv_df[i,32]), "_clinic/","\n",step=""))
        sink()
        }

       sink(out_csv,append = TRUE)
       for(i in seq(length(dir_df))){
           cat(paste0(dir_df[i],",", dir_df[i],"\n", step=""))
       }
      sink()
}



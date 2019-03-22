#!/usr/bin/Rscript
library(stringr)
print("zhaoys")
cat("zhaoys\n")
args <- commandArgs(TRUE)
sampleSheet <- paste0("/haplox/users/zhaoys/data/lihong/lihong.csv")
csv_df <- read.csv(sampleSheet, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
if(nrow(csv_df) >= 1){
    for(i in seq(nrow(csv_df))){
            rawout <- paste0("/haplox/users/zhaoys/data/lihong/")
            if(!file.exists(rawout)){
                dir.create(rawout, recursive = TRUE)
                }
            print(csv_df[,3])
            sh_file <- paste0(rawout, "/oss_downloand.sh")
            sink(sh_file,append = TRUE)
            cat(paste0("###\n","ossutil cp -r oss://sz-hapseq/rawfq/","20", substr(csv_df[i,32], 1, 4),"/",csv_df[i,32],"_clinic/ --include *",csv_df[i,3],"* ",rawout,"\n",step=" "))
            sink()
    }
}


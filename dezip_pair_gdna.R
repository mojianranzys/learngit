#!/usr/bin/Rscript
library(stringr)

args <- commandArgs(TRUE)
input <- args[1]
input2 <- args[2]
csv_df5 <- NULL
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
sampleSheet2 <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")

csv_df1 <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
csv_df2 <- read.csv(sampleSheet2, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
csv_df3 <- csv_df1[csv_df1[, 9] %in% c("cfdna", "healthcfdna", "ttdna", "ffpedna") & grepl("³¦¿µ",csv_df1[,25]), ]
#    print(csv_df3[,15])
if(nrow(csv_df3) <= 0){
  print("no data for tumor")
  quit(save = "no")
}
csv_df4 <- csv_df2[grepl("gdna|saldna|healthgdna|ntdna|atdna",csv_df2[, 1] ) & grepl("wesplus|gdna",csv_df2[, 1] ), ]
#    print(csv_df4[,1])
cat(nrow(csv_df3), "===", nrow(csv_df4), "=====\n")
if(nrow(csv_df4) <= 0){
  print("no gdna")
  quit(save = "no")
}    

NCOL <- ncol(csv_df4)
csv_df4[, (NCOL+1):(NCOL+5)] <- str_match(csv_df4[,1], "S(.*?)_(.*?)_(.*?)_(.*?)_(\\d+)")[, 2:6]
#   print(csv_df4[1, 10])
if(csv_df4[1, 10] == 0){
  oss_dir <- paste0("oss://sz-hapseq/rawrfqz/", "20", substr(input2, 1, 4), "/", input2)
}else{
  oss_dir <- paste0("oss://sz-hapseq/rawrfqz/", "20", substr(input2, 1, 4), "/", input2,  "_clinic/")
}
cmd <- paste0("ossutil ls ", oss_dir)
#    print(cmd)
txt <- system(cmd, intern = TRUE)
#    print(txt)
myStrsplit <- function(x, split_para){
  unlist(strsplit(x, split=split_para))[8]
}
txt_input <- unlist(lapply(txt[grepl("oss://.*_clinic\\/S\\d+.*.rfq.xz", txt)], myStrsplit, split_para="\\s+"))
#    print(txt_input)
myStrsplit <- function(x, split_para){
  unlist(strsplit(x, split=split_para))[8]
}
date <- Sys.Date()
for(i in seq(nrow(csv_df3))){
  for(j in seq(nrow(csv_df4))){
    if(csv_df3[i, 3] == csv_df4[j, 3] && csv_df3[i, 15] == csv_df4[j, 15]){
      restore_dir <- txt_input[grepl(csv_df4[j,1], txt_input)] 
      print(restore_dir)
      oss_restore <- paste0("/haplox/users/zhaoys/Script/dezip/oss_restore_",gsub("-","",date),".sh")
      oss_download <- paste0("/haplox/users/zhaoys/Script/dezip/oss_download_",gsub("-","",date),".sh")
      sink(oss_restore,append =TRUE)
      cat(paste0("###\n","ossutil restore ",restore_dir,"\n",step=""))
      sink()
      dir <- gsub("oss://sz-hapseq","",restore_dir)
      csv_df5 <- c(csv_df5,dir)
      print(csv_df5)
      sink(oss_download,append = TRUE)
      cat(paste0("###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/",substr(gsub("-","",date),1,6),
                 "/tmp_workflow_repaq-xz-rawfq_1_",gsub("-","_",date),"/tmp/repaq-xz-rawfq_node_2/ --include ",
                 csv_df4[j,1],"*fastq.gz oss://sz-hapseq/rawfq/","20", substr(input2, 1, 4), "/", input2,  "_clinic/","\n",step=""))
      sink()
    }
  }
}
out_csv <- paste0("/haplox/users/zhaoys/Script/dezip/dezip_",gsub("-","",date),".csv")
if(!file.exists(out_csv)){
  file.create(out_csv, recursive = TRUE)
}else{
  print("this file is exits")
}

sink(out_csv,append = TRUE)
for(i in seq(length(csv_df5))){
  cat(paste0(csv_df5[i],",", csv_df5[i],"\n", step=""))
}
sink()

#!/usr/bin/Rscript
library(stringr)

args <- commandArgs(TRUE)
input <- args[1]
input2 <- args[2]
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
sampleSheet2 <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")

csv_df1 <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
csv_df2 <- read.csv(sampleSheet2, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")

NCOL <- ncol(csv_df1)
NCOL2 <- ncol(csv_df2)
csv_df1[, (NCOL+1):(NCOL+5)] <- str_match(csv_df1[,1], "S(.*?)_(.*?)_(.*?)_(.*?)_(\\d+)")[, 2:6]
csv_df2[, (NCOL2+1):(NCOL2+5)] <- str_match(csv_df2[,1], "S(.*?)_(.*?)_(.*?)_(.*?)_(\\d+)")[, 2:6]
oss_dir_input <- paste0("oss://sz-hapseq/rawfq/", "20", substr(input, 1, 4), "/", input,  "_clinic/")
oss_dir_input2 <- paste0("oss://sz-hapseq/rawfq/", "20", substr(input2, 1, 4), "/", input2,  "_clinic/")
cmd <- paste0("ossutil ls ", oss_dir_input)
cmd2 <- paste0("ossutil ls ", oss_dir_input2)
#   print(cmd)
txt <- system(cmd, intern = TRUE)
txt2 <- system(cmd2, intern = TRUE) 
#    print(txt)
myStrsplit <- function(x, split_para){
  unlist(strsplit(x, split=split_para))[8]
}
txt_input_R1 <- unlist(lapply(txt[grepl("oss://.*_clinic\\/S\\d+.*R1.*fastq.gz", txt)], myStrsplit, split_para="\\s+"))
txt_input_R2 <- unlist(lapply(txt[grepl("oss://.*_clinic\\/S\\d+.*R2.*fastq.gz", txt)], myStrsplit, split_para="\\s+"))
txt_input2_R1 <- unlist(lapply(txt2[grepl("oss://.*_clinic\\/S\\d+.*R1.*fastq.gz", txt2)], myStrsplit, split_para="\\s+"))
txt_input2_R2 <- unlist(lapply(txt2[grepl("oss://.*_clinic\\/S\\d+.*R2.*fastq.gz", txt2)], myStrsplit, split_para="\\s+"))
#    print(txt_input)
myStrsplit <- function(x, split_para){
  unlist(strsplit(x, split=split_para))[8]
}
out_csv <- paste0("/haplox/users/zhaoys/Script/merge_clinic/merge_",input,"_",input2,".csv")
if(!file.exists(out_csv)){
  file.create(out_csv, recursive = TRUE)
}else{print("this file is exits")
}
for(i in seq(nrow(csv_df1))){
  for(j in seq(nrow(csv_df2))){
    if(csv_df1[i, 3] == csv_df2[j, 3] && csv_df1[i, 1] != csv_df2[j, 1] && csv_df1[i, 2] == csv_df2[j, 2] && csv_df1[i, 9] == csv_df2[j, 9] && csv_df1[i, 15] == csv_df2[j, 15]){
      merge_input_R1 <- txt_input_R1[grepl(csv_df1[i,1], txt_input_R1)]
      merge_input_R2 <- txt_input_R2[grepl(csv_df1[i,1], txt_input_R2)]
      merge_input2_R1 <- txt_input2_R1[grepl(csv_df2[j,1], txt_input2_R1)]
      merge_input2_R2 <- txt_input2_R2[grepl(csv_df2[j,1], txt_input2_R2)]
      rawfq_R1_1 <- gsub("oss://sz-hapseq","",merge_input_R1)
      rawfq_R2_1 <- gsub("oss://sz-hapseq","",merge_input_R2)
      rawfq_R1_2 <- gsub("oss://sz-hapseq","",merge_input2_R1)
      rawfq_R2_2 <- gsub("oss://sz-hapseq","",merge_input2_R2)
      #                    print(rawfq_R1_1)
      sink(out_csv,append= TRUE)
      cat(paste0(rawfq_R1_1,",", rawfq_R1_2,",","1","\n", rawfq_R2_1,",", rawfq_R2_2,",","1","\n", step=""))
      sink()
    }
  }
}
if(file.exists(out_csv)){
  system(paste("ossutil cp -r ",out_csv," oss://sz-hapbin/users/zhaoys/merge_csv/"))
}
cat(paste0("the oss_hapyun dir : oss://sz-hapbin/users/zhaoys/merge_csv/merge_",input,"_",input2,".csv","\n"))
tmp <- paste0("wc -l ",out_csv)
num <- system(tmp,intern=TRUE)
cat("the instance_count :",num,"\n")



#!/usr/bin/Rscript
library(stringr)

args <- commandArgs(TRUE)
path <- args[1]
input2 <- args[2]
input <- strsplit(path,"/")[[1]][4]
#print(input)
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
#print(sample)
cmd <- paste0("ls ",path,"germline/result/*curl.xls")
txt <- system(cmd,intern = T)
normal_trans <- strsplit(txt,"/")[[1]][9]
normal <- gsub("_trans","",strsplit(normal_trans,"[.]")[[1]][1])
#print(normal)
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
for(i in seq(nrow(csv_df))){
    if(csv_df[i,1]==normal){
        if((grepl("男",csv_df[i,5]) && grepl("male",normal_trans)) ||(grepl("女",csv_df[i,5]) && grepl("femal",normal_trans))){
            print("this sample's sex is True")
        }
        else{
            print("this sample's sex is False")
            sex_warning <- paste0("/haplox/rawout/",input,"/Warning_bamqc_snp_sex/sex_false/",sample)
            if(!file.exists(sex_warning)){
                dir.create(sex_warning,recursive = T)
            }
            system(paste0("cp -r ",path,"/cnv/*geneschrX.csv ",sex_warning,"/\n",
            "cp  -r ",path,"germline/result/*trans.cancer* ",sex_warning,"/\n"))
        }
    }
}

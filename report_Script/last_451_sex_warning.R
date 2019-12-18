#!/usr/bin/Rscript
library(stringr)

args <- commandArgs(TRUE)
path <- args[1]
input2 <- args[2]
input <- strsplit(path,"/")[[1]][4]
print(input)
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
print(sample)
cmd <- paste0("ls ",path,"germline/result/*curl.xls")
txt <- system(cmd,intern = T)
normal_trans <- strsplit(txt,"/")[[1]][8]
print(normal_trans)
sex <- strsplit(normal_trans,"_")[[1]][8]
print(sex)
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
for(i in seq(nrow(csv_df))){
    if(grepl(csv_df[i,1],normal_trans)){
        if((grepl("男",csv_df[i,5]) & sex == "male") | (grepl("女",csv_df[i,5]) & sex == "female")){
            cat(csv_df[i,3],csv_df[i,5],"this sample's sex is True","\n")
        }
        if((grepl("女",csv_df[i,5]) & sex == "male") | (grepl("男",csv_df[i,5]) & sex == "female")){
            cat(csv_df[i,3],csv_df[i,5],"this sample's sex is False","\n")
            sex_warning <- paste0("/haplox/rawout/",input,"/Warning_bamqc_snp_sex/sex_false/",sample)
            if(!file.exists(sex_warning)){
                dir.create(sex_warning,recursive = T)
            }
            system(paste0("cp -r ",path,"cnv/*geneschrX.csv ",sex_warning,"/\n",
            "cp  -r ",path,"germline/result/*trans.cancer* ",sex_warning,"/\n"))
        }
    }
}

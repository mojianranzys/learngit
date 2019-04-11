#!/usr/bin/Rscript
library(stringr)

args <- commandArgs(TRUE)
sampleSheet <- paste0("/haplox/users/zhaoys/Script/data_id_sample/sheet_all.csv") #上机信息总表
sampleSheet2 <- paste0("/haplox/users/zhaoys/Script/data_id_sample/data_id.csv") #含data_id和姓名的表

csv_df1 <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
csv_df2 <- read.csv(sampleSheet2, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="GBK")
out_df <- paste0("/haplox/users/zhaoys/Script/data_id_sample/vcf/")
if(nrow(csv_df2)>=1){
    for(i in seq(nrow(csv_df2))){
        for(j in seq(nrow(csv_df1))){
            if(csv_df2[i,2]==csv_df1[j,23] & csv_df2[i,1]==csv_df1[j,4]){
                if(grepl("ffpedna|ttdna|pedna",csv_df2[i,3])){
                    system(paste0("cp -r ",csv_df1[j,1],"/ffpedna_vs_gdna/",csv_df1[j,2],"_snv_annovar.hg19_multianno.vcf ",out_df))
                    system(paste0("cp -r ",csv_df1[j,1],"/ffpedna_vs_gdna/",csv_df1[j,2],"_indel_annovar.hg19_multianno.vcf ",out_df))
                }
                else{
                    system(paste0("cp -r ",csv_df1[j,1],"/",csv_df1[j,2],"_snv_annovar.hg19_multianno.vcf ",out_df))
                    system(paste0("cp -r ",csv_df1[j,1],"/",csv_df1[j,2],"_indel_annovar.hg19_multianno.vcf ",out_df))
                }
            }
        }
    }
}



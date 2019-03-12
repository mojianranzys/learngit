#!/usr/bin/Rscript
print("HPC_check_review")

args <- commandArgs(TRUE)
input <- args[1]

sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
review_dir <- paste0("/haplox/hapreports/12.zszl_crc_chemo_2018/待审核/",input)
report_dir <- paste0("/haplox/hapreports/12.zszl_crc_chemo_2018/working/", input)

csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
tumor_df <- csv_df[grepl("cfdna|healthcfdna|pedna|ttdna|ffpedna",csv_df[,9]) & grepl("肠康",csv_df[,25]),]
data <- read.table("/haplox/users/zhaoys/Script/hpc_report.txt",sep="\t",header=FALSE,stringsAsFactors = FALSE,fileEncoding="GBK")
#print(data[3,1])
cmd_working <- paste0("ls ", report_dir,"/*docx")
cmd_review <- paste0("ls ",review_dir,"/*/*docx")

review <- system(cmd_review,intern = TRUE)
#print(review)
working <- system(cmd_working,intern = TRUE)
#print(working)
n = 1
if(nrow(tumor_df) >= 1){
    for(i in seq(nrow(tumor_df))){
        hap_review <- review[grep(tumor_df[i,3],review)]
        hap_working <- working[grep(tumor_df[i,3],working)]
        if(length(hap_working)==0){
            if(length(hap_review)==0){
                for(j in seq(nrow(data))){
                    if(grepl(tumor_df[i,23],data[j,1])){
                        data_id <- c(strsplit(data[j,1],"；"))
                        for( n in 1:(length(data_id[[1]]))){
                            if(grepl(tumor_df[i,23],data_id[[1]][n])){
                                data_name_rev <- substr(stringi::stri_reverse(data_id[[1]][n]),1,2)
                                data_name <- stringi::stri_reverse(data_name_rev)
                            }
                        }
                    }
                }
         cat(tumor_df[i,3],tumor_df[i,23],data_name,"未出\n")
         next 
         }
         next
    }
        if(file_test("-f",hap_review) && length(hap_working)==0){
            cat(tumor_df[i,3],tumor_df[i,23],strsplit(hap_review,"/")[[1]][7],"待审核\n")
            next
        }
        if(length(hap_working)!=0){
            cat(tumor_df[i,3],tumor_df[i,23],"已出\n")
        }
}
}

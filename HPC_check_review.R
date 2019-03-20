#!/usr/bin/Rscript
print("HPC_check_review")

args <- commandArgs(TRUE)
input <- args[1]

sampleSheet <- paste0("/x01_haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
review_dir <- paste0("/x01_haplox/hapreports/12.zszl_crc_chemo_2018/待审核/",input)
report_dir <- paste0("/x01_haplox/hapreports/12.zszl_crc_chemo_2018/working/", input)

csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
tumor_df <- csv_df[grepl("cfdna|healthcfdna|pedna|ttdna|ffpedna",csv_df[,9]) & grepl("IDT",csv_df[,11]) & grepl("肠康",csv_df[,25]),]
print(tumor_df[,3])
cmd_working <- paste0("ls ", report_dir,"/*docx")
cmd_review <- paste0("ls ",review_dir,"/*/*docx")

review <- system(cmd_review,intern = TRUE)
working <- system(cmd_working,intern = TRUE)

if(nrow(tumor_df) >= 1){
    for(i in seq(nrow(tumor_df))){
        hap_review <- review[grep(tumor_df[i,3],review)]
        hap_working <- working[grep(tumor_df[i,3],working)]
        if(length(hap_working)!=0){
            cat(tumor_df[i,3],tumor_df[i,23],"已出\n")
        }
        if(length(hap_working)==0 && length(hap_review)!=0){
            cat(tumor_df[i,3],tumor_df[i,23],strsplit(hap_review,"/")[[1]][7],"待审核\n")
        }
        if(length(hap_working)==0 && length(hap_review)==0 ){
            cat(tumor_df[i,3],tumor_df[i,23],"未出\n")
        }
    }
}

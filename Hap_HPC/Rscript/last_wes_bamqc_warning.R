#!/usr/bin/Rscript
library(stringr)

args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
#print(input)
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
#print(sample)
cmd <- paste0("ls ",path,"BamQC/*/bam_pileup_QC/*bam_qc.csv")
txt <- system(cmd,intern = T)
tmp <- strsplit(txt,"/")
for(i in seq(length(tmp))){
    if(grepl("ttdna|ffpedna|pedna",tmp[[i]][10])){
        tumor_qc <- tmp[[i]][10]
        tumor <- strsplit(tumor_qc,"[.]")[[1]][1]
#        print(tumor)
        }
    if(grepl("atdna|gdna",tmp[[i]][10])){
       normal_qc <- tmp[[i]][10]
       normal <- strsplit(normal_qc,"[.]")[[1]][1]
#       print(normal)
       }
}
tumor_df <- paste0(path,"BamQC/",tumor,"/bam_pileup_QC/",tumor_qc)
normal_df <- paste0(path,"BamQC/",normal,"/bam_pileup_QC/",normal_qc)
qc_tumor <- read.csv(tumor_df, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="utf-8")
qc_normal <- read.csv(normal_df, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="utf-8")
cat(tumor,qc_tumor[,"target_ave_depth"],qc_tumor[,"capture_rate"],"\n")
cat(normal,qc_normal[,"target_ave_depth"],qc_normal[,"capture_rate"],"\n")
if(str_extract(qc_tumor[,"capture_rate"],"\\d+") <= 30 | str_extract(qc_tumor[,"target_ave_depth"],"\\d+") <= 100 ){
    out_df <- paste0("/haplox/rawout/",input,"/Warning_bamqc_snp_sex/",sample)
    if(!file.exists(out_df)){
        dir.create(out_df,recursive = TRUE)
    }
    system(paste0("cp ",tumor_df," ",out_df))
}
if(str_extract(qc_normal[,"capture_rate"],"\\d+") <= 30 | str_extract(qc_normal[,"target_ave_depth"],"\\d+") <= 100 ){
    out_df <- paste0("/haplox/rawout/",input,"/Warning_bamqc_snp_sex/",sample)
    if(!file.exists(out_df)){
        dir.create(out_df,recursive = TRUE)
    }
    system(paste0("cp ",normal_df," ",out_df))
}

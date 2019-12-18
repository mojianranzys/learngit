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
    if(grepl("cfdna",tmp[[i]][9])){
        tumor_qc <- tmp[[i]][9]
#        print(tumor_qc)
        tumor <- strsplit(tumor_qc,"[.]")[[1]][1]
#        print(tumor)
        }
    if(grepl("gdna",tmp[[i]][9])){
       normal_qc <- tmp[[i]][9]
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
if(as.numeric(str_extract(qc_tumor[,"capture_rate"],"\\d+")) <= 30 | as.numeric(str_extract(qc_tumor[,"target_ave_depth"],"\\d+")) <= 500 ){
    cat(tumor,qc_tumor[,"target_ave_depth"],qc_tumor[,"capture_rate"],"质控不合格\n")
    out_df <- paste0("/haplox/rawout/",input,"/Warning_bamqc_snp_sex/bamqc_bad/",sample)
    if(!file.exists(out_df)){
        dir.create(out_df,recursive = TRUE)
    }
    system(paste0("cp ",tumor_df," ",out_df))
}
if(as.numeric(str_extract(qc_normal[,"capture_rate"],"\\d+")) <= 30 | as.numeric(str_extract(qc_normal[,"target_ave_depth"],"\\d+")) <= 500 ){
    cat(normal,qc_normal[,"target_ave_depth"],qc_normal[,"capture_rate"],"质控不合格\n")
    out_df <- paste0("/haplox/rawout/",input,"/Warning_bamqc_snp_sex/bamqc_bad/",sample)
    if(!file.exists(out_df)){
        dir.create(out_df,recursive = TRUE)
    }
    system(paste0("cp ",normal_df," ",out_df))
}

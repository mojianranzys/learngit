#!usr/bin/Rscript
library(stringr)
args <- commandArgs(TRUE)
sheet1 <- paste0("/haplox/users/zhaoys/data/crc_ngs/changkang_erdaicexu_information.csv")
csv_df <- read.csv(sheet1, header=FALSE, stringsAsFactors = FALSE, na="", fileEncoding="GBK")
if(nrow(csv_df)>= 1){
  for(i in seq(nrow(csv_df))){
    #    cat(csv_df[i,1],csv_df[i,4],"\n")
    if(grepl("cfdna",csv_df[i,2])){
      path <- paste0("/haplox/rawout/",csv_df[i,1],"/",csv_df[i,2],"/")
    }
    else{
      path <- paste0("/haplox/rawout/",csv_df[i,1],"/ffpedna_vs_gdna/",csv_df[i,2],"/")
    }
    vcf_snv <- paste0(path,csv_df[i,2],"_snv_annovar.hg19_multianno.vcf")
    vcf_indel <- paste0(path,csv_df[i,2],"_indel_annovar.hg19_multianno.vcf")
    snv_result <- system(paste0("ls ",vcf_snv))
    system(paste0("cp -r ",path,csv_df[i,2],"_snv_annovar.hg19_multianno.vcf /haplox/users/zhaoys/data/crc_ngs/crc_ngs_vcf/"))
    system(paste0("cp -r ",path,csv_df[i,2],"_indel_annovar.hg19_multianno.vcf /haplox/users/zhaoys/data/crc_ngs/crc_ngs_vcf/"))
    indel_result <- system(paste0("ls ",vcf_indel))
    if(snv_result == 0 & indel_result==0){
      cat(csv_df[i,1],csv_df[i,4],"ÓÐsnv_inde_vcf\n")
    }
    else{cat(csv_df[i,1],csv_df[i,4],"ÎÞsnv_inde_vcf\n")
    }
  }
}

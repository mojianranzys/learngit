#!/usr/bin/Rscript
#print("move blood_vcf to ffpe_vcf")
args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
data_id <- strsplit(sample,"_")[[1]][5]
order <- strsplit(sample,"_")[[1]][2]
library(stringr)
args <- commandArgs(TRUE)
if(grepl("ffpedna|ttdna|pedna|fnadna",sample)){
  Annokb_snv <- paste0(path,"Annokb_mrbam_",order,"_",data_id,".snv-nobias-GB18030-baseline-genes464.csv")
  Annokb_indel <- paste0(path,"Annokb_mrbam_",order,"_",data_id,".indel-nobias-GB18030-baseline-genes464.csv")
  if(file.exists(Annokb_snv)){
    snv_df <- read.csv(Annokb_snv, header=T, stringsAsFactors = FALSE, na=" ", fileEncoding="GBK")
    snv_df$VAF_percent_tumor <- snv_df$VAF_percent_blood
    snv_df$VAF_percent_blood <- NA
    write.csv(snv_df,file=Annokb_snv,row.names=FALSE, na="", quote = F)
  }
  if(file.exists(Annokb_indel)){
    indel_df <- read.csv(Annokb_indel, header=T, stringsAsFactors = FALSE, na=" ",fileEncoding="GBK")
    indel_df$VAF_percent_tumor <- indel_df$VAF_percent_blood
    indel_df$VAF_percent_blood <- NA
    write.csv(indel_df,file=Annokb_indel,row.names=FALSE, na="", quote = F)
  }
}
if(grepl("cfdna",sample)){
  print("this is cfdna")
}

#!/usr/bin/Rscript
library(stringr)
args <- commandArgs(TRUE)
path_ttdna <- args[1]
path_cfdna <- args[2]
ttdna <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path_ttdna),"/")[[1]][2])
cfdna <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path_cfdna),"/")[[1]][2])
out_combine <- paste0(path_ttdna,"Combine_mutscan_fusion_virus/")
if(!file.exists(out_combine)){
    dir.create(out_combine, recursive = TRUE)
}

##Mutcsan
system(paste0("Rscript /haplox/users/zhaoys/Script/mutscan_result.R ",path_ttdna))
system(paste0("Rscript /haplox/users/zhaoys/Script/mutscan_result.R ",path_cfdna))
ttdna_csv <- paste0(path_ttdna,"MutScan/",ttdna,"_mutscan_result.csv")
cfdna_csv <- paste0(path_cfdna,"MutScan/",cfdna,"_mutscan_result.csv")
ttdna_df <- read.csv(ttdna_csv,header=TRUE, stringsAsFactors = FALSE, na="")
cfdna_df <- read.csv(cfdna_csv,header=TRUE, stringsAsFactors = FALSE, na="")
result_mutscan <- rbind(ttdna_df,cfdna_df)
out_mutscan <- paste0(path_ttdna,"Combine_mutscan_fusion_virus/",ttdna,"_ffpe_vs_cfdna_mutscan_result.csv")
write.csv(result_mutscan,file=out_mutscan,row.names=FALSE, na="", quote = F)

###fusion
fusion_dir <- paste0(path_ttdna,"fusionscan/")
fusion_csv <- paste0(fusion_dir,ttdna,"_ffpe_vs_cfdna_fusion.csv")
fusion_out <- paste0(out_combine,ttdna,"_ffpe_vs_cfdna_fusion_result.csv")
fusion_df <- read.csv(fusion_csv, header=TRUE ,stringsAsFactors = FALSE, na="")
result_fusion <- NULL
for(i in seq(nrow(fusion_df))){
  if(as.numeric(fusion_df[i,"level"]) >= 2){
    tmp <- as.data.frame(fusion_df[i,])
    result_fusion <- rbind(result_fusion,tmp)
  }
}
write.csv(result_fusion,file=fusion_out,row.names=FALSE, na="", quote = F)    
if(length(result_fusion)==0){
  result_fusion <- paste0("This Sample dont have important fusion")
  write.table(result_fusion,file=fusion_out,row.names=FALSE, col.names=FALSE,na="", quote = F,sep=",")
}

###virus
virus_df <- paste0(path_ttdna,"virus/virus_tumor_normal_result.txt")
virus_df2 <- paste0(path_cfdna,"virus/virus_tumor_normal_result.txt")
ttdna_virus <- read.table(virus_df, header=TRUE, fileEncoding="GB18030",fill=TRUE)
cfdna_virus <- read.table(virus_df2, header=TRUE, fileEncoding="GB18030",fill=TRUE)
out_df <- merge(ttdna_virus,cfdna_virus,by="virus")
out_df <- out_df[,-5]
colnames(out_df) <- c("virus","tumor","normal","cfdna")
out_csv <- paste0(out_combine,ttdna,"_ffpe_vs_cfdna_virus_result.csv")
write.csv(out_df,file=out_csv,row.names=FALSE, na="", quote = F)



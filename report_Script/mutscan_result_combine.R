#!/usr/bin/Rscript
library(stringr)
args <- commandArgs(TRUE)
path_ttdna <- args[1]
path_cfdna <- args[2]
ttdna <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path_ttdna),"/")[[1]][2])
cfdna <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path_cfdna),"/")[[1]][2])

system(paste0("Rscript /haplox/users/zhaoys/Script/mutscan_result.R ",path_ttdna))
system(paste0("Rscript /haplox/users/zhaoys/Script/mutscan_result.R ",path_cfdna))
ttdna_csv <- paste0(path_ttdna,"MutScan/0001.MutScan_out_html_output_24.html.files/",ttdna,"_mutscan_result.csv")
cfdna_csv <- paste0(path_cfdna,"MutScan/0001.MutScan_out_html_output_24.html.files/",cfdna,"_mutscan_result.csv")
ttdna_df <- read.csv(ttdna_csv,header=TRUE, stringsAsFactors = FALSE, na="")
cfdna_df <- read.csv(cfdna_csv,header=TRUE, stringsAsFactors = FALSE, na="")
result <- rbind(ttdan_df,cfdna_df)
out_combine <- paste0(path_ttdna,"Combine_mutscan_fusion_virus/",ttdna,"_ffpe_vs_cfdna_mutscan_result.csv")
write.csv(result,file=out_combine,row.names=FALSE, na="", quote = F)

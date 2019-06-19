#!usr/bin/Rscript
library(stringr)
args <- commandArgs(TRUE)
samplesheet <- paste0("C:/Users/user/Desktop/sequence_190613_A00250_0139_BHKYMLDSXX.csv")
samplesheet2 <- paste0("C:/Users/user/Desktop/changkang_share.csv")
csv_df <- read.csv(samplesheet, header=FALSE, stringsAsFactors = FALSE, na=" ", fileEncoding="GBK")
csv_df2 <- read.csv(samplesheet2,header=FALSE, stringsAsFactors = FALSE, na=" ", fileEncoding="GBK")
out_df <- csv_df[grepl("³¦¿µ",csv_df[,25]),]
tumor_df <- csv_df[csv_df[,9] %in% c("ttdna","ffpedna","cfdna","pedna") & grepl("³¦¿µ",csv_df[,25]),]
normal_df <- csv_df2[csv_df2[,12] %in% c("ntdna","gdna","atdna") & grepl("³¦¿µ",csv_df2[,27]),]
out_csv <- gsub("sequence_","sequence_³¦¿µ_",samplesheet)
write.csv(out_df,file=out_csv, fileEncoding="GBK",row.names=FALSE, na=" ", quote = F)
out_csv2 <- gsub("sequence_","sequence_normal_",samplesheet)
result <- NULL
if(nrow(tumor_df)>=1){
  for(i in seq(nrow(tumor_df))){
    for(j in seq(nrow(normal_df))){
      if(tumor_df[i,3]==normal_df[j,4] && tumor_df[i,15]==normal_df[j,17]){
        result <- c(result,normal_df[j,2])
        normal_out <- normal_df[normal_df[,2] %in% unique(result),]
        normal_out <- normal_out[!duplicated(normal_out[,c(1,2,3,4)]),]
        write.csv(normal_out,file=out_csv2, fileEncoding="GBK",row.names=FALSE, na=" ", quote = F)
      }
    }
  }
}
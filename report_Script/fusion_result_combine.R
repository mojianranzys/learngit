#!/usr/bin/Rscript
args <- commandArgs(TRUE)
path <- args[1]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
fusion_dir <- paste0(path,"fusionscan/")
cmd <- paste0("ls ",fusion_dir,"*_ffpe_vs_cfdna_fusion.csv")
fusion_csv <- system(cmd,intern = TRUE)
fusion_out <- paste0(fusion_dir,sample,"_ffpe_vs_cfdna_fusion_result.csv")
csv_df <- read.csv(fusion_csv, header=TRUE, stringsAsFactors = FALSE, na="")
result <- NULL
for(i in seq(nrow(csv_df))){
  if(csv_df[i,"level"] >= 2){
    tmp <- as.data.frame(csv_df[i,])
    result <- rbind(result,tmp)
  }
}
write.csv(result,file=fusion_out,row.names=FALSE, na="", quote = F)
if(length(result) == 0){
      result <- paste0("This Sample dont have important fusion")
      write.table(result,file=fusion_out,row.names=FALSE, col.names=FALSE,na="", quote = F,sep=",")
}

#!/usr/bin/Rscript
require("XML")
require("RCurl")
library(stringr)
args <- commandArgs(TRUE)
path <- args[1]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
data_id <- strsplit(sample,"_")[[1]][5]
out_dir <- paste0(path,"Combine_mutscan_fusion_virus/")
if(!file.exists(out_dir)){
  dir.create(out_dir,recursive = TRUE)
}
#mutscan
file_html <- paste0(path,"MutScan/0001.MutScan_out_html_output_24.html.files/main.html")
#system(paste0("rename ", '"s/0001.MutScan_out/',sample,'_mutscan/"', " ", mutscan_dir,"/*\n"))
#file_html <- paste0(mutscan_dir,sample,"_mutscan_html_output_24.html.files/main.html")
tmp <- readLines(file_html)
result_mutscan <- NULL
mutscan_out <- paste0(out_dir,sample,"_mutscan_result.csv")
if(grepl("MutScan didn't find any mutation",tmp[[1]])){
  result <- paste0("MutScan didn't find any mutation")
  write.table(result,file=mutscan_out,row.names=FALSE, col.names=FALSE,na="", quote = F,sep=",")
}else{
  main_df <- as.data.frame(strsplit(tmp[[1]],"<li class='menu_item'>"))
  main_df <- main_df[-1,]
  for(i in seq(length(main_df))){
    infor_df <- unlist(strsplit(as.character(main_df[i]),"-"))
    gene <- gsub("<.*>","",as.character(infor_df[1]))
    direction <- infor_df[2]
    chr <- infor_df[3]
    pos <- infor_df[4]
    if(length(infor_df)==8){
      exon <- infor_df[5]
      base <- infor_df[6]
      AA <- infor_df[7]
      cosmic <- strsplit(infor_df[8],"\\(")[[1]][1]
      tmp2 <- strsplit(infor_df[8],"\\(")[[1]][2]
    }
    if(length(infor_df)==7){
      exon <- ""
      base <- infor_df[5]
      AA <- infor_df[6]
      cosmic <- strsplit(infor_df[7],"\\(")[[1]][1]
      tmp2 <- strsplit(infor_df[7],"\\(")[[1]][2]
    }
    reads_support <- str_extract_all(tmp2,"\\d+")[[1]][1]
    unique <- str_extract_all(tmp2,"\\d+")[[1]][2]
    result1 <- cbind(data_id,gene,direction,chr,pos,exon,base,AA,cosmic,reads_support,unique)
    result_mutscan <- rbind(result_mutscan,result1)
    write.csv(result_mutscan,file=mutscan_out,row.names=FALSE, na="", quote = F)
  }
}
###fusion
fusion_dir <- paste0(path,"fusionscan/")
fusion_csv <- paste0(fusion_dir,sample,"_fusion.csv")
fusion_out <- paste0(out_dir,sample,"_fusion_result.csv")
csv_df <- read.csv(fusion_csv, header=TRUE, stringsAsFactors = FALSE, na="")
result2 <- NULL
for(i in seq(nrow(csv_df))){
  if(csv_df[i,"level"] >= 2){
    tmp <- as.data.frame(csv_df[i,])
    result2 <- rbind(result2,tmp)
  }
}
write.csv(result2,file=fusion_out,row.names=FALSE, na="", quote = F)
if(length(result2) == 0){
  result2 <- paste0("This Sample dont have important fusion")
  write.table(result2,file=fusion_out,row.names=FALSE, col.names=FALSE,na="", quote = F,sep=",")
}


###virus
virus_dir <- paste0(path,"virus/")
virus_txt <- paste0(virus_dir,"virus_tumor_normal_result.txt")
virus_df <- read.table(virus_txt, header=TRUE, fileEncoding="GB18030",fill=TRUE)
out_virus <- paste0(out_dir,sample,"_virus_result.csv")
write.csv(virus_df,file=out_virus,row.names=FALSE, na="", quote = F)



#!/usr/bin/Rscript
require("XML")
require("RCurl")
library(stringr)
args <- commandArgs(TRUE)
path <- args[1]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
data_id <- strsplit(sample,"_")[[1]][5]
mutscan_dir <- paste0(path,"MutScan/")
#system(paste0("rename ", '"s/0001.MutScan_out/',sample,'_mutscan/"', " ", mutscan_dir,"/*\n"))
file_html <- paste0(mutscan_dir,"0001.MutScan_out_html_output_24.html.files/main.html")
tmp <- readLines(file_html)
result_df <- NULL
mutscan_out <- paste0(mutscan_dir,sample,"_mutscan_result.csv")
if(grepl("MutScan didn't find any mutation",tmp[[1]])){
  result <- paste0("MutScan didn't find any mutation")
  write.table(result,file=mutscan_out,row.names=FALSE, col.names=FALSE,na="", quote = F,sep=",")
  }else{
main_df <- as.data.frame(strsplit(tmp[[1]],"<li class='menu_item'>"))
main_df <- main_df[-1,]
for(i in seq(length(main_df))){
  infor_df <- unlist(strsplit(as.character(main_df[i]),"-"))
#  print(length(infor_df))
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
  result <- cbind(data_id,gene,direction,chr,pos,exon,base,AA,cosmic,reads_support,unique)
  result_df <- rbind(result_df,result)
  write.csv(result_df,file=mutscan_out,row.names=FALSE, na="", quote = F)
}
}

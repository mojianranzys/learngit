#!usr/bin/Rscript
library(stringr)
args <- commandArgs(TRUE)
sheet1 <- paste0("/haplox/users/zhaoys/data/crc_ngs/changkang_erdaicexu_information.csv")
csv_df <- read.csv(sheet1, header=FALSE, stringsAsFactors = FALSE, na="", fileEncoding="GBK")
if(nrow(csv_df)>= 1){
  for(i in seq(nrow(csv_df))){
    report_working <- paste0("/x01_haplox/hapreports/12.zszl_crc_chemo_2018/working/",csv_df[i,1],"/")
    #    cat(csv_df[i,1],csv_df[i,2],csv_df[i,4],"\n")
    check_report1 <- system(paste0("ls -l ",report_working,"*docx | grep ",csv_df[i,4]))
    check_report2 <- system(paste0("ls -l ",report_working,"*/*docx | grep ",csv_df[i,4]))
    if(check_report1 == 0 | check_report2==0){
      cat(csv_df[i,1],csv_df[i,2],csv_df[i,4],"有报告\n")  
    }
    if(check_report1 == 1 & check_report2==1){
      cat(csv_df[i,1],csv_df[i,2],csv_df[i,4],"无报告\n")
    }
  }
}

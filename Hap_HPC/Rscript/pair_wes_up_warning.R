#!/usr/bin/Rscript
print("up warning csv")
library("readr")
args <- commandArgs(TRUE)
tumor_dir <- args[1]
data_id <- stringi::stri_reverse(strsplit(stringi::stri_reverse(tumor_dir),"_")[[1]][1])
cmd_snv <- paste0("ls ",tumor_dir,"/Curl_mrbam_*snv-nobias-GB18030-baseline-wesplus.csv")
out_snv <- system(cmd_snv,intern = TRUE)
cmd_indel <- paste0("ls ",tumor_dir,"/Curl_mrbam_*indel-nobias-GB18030-baseline-wesplus.csv")
out_indel <- system(cmd_indel,intern = TRUE)
warning_df <- paste0(tumor_dir,"/Warning.csv")
if(file_test("-f",warning_df)){
    csv_df <- read.csv(warning_df, header=FALSE, stringsAsFactors = FALSE, fileEncoding = "utf-8")
    if(nrow(csv_df) >= 1){
        for(i in seq(nrow(csv_df))){
            if(csv_df[i,7] >=2 && csv_df[i,26] >= 3 && csv_df[i,47] ==1){
                tmp <- csv_df[i,47:54]
                tmp[is.na(tmp)] <- ""
                result <- data.frame(data_id,csv_df[i,1:6],csv_df[i,7],"",csv_df[i,8],tmp)
                if(grepl("[A-Z]",(substr(csv_df[i,5],3,3)))){
                    write_csv(result,out_snv,append=TRUE)
                    system(paste0('curl haplab.haplox.net/api/report/csv?type=snv -F "import_file=@', out_snv, '"'))
                }
                else{
                    write_csv(result,out_indel,append = TRUE)
                    system(paste0('curl haplab.haplox.net/api/report/csv?type=indel -F "import_file=@', out_indel, '"'))
                }
            }
           else{
               print("no need warning to add")
           }
        }
    }
}
if(!file_test("-f",warning_df)){
    print("no warning csv")
}

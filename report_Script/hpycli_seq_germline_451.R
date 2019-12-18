#!/usr/bin/Rscript
library(stringr)

args <- commandArgs(TRUE)
input <- args[1]
cat(input, "\n")
input2 <- format(Sys.time(), "%b-%d-%H-%M-%S-%Y")


sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
cat(sampleSheet, "\n")

out_csv <- paste0("/haplox/users/zhaoys/Hap_HPC/single_germline_",  input,"451plus_tpl.csv")
    csv_df1 <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    csv_df3 <- csv_df1[grepl("healthgdna", csv_df1[,1]) & grepl("肠康",csv_df1[,25]),]
    if(nrow(csv_df3) <= 0){
        print("no data for germline")
        quit(save = "no")
    }
    NCOL <- ncol(csv_df3)

    csv_df3[, (NCOL+1):(NCOL+5)] <- str_match(csv_df3[,2-1], "S(.*?)_(.*?)_(.*?)_(.*?)_(\\d+)")[, 2:6]
    csv_df3$tR1 <- NA
    csv_df3$tR2 <- NA
    csv_df3$cancerlist      <- "oss://sz-hapbin/users/lvxy/germline/database/female_cancer.list"
    csv_df3$bed      <- "oss://sz-hapbin/ctdna_pipeline/clinical/bed/451plus.bed"
    csv_df3$sample   <- csv_df3[, 1]
    
    myStrsplit <- function(x, split_para){
        unlist(strsplit(x, split=split_para))[8]
    }
    

    for(i in seq(nrow(csv_df3))){
        if(csv_df3[i, 11-1] == 0){
            oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(input, 1, 4), "/", input)
        }else{
            oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(input, 1, 4), "/", input,  "_clinic/")
        }
        cmd     <- paste0("ossutil ls ", oss_dir)
        txt <- system(cmd, intern = TRUE)
        txt_input <- unlist(lapply(txt[grepl("oss://.*\\/S\\d+.*R1.*.fastq.gz", txt)], myStrsplit, split_para="\\s+"))
#    print(txt_input)
        csv_df3[i, "tR1"] = txt_input[grepl(csv_df3[i,2-1], txt_input)]
        csv_df3[i, "tR2"] = gsub("R1", "R2", csv_df3[i, "tR1"])
    }
    tumor_df <- csv_df3[grepl("451plus",csv_df3[, 1]) & !is.na(csv_df3[, "tR1"]), c("tR1", "tR2", "cancerlist", "bed", "sample")]
    if(nrow(tumor_df) > 0){
        write.csv(tumor_df, file = out_csv, row.names = FALSE, na = "-", quote = FALSE)
    }else{
        print("no data for single")
    }
    



#    quit("yes")

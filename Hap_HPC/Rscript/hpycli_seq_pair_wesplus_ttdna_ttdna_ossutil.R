#!/usr/bin/Rscript
library(stringr)

args <- commandArgs(TRUE)
input <- args[1]
cat(input, "\n")
input2 <- args[2]


sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
cat(sampleSheet, "\n")
sampleSheet2 <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")

out_csv <- paste0("/haplox/users/huang/myGit/hpycli/pair_", input, "_", input2,"_wesplus_tpl.csv")
    csv_df1 <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE, , fileEncoding="UTF-8")
    csv_df2 <- read.csv(sampleSheet2, header=FALSE, stringsAsFactors = FALSE, fileEncoding="UTF-8")
    print(csv_df2[,3])
    print(csv_df2[18, 3] == csv_df2[19, 3])
    csv_df3 <- csv_df1[csv_df1[,9] %in% c("ffpedna", "ttdna") & grepl("癌组织|肿块", csv_df1[,26]),]
    if(nrow(csv_df3) <= 0){
        print("no wesplus for tumor")
        quit(save = "no")
    }
    csv_df4 <- csv_df2[grepl("atdna|ntdna|ttdna|ffpedna",csv_df2[,9]) & grepl("癌旁组织|正常组织", csv_df2[,26]), ]
    cat(nrow(csv_df3), "===", nrow(csv_df4), "=====\n")
    if(nrow(csv_df4) <= 0){
        print("no wesplus for gdna")
        quit(save = "no")
    }
    NCOL <- ncol(csv_df3)
    NCOL2 <- ncol(csv_df4)

    csv_df3[, (NCOL+1):(NCOL+5)] <- str_match(csv_df3[,1], "S(.*?)_(.*?)_(.*?)_(.*?)_(\\d+)")[, 2:6]
    csv_df4[, (NCOL2+1):(NCOL2+5)] <- str_match(csv_df4[,1], "S(.*?)_(.*?)_(.*?)_(.*?)_(\\d+)")[, 2:6]
    csv_df3$tR1 <- NA
    csv_df3$tR2 <- NA
    csv_df3$genefuse <- "oss://sz-hapbin/ctdna_pipeline/tools/GeneFuse/genes/cancer.hg19.csv"
    csv_df3$germline <- "oss://sz-hapbin/users/lvxy/germline/database/female_cancer.list"
    csv_df3$ref      <- "oss://sz-hapbin/ctdna_pipeline/clinical/ucsc.hg19/ucsc.hg19.fasta"
    csv_df3$bed      <- "oss://sz-hapbin/ctdna_pipeline/clinical/bed/wesplus.bed"
    csv_df3$exon     <- "oss://sz-hapbin/ctdna_pipeline/clinical/bed/wesplus-gene.bed"
    csv_df3$data_id  <- csv_df3[, 23]
    csv_df3$order    <- csv_df3[, NCOL+2]
    csv_df3$sample   <- csv_df3[, 1]
    csv_df3$nR1 <- NA
    csv_df3$nR2 <- NA
    
    if(csv_df3[1, 10] == 0){
        oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(input, 1, 4), "/", input)
    }else{
        oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(input, 1, 4), "/", input,  "_clinic/")
    }
    cmd     <- paste0("ossutil ls ", oss_dir)
    txt <- system(cmd, intern = TRUE)


    myStrsplit <- function(x, split_para){
        unlist(strsplit(x, split=split_para))[8]
    }
    txt_input <- unlist(lapply(txt[grepl("oss://.*\\/S\\d+.*R1.*.fastq.gz", txt)], myStrsplit, split_para="\\s+"))
    print(txt_input)
    if(csv_df4[1, 10] == 0){
        oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(input2, 1, 4), "/", input2)
    }else{
        oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(input2, 1, 4), "/", input2,  "_clinic/")
     }
    cmd     <- paste0("ossutil ls ", oss_dir)
    txt <- system(cmd, intern = TRUE)
    txt_input2 <- unlist(lapply(txt[grepl("oss://.*\\/S\\d+.*R1.*.fastq.gz", txt)], myStrsplit, split_para="\\s+"))
    print(txt_input2)

    for(i in seq(nrow(csv_df3))){
        csv_df3[i, "tR1"] = txt_input[grepl(csv_df3[i,1], txt_input)]
        csv_df3[i, "tR2"] = gsub("R1", "R2", csv_df3[i, "tR1"])
        for(j in seq(nrow(csv_df4))){
            if(csv_df3[i, 3] == csv_df4[j, 3]){
                csv_df3[i, "nR1"] = txt_input2[grepl(csv_df4[j,1], txt_input2)]
                csv_df3[i, "nR2"] = gsub("R1", "R2", csv_df3[i, "nR1"])
                break
            }
        }
    }
 tumor_df <- csv_df3[grepl("wesplus",csv_df3[, 1]) & !is.na(csv_df3[, "nR1"]), c("tR1", "tR2", "nR1", "nR2", "genefuse", "germline", "ref", "bed", "exon", "data_id", "order", "sample")]
#    print(csv_df3[,c(1, 10, 23)])
    if(nrow(tumor_df) > 0){
        write.csv(tumor_df, file = out_csv, row.names = FALSE, na = "-", quote = FALSE)
    }else{
        print("no big panel wesplus data")
    }
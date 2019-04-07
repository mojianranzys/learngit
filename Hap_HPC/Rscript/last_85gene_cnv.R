#!/usr/bin/Rscript
###86gene-180518-cnv

args <- commandArgs(TRUE)
path <- args[1]
input <- strsplit(path,"/")[[1]][4]
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(path),"/")[[1]][2])
data_id <- stringi::stri_reverse(strsplit(stringi::stri_reverse(sample),"_")[[1]][1])
dna_type <- strsplit(sample,"_")[[1]][3]
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
if(nrow(csv_df)>=0){
    for(i in seq(nrow(csv_df))){
        if(csv_df[i,1] == sample){
            gene <- substr(csv_df[i,24],6,7)
            print(gene)
            cnv_file <- paste0(path,"cnv/",sample,"_rg_cnv.genes",gene,".csv")
            out_cnv_file <- gsub(".csv", "_Curl.csv", cnv_file)
            cnv <- read.csv(cnv_file, header=TRUE, stringsAsFactors=FALSE,fill=TRUE, fileEncoding="UTF-8", row.names=NULL)
            cnv[,2] <- as.numeric(cnv[,2])
            cnv$type = rep("cnv", nrow(cnv))
            cnv$variation = NA
            cnv$data_id = data_id
            for(j in seq(nrow(cnv))){
                if(cnv[j,2] >= 3){
                    cnv[j, "variation"] <- "扩增"
                    print(cnv[j,])
                }else{
                    if(cnv[j,2] <= 1 ){
                        cnv[j, "variation"] <- "缺失"
                    }
                }
            }
            if(grepl("ffpedna|ttdna|pedna|fnadna",dna_type)){
                cnv$tumor <- cnv$cnv
                cnv$cfdna <- ""
            }else if(dna_type == "cfdna"){
                cnv$cfdna <- cnv$cnv
                cnv$tumor <- ""
            }
            cnv$result <- cnv$variation
            cnv_res <- cnv[!is.na(cnv[, "variation"]), c("data_id", "genes", "result", "tumor", "cfdna", "type")]
            if(nrow(cnv_res) >= 1){
                write.csv(cnv_res,  file=out_cnv_file, fileEncoding="GBK",row.names=FALSE, quote=FALSE, na = "")
                print(out_cnv_file)
                system(paste0('curl haplab.haplox.net/api/report/csv?type=cnv -F "import_file=@', out_cnv_file, '"'))
                }
        }
    }
}
if(!file.exists(out_cnv_file)){
    print("no hign/low expression cnv")
}else{
    system(paste0("iconv -f gbk -t utf-8 -c ",out_cnv_file," -o ",out_cnv_file ))
    }


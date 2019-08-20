###血451——cnv
    library(stringr)
    library(dplyr)
    args <- commandArgs(TRUE)
    gender <- args[2]
    dirs   <- args[1]
    files <- list.files(path = dirs, pattern = "Annokb.*csv", full.names = TRUE)
    data_id     <- gsub(".*_(\\d+)(_|\\.)(snv|indel).*","\\1",files[1])
    germline_male <- list.files(path = paste0(dirs,"/germline/result"), pattern = ".*.cancer.male.xls", full.names = TRUE)
    germline_male_curl <- gsub("male", "male_curl",germline_male)
    germline_female <- list.files(path = paste0(dirs,"/germline/result"), pattern = ".*.cancer.female.xls", full.names = TRUE)
    germline_female_curl <- gsub("female", "female_curl",germline_female)
    cnvfiles <- list.files(path = paste0(dirs,"/cnv"), pattern = ".*geneschrX.csv", full.names = TRUE)
    out_cnv_file <- gsub("geneschrX", "cnvCurl", cnvfiles)
    print(cnvfiles)
    cnv <- read.csv(cnvfiles, header=TRUE, stringsAsFactors=FALSE,fill=TRUE, fileEncoding="GB18030", row.names=NULL)
    cnv[,2] <- as.numeric(cnv[,2])
    print(cnv[, 2])
    if(sum(abs(cnv[,2]-1)) < sum(abs(cnv[,2]-2))){
        gender <- "male"
        print("this is a man")
        system(paste0("cp ", germline_male, " ", germline_male_curl))
    }else{
        gender <- "female"
        print("this is a woman")
        system(paste0("cp ", germline_female, " ", germline_female_curl))
    }
    cnvfiles <- list.files(path = paste0(dirs,"/cnv"), pattern = ".*cnv_result\\.csv",full.names = TRUE)
    print(cnvfiles)
    cnv <- read.csv(cnvfiles, header=TRUE, stringsAsFactors=FALSE,fill=TRUE, fileEncoding="GB18030", row.names=NULL)
    cnv[,2] <- as.numeric(cnv[,2])
    cnv$type = rep("cnv", nrow(cnv))
    cnv$variation = NA
    cnv$data_id = data_id
    cnv$tumor = ""
    cnv$chrs  = as.character(cnv$chrs)
    for(i in seq(nrow(cnv))){
        if(grepl("chrX", cnv[i, 3]) && cnv[i, 2] >= 2 && gender == "male"){
            cnv[i, "variation"] <- "扩增"
        }else if(grepl("chrX", cnv[i, 3]) && cnv[i, 2] <= 0.5 & gender == "male"){
            cnv[i, "variation"] <- "缺失"
        } else if( grepl("chrX", cnv[i, 3]) && gender == "male") { next }
        else if(grepl("chrX", cnv[i, 3]) && cnv[i, 2] >= 3 && gender == "female"){
            cnv[i, "variation"] <- "扩增"
        }else if(grepl("chrX", cnv[i, 3]) && cnv[i, 2] <= 1.3 && gender == "female"){
            cnv[i, "variation"] <- "缺失"
        } else if( grepl("chrX", cnv[i, 3]) & gender == "female") { next }
        else if(cnv[i, 2] >= 3){
            cnv[i, "variation"] <- "扩增"
        }else if (cnv[i, 2] <= 1.3){
            cnv[i, "variation"] <- "缺失"
        }
    }
    cnv$result <- cnv$variation
    cnv$cfdna <- cnv$cnv
    cnv_res <- cnv[!is.na(cnv[, "variation"]), c("data_id", "genes", "result", "tumor", "cfdna", "type")]
    if(nrow(cnv_res) >= 1){
        write.csv(cnv_res,  file=out_cnv_file, fileEncoding="GB18030",row.names=FALSE, quote=FALSE, na = "")
        print(out_cnv_file)
        system(paste0('curl haplab.haplox.net/api/report/csv?type=cnv -F "import_file=@', out_cnv_file, '"'))
    }
    files <- list.files(path = paste0(dirs,"/germline/result"), pattern = paste0(".*_trans\\.cancer\\.", gender, "\\.txt"), full.names = TRUE)
    print(files)
    system(paste0('curl haplab.haplox.net/api/report/chemotherapy/', data_id, ' -F "germline=@', files, '"'))

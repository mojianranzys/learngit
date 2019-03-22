	#组织和血  ---31基因		
	library(stringr)
    library(dplyr)
    args <- commandArgs(TRUE)
    gender <- args[2]
    dirs   <- args[1]
    files <- list.files(path = dirs, pattern = "Annokb.*csv", full.names = TRUE)
    data_id     <- gsub(".*_(\\d+)(_|\\.)(snv|indel).*","\\1",files[1])
    print(files)
    files2 <- gsub("Annokb", "Curl", files)
    print(files2)
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
   cnvfiles <- list.files(path = paste0(dirs,"/cnv"), pattern = ".*genesWESPLUS\\.csv", full.names = TRUE)
    print(cnvfiles)
	cnv <- read.csv(cnvfiles, header=TRUE, stringsAsFactors=FALSE,fill=TRUE, fileEncoding="GB18030", row.names=NULL)
    cnv[,2] <- as.numeric(cnv[,2])
    cnv$type = rep("cnv", nrow(cnv))
    cnv$variation = NA
    cnv$data_id = data_id
    cnv$cfdna = ""
    cnv$chrs  = as.character(cnv$chrs)
    print(cnv$chrs)
    for(i in seq(nrow(cnv))){
        if(grepl("chrX", cnv[i, 3]) && cnv[i, 2] >= 2 && gender == "male"){
            cnv[i, "variation"] <- "扩增"
        }else if(grepl("chrX", cnv[i, 3]) && cnv[i, 2] <= 0.5 & gender == "male"){
            cnv[i, "variation"] <- "缺失"
        } else if( grepl("chrX", cnv[i, 3]) && gender == "male") { next } 
        else if(grepl("chrX", cnv[i, 3]) && cnv[i, 2] >= 3 && gender == "female"){
            cnv[i, "variation"] <- "扩增"
        }else if(grepl("chrX", cnv[i, 3]) && cnv[i, 2] <= 1 && gender == "female"){
            cnv[i, "variation"] <- "缺失"
        } else if( grepl("chrX", cnv[i, 3]) & gender == "female") { next } 
        else if(cnv[i, 2] >= 3){
            cnv[i, "variation"] <- "扩增"
        }else if (cnv[i, 2] <= 1){
            cnv[i, "variation"] <- "缺失"
        }
    }
    cnv$result <- cnv$variation
    cnv$tumor <- cnv$cnv
    cnv_res <- cnv[!is.na(cnv[, "variation"]), c("data_id", "genes", "result", "tumor", "cfdna", "type")]
    if(nrow(cnv_res) >= 1){
        write.csv(cnv_res,  file=out_cnv_file, fileEncoding="GB18030",row.names=FALSE, quote=FALSE, na = "")
        print(out_cnv_file)
        system(paste0('curl haplab.haplox.net/api/report/csv?type=cnv -F "import_file=@', out_cnv_file, '"'))
    }
    
    
#    genes_bed  <- args[1]
#    in_file1    <- args[2]
#    in_file2    <- args[3]
#    out_file    <- args[4]
    VAF         <- as.numeric(args[3])
    VAF         <- 5
    VAF_ctDNA         <- 0.1
#    name <- args[2]
#    genes <- read.table(genes_bed, header=FALSE,stringsAsFactors=FALSE,sep="\t")
#    print(genes)
#	genes_last <- genes[,4]
#	genes_last <- genes_last[genes_last != ""]
#	library(dplyr)
#	setwd("C:/nord/2016/reports/170814_NB551106_0043_AHKCH7BGX2")
for (in_file1 in files) {    
	snv <- read.csv(in_file1, header=TRUE, stringsAsFactors=FALSE,fill=TRUE, fileEncoding="GB18030", row.names=NULL)
	print(nrow(snv))
    out_file <- gsub("Annokb", "Curl", in_file1)
    snv <- filter(snv, grepl("chr", snv[,2]), grepl("NM", snv[,3]))
#	snv[,"MEAN_FREQUENCY"] <- as.numeric(snv[,"MEAN_FREQUENCY"])
	snv[,"healthy_cfdna_MEAN_FREQUENCY"] <- as.numeric(snv[,"healthy_cfdna_MEAN_FREQUENCY"])
#    snv[,"COUNT"] <- as.numeric(snv[,"COUNT"])
    snv[,"healthy_cfdna_COUNT"] <- as.numeric(snv[,"healthy_cfdna_COUNT"])
	snv[,7] <- as.numeric(snv[,7])
	snv[,"sr"] <- as.numeric(snv[,"sr"] )
	snv[,"sv"] <- as.numeric(snv[,"sv"] )
	snv[,"One_Overlap_Alt"] <- as.numeric(snv[,"One_Overlap_Alt"] )
	snv[,"unique_alt"] <- as.numeric(snv[,"unique_alt"] )
	snv[,"hap_research_0317_health_MEAN_SUPPORT"] <- as.numeric(snv[,"hap_research_0317_health_MEAN_SUPPORT"] )
	snv[,"X451plus_health_COUNT"] <- as.numeric(snv[,"X451plus_health_COUNT"] )
#	snv_filter <- filter(snv, snv[,7] >=VAF,snv[,"sv"] >= 3,  snv[,"One_Overlap_Alt"] >= 3, snv[,"unique_alt"] >= 4, snv[,"hap_research_0317_health_MEAN_SUPPORT"] <= 4, snv[,"X451plus_health_COUNT"] <= 4)
	snv_filter <- filter(snv, snv[,7] >=VAF,snv[,"sv"] >= 3,  snv[,"One_Overlap_Alt"] >= 3, snv[,"unique_alt"] >= 4, snv[,"hap_research_0317_health_MEAN_SUPPORT"] <= 4, snv[,"X451plus_health_COUNT"] <= 4)
    N <- ncol(snv_filter)
    data_id     <- gsub(".*_(\\d+)(_|\\.)(snv|indel).*","\\1",in_file1)
    snv_filter$Data_id <- data_id
    snv_filter$VAF_percent_blood <- ""
    snv_csv_df  <- cbind(snv_filter[,"Data_id"], snv_filter[,1:7], snv_filter[, "VAF_percent_blood"], snv_filter[, 8], snv_filter[, (N-7):N])
    colnames(snv_csv_df)[1] <- "Data_id"
    colnames(snv_csv_df)[8:10] <- c("VAF_percent_tumor","VAF_percent_blood", "cosmic")
#    write.csv(snv,  file=out_file, fileEncoding="GB18030",row.names=FALSE,quote=FALSE)
    write.csv(snv_csv_df,  file=out_file, fileEncoding="GB18030",row.names=FALSE,quote=FALSE, na = "")
    if(grepl("snv", in_file1)){
        print("start curl snv into haplab")
        system(paste0('curl haplab.haplox.net/api/report/csv?type=snv -F "import_file=@', out_file, '"'))
    }else{
        print("start curl indel into haplab")
        system(paste0('curl haplab.haplox.net/api/report/csv?type=indel -F "import_file=@', out_file, '"'))
    }
}
   print("snv-indel-curl-complete!!!!!!!!!!!!!!!!!!!!!!")

    files <- list.files(path = paste0(dirs,"/germline/result"), pattern = paste0(".*_trans\\.cancer\\.", gender, "\\.txt"), full.names = TRUE)
    print(files)
    #curl haplab.haplox.net/api/report/chemotherapy/13326 -F "germline=@/haplox/rawout/181111_A00283_0066_AH5W2CDSXX/S025_20181108008-4_cfdna_451plus_13326/germline/result/S026_20181108008-4_gdna_451plus_13327_trans.cancer.female.txt"
    system(paste0('curl haplab.haplox.net/api/report/chemotherapy/', data_id, ' -F "germline=@', files, '"'))
    

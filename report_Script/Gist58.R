#######################
#Data:2019-08-21
#Author:Zhaoys
#GIST 58
#######################
dir = getwd()
sample <- stringi::stri_reverse(strsplit(stringi::stri_reverse(dir),"/")[[1]][1])
print(sample)
germline_dir <- paste0(dir,"/germline/result/")
tmp <- system(paste0("ls ",germline_dir,"*germline.txt"),intern = T)
gdna_txt <- gsub(germline_dir,"",tmp)
gdna_name <- strsplit(gdna_txt,"[.]")[[1]][1]
print(gdna_name)
dna_type <- strsplit(sample,"_")[[1]][3]
data_id <- strsplit(sample,"_")[[1]][5]
print(data_id)
system(paste("bash /haplox/users/liaowt/Script/germline/germline_trans/GIST58_germline.sh ",dir,gdna_name,data_id))
cat("\n")
#### cnv curl
cnv_file <- paste0(dir,"/cnv/",sample,"_rg_cnv.genes58.csv")
cnv <- read.csv(cnv_file, header=FALSE, stringsAsFactors=FALSE,fill=TRUE, fileEncoding="UTF-8", row.names=NULL)
colnames(cnv) <- c("genes","cnv","chrs")
out_cnv_file <- gsub(".csv", "_Curl_gain.csv", cnv_file)
cnv[,2] <- as.numeric(cnv[,2])
cnv$type = rep("cnv", nrow(cnv))
cnv$variation = NA
cnv$data_id = data_id
for(j in seq(nrow(cnv))){
  if(cnv[j,2] >= 3){
    cnv[j, "variation"] <- "扩增"
    print(cnv[j,])
  }else{
    if(cnv[j,2] <= 1.2 ){
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
if(!file.exists(out_cnv_file)){
    print("no high/low expression cnv")
}else{
    out <- gsub("_Curl_gain.csv", "_Curl.csv", out_cnv_file)
    system(paste0("iconv -f gbk -t utf-8 -c ",out_cnv_file," -o ",out ))
    }
cat("\n")
#### cp cnv/chem/germline to hapreports
input <- strsplit(dir,"/")[[1]][4]
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
tumor_df <- csv_df[csv_df[,1] %in% sample,]
sheet_dir <- paste0("/x01_haplox/hapreports/3.遗传咨询待发送/00.待审核x小panel/")
system(paste0("cp ",dir,"/cnv/",sample,"_rg_cnv.genes58.csv ",sheet_dir,"\n",
               "mv ",sheet_dir,sample,"_rg_cnv.genes58.csv ",sheet_dir,gsub("/","-",tumor_df[,22]),"-",tumor_df[,3],"-",tumor_df[,7],"-",dna_type,"-",data_id,"_rg_cnv.genes58.csv ","\n"))
system(paste0("cp ",germline_dir,gdna_name,"_trans.germline_GIST58.xls ",sheet_dir,"\n",
               "mv ",sheet_dir,gdna_name,"_trans.germline_GIST58.xls ",sheet_dir,gsub("/","-",tumor_df[,22]),"-",tumor_df[,3],"-",tumor_df[,7],"-",dna_type,"-",data_id,"_trans.germline_GIST58.xls ","\n"))
system(paste0("cp ",germline_dir,gdna_name,".chem_GIST58.xls ",sheet_dir,"\n",
               "mv ",sheet_dir,gdna_name,".chem_GIST58.xls ",sheet_dir,gsub("/","-",tumor_df[,22]),"-",tumor_df[,3],"-",tumor_df[,7],"-",dna_type,"-",data_id,".chem_GIST58.xls ","\n"))
cat("FINISH !!!!!!!!\n")                  

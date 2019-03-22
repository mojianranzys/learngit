library(stringr)

args <- commandArgs(TRUE)
csv <- NULL
sampleSheet <- paste0("/haplox/users/zhaoys/colon/colon_124sample.csv")
csv_df <- read.csv(sampleSheet, header=TRUE, stringsAsFactors = FALSE,  fileEncoding="GBK")
#print(csv_df[,1])
print(csv_df[,32])
#gsub("\n","",csv_df[,32])
oss_dir <- paste0("oss://sz-hapseq/rawfq/", "20", substr(csv_df[,32], 1, 4), "/", gsub("\n","",csv_df[,32]),  "_clinic/")
print(oss_dir)

out_csv <- paste0("/haplox/users/zhaoys/colon/colon_124sample_rawfq_R1_R2.csv")
if(!file.exists(out_csv)){
    file.create(out_csv, recursive = TRUE)
    }else{
        print("this file is exits")
    }

cmd_csv <- paste0("/haplox/users/zhaoys/colon/cmd_colon_124sample.csv")
sink(cmd_csv)
cat(paste0("ossutil ls ", oss_dir,"\n",step=""))
sink()

cmd_df <- read.csv(cmd_csv, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
#print(cmd_df[,1])
rawfq_R1 <- NULL
rawfq_R2 <- NULL

for(j in seq(nrow(cmd_df))){
    rawfq <- system(cmd_df[j,1], intern = TRUE)
    myStrsplit <- function(x, split_para){
        unlist(strsplit(x, split=split_para))[8]
        }
    rawfq_R1 <- c(rawfq_R1,unlist(lapply(rawfq[grepl("oss://.*\\/S\\d+.*R1.*.fastq.gz", rawfq)], myStrsplit, split_para="\\s+")))
    rawfq_R2 <- c(rawfq_R2,unlist(lapply(rawfq[grepl("oss://.*\\/S\\d+.*R2.*.fastq.gz", rawfq)], myStrsplit, split_para="\\s+")))
#    print(rawfq_R1)
}
rawfq_R1 <- unique(rawfq_R1)
rawfq_R2 <- unique(rawfq_R2)


if(nrow(csv_df) >=1){
    for(i in seq(nrow(csv_df))){
        csv_R1 <- rawfq_R1[grepl(csv_df[i,3],rawfq_R1) & grepl(gsub("\n","",csv_df[i,32]),rawfq_R1)]
        csv_R2 <- rawfq_R2[grepl(csv_df[i,3],rawfq_R2) & grepl(gsub("\n","",csv_df[i,32]),rawfq_R2)]
        csv_path <- gsub("\n","",csv_df[i,32])
        csv_order <- csv_df[i,3]
        sink(out_csv,append= TRUE)
        cat(paste0(csv_path,",",csv_order,",",csv_R1,",",csv_R2,"\n",step = ""))
        sink()
        }
    }

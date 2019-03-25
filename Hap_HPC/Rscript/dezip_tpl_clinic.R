library(stringr)
args <- commandArgs(TRUE)
input <- args[1]
rawrfqz_df <- NULL
dezip_df <- NULL
oss_dir <- paste0("oss://sz-hapseq/rawrfqz/", "20", substr(input,1, 4), "/", input,  "_clinic/")
###-------------------step1:restore--------------------------###
system(paste0("ossutil restore -r ",oss_dir))
###-------------------step2:dezip_to_csv --------------------------###
cmd <- paste0("ossutil ls ", oss_dir)
cmd_df <- system(cmd,intern = TRUE )
myStrsplit <- function(x, split_para){
    unlist(strsplit(x, split=split_para))[8]
    }
rawrfqz_df <- c(rawrfqz_df,unlist(lapply(cmd_df[grepl("oss://.*_clinic\\/S\\d+.*.rfq.xz", cmd_df)], myStrsplit, split_para="\\s+")))
#print(rawrfqz_df)
out_csv <- paste0("/haplox/users/zhaoys/Hap_HPC/",input,"_rawrfqz.csv")
if(!file.exists(out_csv)){
    file.create(out_csv, recursive = TRUE)
    }else{
        print("this dezip_csv is exits")
    }
for(i in seq(length(rawrfqz_df))){
#    print(rawrfqz_df[i])
    sink(out_csv,append=TRUE)
    cat(paste0(gsub("oss://sz-hapseq","",rawrfqz_df[i]),",",gsub("oss://sz-hapseq","",rawrfqz_df[i]),"\n",seq=""))
    sink()
}
###------------------step3:dezip_csv_to_oss-------------------------###
system(paste0("ossutil cp  ",out_csv," ","oss://sz-hapbin/users/zhaoys/dezip/"))
###------------------step4:tpl to hapyun----------------------------###
tpl_csv <- paste0("/haplox/users/zhaoys/Hap_HPC/tpl_dezip_",input,".csv") 
if(!file.exists(tpl_csv)){
    file.exists(tpl_csv,recursive = TRUE)
}else{
    print("this tpl_csv is exists") 
}
rawrfqz_csv <- paste0("oss://sz-hapbin/users/zhaoys/dezip/",input,"_rawrfqz")
num <- length(rawrfqz_df)
time_id <- paste0("20", substr(input,1, 4))
sink(tpl_csv)
cat(paste0("rawrfqz_csv",",","sed_id",",","time_id",",","instance_count",",","sample","\n",rawrfqz_csv,",",input,",",time_id,",",num,",",input,"\n"))
sink()

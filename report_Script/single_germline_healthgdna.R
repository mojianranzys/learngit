#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")

args <- commandArgs(TRUE)
input <- args[1]
#only healthgdna 
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
rawout <- paste0("/haplox/rawout/",input)
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
if(nrow(csv_df) >= 1){
    for(i in seq(nrow(csv_df))){
        if(csv_df[i,9] %in% c("healthgdna")){
            out <- paste0(rawout,"/",csv_df[i,1])
            print(csv_df[i,c(2,23)])
            out <- paste0(rawout,"/",csv_df[i,1])
            sh_file <- paste0(out, "/sigle_germline_healthgdna.sh")
            if(!file.exists(out)){
                dir.create(out, recursive = TRUE)
                }   
sink(sh_file)
cat(paste0("###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201910/germline-16core64g_",
csv_df[i,1],"/tmp/germline-sentieon-16core64g_node_5/result/ --include *germline.txt --include *chem_451.txt ",out,"/germline/result/\n",
"###\n","perl /haplox/users/ZhouYQ/germline/bin/Gene2Disease.pl /haplox/users/ZhouYQ/germline/bin/Database/female_cancer.list ",
out,"/germline/result/", csv_df[i,1],".germline.txt ", out,"/germline/result/", csv_df[i,1],".cancer.female.txt ",
out,"/germline/result/", csv_df[i,1],".nocancer.female.txt ", out,"/germline/result/\n",
"###\n","perl /haplox/users/ZhouYQ/germline/bin/Gene2Disease.pl /haplox/users/ZhouYQ/germline/bin/Database/male_cancer.list ",
out,"/germline/result/", csv_df[i,1],".germline.txt ", out,"/germline/result/", csv_df[i,1],".cancer.male.txt ",
out,"/germline/result/", csv_df[i,1],".nocancer.male.txt ", out,"/germline/result/\n",
"###\n","perl /haplox/users/wenger/script/germline_trans_v2.pl ", out,"/germline/result/", csv_df[i,1],".cancer.female.txt ",
out,"/germline/result/", csv_df[i,1],"_trans.cancer.female.txt\n",
"###\n","perl /haplox/users/wenger/script/germline_trans_v2.pl ", out,"/germline/result/", csv_df[i,1],".cancer.male.txt ",
out,"/germline/result/", csv_df[i,1],"_trans.cancer.male.txt\n",
"###\n","python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ",out,"/germline/result/", csv_df[i,1],"_trans.cancer.female.txt ",
"-o ", out,"/germline/result/", csv_df[i,1],"_trans.cancer.female.xls\n",
"###\n","python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ",out,"/germline/result/", csv_df[i,1],"_trans.cancer.male.txt ",
"-o ", out,"/germline/result/", csv_df[i,1],"_trans.cancer.male.xls\n",
"###\n","python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ",out,"/germline/result/", csv_df[i,1],".chem_451.txt ",
"-o ", out,"/germline/result/", csv_df[i,1],".chem_451.xls\n", step = ''))
sink()
        }
    }
}else{
    print("NO healthgdna")
}


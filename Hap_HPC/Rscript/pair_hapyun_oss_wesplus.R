#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")
args <- commandArgs(TRUE)
input <- args[1]
input2 <- args[2]
csv_df3 <- NULL
#ttDNA_wesplus_vs_gDAN
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
sampleSheet2 <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")
rawout <- paste0("/haplox/rawout/",input,"/ffpedna_vs_gdna")
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
wk <- paste0(rawout,"/WORKING")
if(!file.exists(wk)){
    dir.create(wk, recursive = TRUE)
}
#    csv_df <- read.csv(input, header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8")
    csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
    csv_df2 <- read.csv(sampleSheet2, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
    tumor_df <- csv_df[csv_df[,9] %in% c("ffpedna","ttdna") & grepl("wesplus",csv_df[,1]),]
    print(tumor_df[,c(2,23)])
    tumor_df$normal = rep(NA, nrow(tumor_df))
    if(nrow(tumor_df) >= 1){
        for(i in seq(nrow(tumor_df))){
           for(j in seq(nrow(csv_df2))){
             if(csv_df2[j,3] == tumor_df[i,3] & grepl("gdna|atdna",csv_df2[j,9]) & grepl("wesplus", csv_df2[j,1])){
                tumor_df[i,"normal"] <- csv_df2[j,1]
                out <- paste0(rawout,"/",tumor_df[i,1])
                csv_df3 <- c(csv_df3,out)
                sh_file <- paste0(out,"/last_pair_wesplus_oss_hapyun.sh")
                sh_file_2 <- paste0(rawout,"/muilt_pair_ttdna_wes.sh")
                if(!file.exists(out)){
                    dir.create(out, recursive = TRUE)
                }
                sink(sh_file)
                out_nohup <- paste0(rawout,"/",tumor_df[i,1],"/",tumor_df[i,1],".nohup.out")
                out_error <- paste0(rawout,"/",tumor_df[i,1],"/",tumor_df[i,1],".nohup.out")
                cnv_in <-paste0(rawout,"/",tumor_df[i,1],"/cnv-pair_node_25")
                cnv_out <- paste0(rawout,"/",tumor_df[i,1],"/cnv")
                cnv_rename <- paste0('"s/0001.sample/',tumor_df[i,1],'/"')
                qc_in <- paste0(rawout,"/",tumor_df[i,1],"/fastp-16core64g_*/reports/*")
                qc_out <- paste0(rawout,"/",tumor_df[i,1],"/QC")
                MutScan_in <- paste0(rawout,"/",tumor_df[i,1],"/MutScan_node_24")
                MutScan_out <- paste0(rawout,"/",tumor_df[i,1],"/mutscan_",tumor_df[i,1])
                MutScan_rename<-paste0('"s/0001.MutScan_out/',tumor_df[i,1],'_mutscan/"')
                fusionscan_in <- paste0(rawout,"/",tumor_df[i,1],"/genefuse_huang_test_node_22")
                fusionscan_out <- paste0(rawout,"/",tumor_df[i,1],"/fusionscan")
                fusionscan_rn_1_in <- paste0(rawout,"/",tumor_df[i,1],"/fusionscan/0001.genefuse_huang_test_out_html_output_22.html")
                fusionscan_rn_1_out <-  paste0(rawout,"/",tumor_df[i,1],"/fusionscan/",tumor_df[i,1],"_fusion.html")
                fusionscan_rn_2_in <- paste0(rawout,"/",tumor_df[i,1],"/fusionscan/0001.genefuse_huang_test_out_json_output_22.json")
                fusionscan_rn_2_out <-  paste0(rawout,"/",tumor_df[i,1],"/fusionscan/",tumor_df[i,1],"_fusion.json")
                germline_mv_1 <- paste0(rawout,"/",tumor_df[i,1],"/germline-sentieon-16core64g_node_38")
                germline_mv_out <- paste0(rawout,"/",tumor_df[i,1],"/hapyun")
                germline_rn <- paste0('"s/germline/',tumor_df[i,"normal"],'/"')
                germline_mv_2 <- paste0(rawout,"/",tumor_df[i,1],"/germline")
                mrbam_in <- paste0(rawout,"/",tumor_df[i,1],"/MrBam*/mrbam/*")
                mrbam_mv <- paste0(rawout,"/",tumor_df[i,1],"/MrBam*")
                varscan_in <- paste0(rawout,"/",tumor_df[i,1],"/varscan*")
                varscan_rn_1_in <- paste0(rawout,"/",tumor_df[i,1],"/0001.varscan-annovar-pair_indel_txt_output_18.txt")
                varscan_rn_1_out <- paste0(rawout,"/",tumor_df[i,1],"/",tumor_df[i,1],"_indel_annovar.hg19_multianno.txt")
                varscan_rn_2_in <- paste0(rawout,"/",tumor_df[i,1],"/0001.varscan-annovar-pair_snv_txt_output_18.txt")
                varscan_rn_2_out <- paste0(rawout,"/",tumor_df[i,1],"/",tumor_df[i,1],"_snv_annovar.hg19_multianno.txt")
                varscan_rename <- paste0('"s/sample/',tumor_df[i,1],'/"')
                baseline <- paste0(tumor_df[i, 2], "_", tumor_df[i, 23])
                fusion_json  <- paste0(rawout, "/", tumor_df[i, 1], "/fusionscan/", tumor_df[i, 1], "_fusion.json")
                fusion_bam  <- paste0(rawout, "/", tumor_df[i, 1], "/", tumor_df[i, 1], "_rg.bam")
                cnv_result <- paste0(rawout, "/", tumor_df[i, 1], "/cnv/", tumor_df[i, 1], "_rg_cnv_result.txt")
                cnv_wesplus <- paste0(rawout, "/", tumor_df[i, 1], "/cnv/", tumor_df[i, 1], "_rg_cnv_genesWESPLUS.csv")
                Annokb_snv_in <- paste0(rawout, "/", tumor_df[i, 1],"/", tumor_df[i, 2], "_", tumor_df[i, 23] ,".snv-nobias-GB18030-baseline.csv")
                Annokb_snv_out <- paste0(rawout, "/", tumor_df[i, 1],"/Annokb_mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23] ,".snv-nobias-GB18030-baseline-wesplus.csv")
                Annokb_indel_in <- paste0(rawout, "/", tumor_df[i, 1],"/", tumor_df[i, 2], "_", tumor_df[i, 23] ,".indel-nobias-GB18030-baseline.csv")
                Annokb_indel_out <- paste0(rawout, "/", tumor_df[i, 1],"/Annokb_mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23] ,".indel-nobias-GB18030-baseline-wesplus.csv")
                germline <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".germline.txt")
                germline_out <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result")
                cancer_female <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".cancer.female.txt")
                cancer_female_trans <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.female.txt")
                cancer_female_trans_xls <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.female.xls")
                nocancer_female <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".nocancer.female.txt")
                cancer_male <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".cancer.male.txt")
                cancer_male_trans <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.male.txt")
                nocancer_male <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".nocancer.male.txt")
                tsv_dir <- paste0(out,"/tsv")
                mrbam_snv <- paste0(out, "/",baseline,".snv_MrBam.txt")
                mrbam_indel <- paste0(out, "/",baseline,".indel_MrBam.txt")
                tsv_snv <- paste0(tsv_dir,out,"/",baseline,".snv_MrBam.tsv")
                tsv_indel <- paste0(tsv_dir,out,"/",baseline,".indel_MrBam.tsv")
                cancer_male_trans_xls <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.male.xls")
                Curl_snv_in <- paste0(rawout, "/", tumor_df[i, 1],"/Curl_mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23], ".snv-nobias-GB18030-baseline-wesplus.csv")
                Curl_snv_out <- paste0(rawout, "/", tumor_df[i, 1], "/NEW-Annokb-", tumor_df[i, 2], "_", tumor_df[i, 23], ".snv-wesplus.csv")
                Curl_indel_in <- paste0(rawout, "/", tumor_df[i, 1],"/Curl_mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23], ".indel-nobias-GB18030-baseline-wesplus.csv")
                Curl_indel_out <- paste0(rawout, "/", tumor_df[i, 1], "/NEW-Annokb-", tumor_df[i, 2], "_", tumor_df[i, 23], ".indel-wesplus.csv")
cat(paste("###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_",
 tumor_df[i, 1], "/tmp/MrBam_pair_node_16/ ", out,"/MrBam_pair_node_16/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_",
 tumor_df[i, 1], "/tmp/MrBam_pair_node_17/ ", out,"/MrBam_pair_node_17/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_", 
tumor_df[i, 1], "/tmp/MutScan_node_24/ ",out, "/MutScan_node_24/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_",
tumor_df[i, 1], "/tmp/cnv-pair_node_25/ ", out,"/cnv-pair_node_25/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_",
tumor_df[i, 1], "/tmp/genefuse_huang_test_node_22/ ", out,"/genefuse_huang_test_node_22/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_",
tumor_df[i, 1], "/tmp/germline-sentieon-16core64g_node_38/result/ --include germline* ", out,"/germline-sentieon-16core64g_node_38/result/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_",
tumor_df[i, 1], "/tmp/varscan-annovar-pair_node_18/ ", out,"/varscan-annovar-pair_node_18/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_",
tumor_df[i, 1], "/tmp/fastp_node_5/reports/ --include S* ", out,"/fastp_node_5/reports/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_",
tumor_df[i, 1], "/tmp/fastp_node_6/reports/ --include S* ", out,"/fastp_node_6/reports/\n",
"###\n","echo ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_",
tumor_df[i, 1], "/tmp/sentieon-out-sort-rmdup-bam_node_37/0001.sentieon-bwa-sort-gencore-out-sort-rmdup-bam_sortbam_cfdna.bam ./ >> /haplox/rawout/sort.txt\n",
"###\n","echo ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_sentieon_16core64g_no_factera_",
tumor_df[i, 1], "/tmp/sentieon-out-sort-rmdup-bam_node_36/0001.sentieon-bwa-sort-gencore-out-sort-rmdup-bam_sortbam_gdna.bam ./ >> /haplox/rawout/sort.txt\n",
"###\n","mv ", cnv_in, " ",  cnv_out, "\n",
"###\n","mkdir ",qc_out, "\n","###\n","mv ",qc_in, " ",qc_out, "/\n","###\n","rm -r ", out, "/fastp*\n",
"###\n","rename ", cnv_rename ," ", cnv_out, "/*\n", "###\n","mv ", MutScan_in , " ", MutScan_out , "\n", 
"###\n","rename ", MutScan_rename ," ",  MutScan_out,"/*\n","###\n","mv ",fusionscan_in ," ", fusionscan_out,"\n", 
"###\n","mv ",fusionscan_rn_1_in , " ", fusionscan_rn_1_out,"\n","###\n","mv ", fusionscan_rn_2_in ," ", fusionscan_rn_2_out,"\n",
"###\n","mv ",germline_mv_1, " ", germline_mv_out, "\n", "###\n" ,"rename ",germline_rn, " ", germline_mv_out, "/result/*","\n",
"###\n","mv ", germline_mv_out, " ", germline_mv_2, "\n", "###\n", "mv ", mrbam_in ," ", out, "/", "\n",
"###\n","rm -r ",mrbam_mv,"\n", "###\n","mv  ",varscan_in ,"/*"," ",out,"\n","###\n","mv ",varscan_rn_1_in ," ",varscan_rn_1_out,"\n",
"###\n","mv ", varscan_rn_2_in ," ", varscan_rn_2_out, "\n", "###\n" ,"rename ",varscan_rename ," ", out, "/*","\n", 
"###\n","rm -r " ,varscan_in, "\n", 
"###\n","/haplox/thinker/net/tools/extract_vcf_nofilter ", tsv_dir, " ", mrbam_snv, "\n",
"###\n","/haplox/thinker/net/tools/extract_vcf_nofilter ", tsv_dir, " ", mrbam_indel, "\n",
"###\n", "/haplox/thinker/net/ctDNA/samplemutationimport  -i ",tsv_snv, "\n",
"###\n", "/haplox/thinker/net/ctDNA/samplemutationimport  -i ", tsv_indel, "\n",
"###\n", "/haplox/thinker/net/ctDNA/mutationimport -mysql=192.168.1.14:3306 -i ", tsv_snv, "\n",
"###\n", "/haplox/thinker/net/ctDNA/mutationimport -mysql=192.168.1.14:3306 -i ", tsv_indel, "\n", 
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/nobias_getMrBam_txt.R ", out, " ", baseline ,"\n",
"###\n", "python /haplox/users/yangbo/futionbase.py -f ", fusion_json ,  "\n",
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getCnv.R", " ",
          "/haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/cnv/final.cnv.genelist ",cnv_result," ", cnv_wesplus,"\n",
"###\n", "python /thinker/net/tools/Annokb.py -f ",Annokb_snv_in, " ", "-t  snv -o ", Annokb_snv_out, "\n",
"###\n", "python /thinker/net/tools/Annokb.py -f ",Annokb_indel_in, " ", "-t  indel -o ", Annokb_indel_out, "\n",
"###\n","perl /haplox/users/ZhouYQ/germline/bin/Gene2Disease.pl /haplox/users/ZhouYQ/germline/bin/Database/female_cancer.list ", germline, " ",  cancer_female," ",  nocancer_female," ",  germline_out, " \n",
"perl /haplox/users/ZhouYQ/germline/bin/Gene2Disease.pl /haplox/users/ZhouYQ/germline/bin/Database/male_cancer.list ", germline," ",  cancer_male," ",   nocancer_male," ",   germline_out, " \n",
"perl /haplox/users/wenger/script/germline_trans_v2.pl ", cancer_female, " ", cancer_female_trans, " \n", 
"perl /haplox/users/wenger/script/germline_trans_v2.pl ", cancer_male, " ", cancer_male_trans, " \n", 
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", cancer_female_trans, " -o ", cancer_female_trans_xls, " \n", 
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", cancer_male_trans, " -o ", cancer_male_trans_xls, " \n", 
"###\n","Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/idSNP.R ", out, tumor_df[i,1],"\n",
"###\n","Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_wesplus.R ",out, "\n",
"###\n","python /haplox/users/zhaoys/Annokb.wes.py -f ",Curl_snv_in," -t snv -o ",Curl_snv_out,"\n",
"###\n","python /haplox/users/zhaoys/Annokb.wes.py -f ",Curl_indel_in," -t indel -o ",Curl_indel_out,"\n",
"###\n","mkdir ",wk,"/",tumor_df[i,23],"\n","###\n","cp -r ",out,"/NEW*", " ", wk,"/",tumor_df[i,23], "/\n",
"###\n","cp -r ",out, "/cnv/*cnv_genesWESPLUS.csv", " ", wk,"/",tumor_df[i,23],"/\n",
"###\n","cp -r ",out,"/germline/result/*trans.cancer*curl.xls"," ",wk,"/",tumor_df[i,23],"/\n",
"###\n","python3 /haplox/users/zhaoys/Hap_HPC/pair_ttdna_wes_warning.py -d ",rawout,"/",tumor_df[i,1],"\n",sep = ""))
                 sink()
            }
        }
    }
}else{
        print("no ttdna_vs_gdna")
    }

    print(csv_df[9, 3] == csv_df[10, 3])
    cat(paste(csv_df[1,], sep="-"), "\n")
###
sink(sh_file_2,append = TRUE)
for ( i in seq(length(csv_df3))){
      cat(paste0("###\n","nohup bash ",csv_df3[i],"/last_pair_wesplus_oss_hapyun.sh &","\n",step = ""))          
}
sink()

print("zhaoys")
cat("zhaoys\n")
args <- commandArgs(TRUE)
input <- args[1]
input2 <- args[2]
csv_df3 <- NULL
#ttDNA_wesplus_vs_gDAN
path <- paste0("/haplox/runPipelineInfo/",  input)
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
sampleSheet2 <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")
if(!file.exists(path)){
    dir.create(path, recursive = TRUE)
    system(paste0("cp /x01_haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv ","/haplox/runPipelineInfo/",  input)) 
}
rawout <- paste0("/haplox/rawout/",input,"/ffpedna_vs_gdna")
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
wk <- paste0(rawout,"/WORKING")
if(!file.exists(wk)){
    dir.create(wk, recursive = TRUE)
}
#    csv_df <- read.csv(input, header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8")
    csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    csv_df2 <- read.csv(sampleSheet2, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    tumor_df <- csv_df[csv_df[,9] %in% c("ffpedna","ttdna") & grepl("wesplus",csv_df[,1]),]
#    print(tumor_df[,c(2,23)])
    tumor_df$normal = rep(NA, nrow(tumor_df))
    if(nrow(tumor_df) >= 1){
        for(i in seq(nrow(tumor_df))){
           for(j in seq(nrow(csv_df2))){
             if(csv_df2[j,3] == tumor_df[i,3] & grepl("gdna|atdna",csv_df2[j,9]) & grepl("wesplus", csv_df2[j,1])){
                cat(tumor_df[i,1],tumor_df[i,3],csv_df2[j,1],csv_df2[j,3])
                cat("\n")
                tumor_df[i,"normal"] <- csv_df2[j,1]
                out <- paste0(rawout,"/",tumor_df[i,1])
                csv_df3 <- c(csv_df3,out)
                sh_file <- paste0(out,"/last_pair_wesplus_no_facter.sh")
                if(!file.exists(out)){
                    dir.create(out, recursive = TRUE)
                }
                sink(sh_file)
                baseline <- paste0(tumor_df[i, 2], "_", tumor_df[i, 23])
                fusion_json  <- paste0(out, "/fusionscan/", tumor_df[i, 1], "_fusion.json")
                cnv_result <- paste0(out, "/cnv/", tumor_df[i, 1], "_rg_cnv_result.txt")
                cnv_wesplus <- paste0(out, "/cnv/", tumor_df[i, 1], "_rg_cnv_genesWESPLUS.csv")
                Annokb_snv_in <- paste0(out,"/", tumor_df[i, 2], "_", tumor_df[i, 23] ,".snv-nobias-GB18030-baseline.csv")
                Annokb_snv_out <- paste0(out,"/Annokb_mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23] ,".snv-nobias-GB18030-baseline-wesplus.csv")
                Annokb_indel_in <- paste0(out,"/", tumor_df[i, 2], "_", tumor_df[i, 23] ,".indel-nobias-GB18030-baseline.csv")
                Annokb_indel_out <- paste0(out,"/Annokb_mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23] ,".indel-nobias-GB18030-baseline-wesplus.csv")
                germline <- paste0(out, "/germline/result/", tumor_df[i, "normal"], ".germline.txt")
                germline_out <- paste0(out, "/germline/result")
                cancer_female <- paste0(out, "/germline/result/", tumor_df[i, "normal"], ".cancer.female.txt")
                cancer_female_trans <- paste0(out, "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.female.txt")
                cancer_female_trans_xls <- paste0(out, "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.female.xls")
                nocancer_female <- paste0(out, "/germline/result/", tumor_df[i, "normal"], ".nocancer.female.txt")
                cancer_male <- paste0(out, "/germline/result/", tumor_df[i, "normal"], ".cancer.male.txt")
                cancer_male_trans <- paste0(out, "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.male.txt")
                nocancer_male <- paste0(out, "/germline/result/", tumor_df[i, "normal"], ".nocancer.male.txt")
                tsv_dir <- paste0(out,"/tsv")
                mrbam_snv <- paste0(out, "/",baseline,".snv_MrBam.txt")
                mrbam_indel <- paste0(out, "/",baseline,".indel_MrBam.txt")
                tsv_snv <- paste0(tsv_dir,out,"/",baseline,".snv_MrBam.tsv")
                tsv_indel <- paste0(tsv_dir,out,"/",baseline,".indel_MrBam.tsv")
                cancer_male_trans_xls <- paste0(out, "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.male.xls")
                Curl_snv_in <- paste0(out,"/Curl_mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23], ".snv-nobias-GB18030-baseline-wesplus.csv")
                Curl_snv_out <- paste0(out, "/NEW-Annokb-", tumor_df[i, 2], "_", tumor_df[i, 23], ".snv-wesplus.csv")
                Curl_indel_in <- paste0(out,"/Curl_mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23], ".indel-nobias-GB18030-baseline-wesplus.csv")
                Curl_indel_out <- paste0(out, "/NEW-Annokb-", tumor_df[i, 2], "_", tumor_df[i, 23], ".indel-wesplus.csv")
                bamqc_tumor <- paste0(out,"/BamQC/",tumor_df[i,1],"/bam_pileup_QC/",tumor_df[i,1],".bam_qc.csv")
                bamqc_normal <- paste0(out,"/BamQC/",tumor_df[i,"normal"],"/bam_pileup_QC/",tumor_df[i,"normal"],".bam_qc.csv")
cat(paste("###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/MrBam_pair_node_16/mrbam/ ", out,"/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
 tumor_df[i, 1], "/tmp/MrBam_pair_node_17/mrbam/ ", out,"/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_", 
tumor_df[i, 1], "/tmp/MutScan_node_24/ ",out, "/mutscan_",tumor_df[i,1],"\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/cnv-pair_node_25/ ", out,"/cnv/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/genefuse_huang_test_node_22/ ", out,"/fusionscan/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/germline-sentieon-16core64g_node_38/result/ --include germline* ", out,"/hapyun/result/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/varscan-annovar-pair_node_18/ ", out,"/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/fastp-16core64g_node_39/reports/ --include S* ", out,"/fastp/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/fastp-16core64g_node_40/reports/ --include S* ", out,"/fastp/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/Visual_msi_node_43/ ", out,"/Visual_msi/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/rgbam_captureByBase_depth_maprate_node_45/ ", out, "/BamQC/",tumor_df[i,1],"/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/rgbam_captureByBase_depth_maprate_node_47/ ", out, "/BamQC/",tumor_df[i,"normal"],"/\n",
"###\n","echo ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/sentieon-bwa-gencore-pileup-no-umi_node_48/0001.sentieon-bwa-gencore-pileup-no-umi_cfdna_rgbam_output_48.bam ./ >> /haplox/rawout/sort.txt\n",
"###\n","echo ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_wes_IDT_no_facter_",
tumor_df[i, 1], "/tmp/sentieon-bwa-gencore-pileup-no-umi_node_49/0001.sentieon-bwa-gencore-pileup-no-umi_gdna_rgbam_output_49.bam ./ >> /haplox/rawout/sort.txt\n",
"###\n","rename ", '"s/0001.sample/',tumor_df[i,1],'/"'," ", out, "/cnv/*\n",
"###\n","rename ",'"s/0001.MutScan_out/',tumor_df[i,1],'_mutscan/"' ," ", out,"/mutscan_",tumor_df[i,1],"/*\n",
"###\n","mv ",out,"/fusionscan/0001.genefuse_huang_test_out_html_output_22.html ",out,"/fusionscan/",tumor_df[i,1],"_fusion.html \n", 
"###\n","mv ",out,"/fusionscan/0001.genefuse_huang_test_out_json_output_22.json ",  out,"/fusionscan/",tumor_df[i,1],"_fusion.json \n",
"###\n" ,"rename ",'"s/germline/',tumor_df[i,"normal"],'/"', " ", out, "/hapyun/result/*","\n",
"###\n","mv ", out, "/hapyun/ " , out, "/germline/ \n",
"###\n","mv  ",out,"/0001.varscan-annovar-pair_indel_txt_output_18.txt ",out,"/",tumor_df[i,1],"_indel_annovar.hg19_multianno.txt\n",
"###\n","mv  ",out,"/0001.varscan-annovar-pair_snv_txt_output_18.txt ",out,"/",tumor_df[i,1],"_snv_annovar.hg19_multianno.txt\n",
"###\n" ,"rename ",'"s/sample/',tumor_df[i,1],'/"'," ", out, "/*","\n", 
"###\n","mv ",out,"/Visual_msi/0001.Visual_msi_html_output_43.html ",out,"/Visual_msi/",tumor_df[i,1],"_msi.html\n",
"###\n","mv ",out,"/Visual_msi/0001.Visual_msi_json_output_43.json ",out,"/Visual_msi/",tumor_df[i,1],"_msi.json\n",
"###\n","rename ",'"s/0001.sentieon-bwa-gencore-pileup-no-umi_cfdna_rgbam_output_48/',tumor_df[i,1],'/"'," ", 
out,"/BamQC/",tumor_df[i,1],"/bam_pileup_QC/*\n",
"###\n","rename ",'"s/0001.sentieon-bwa-gencore-pileup-no-umi_gdna_rgbam_output_49/',tumor_df[i, "normal"],'/"'," ", 
out,"/BamQC/",tumor_df[i,"normal"],"/bam_pileup_QC/*\n",
"###\n","mv ", out,"/BamQC/",tumor_df[i,1],"/capture/0001.sentieon-bwa-gencore-pileup-no-umi_cfdna_rgbam_output_48.bam_capture_stat.txt ",
out,"/BamQC/",tumor_df[i,1],"/capture/", tumor_df[i,1],"_capture_stat.txt\n",
"###\n","mv ", out,"/BamQC/",tumor_df[i,"normal"],"/capture/0001.sentieon-bwa-gencore-pileup-no-umi_gdna_rgbam_output_49.bam_capture_stat.txt ",
out,"/BamQC/",tumor_df[i,"normal"],"/capture/", tumor_df[i,"normal"],"_capture_stat.txt\n",
"###\n","rename ",'"s/0001.sentieon-bwa-gencore-pileup-no-umi_cfdna_rgbam_output_48/',tumor_df[i,1],'/"'," ",
out,"/BamQC/",tumor_df[i,1],"/depth/*\n",
"###\n","rename ",'"s/0001.sentieon-bwa-gencore-pileup-no-umi_gdna_rgbam_output_49/',tumor_df[i,1],'/"'," ",
out,"/BamQC/",tumor_df[i,"normal"],"/depth/*\n",
"###\n",'curl haplab.haplox.net/api/report/depth-new -F "import_file=@',bamqc_tumor,'"',"\n",
"###\n",'curl haplab.haplox.net/api/report/depth-new -F "import_file=@',bamqc_normal,'"',"\n",
"###\n","/haplox/thinker/net/tools/extract_vcf_nofilter ", tsv_dir, " ", mrbam_snv, "\n",
"###\n","/haplox/thinker/net/tools/extract_vcf_nofilter ", tsv_dir, " ", mrbam_indel, "\n",
"###\n", "/haplox/thinker/net/ctDNA/samplemutationimport  -i ",tsv_snv, "\n",
"###\n", "/haplox/thinker/net/ctDNA/samplemutationimport  -i ", tsv_indel, "\n",
"###\n", "/haplox/thinker/net/ctDNA/mutationimport -mysql=192.168.1.14:3306 -i ", tsv_snv, "\n",
"###\n", "/haplox/thinker/net/ctDNA/mutationimport -mysql=192.168.1.14:3306 -i ", tsv_indel, "\n", 
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/nobias_getMrBam_txt_wesplus.R ", out, " ", baseline ,"\n",
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
"###\n","Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/idSNP.R ", out," ", tumor_df[i,1],"\n",
"###\n", "Rscript /haplox/users/zhaoys/Script/SNP_diff_warning.R ",out,"/\n",
"###\n","Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_wesplus.R ",out, "\n",
"###\n","python3 /haplox/users/zhaoys/Hap_HPC/pair_ttdna_wes_warning.py -d ",out,"\n",
"###\n","Rscript /haplox/users/zhaoys/Hap_HPC/pair_wes_up_warning.R ",out,"\n",
"###\n","python /haplox/users/zhaoys/Annokb.wes.py -f ",Curl_snv_in," -t snv -o ",Curl_snv_out,"\n",
"###\n","python /haplox/users/zhaoys/Annokb.wes.py -f ",Curl_indel_in," -t indel -o ",Curl_indel_out,"\n",
"###\n","Rscript /haplox/users/zhaoys/Script/gene8_wes.R ",out,"/\n",
"###\n","mkdir ",wk,"/",tumor_df[i,23],"\n","###\n","cp -r ",out,"/NEW*", " ", wk,"/",tumor_df[i,23], "/\n",
"###\n","cp -r ",out, "/cnv/*cnv_genesWESPLUS.csv", " ", wk,"/",tumor_df[i,23],"/\n",
"###\n","cp -r ",out,"/germline/result/*trans.cancer*curl.xls"," ",wk,"/",tumor_df[i,23],"/\n",
"###\n","cp -r ",out,"/Gene8*", " ", wk,"/",tumor_df[i,23], "/\n",sep = ""))
                 sink()
            }
        }
    }
}else{
        print("no ttdna_vs_gdna")
    }

#    print(csv_df[9, 3] == csv_df[10, 3])
#    cat(paste(csv_df[1,], sep="-"), "\n")
###
sh_file_2 <- paste0(rawout,"/muilt_pair_ttdna_wes.sh")
sink(sh_file_2,append = TRUE)
for ( i in seq(length(csv_df3))){
      cat(paste0("###\n","nohup bash ",csv_df3[i],"/last_pair_wesplus_no_facter.sh &","\n",step = ""))          
}
sink()


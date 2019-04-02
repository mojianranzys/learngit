#!/usr/bin/Rscript

print("huang")
cat("huang\n")

args <- commandArgs(TRUE)
input <- args[1]
cat(input, "\n")
input2 <- args[2]
input3 <- args[3]
rawout3 <- paste0("/haplox/rawout/",  input3)

sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
sampleSheet2 <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")
sampleSheet3 <- paste0("/haplox/runPipelineInfo/",  input3,  "/sequence_", input3,  ".csv")
rawout <- paste0("/haplox/rawout/",  input)
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
#    csv_df <- read.csv(input, header=FALSE, stringsAsFactors = FALSE, encoding = "UTF-8")
    csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
    csv_df2 <- read.csv(sampleSheet2, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
    csv_df3 <- read.csv(sampleSheet3, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")   
rawout <- paste0("/haplox/rawout/",  input,  "/ffpedna_vs_gdna")
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
    tumor_df <- csv_df[csv_df[, 9] %in% c("ffpedna", "ttdna", "pedna", "fnadna"), ]
    print(tumor_df[,c(2,23)])
#    quit("yes")
    tumor_df$normal = rep(NA, nrow(tumor_df))
    if(nrow(tumor_df) >= 1){
        for(i in seq(nrow(tumor_df))){
            for(j in seq(nrow(csv_df2))){
                if(csv_df2[j, 3] == tumor_df[i, 3] && grepl("gdna|saldna", csv_df2[j, 9] )){
                    tumor_df[i, "normal"] <- csv_df2[j, 1]
                    out  <- paste0(rawout, "/", tumor_df[i, 1])
                    if(!file.exists(out)){
                        dir.create(out, recursive = TRUE)
                    }
                    germline <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/cd", tumor_df[i, "normal"], ".germline.txt")
                    germline_out <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result")
                    cancer_female <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".cancer.female.txt")
                    cancer_female_trans <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.female.txt")
                    nocancer_female <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".nocancer.female.txt")
                    cancer_male <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".cancer.male.txt")
                    cancer_male_trans <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.male.txt")
                    nocancer_male <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".nocancer.male.txt")
                }
            }
            for(j in seq(nrow(csv_df3))){
                if(csv_df3[j, 3] == tumor_df[i, 3] && grepl("cfdna", csv_df3[j, 9] )){
                    tumor_df[i, "cfdna"] <- csv_df3[j, 1]
                    out  <- paste0(rawout, "/", tumor_df[i, 1])
                    tt_rg_bam  <- paste0(rawout, "/", tumor_df[i, 1], "/", tumor_df[i, 1],"_rg.bam")
                    fusion_json  <- paste0(rawout, "/", tumor_df[i, 1], "/fusionscan/", tumor_df[i, 1], "_fusion.json")
                    fusion_bam  <- paste0(rawout, "/", tumor_df[i, 1], "/", tumor_df[i, 1], "_rg.bam")
                    tt_sort_bam  <- paste0(rawout, "/", tumor_df[i, 1], "/", tumor_df[i, 1],"_sort.bam")
                    germline <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".germline.txt")
                    germline_out <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result")
                    cancer_female <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".cancer.female.txt")
                    cancer_female_trans <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.female.txt")
                    cancer_female_trans_xls <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.female.xls")
                    nocancer_female <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".nocancer.female.txt")
                    cancer_male <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".cancer.male.txt")
                    cancer_male_trans <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.male.txt")
                    cancer_male_trans_xls <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], "_trans.cancer.male.xls")
                    nocancer_male <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".nocancer.male.txt")
                    qc_info <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".information.txt")
                    qc_info_xls <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".information.xls")
                    chem_info <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".chem_451.txt")
                    chem_info_xls <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".chem_451.xls")
                    target_info <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".Target_451.txt")
                    target_info_xls <- paste0(rawout, "/", tumor_df[i, 1], "/germline/result/", tumor_df[i, "normal"], ".Target_451.xls")
                    indel_csv <- paste0(out,"/", tumor_df[i, 2], "_", tumor_df[i, 23], ".indel-nobias-GB18030-baseline.csv")
                    snv_csv <- paste0(out,"/", tumor_df[i, 2], "_", tumor_df[i, 23], ".snv-nobias-GB18030-baseline.csv")
                    out_combine_indel <- paste0(out, "/", "mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23], "_indel_combine.csv")
                    out_combine_snv <- paste0(out, "/", "mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23], "_snv_combine.csv")
                    out_anno_indel <- paste0(out, "/", "Annokb_mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23], "_indel_combine.csv")
                    out_anno_snv <- paste0(out, "/", "Annokb_mrbam_", tumor_df[i, 2], "_", tumor_df[i, 23], "_snv_combine.csv")
                    out_cf  <- paste0(rawout3, "/", tumor_df[i, "cfdna"])
                    indel_csv_cf <- paste0(out_cf,"/", csv_df3[j, 2], "_", csv_df3[j, 23], ".indel-nobias-GB18030-baseline.csv")
                    snv_csv_cf <- paste0(out_cf,"/", csv_df3[j, 2], "_", csv_df3[j, 23], ".snv-nobias-GB18030-baseline.csv")
                    ff_cnv  <- paste0(rawout, "/", tumor_df[i, 1], "/cnv/", tumor_df[i, 1],"_rg_cnv_result.csv")
                    cf_cnv  <- paste0(out_cf,"/cnv/", tumor_df[i, "cfdna"], "_rg_cnv_result.csv")
                    out_cnv  <- paste0(rawout, "/", tumor_df[i, 1], "/cnv/", tumor_df[i, 1],"_rg_cnv_tumor_cfdna.csv")
                    gd  <- tumor_df[i, "normal"]
                    gd_rg_bam  <- paste0(out, "/", gd,"_rg.bam")
                    gd_sort_bam  <- paste0( out, "/", gd,"_sort.bam")
                    cf_vrius <- paste0(out_cf,"/virus/",tumor_df[i, "cfdna"], "_virus_result.txt")
                    cf_facter <- paste0(out_cf,"/fusion/",tumor_df[i, "cfdna"],".fusions.txt")
                    sh_file <- paste0(out, "/zys_last_tumor_cfdna_gdna_huang.sh")
                    if(!file.exists(out)){
                        dir.create(out, recursive = TRUE)
                    }
                    sink(sh_file)
                    out_nohup  <- paste0(rawout, "/", tumor_df[i, 1], "/", tumor_df[i, 1], ".nohup.out")
                    out_error  <- paste0(rawout, "/", tumor_df[i, 1], "/", tumor_df[i, 1], ".nohup.error")
cat(paste("#!/bin/bash","\n",
"rename ",'"s/0001.MutScan_out/',tumor_df[i,1],'_mutscan/"' ," ", out,"/MutScan/* \n",
"rename ",'"s/0001.MutScan_out/',tumor_df[i,"cfdna"],'_mutscan/"' ," ", out_cf,"/MutScan/* \n",
"cp -r ",out_cf,"/MutScan/* ",out,"/MutScan/ \n",
"cp -r ",out_cf,"/fusionscan/* ",out,"/fusionscan/ \n",
"cp ",cf_vrius," ",out,"/virus/ \n",
"cp ",cf_facter," ",out,"/fusion/ \n",
"#----------------------------------------------------------------------------------------\n",
"Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getCnv_ff_cf.R ", ff_cnv, " ", cf_cnv, " ", out_cnv, " \n",
"Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes464.bed ", indel_csv, " ", indel_csv_cf, " ", out_combine_indel, " 0.5 \n", 
"Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes464.bed ", snv_csv, " ", snv_csv_cf, " ", out_combine_snv, " 0.5 \n", 
"python /thinker/net/tools/Annokb.py -f ", out_combine_indel, "  -t indel -o ", out_anno_indel, " \n",
"python /thinker/net/tools/Annokb.py -f ", out_combine_snv, "  -t snv -o ", out_anno_snv, " \n",
" #-----------------------------------------------------------------------------------------\n ",         
"python /haplox/users/yangbo/futionbase.py -f ", fusion_json, " -b ", fusion_bam, " \n",
"Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/idSNP.R ", out, "  ", tumor_df[i, 1], " \n",
"perl /haplox/users/ZhouYQ/germline/bin/Gene2Disease.pl /haplox/users/ZhouYQ/germline/bin/Database/female_cancer.list ", germline, " ",  cancer_female," ",  nocancer_female," ",  germline_out, " \n",
"perl /haplox/users/ZhouYQ/germline/bin/Gene2Disease.pl /haplox/users/ZhouYQ/germline/bin/Database/male_cancer.list ", germline," ",  cancer_male," ",   nocancer_male," ",   germline_out, " \n",
"perl /haplox/users/wenger/script/germline_trans_v2.pl ", cancer_female, " ", cancer_female_trans, " \n", 
"perl /haplox/users/wenger/script/germline_trans_v2.pl ", cancer_male, " ", cancer_male_trans, " \n", 
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", cancer_female_trans, " -o ", cancer_female_trans_xls, " \n", 
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", cancer_male_trans, " -o ", cancer_male_trans_xls, " \n", 
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", qc_info, " -o ", qc_info_xls, " \n", 
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", chem_info, " -o ", chem_info_xls, " \n", 
"python /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/zhaoys/txt_xls.py -i ", target_info, " -o ", target_info_xls, " \n", 
'curl haplab.haplox.net/api/report/chemotherapy/', tumor_df[i, 23], ' -F "qc=@', qc_info, '" ', "\n", 
'curl haplab.haplox.net/api/report/chemotherapy/', tumor_df[i, 23], ' -F "chem=@', chem_info, '" ', "\n", 
'curl haplab.haplox.net/api/report/chemotherapy/', tumor_df[i, 23], ' -F "germline=@', cancer_female_trans, '" ', "\n", 
'curl haplab.haplox.net/api/report/chemotherapy/', tumor_df[i, 23], ' -F "germline=@', cancer_male_trans, '" ', "\n",
"Rscript /haplox/users/zhaoys/Script/combine_last_pair_attached_sheet.R ",out,"/\n",
sep = ""))
                    sink()
                }
            }
        }
    }else{
        print("no ffpedna_vs_gdna")
    }
    
    print(csv_df[9, 3] == csv_df[10, 3])
    cat(paste(csv_df[1,], sep="-"), "\n")

#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")

args <- commandArgs(TRUE)
input <- args[1]
input2 <- args[2]
#cfDNA_vs_gDAN
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
sampleSheet2 <- paste0("/haplox/runPipelineInfo/",  input2,  "/sequence_", input2,  ".csv")
rawout <- paste0("/haplox/rawout/",input)
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
    tumor_df <- csv_df[csv_df[,9] %in% c("cfdna","healthcfdna"),]
    print(tumor_df[,c(2,23)])
    tumor_df$normal = rep(NA, nrow(tumor_df))
    if(nrow(tumor_df) >= 1){ 
        for(i in seq(nrow(tumor_df))){
           for(j in seq(nrow(csv_df2))){
            if(csv_df2[j,3] == tumor_df[i,3] && grepl("gdna|saldna|healthdnai|ntdna",csv_df2[j,9])){
                tumor_df[i,"normal"] <- csv_df2[j,1]
                out <- paste0(rawout,"/",tumor_df[i,1])
                sh_file <- paste0(out,"/last_pair_451plus_hapyun_sentieon.sh")
                if(!file.exists(out)){
                    dir.create(out, recursive = TRUE)
                }   
                sink(sh_file)
                out_nohup <- paste0(rawout,"/",tumor_df[i,1],"/",tumor_df[i,1],".nohup.out")
                out_error <- paste0(rawout,"/",tumor_df[i,1],"/",tumor_df[i,1],".nohup.out")
                cnv_in <-paste0(rawout,"/",tumor_df[i,1],"/cnv-pair_node_25")
                cnv_out <- paste0(rawout,"/",tumor_df[i,1],"/cnv")
                cnv_rename <- paste0('"s/0001.sample/',tumor_df[i,1],'/"')
                qc_in <- paste0(rawout,"/",tumor_df[i,1],"/fastp_*/reports/*")
                qc_out <- paste0(rawout,"/",tumor_df[i,1],"/QC")
                MutScan_in <- paste0(rawout,"/",tumor_df[i,1],"/MutScan_node_24")
                MutScan_out <- paste0(rawout,"/",tumor_df[i,1],"/mutscan_",tumor_df[i,1])
                MutScan_rename<-paste0('"s/0001.MutScan_out/',tumor_df[i,1],'_mutscan/"')
                fusion <- paste0(rawout,"/",tumor_df[i,1],"/fusion")
                fusionscan_in <- paste0(rawout,"/",tumor_df[i,1],"/genefuse_huang_test_node_22")
                fusionscan_out <- paste0(rawout,"/",tumor_df[i,1],"/fusionscan")
                fusionscan_rn_1_in <- paste0(rawout,"/",tumor_df[i,1],"/fusionscan/0001.genefuse_huang_test_out_html_output_22.html")
                fusionscan_rn_1_out <-  paste0(rawout,"/",tumor_df[i,1],"/fusionscan/",tumor_df[i,1],"_fusion.html")
                fusionscan_rn_2_in <- paste0(rawout,"/",tumor_df[i,1],"/fusionscan/0001.genefuse_huang_test_out_json_output_22.json")
                fusionscan_rn_2_out <-  paste0(rawout,"/",tumor_df[i,1],"/fusionscan/",tumor_df[i,1],"_fusion.json")
                germline_in <- paste0(rawout,"/",tumor_df[i,1],"/germline-sentieon-nofastp_node_36")
                germline_out<- paste0(rawout,"/",tumor_df[i,1],"/germline")
                germline_rn <- paste0('"s/sample/',tumor_df[i,"normal"],'/"')
                mrbam_in <- paste0(rawout,"/",tumor_df[i,1],"/MrBam*/mrbam/*")
                mrbam_mv <- paste0(rawout,"/",tumor_df[i,1],"/MrBam*")
                varscan_in <- paste0(rawout,"/",tumor_df[i,1],"/varscan*/*")
                varscan_rn_1_in <- paste0(rawout,"/",tumor_df[i,1],"/0001.varscan-annovar-pair_indel_txt_output_18.txt")
                varscan_rn_1_out <- paste0(rawout,"/",tumor_df[i,1],"/",tumor_df[i,1],"_indel_annovar.hg19_multianno.txt")
                varscan_rn_2_in <- paste0(rawout,"/",tumor_df[i,1],"/0001.varscan-annovar-pair_snv_txt_output_18.txt")
                varscan_rn_2_out <- paste0(rawout,"/",tumor_df[i,1],"/",tumor_df[i,1],"_snv_annovar.hg19_multianno.txt")
                varscan_rename <- paste0('"s/sample/',tumor_df[i,1],'/"')
                varscan_mv <- paste0(rawout,"/",tumor_df[i,1],"/varscan*")
                baseline <- paste0(tumor_df[i, 2], "_", tumor_df[i, 23])
                fusion_json  <- paste0(rawout, "/", tumor_df[i, 1], "/fusionscan/", tumor_df[i, 1], "_fusion.json")
                fusion_bam  <- paste0(rawout, "/", tumor_df[i, 1], "/", tumor_df[i, 1], "_rg.bam")
                tsv_dir <- paste0(out,"/tsv")
                mrbam_snv <- paste0(out, "/",baseline,".snv_MrBam.txt")
                mrbam_indel <- paste0(out, "/",baseline,".indel_MrBam.txt")
                tsv_snv <- paste0(tsv_dir,out,"/",baseline,".snv_MrBam.tsv")
                tsv_indel <- paste0(tsv_dir,out,"/",baseline,".indel_MrBam.tsv")
cat(paste("###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
 tumor_df[i, 1], "/tmp/MrBam_pair_node_16/ ", out,"/MrBam_pair_node_16/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
 tumor_df[i, 1], "/tmp/MrBam_pair_node_17/ ", out,"/MrBam_pair_node_17/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_", 
tumor_df[i, 1], "/tmp/MutScan_node_24/ ", out, "/MutScan_node_24/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
tumor_df[i, 1], "/tmp/cnv-pair_node_25/ ", out, "/cnv-pair_node_25/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
tumor_df[i, 1], "/tmp/genefuse_huang_test_node_22/ ", out, "/genefuse_huang_test_node_22/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
tumor_df[i, 1], "/tmp/germline-sentieon-nofastp_node_36/result/ --include sample* ", out, "/germline-sentieon-nofastp_node_36/result/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
tumor_df[i, 1], "/tmp/varscan-annovar-pair_node_18/ ", out, "/varscan-annovar-pair_node_18/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
tumor_df[i, 1], "/tmp/fastp_node_5/reports/ --include S* ", out,"/fastp_node_5/reports/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
tumor_df[i, 1], "/tmp/fastp_node_6/reports/ --include S* ", out, "/fastp_node_6/reports/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
tumor_df[i, 1], "/tmp/factera_fusion_node_35/fusion/0001.sentieon-bwa-sort-gencore-out-sort-rmdup-factera.fusions.txt_rgfactera.fusions.txt_cfdna.factera.fusions.txt ",out,"/factera_fusion_node_35/fusion/\n",
"###\n","echo ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
tumor_df[i, 1], "/tmp/sentieon-bwa-sort-gencore-out-sort-rmdup-bam_node_34/0001.sentieon-bwa-sort-gencore-out-sort-rmdup-bam_rgbam_cfdna.bam ./ >> /haplox/rawout/sort.txt\n",
"###\n","echo ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/pair_mutant_pe_sentieon_gencore_16core64g_",
tumor_df[i, 1], "/tmp/sentieon-bwa-sort-gencore-out-sort-rmdup-bam_node_33/0001.sentieon-bwa-sort-gencore-out-sort-rmdup-bam_rgbam_gdna.bam ./ >> /haplox/rawout/sort.txt\n",
"###\n","mv ", cnv_in, " ",  cnv_out, "\n","###\n","rename ", cnv_rename ," ", cnv_out, "/*\n",
"###\n","mkdir ",qc_out, "\n", "###\n","mv ",qc_in, " ", qc_out, "/\n", "###\n", "rm -r ", out, "/fastp*\n",
"###\n","mv ", MutScan_in , " ", MutScan_out , "\n", "###\n","rename ", MutScan_rename ," ",  MutScan_out,"/*\n",
"###\n","mv ",out,"/factera_fusion_node_35/fusion"," ",out,"/\n","###\n","rm -r ",out,"/factera_fusion_node_35","\n",
"###\n","mv ",fusion,"/0001.sentieon-bwa-sort-gencore-out-sort-rmdup-factera.fusions.txt_rgfactera.fusions.txt_cfdna.factera.fusions.txt"," ",fusion,"/",tumor_df[i, 1],".factera.fusions.txt","\n",
"###\n","mv ",fusionscan_in ," ", fusionscan_out,"\n","###\n","mv ",fusionscan_rn_1_in , " ", fusionscan_rn_1_out,"\n",
"###\n","mv ", fusionscan_rn_2_in ," ", fusionscan_rn_2_out,"\n","###\n","mv ",germline_in ," ", germline_out,"\n",
"###\n","rename ", germline_rn ," ",  germline_out, "/result/* \n", "###\n", "mv ", mrbam_in ," ", out, "/", "\n",
"###\n","rm -r ",mrbam_mv,"\n","###\n","mv  ",varscan_in ," ",out,"\n",
"###\n","mv ",varscan_rn_1_in ," ",varscan_rn_1_out,"\n",
"###\n","mv ", varscan_rn_2_in ," ", varscan_rn_2_out, "\n", "###\n" ,"rename ",varscan_rename ," ", out, "/*","\n",
"###\n","rm -r " ,varscan_mv, "\n", 
"###\n","/haplox/thinker/net/tools/extract_vcf_nofilter ", tsv_dir, " ", mrbam_snv, "\n",
"###\n","/haplox/thinker/net/tools/extract_vcf_nofilter ", tsv_dir, " ", mrbam_indel, "\n",
"###\n", "/haplox/thinker/net/ctDNA/samplemutationimport  -i ",tsv_snv, "\n",
"###\n", "/haplox/thinker/net/ctDNA/samplemutationimport  -i ", tsv_indel, "\n",
"###\n", "/haplox/thinker/net/ctDNA/mutationimport -mysql=192.168.1.14:3306 -i ", tsv_snv, "\n",
"###\n", "/haplox/thinker/net/ctDNA/mutationimport -mysql=192.168.1.14:3306 -i ", tsv_indel, "\n",
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/nobias_getMrBam_txt.R ", out, " ", baseline ,"\n",
"###\n", "python /haplox/users/yangbo/futionbase.py -f ", fusionscan_rn_2_out ,  "\n",
"###\n", "python /haplox/users/yangbo/last_Annokb.py -d ", out, "\n",
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/idSNP.R ", out , " ",tumor_df[i,1],"\n",
"###\n","Rscript  /haplox/users/zhaoys/cnv/getCnv.R  /haplox/users/zhaoys/cnv/cnv.csv ", out,"/cnv/",tumor_df[i,1],"_rg_cnv_result.txt", " ", out,"/cnv/",tumor_df[i,1],"_rg_cnv_result_chr.csv","\n",
"###\n","Rscript /haplox/users/zhaoys/cnv/hpc_cnv_germline_451.R"," ",out,"\n",
"###\n","mkdir ",wk,"/",tumor_df[i,23],"\n","###\n","cp -r ",out,"/Annokb*", " ", wk,"/",tumor_df[i,23], "/\n",
"###\n","cp -r ",out,"/mutscan* ", wk,"/",tumor_df[i,23],"/\n", "###\n","###\n","cp -r ",out,"/fusionscan ", wk,"/",tumor_df[i,23],"/\n", "###\n",
"###\n","cp -r ",out, "/cnv/*rg_cnv_result.csv", " ", wk,"/",tumor_df[i,23],"/\n",
"###\n","cp -r ",out,"/germline/result/*curl.xls"," ",wk,"/",tumor_df[i,23],"/\n",sep = ""))
                 sink()
            }
        }
    }
}else{
        print("no cfdna_vs_gdna")
    }

    print(csv_df[9, 3] == csv_df[10, 3])
    cat(paste(csv_df[1,], sep="-"), "\n")


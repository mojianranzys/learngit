#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")

args <- commandArgs(TRUE)
csv_df3 <- NULL
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
    csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    csv_df2 <- read.csv(sampleSheet2, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="GBK")
    tumor_df <- csv_df[csv_df[,9] %in% c("cfdna","healthcfdna","pedna") & grepl("肠康",csv_df[,25]),]
    print(tumor_df[,c(2,23)])
    tumor_df$normal = rep(NA, nrow(tumor_df))
    if(nrow(tumor_df) >= 1){ 
        for(i in seq(nrow(tumor_df))){
           for(j in seq(nrow(csv_df2))){
            if(csv_df2[j,3] == tumor_df[i,3] && grepl("gdna|saldna|healthdna|ntdna|atdna",csv_df2[j,9])){
                tumor_df[i,"normal"] <- csv_df2[j,1]
                out <- paste0(rawout,"/",tumor_df[i,1])
                csv_df3 <- c(csv_df3,out)
                sh_file <- paste0(out,"/last_pair_451plus_HPCH_IDT_no_facter.sh")
                if(!file.exists(out)){
                    dir.create(out, recursive = TRUE)
                }   
                sink(sh_file)
                tsv_dir <- paste0(out,"/tsv")
                baseline <- paste0(tumor_df[i, 2], "_", tumor_df[i, 23])
                mrbam_snv <- paste0(out, "/",baseline,".snv_MrBam.txt")
                mrbam_indel <- paste0(out, "/",baseline,".indel_MrBam.txt")
                tsv_snv <- paste0(tsv_dir,out,"/",baseline,".snv_MrBam.tsv")
                tsv_indel <- paste0(tsv_dir,out,"/",baseline,".indel_MrBam.tsv")
                bamqc_cfdna <- paste0(out,"/BamQC/",tumor_df[i,1],"/bam_pileup_QC/",tumor_df[i,1],".bam_qc.csv")
                bamqc_gdna <- paste0(out,"/BamQC/",tumor_df[i,"normal"],"/bam_pileup_QC/",tumor_df[i,"normal"],".bam_qc.csv")
cat(paste("ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
 tumor_df[i, 1], "/tmp/MrBam_pair_node_16/mrbam/ --include *snv_MrBam.txt ", out,"/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
 tumor_df[i, 1], "/tmp/MrBam_pair_node_17/mrbam/ --include *indel_MrBam.txt ", out,"/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_", 
tumor_df[i, 1], "/tmp/MutScan_node_24/ ", out, "/mutscan_", tumor_df[i,1], "/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/cnv-pair_node_25/ ", out, "/cnv/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/genefuse_huang_test_node_22/ ", out, "/fusionscan/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/germline-sentieon-nofastp_node_36/result/ --include sample* ", out, "/germline/result/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/varscan-annovar-pair_node_18/ ", out, "/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/fastp-16core64g_node_1/reports/ ", out,"/fastp/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/fastp-16core64g_node_2/reports/ ", out, "/fastp/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/rgbam_captureByBase_depth_maprate_node_43/ ", out, "/BamQC/",tumor_df[i,1],"/\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/rgbam_captureByBase_depth_maprate_node_42/ ", out, "/BamQC/",tumor_df[i,"normal"],"/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/Visual_msi_node_41/ ", out, "/Visual_msi/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/virus_node_37/0001.virus_resulttxt_cfdna_output_37.txt  ", out,"/virus/\n",
"ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/virus_node_38/0001.virus_resulttxt_gdna_output_38.txt ", out, "/virus/\n",
"echo ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/sentieon-bwa-gencore-pileup-no-umi_node_3/0001.sentieon-bwa-gencore-pileup-no-umi_gdna_rgbam_output_3.bam ./ >> /haplox/rawout/sort.txt\n",
"echo ossutil cp -r oss://sz-hapres/haplox/hapyun/201904/pair_IDT_HPCH_no_facter_",
tumor_df[i, 1], "/tmp/sentieon-bwa-gencore-pileup-no-umi_node_4/0001.sentieon-bwa-gencore-pileup-no-umi_cfdna_rgbam_output_4.bam ./ >> /haplox/rawout/sort.txt\n",
"#-------------------------------------------------------------------------------------------------\n",
"rename ",'"s/0001.sample/',tumor_df[i,1],'/"', " ", out,"/cnv/*\n",
"###\n","rename ", '"s/0001.MutScan_out/',tumor_df[i,1],'_mutscan/"', " ", out,"/mutscan_", tumor_df[i,1],"/*\n",
"###\n","mv ",out,"/fusionscan/0001.genefuse_huang_test_out_html_output_22.html ",out,"/fusionscan/",tumor_df[i,1],"_fusion.html\n",
"###\n","mv ",out,"/fusionscan/0001.genefuse_huang_test_out_json_output_22.json ",out,"/fusionscan/",tumor_df[i,1],"_fusion.json\n",
"###\n","rename ",'"s/sample/',tumor_df[i,"normal"],'/"'," ", out, "/germline/result/*\n", 
"###\n","mv ", out,"/0001.varscan-annovar-pair_indel_txt_output_18.txt ", out, "/",tumor_df[i,1],"_indel_annovar.hg19_multianno.txt\n",
"###\n","mv ", out,"/0001.varscan-annovar-pair_snv_txt_output_18.txt ", out, "/",tumor_df[i,1],"_snv_annovar.hg19_multianno.txt\n",
"###\n","rename ",'"s/sample/',tumor_df[i,1],'/"', " ", out,"/*\n",
"###\n","rename ",'"s/0001.sentieon-bwa-gencore-pileup-no-umi_cfdna_rgbam_output_4/',tumor_df[i,1],'/"'," ", 
out,"/BamQC/",tumor_df[i,1],"/bam_pileup_QC/*\n",
"###\n","rename ",'"s/0001.sentieon-bwa-gencore-pileup-no-umi_gdna_rgbam_output_3/',tumor_df[i, "normal"],'/"'," ", 
out,"/BamQC/",tumor_df[i,"normal"],"/bam_pileup_QC/*\n",
"###\n","mv ", out,"/BamQC/",tumor_df[i,1],"/capture/0001.sentieon-bwa-gencore-pileup-no-umi_cfdna_rgbam_output_4.bam_capture_stat.txt ",
out,"/BamQC/",tumor_df[i,1],"/capture/", tumor_df[i,1],"_capture_stat.txt\n",
"###\n","mv ", out,"/BamQC/",tumor_df[i,"normal"],"/capture/0001.sentieon-bwa-gencore-pileup-no-umi_gdna_rgbam_output_3.bam_capture_stat.txt ",
out,"/BamQC/",tumor_df[i,"normal"],"/capture/", tumor_df[i,"normal"],"_capture_stat.txt\n",
"###\n","rename ",'"s/0001.sentieon-bwa-gencore-pileup-no-umi_cfdna_rgbam_output_4/',tumor_df[i,1],'/"'," ",
out,"/BamQC/",tumor_df[i,1],"/depth/*\n",
"###\n","rename ",'"s/0001.sentieon-bwa-gencore-pileup-no-umi_gdna_rgbam_output_3/',tumor_df[i,1],'/"'," ",
out,"/BamQC/",tumor_df[i,"normal"],"/depth/*\n",
"###\n",'curl haplab.haplox.net/api/report/depth-new -F "import_file=@',bamqc_cfdna,'"',"\n",
"###\n",'curl haplab.haplox.net/api/report/depth-new -F "import_file=@',bamqc_gdna,'"',"\n",
"###\n","mv ", out,"/Visual_msi/0001.Visual_msi_html_output_41.html ",out,"/Visual_msi/", tumor_df[i,1], "_msi.html\n",
"###\n","mv ", out,"/Visual_msi/0001.Visual_msi_json_output_41.json ",out,"/Visual_msi/", tumor_df[i,1], "_msi.json\n",
"###\n","mv ", out,"/virus/0001.virus_resulttxt_cfdna_output_37.txt ", out, "/virus/",tumor_df[i,1],"_virus_result.txt\n",
"###\n","mv ", out,"/virus/0001.virus_resulttxt_gdna_output_38.txt ", out, "/virus/",tumor_df[i,"normal"],"_virus_result.txt\n",
"###\n","/haplox/thinker/net/tools/extract_vcf_nofilter ", tsv_dir, " ", mrbam_snv, "\n",
"###\n","/haplox/thinker/net/tools/extract_vcf_nofilter ", tsv_dir, " ", mrbam_indel, "\n",
"###\n", "/haplox/thinker/net/ctDNA/samplemutationimport  -i ",tsv_snv, "\n",
"###\n", "/haplox/thinker/net/ctDNA/samplemutationimport  -i ", tsv_indel, "\n",
"###\n", "/haplox/thinker/net/ctDNA/mutationimport -mysql=192.168.1.14:3306 -i ", tsv_snv, "\n",
"###\n", "/haplox/thinker/net/ctDNA/mutationimport -mysql=192.168.1.14:3306 -i ", tsv_indel, "\n",
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/nobias_getMrBam_txt.R ", out, " ", baseline ,"\n",
"###\n", "python /haplox/users/yangbo/futionbase.py -f ",out,"/fusionscan/",tumor_df[i,1],"_fusion.json\n",
"###\n", "python /haplox/users/yangbo/last_Annokb.py -d ", out, "\n",
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/idSNP.R ", out , " ",tumor_df[i,1],"\n",
"###\n", "Rscript /haplox/users/zhaoys/Script/SNP_diff_warning.R ",out,"/\n",
"###\n","Rscript  /haplox/users/zhaoys/cnv/getCnv.R  /haplox/users/zhaoys/cnv/cnv.csv ", out,"/cnv/",tumor_df[i,1],"_rg_cnv_result.txt", " ", out,"/cnv/",tumor_df[i,1],"_rg_cnv_result_chr.csv","\n",
"###\n","Rscript /haplox/users/zhaoys/cnv/hpc_cnv_germline_451.R"," ",out,"\n",
"###\n","mkdir ",wk,"/",tumor_df[i,23],"\n","###\n","cp -r ",out,"/Annokb*", " ", wk,"/",tumor_df[i,23], "/\n",
"###\n","cp -r ",out,"/mutscan* ", wk,"/",tumor_df[i,23],"/\n", "###\n","###\n","cp -r ",out,"/fusionscan ", wk,"/",tumor_df[i,23],"/\n", "###\n",
"###\n","cp -r ",out,"/Visual_msi ", wk,"/",tumor_df[i,23],"/\n",
"###\n","cp -r ",out,"/virus ",wk,"/",tumor_df[i,23],"/\n",
"###\n","cp -r ",out, "/cnv/*rg_cnv_result.csv", " ", wk,"/",tumor_df[i,23],"/\n",
"###\n","cp -r ",out,"/germline/result/*curl.xls"," ",wk,"/",tumor_df[i,23],"/\n",sep = ""))
                 sink()
            }
        }
    }
}else{
        print("no cfdna_vs_gdna")
    }
###
sh_file2 <- paste0(rawout,"/muilt_pair_cfdna_451plus.sh")
sink(sh_file2,append = TRUE)
for(i in seq(length(csv_df3))){
    cat(paste0("###\n","nohup bash ",csv_df3[i],"/last_pair_451plus_HPCH_IDT_no_facter.sh & \n",step = ""))  
}


#!/usr/bin/Rscript
print("zhaoys")
cat("zhaoys\n")

args <- commandArgs(TRUE)
input <- args[1]
#only cfdna/ttdna no gdna & 451plus
sampleSheet <- paste0("/haplox/runPipelineInfo/",  input,  "/sequence_", input,  ".csv")
rawout <- paste0("/haplox/rawout/",input)
if(!file.exists(rawout)){
    dir.create(rawout, recursive = TRUE)
}
csv_df <- read.csv(sampleSheet, header=FALSE, stringsAsFactors = FALSE,  fileEncoding="latin1", encoding="UTF-8")
if(nrow(csv_df) >= 1){
    for(i in seq(nrow(csv_df))){
        if(csv_df[i,9] %in% c("cfdna","healthcfdna","ttdna") & grepl("451plus", csv_df[i,1])){
            out <- paste0(rawout,"/",csv_df[i,1])
            print(csv_df[,c(2,23)])
            out <- paste0(rawout,"/",csv_df[i,1])
            sh_file <- paste0(out, "/sigle_cfdna_ttdna_451plus.sh")
            if(!file.exists(out)){
                dir.create(out, recursive = TRUE)
                }   
sink(sh_file)
tsv_dir <- paste0(out,"/tsv")
baseline <- paste0(csv_df[i, 2], "_", csv_df[i, 23])
mrbam_snv <- paste0(out, "/",baseline,".snv_MrBam.txt")
mrbam_indel <- paste0(out, "/",baseline,".indel_MrBam.txt")
tsv_snv <- paste0(tsv_dir,out,"/",baseline,".snv_MrBam.tsv")
tsv_indel <- paste0(tsv_dir,out,"/",baseline,".indel_MrBam.tsv")
cat(paste0("###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/sentieon-single_", csv_df[i,1], "/tmp/MrBam_node_15/mrbam/ --include *snv_MrBam.txt  ", out, "\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/sentieon-single_", csv_df[i,1], "/tmp/MrBam_node_16/mrbam/ --include *indel_MrBam.txt  ", out, "\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/sentieon-single_",csv_df[i,1], "/tmp/MutScan_node_11/  ", out, "/mutscan_",csv_df[i,1],"\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/sentieon-single_",csv_df[i,1], "/tmp/Visual_msi_single_node_19/  ", out, "/msi\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/sentieon-single_",csv_df[i,1], "/tmp/cnv_node_17/ --include 0001.sample* ", out,"/cnv\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/sentieon-single_",csv_df[i,1], "/tmp/factera_bigcase_node_12/fusion/ --include *fusions.txt ",out, "/fusion\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/sentieon-single_",csv_df[i,1],"/tmp/fastp-16core64g_node_3/reports/ ",out,"/QC\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/sentieon-single_",csv_df[i,1],"/tmp/genefuse_huang_test_node_9/  " ,out,"/fusionscan\n",
"###\n","ossutil cp -r oss://sz-hapres/haplox/hapyun/201901/sentieon-single_",csv_df[i,1],"/tmp/varscan-annovar-single_node_14/ --include 0001.varscan_output* ", out,"\n",
"###\n","rename ",'"s/0001.MutScan_out_html_output_11/',csv_df[i,1],'_mutscan/"'," ",  out, "/mutscan_", csv_df[i,1],"/*\n",
"###\n","mv ",out,"/mutscan_", csv_df[i,1],"/0001.MutScan_out_json_output_11.json ", out,"/mutscan_", csv_df[i,1],"/",csv_df[i,1],"_mutscan.json\n",
"###\n","mv ",out,"/msi/0001.Visual_msi_single_html_output_19.html ",out,"/msi/",csv_df[i,1],"_msi.html\n",
"###\n","mv ",out,"/msi/0001.Visual_msi_single_json_output_19.json ",out,"/msi/",csv_df[i,1],"_msi.json\n",
"###\n","rename ",'"s/0001.sample/',csv_df[i,1],'/"'," ", out,"/cnv/*\n",
"###\n","mv ",out, "/fusion/0001.sentieon_output_rgfactera.fusions.txt.factera.fusions.txt ",out,"/fusion/",csv_df[i,1],"_sort.factera.fusions.txt\n",
"###\n","mv ",out, "/fusionscan/0001.genefuse_output_html.html ", out,"/fusionscan/",csv_df[i,1],"_fusion.html\n",
"###\n","mv ",out, "/fusionscan/0001.genefuse_output_json.json ", out,"/fusionscan/",csv_df[i,1],"_fusion.json\n",
"###\n","mv ",out,"/0001.varscan_output_indel.txt ",out,"/",csv_df[i,1],"_indel_annovar.hg19_multianno.txt\n",
"###\n","mv ",out,"/0001.varscan_output_snv.txt ",out,"/",csv_df[i,1],"_snv_annovar.hg19_multianno.txt\n",
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/single_getMrBam_txt.R ", out, "/ ", baseline ,"\n",
"###\n","/haplox/thinker/net/tools/extract_vcf_nofilter ", tsv_dir, " ", mrbam_snv, "\n",
"###\n","/haplox/thinker/net/tools/extract_vcf_nofilter ", tsv_dir, " ", mrbam_indel, "\n",
"###\n", "/haplox/thinker/net/ctDNA/samplemutationimport  -i ",tsv_snv, "\n",
"###\n", "/haplox/thinker/net/ctDNA/samplemutationimport  -i ", tsv_indel, "\n",
"###\n", "/haplox/thinker/net/ctDNA/mutationimport -mysql=192.168.1.14:3306 -i ", tsv_snv, "\n",
"###\n", "/haplox/thinker/net/ctDNA/mutationimport -mysql=192.168.1.14:3306 -i ", tsv_indel, "\n",
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getCnv.R ",
        "/haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/cnv/cnv.csv ",
        out,"/cnv/",csv_df[i,1],"_rg_cnv_result.txt ",out,"/cnv/",csv_df[i,1],"_rg_cnv_result.csv ",
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R ",
        "/haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes378.bed " ,
        out, "/", baseline,"_snv-GB18030-baseline.csv T ",
        out, "/", baseline,"_snv-GB18030-baseline-genes378.csv 0.2 \n",
"###\n", "Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R ",
        "/haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes378.bed ", 
        out, "/", baseline,"_indel-GB18030-baseline.csv T ",
        out, "/", baseline,"_indel-GB18030-baseline-genes378.csv 0.2 \n",
"###\n", "python /thinker/net/tools/Annokb.py ", 
        "-f ", out, "/", baseline,"_snv-GB18030-baseline-genes378.csv ",
        "-t snv -o ",  out,"/Annokb_mrbam_", baseline,".snv-nobias-GB18030-baseline-genes378.csv \n",
"###\n", "python /thinker/net/tools/Annokb.py ", 
        "-f ", out, "/", baseline,"_indel-GB18030-baseline-genes378.csv ",
        "-t snv -o ",  out,"/Annokb_mrbam_", baseline,".indel-nobias-GB18030-baseline-genes378.csv \n",
step =""))
                 sink()
            }
        }
    }else{
        print("no single cfdna/ttdna")
    }

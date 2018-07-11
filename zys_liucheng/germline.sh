####eg:cfdna_6226
###step1_fastp
/tools/fastp/fastp -i /haplox/users/zhaoys/rawfq/S001_20180404003-3_cfdna_pan-cancer-v1_6266_S1_R1_001.fastq.gz\
     -I /haplox/users/zhaoys/rawfq/S001_20180404003-3_cfdna_pan-cancer-v1_6266_S1_R2_001.fastq.gz\
     -o /haplox/users/zhaoys/cleanfq/S001_20180404003-3_cfdna_pan-cancer-v1_6266_S1_R1_001.good.fq.gz\
     -O /haplox/users/zhaoys/cleanfq/S001_20180404003-3_cfdna_pan-cancer-v1_6266_S1_R2_001.good.fq.gz\
     -j /haplox/users/zhaoys/cleanfq/S001_20180404003-3_cfdna_pan-cancer-v1_6266_S1.json\
     -h /haplox/users/zhaoys/cleanfq/S001_20180404003-3_cfdna_pan-cancer-v1_6266_S1.html &

###step2_BWA
bwa mem -R "@RG\tID:S001_20180404003-3_cfdna_pan-cancer-v1_6266\tLB:S001_20180404003-3_cfdna_pan-cancer-v1_6266\tPL:ILLUMINA\tSM:S001_20180404003-3_cfdna_pan-cancer-v1_6266" -t 10 -k 32 -M /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta /haplox/users/zhaoys/cleanfq/S001_20180404003-3_cfdna_pan-cancer-v1_6266_S1_R1_001.good.fq.gz /haplox/users/zhaoys/cleanfq/S001_20180404003-3_cfdna_pan-cancer-v1_6266_S1_R2_001.good.fq.gz > ./S001_20180404003-3_cfdna_pan-cancer-v1_6266.sam &

###step3_sam&bam
/tools/samtools/samtools view -bS -@ 10 /haplox/users/zhaoys/step2_bwa/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.sam -o /haplox/users/zhaoys/step2_bwa/S001_20180404003-3_cfdna_pan-cancer-v1_6266.bam  &

###step4_sort
java -Djava.io.tmpdir=/haplox/users/Zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
   -Xmx4g -jar /tools/GATK/picard/SortSam.jar\
   INPUT=/haplox/users/zhaoys/step2_bwa/S001_20180404003-3_cfdna_pan-cancer-v1_6266.bam \
   OUTPUT=/haplox/users/zhaoys/step2_bwa/S001_20180404003-3_cfdna_pan-cancer-v1_6266.sort.bam SORT_ORDER=coordinate &

###step5_piacrd
java -Djava.io.tmpdir=/haplox/users/zhaoys/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
  -Xmx8g -jar /tools/GATK/picard/MarkDuplicates.jar MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000\
  INPUT=/haplox/users/zhaoys/step2_bwa/S001_20180404003-3_cfdna_pan-cancer-v1_6266.sort.bam\
  OUTPUT=/haplox/users/zhaoys/step3_picard/S001_20180404003-3_cfdna_pan-cancer-v1_6266.dedup.bam\
  METRICS_FILE=/haplox/users/zhaoys/step3_picard/S001_20180404003-3_cfdna_pan-cancer-v1_6266.metrics\
  VALIDATION_STRINGENCY=LENIENT  & 

###step6_index
/tools/samtools/samtools index /haplox/users/zhaoys/step3_picard/S001_20180404003-3_cfdna_pan-cancer-v1_6266.dedup.bam

###step7_RealignerTargetCreator
java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
    -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
    -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta -T RealignerTargetCreator\
    -I /haplox/users/zhaoys/step3_picard/S001_20180404003-3_cfdna_pan-cancer-v1_6266.dedup.bam\
    -o /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.realn.interval\
    -known /haplox/users/ZhouYQ/Database/WES_ref/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf\
    -known /haplox/users/ZhouYQ/Database/WES_ref/1000G_phase1.indels.hg19.sites.vcf &

###step8_indel realigner
java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
  -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
  -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\
  -T IndelRealigner -targetIntervals /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.realn.intervals\
  -o /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.realn.bam\
  -I /haplox/users/zhaoys/step3_picard/S001_20180404003-3_cfdna_pan-cancer-v1_6266.dedup.bam\
  -known /haplox/users/ZhouYQ/Database/WES_ref/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf\
  -known /haplox/users/ZhouYQ/Database/WES_ref/1000G_phase1.indels.hg19.sites.vcf &

###step9_index
/tools/samtools/samtools index /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.realn.bam &

###step10_1_base recalibrator(BQSR)
java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
 -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
 -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\
 -T BaseRecalibrator\
 -I /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.realn.bam\
 -knownSites /haplox/users/ZhouYQ/Database/WES_ref/dbsnp_138.hg19.vcf\
 -knownSites /haplox/users/ZhouYQ/Database/WES_ref/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf\
 -knownSites /haplox/users/ZhouYQ/Database/WES_ref/1000G_phase1.indels.hg19.sites.vcf\
 -o /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.grp -nct 10 &

###step10_2_BQSR compare graph
 java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
 -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
 -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\
 -T BaseRecalibrator\
 -I /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.realn.bam\
 -BQSR /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.grp\
 -o /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.recal_2.grp\
 -knownSites /haplox/users/ZhouYQ/Database/WES_ref/dbsnp_138.hg19.vcf\
 -knownSites /haplox/users/ZhouYQ/Database/WES_ref/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf\
 -knownSites /haplox/users/ZhouYQ/Database/WES_ref/1000G_phase1.indels.hg19.sites.vcf &
 
###step10_3_print reads
java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
 -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
 -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\
 -T PrintReads\
 -I /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.realn.bam\
 -BQSR /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.grp\
 -o /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.baserecal.bam -nct 10 &

###step11_analyze
java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
  -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
  -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\
  -T AnalyzeCovariates\
  -before /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.grp\
  -after /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.recal_2.grp\
  -csv /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.recal.grp.csv\
  -plots /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.recal.grp.pdf &

###step12_ HaplotypeCaller
java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
 -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
 -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\
 -T HaplotypeCaller\
 -I /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.baserecal.bam\
 -D /haplox/users/ZhouYQ/Database/WES_ref/dbsnp_138.hg19.vcf\
 -o /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.vcf\
 -stand_call_conf 30.0 -stand_emit_conf 10 \
 -rf BadCigar -l INFO -L /haplox/ref/bed/hap-research-0317.bed -nct 10

###step12_1_select SNP
java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
  -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
  -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\
  -T SelectVariants\
  -V /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.vcf\
  -selectType SNP\
  -o /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.snp.vcf &
  
###step12_2_select INDEL
java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
  -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
  -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\
  -T SelectVariants\
  -V /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.vcf\
  -selectType INDEL\
  -o /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.indel.vcf &

###step12_3_fliter SNP
java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
  -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
  -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\
  -T VariantFiltration\
  -V /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.snp.vcf\
  --filterExpression "QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0" --filterName "SNP_filter" \
 -o /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.snp.fliter.vcf &

###step12_4_fliter INDEL
java -Djava.io.tmpdir=/haplox/users/zhaoys/tmp/S001_20180404003-3_cfdna_pan-cancer-v1_6266\
  -Xmx8g -jar /tools/GATK/GenomeAnalysisTK.jar\
  -R /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\
  -T VariantFiltration\
  -V /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.indel.vcf\
  --filterExpression "QD < 2.0 || FS > 200.0 || SOR > 10.0 || ReadPosRankSum < -20.0" --filterName "INDEL_filter" \
 -o /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.indel.fliter.vcf &

###step12_5 join SNP_INDEL
grep '^#' /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.snp.fliter.vcf > /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.filter.vcf
grep PASS /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.snp.fliter.vcf >> /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.filter.vcf
grep PASS /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.raw.indel.fliter.vcf >> /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.filter.vcf &

###step13_varation annotation
perl /haplox/tools/annovar/table_annovar.pl /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.fliter.vcf /haplox/tools/annovar/humandb/ -buildver hg19 -out /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.fliter -remove -protocol refGene,cytoBand,genomicSuperDups,esp6500siv2_all,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eas,1000g2014oct_eur,snp138,ljb26_all -operation g,r,r,f,f,f,f,f,f,f -arg '-splicing_threshold 10',,,,,,,,, -nastring . -vcfinput &  

###step14_germline/result
######chem_genotype
perl /haplox/users/ZhouYQ/germline/bin/chem_sen.pl /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.fliter.vcf /haplox/users/ZhouYQ/germline/bin/Database/Chem_drug_sen.list /haplox/users/zhaoys/step5_result/S001_20180404003-3_cfdna_pan-cancer-v1_6266.chem_genotype.txt
###chem_58
perl /haplox/users/ZhouYQ/germline/bin/NewPan_chem.pl /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.fliter.vcf /haplox/users/ZhouYQ/germline/bin/Database/Chem58_gene.txt /haplox/users/zhaoys/step5_result/S001_20180404003-3_cfdna_pan-cancer-v1_6266.chem_58.txt
###chem_86
perl /haplox/users/ZhouYQ/germline/bin/NewPan_chem.pl /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.fliter.vcf /haplox/users/ZhouYQ/germline/bin/Database/Chem86_gene.txt /haplox/users/zhaoys/step5_result/S001_20180404003-3_cfdna_pan-cancer-v1_6266.chem_86.txt
###chem_451
perl /haplox/users/ZhouYQ/germline/bin/NewPan_chem.pl /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.fliter.vcf /haplox/users/ZhouYQ/germline/bin/Database/Chem451_gene.txt /haplox/users/zhaoys/step5_result/S001_20180404003-3_cfdna_pan-cancer-v1_6266.chem_451.txt
###information(!!!!!!!keep dir construct)
perl /haplox/users/ZhouYQ/germline/bin/QC_exome.pl S001_20180404003-3_cfdna_pan-cancer-v1_6266 /haplox/users/zhaoys/step3_picard/S001_20180404003-3_cfdna_pan-cancer-v1_6266.dedup.bam /haplox/ref/bed/pan-cancer-v1.bed /haplox/users/zhaoys/step5_result
###tagert.txt
perl /haplox/users/ZhouYQ/germline/bin/NewPan_chem.pl /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.fliter.vcf  /haplox/users/ZhouYQ/germline/bin/Database/Target451_gene.txt /haplox/users/zhaoys/step5_result/S001_20180404003-3_cfdna_pan-cancer-v1_6266.Target_451.txt
###germline
perl /haplox/users/ZhouYQ/germline/bin/PathCall.pl -i /haplox/users/zhaoys/step4_GATK/S001_20180404003-3_cfdna_pan-cancer-v1_6266.fliter.hg19_multianno.txt -g /haplox/users/ZhouYQ/germline/bin/Database/Heart_Cancer_Incidental.txt -o /haplox/users/zhaoys/step5_result/S001_20180404003-3_cfdna_pan-cancer-v1_6266.germline.txt
###trans_germ
perl /haplox/users/wenger/script/germline_trans.pl /haplox/users/zhaoys/step5_result/S001_20180404003-3_cfdna_pan-cancer-v1_6266.germline.txt /haplox/users/zhaoys/step5_result/S001_20180404003-3_cfdna_pan-cancer-v1_6266.trans_germ.txt


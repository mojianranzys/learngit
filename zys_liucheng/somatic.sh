###step1_fastp and step2_bwa and step3_picard(as same as germline)
###step4_mileup_calling
###ste4_1_pileup
/tools/samtools-0.1.19/samtools mpileup -B -C 50 -Q 20 -q 20 -d 30000 -f /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta -l /haplox/ref/bed/hap-research-0317.bed /haplox/users/zhaoys/step3_picard/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.dedup.bam > /haplox/users/zhaoys/somatic/mileup_calling/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.pileup

###step4_2_calling_snp
java -jar /tools/VarScan.v2.3.8.jar mpileup2snp /haplox/users/zhaoys/somatic/mileup_calling/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.pileup --min-coverage 20 --min-var-freq 0.0005  --p-value 1   --output-vcf 1 > /haplox/users/zhaoys/somatic/mileup_calling/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.snp.vcf

###step4_3_calling_indel
java -jar /tools/VarScan.v2.3.8.jar mpileup2indel /haplox/users/zhaoys/somatic/mileup_calling/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.pileup --min-coverage 50 --min-var-freq 0.0005 --p-value 1 --output-vcf 1 >  /haplox/users/zhaoys/somatic/mileup_calling/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.indel.vcf

###step5_fliter
java -jar /tools/VarScan.v2.3.8.jar filter /haplox/users/zhaoys/somatic/mileup_calling/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.snp.vcf --indel-file /haplox/users/zhaoys/somatic/mileup_calling/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.indel.vcf --output-file /haplox/users/zhaoys/somatic/fliter/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.snp.filter.vcf

###step6_annotation
###step6_1_snp_annotation
/haplox/tools/annovar/table_annovar.pl /haplox/users/zhaoys/somatic/mileup_calling/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.snp.vcf /haplox/tools/annovar/humandb/ -buildver hg19 -out /haplox/users/zhaoys/somatic/fliter_annotation/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.snp_annovar -remove -protocol refGene,cytoBand,genomicSuperDups,esp6500siv2_all,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eas,1000g2014oct_eur,snp138,ljb26_all,cosmic77,clinvar_20160302 -operation g,r,r,f,f,f,f,f,f,f,f,f -nastring . -vcfinput

###indel_annotation
/haplox/tools/annovar/table_annovar.pl /haplox/users/zhaoys/somatic/mileup_calling/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.indel.vcf /haplox/tools/annovar/humandb/ -buildver hg19 -out /haplox/users/zhaoys/somatic/fliter_annotation/S001_20180404003-3_cfdna_pan-cancer-v1_6266_2.indel_annovar -remove -protocol refGene,cytoBand,genomicSuperDups,esp6500siv2_all,1000g2014oct_all,1000g2014oct_afr,1000g2014oct_eas,1000g2014oct_eur,snp138,ljb26_all,cosmic77,clinvar_20160302 -operation g,r,r,f,f,f,f,f,f,f,f,f -nastring . -vcfinput



####step1_gencore
/tools/gencore/gencore\
  -i /haplox/users/zhaoys/zys_liucheng/step2_bwa/S001_20180404003-3_cfdna_pan-cancer-v1_6266.sort.bam\
  -o /haplox/users/zhaoys/gencore/S001_20180404003-3_cfdna_pan-cancer-v1_6266_gencore.bam\
  -r /haplox/ref/GATK/ucsc.hg19/ucsc.hg19.fasta\


####step2_sort_bam
/tools/samtools/samtools sort S001_20180404003-3_cfdna_pan-cancer-v1_6266.gencore.bam -o S001_20180404003-3_cfdna_pan-cancer-v1_6266.gencore.sort.bam


###step3_index_bam
/tools/samtools/samtools index /haplox/users/zhaoys/gencore/S001_20180404003-3_cfdna_pan-cancer-v1_6266.gencore.sort.bam

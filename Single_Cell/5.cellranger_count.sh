wkd=/haplox/users/zhaoys/Single_Cell
cd $wkd
mkdir -p count
cat Patient_2586-4.txt | while read i
do
/haplox/users/zhaoys/cellranger-3.1.0/cellranger count --id=count \
  --transcriptome=/haplox/users/zhaoys/cellranger-GRCh38/refdata-cellranger-GRCh38-1.2.0 \
  --fastqs=/haplox/users/zhaoys/Single_Cell/data/SRR_Patient_2586-4 \
  --sample=${i}
done

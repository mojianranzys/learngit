wkd=/haplox/users/zhaoys/Single_Cell/
cd $wkd/data/SRR_Patient_9245-3/
cat /haplox/users/zhaoys/Single_Cell/Patient_9245-3.txt | while read i
do
time /haplox/users/zhaoys/SRA/sratoolkit.2.8.2-1-ubuntu64/bin/fastq-dump --gzip --split-3 -A $i ${i}.sra && echo "** ${i}.sra to fastq done **"
done

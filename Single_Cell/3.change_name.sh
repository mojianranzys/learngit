wkd=/haplox/users/zhaoys/Single_Cell/
cd $wkd/data/SRR_Patient_2586-4/
cat /haplox/users/zhaoys/Single_Cell/Patient_2586-4.txt | while read i 
do
mv ${i}_1*.gz ${i}_S1_L001_I1_001.fastq.gz
mv ${i}_2*.gz ${i}_S1_L001_R1_001.fastq.gz
mv ${i}_3*.gz ${i}_S1_L001_R2_001.fastq.gz
done

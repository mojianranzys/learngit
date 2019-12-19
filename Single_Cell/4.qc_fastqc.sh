wkd=/haplox/users/zhaoys/Single_Cell
mkdir -p $wkd/qc
cd $wkd/qc
find $wkd/data/SRR_Patient_2586-4 -name '*R1*.gz'> P2586-4-id-1.txt
find $wkd/data/SRR_Patient_2586-4 -name '*R2*.gz'> P2586-4-id-2.txt
cat P2586-4-id-1.txt P2586-4-id-2.txt > P2586-4-id-all.txt
cat P2586-4-id-all.txt | xargs /haplox/users/zhaoys/FastQC/fastqc -t 20 -o ./

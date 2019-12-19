# First ways
/haplox/users/zhaoys/SRA/sratoolkit.2.8.2-1-ubuntu64/bin/prefetch.2.8.2 --option-file /haplox/users/zhaoys/Single_Cell/SraAccList2.txt 

#Second ways
ascp -QT -l 300m -P33001 -i ~/.aspera/connect/etc/asperaweb_id_dsa.openssh era-fasp@fasp.sra.ebi.ac.uk:vol1/srr/SRR772/009/SRR7722939 /haplox/users/zhaoys/Single_Cell/data/SRR_Patient_2586-4/

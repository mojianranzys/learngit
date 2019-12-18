read -p "print input up csv:" S1
ossutil cp -r /haplox/users/zhaoys/Script/dezip/${S1} oss://sz-hapbin/users/zhaoys/dezip_csv/
echo "oss://sz-hapbin/users/zhaoys/dezip_csv/${S1}"

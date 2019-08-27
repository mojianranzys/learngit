#coding:utf-8
#!/bin/bash
import os
import argparse
import xlwt
import csv
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument("-d", "--dir", nargs='?', action="store" , type=str, help="annokb sample directory")
args = parser.parse_args()

def txt_xls(in_file,out_file):
    f=open(in_file,"rt")
    x=0
    y=0
    xls=xlwt.Workbook()
    sheet = xls.add_sheet('sheet1',cell_overwrite_ok=True)
    while True:
          line = f.readline()
          if not line:
             break
          for i in line.split('\t'):
             item=i.strip().decode('utf8')
             sheet.write(x,y,item)
             y+=1
          x+=1
          y=0
    f.close()
    xls.save(out_file)

def cnv(cnv_x):
    filename = cnv_x
    with open(filename) as c:
        reader = csv.reader(c)
        cnv = list(reader)
        cnv_num = '0'   
        for i in cnv:
            if i[1] != 'cnv':
                cnv_num = cnv_num + '+' + i[1]
        avg = (eval(cnv_num)/(len(cnv)-1))
    return avg

def Annokb(path,hap,dat,gdna,num):
    if hap != gdna:
        os.system('Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R \
        /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes464.bed \
        {S1}/{S3}.snv-nobias-GB18030-baseline.csv T \
        {S1}/{S3}.snv-nobias-GB18030-baseline-genes464.csv 0.3'.format(S1=path,S3=dat))

        os.system('Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R \
        /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes464.bed \
        {S1}/{S3}.indel-nobias-GB18030-baseline.csv T \
        {S1}/{S3}.indel-nobias-GB18030-baseline-genes464.csv 0.3'.format(S1=path,S3=dat))
    else:
        os.system('Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R \
        /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes464.bed \
        {S1}/{S3}_snv-GB18030-baseline.csv T \
        {S1}/{S3}.snv-nobias-GB18030-baseline-genes464.csv 0.5'.format(S1=path,S3=dat))

        os.system('Rscript /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/getFFPE_cfDNA_snv_indel_v2.R \
        /haplox/users/huang/mypy/data-analysis/ctdna_exome_pipeline/ffpe_vs_pbl/genes464.bed \
        {S1}/{S3}_indel-GB18030-baseline.csv T \
        {S1}/{S3}.indel-nobias-GB18030-baseline-genes464.csv 0.5'.format(S1=path,S3=dat))


    #-----------------------------------------------------------------------------------------      
    os.system('python /thinker/net/tools/Annokb.py \
    -f {S1}/{S3}.indel-nobias-GB18030-baseline-genes464.csv  \
    -t indel -o {S1}/Annokb_mrbam_{S3}.indel-nobias-GB18030-baseline-genes464.csv'.format(S1=path,S3=dat))

    os.system('python /thinker/net/tools/Annokb.py \
    -f {S1}/{S3}.snv-nobias-GB18030-baseline-genes464.csv  \
    -t snv -o {S1}/Annokb_mrbam_{S3}.snv-nobias-GB18030-baseline-genes464.csv'.format(S1=path,S3=dat))

    os.system('python /haplox/users/yangbo/futionbase.py -f {S1}/fusionscan/{S2}_fusion.json -b {S1}/{S2}_rg.bam'.format(S1=path,S2=hap))
    #-----------------------------------------------------------------------------------------          
                                                      
    os.system('perl /haplox/users/ZhouYQ/germline/bin/Gene2Disease.pl /haplox/users/ZhouYQ/germline/bin/Database/female_cancer.list \
    {S1}/germline/result/{S4}.germline.txt \
    {S1}/germline/result/{S4}.cancer.female.txt \
    {S1}/germline/result/{S4}.nocancer.female.txt \
    {S1}/germline/result'.format(S1=path,S4=gdna)) 
                                                    
    os.system('perl /haplox/users/ZhouYQ/germline/bin/Gene2Disease.pl /haplox/users/ZhouYQ/germline/bin/Database/male_cancer.list \
    {S1}/germline/result/{S4}.germline.txt \
    {S1}/germline/result/{S4}.cancer.male.txt \
    {S1}/germline/result/{S4}.nocancer.male.txt \
    {S1}/germline/result '.format(S1=path,S4=gdna))

    os.system('perl /haplox/users/wenger/script/germline_trans_v2.pl \
    {S1}/germline/result//{S4}.cancer.female.txt  \
    {S1}/germline/result//{S4}_trans.cancer.female.txt'.format(S1=path,S4=gdna)) 

    os.system('perl /haplox/users/wenger/script/germline_trans_v2.pl \
    {S1}/germline/result//{S4}.cancer.male.txt  \
    {S1}/germline/result//{S4}_trans.cancer.male.txt'.format(S1=path,S4=gdna))

    cnv_list = path + '/cnv/' + hap + '_rg_cnv.chrX_genes.csv'
    avg = cnv(cnv_list)

    os.system('curl haplab.haplox.net/api/report/chemotherapy/{S5} -F "qc=@{S1}/germline/result/{S4}.information.txt" '.format(S1=path,S2=hap,S4=gdna,S5=num))
    os.system('curl haplab.haplox.net/api/report/chemotherapy/{S5} -F "chem=@{S1}/germline/result/{S4}.chem_451.txt" '.format(S1=path,S2=hap,S4=gdna,S5=num))
    if avg >= 1.5:
        os.system('curl haplab.haplox.net/api/report/chemotherapy/{S5} -F "germline=@{S1}/germline/result/{S4}_trans.cancer.female.txt" '.format(S1=path,S2=hap,S4=gdna,S5=num))
    if avg < 1.5:
        os.system('curl haplab.haplox.net/api/report/chemotherapy/{S5} -F "germline=@{S1}/germline/result/{S4}_trans.cancer.male.txt" '.format(S1=path,S2=hap,S4=gdna,S5=num))

def cnv_updata(path,num):
    title = ["data_id","gene","result","tumor","cfdna","type"]
    cnv_dir = path + '/cnv/'
    a=0
    for i in os.listdir(cnv_dir):
        if i.endswith("_rg_cnv_result.csv") and i.startswith("S"):
            with open(cnv_dir + i) as cnv_list:
                point_reader = csv.reader(cnv_list)
                for row in point_reader:
                    if a==0:
                        a += 1
                        df = pd.DataFrame ([title] , columns = title)
                        df.to_csv(cnv_dir + "result_cnv.csv",encoding="gb2312",index=False, header=False)
                        continue
                    if float(row[1]) >= 3:
                        inside = [num,row[0],"扩增",row[1],'',"cnv"]
                        df = pd.DataFrame ([inside] , columns = title)
                        df.to_csv(cnv_dir + "result_cnv.csv",encoding="gb2312",index=False, header=False, mode='a')
                        a += 1
                    if float(row[1]) <= 1 and row[0] != 'ATRX' and row[0] != 'AR':
                        inside = [num,row[0],"缺失",row[1],'',"cnv"]
                        df = pd.DataFrame ([inside] , columns = title)
                        df.to_csv(cnv_dir + "result_cnv.csv",encoding="gb2312",index=False, header=False, mode='a')
                        a += 1
    if a > 1:
        os.system('curl haplab.haplox.net/api/report/csv?type=cnv -F "import_file=@{S1}result_cnv.csv" '.format(S1=cnv_dir))

def main():
    path = os.getcwd()
    if args.dir:
        path = args.dir
    hap = path.split('/')[-1]
    dat = hap.split('_')[1] + '_' + hap.split('_')[-1]
    gdna_dir = path + '/germline/result/'
    for i in os.listdir(gdna_dir):
        if i.endswith('chem_451.txt'):
            gdna = i.split('.')[0]
    num = hap.split('_')[-1]
    Annokb(path,hap,dat,gdna,num)
    target = ['_trans.cancer.male.txt','information.txt','chem_451.txt','Target_451.txt','_trans.cancer.female.txt']
    for i in os.listdir(gdna_dir):
        for j in target:
            if i.endswith(j):
                pat = gdna_dir + '/' + i              
                if j in target[1:4]:
                    txt_xls(pat,(pat[:-3]+'xls'))
                if j not in target[1:4]:
                    txt_xls(pat,(pat.replace('.','_')[:-4] + '.xls'))

    cnv_updata(path,num)
    os.system('Rscript /haplox/users/zhaoys/Script/last_pair_attached_sheet.R  {S1}/'.format(S1=path))

if __name__ == "__main__":
    main()

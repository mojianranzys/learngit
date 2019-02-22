#!/usr/bin/env python
#coding:utf-8
import os
import re
import sys
import csv
import argparse
import pandas as pd

parser = argparse.ArgumentParser()
parser.add_argument("-d", "--dir", nargs='?', action="store" , type=str, help="sample dir")
args = parser.parse_args()

def qc_csv(path):
    title = ["mean_depth","coverage_1X","coverage_100X","capture_percentage","Data_ID"]
    qc_dir = path + '/captureByRead_ave_depth/'
    a=0
    for i in os.listdir(qc_dir):
        if i.endswith("_ave_depth.stat"):
            cap = i.split('_ave_depth.stat')[0]
            with open(qc_dir + i) as depth_list:
                for n in range(8):
                    te = depth_list.next()
                    tmp = te.split('\t')[-1]
                    if a == 0 :
                        a+=1
                        qc = pd.DataFrame ([title] , columns = title)
                        qc.to_csv(qc_dir + "result_qc.csv",encoding="gb2312",index=False, header=False)
                        continue
                    if n == 2:
                        mean_depth = tmp[:-1]
                    if n== 3:
                        coverage_1X = tmp[:-1]
                    if n== 4:
                        coverage_100X = tmp[:-1]
            with open(qc_dir + cap + '_sortbam_capture_stat.txt') as capture_list:
                    te2 = capture_list.next()
                    tmp2 = te2.split(':')[-1]
                    tmp2 = tmp2.replace('\t','')
                    capture_percentage = tmp2[:-1]
                    data_id = cap.split('_')[-1]
                    qc_data = [mean_depth,coverage_1X,coverage_100X,capture_percentage,data_id]
                    print(qc_data)
                    qc =  pd.DataFrame ([qc_data] , columns = title)
                    qc.to_csv(qc_dir + "result_qc.csv",encoding="gb2312",index=False, header=False, mode='a')
    os.system('curl haplab.haplox.net/backend/analyse/sequence-qc/import-depth -F "import_file=@{S1}result_qc.csv" '.format(S1=qc_dir))                
                    
def main():
    path = os.getcwd()
    if args.dir:
        path = args.dir
    qc_csv(path)

if __name__ == "__main__":
    main()


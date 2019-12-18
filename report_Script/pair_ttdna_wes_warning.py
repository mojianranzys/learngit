import csv
import pandas as pd
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("-d", "--directory", nargs='?', action="store" , type=str, help="directory and subdirectory ")
args = parser.parse_args()

def check(dirc,heat_file):
    with open(heat_file,encoding = 'GB18030') as heat:
        point_reader = csv.reader(heat)
        heat_point = ['KRAS','NRAS','BRAF','EGFR','ERBB2','PIK3CA','POLE','POLD1','APC']
        a=0
        for row in point_reader:
            if a == 0:
                a+=1
                head = row              
            if row[0] in heat_point and float(row[6]) >= 1 and float(row[6]) < 5 and int(row[46]) == 1 :
                print(heat_file,row[0],row[5])
                for i in range(len(row)):
                    if row[i] == '   ':
                        row[i] = None
                df = pd.DataFrame ([row] , columns = head)
                df.to_csv(dirc + "//Warning.csv",encoding="utf_8_sig",index=False, header=False, mode='a')

def list_all_files(directory):
    _files = []
    listdb = os.listdir(directory)
    for i in range(0,len(listdb)):
        path = os.path.join(directory,listdb[i])
        if os.path.isdir(path):
            _files.extend(list_all_files(path))
        if os.path.isfile(path):
            _files.append(path)
            if path.split('/')[-1].startswith('A'):
                file_list.append(path)
    return file_list

file_list = []
dirc = args.directory
warnfile_list = list_all_files(dirc)
for i in warnfile_list:
    check(dirc,i)


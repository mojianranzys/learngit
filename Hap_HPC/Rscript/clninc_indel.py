#coding:utf-8  

from urllib import request
import urllib.error
import re 
import csv
import time
import socket
import os

dirc = os.getcwd()
socket.setdefaulttimeout(20)
long_aa = ['Ala','Arg','Asn','Asp','Cys','Gln','Glu','Gly','His','Ile','Leu','Lys','Met','Phe','Pro','Ser','Thr','Trp','Tyr','Val']
short_aa = ['A','R','N','D','C','Q','E','G','H','I','L','K','M','F','P','S','T','W','Y','V']
for f in os.listdir(dirc):
    if 'indel' in f and 'Annokb' in f:
        total=[]
        with open(f,encoding='UTF-8') as cnv_list:
            point_reader = csv.reader(cnv_list)
            for row in point_reader:
                total.append(row)
        with open(f , 'w',  newline='', encoding="gb2312") as out:
            csv_write = csv.writer(out,dialect='excel')
            a=0
            for row in total:
                time.sleep(5)
                if a==0:
                    a+=1
                    csv_write.writerow(row)
                    continue
                if '-' in row[5]:
                    csv_write.writerow(row)
                    continue
                try:
                    response = request.urlopen("https://mutalyzer.nl/name-checker?description={S1}%3A{S2}".format(S1=row[3],S2=row[5]))
                    html = response.read()
                    re_base = re.compile(b':c.(\S+)</a></code></p>')
                    re_aa = re.compile(b'p.\((\S+)\)')
                    fi_base = re_base.findall(html)
                    fi_aa = re_aa.findall(html)
                    response.close()
                    aa = str(fi_aa[0],'utf-8')
                    base = str(fi_base[0],'utf-8')
                    for i in range(len(long_aa)):
                        if long_aa[i] in aa:
                            aa=aa.replace(long_aa[i],short_aa[i])
                    row[5] = 'c.' + base
                    row[6] = 'p.' + aa
                    csv_write.writerow(row)
                    print(aa)
                except urllib.error.URLError as e:
                    print(e.reason)
            time.sleep(3)
            out.close()
        os.popen('curl haplab.haplox.net/api/report/csv?type=indel -F "import_file=@{S1}"'.format(S1=dirc + '\\' + f))
        time.sleep(3)
    if 'snv' in f and 'Annokb' in f:
        os.popen('curl haplab.haplox.net/api/report/csv?type=snv -F "import_file=@{S1}"'.format(S1=dirc + '\\' + f))
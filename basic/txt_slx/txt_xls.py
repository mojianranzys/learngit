#!/usr/bin/python
#coding:utf-8

#### 将txt 转为 xls


import datetime
import time
import os
import sys
import xlwt  #所需模块
from optparse import OptionParser



def parseCommand():
    usage = "usage: ./txt_xls.py -i in.txt -o out.xls"
    parser = OptionParser(usage = usage)
    parser.add_option("-i","--input1",dest = "input1",help = "please input txt_file")
    parser.add_option("-o","--output",dest = "output",help = "output xls_file")
    return parser.parse_args()


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
             y+=1  #另起一列
          x+=1  #另起一行
          y=0   #初始成第一列
    f.close()
    xls.save(out_file)      #保存

if __name__=="__main__":
    (options,args)=parseCommand()
    if options.input1 == None:
        print "see -h for help"
    if options.output == None:
        print "see -h for help"
    txt_xls(options.input1,options.output)



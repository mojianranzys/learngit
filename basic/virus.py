#!/usr/bin python
#coding:utf-8

###计算病毒嵌入率#####

import sys
import math
from optparse import OptionParser

def parseCommand():
    usage="usage:./vriuscount.py -1 cfDNA/ffpeDNA.idxstats -2 gDNA.idxstats -o vrius.result "
    parser=OptionParser(usage = usage)
    parser.add_option("-1","--input1",dest = "input1",help = "please input ffpeDNA/cfDNA vrius.bam.idxstats")
    parser.add_option("-2","--input2",dest = "input2",help = "please input gDNA vrius.bam.idxstats")
    parser.add_option("-o","--output",dest = "output",help = "output vriuscount.result")
    return parser.parse_args()

def vriuscount(in_file1,in_file2,out_file):
    print ("to count the infection rate of vrius")
    s1=[]
    s2=[]
    List_sourse1=[]
    List_sourse2=[]
    vrius_result=[]
    fp=open(out_file,"wt")
    fp1=open(in_file1,"rt")
    List_row1=fp1.readlines()
    for List_line1 in List_row1:
        List_line1 = list(List_line1.strip().split('\t'))
        for i in List_line1:
            s1.append(i)
        List_sourse1.append(s1)
    print(List_sourse1)
    fp2=open(in_file2,"r")
    List_row2=fp2.readlines()
    for List_line2 in List_row2:
        List_line2 = list(List_line2.strip().split('\t'))
        for j in List_line2:
            s.append(int(j))
        List_sourse2.append(s2)
    return List_sourse2
    for i in range(0,29):
        for j in range(1,4):
            D_value=List_sourse1[i][j]-List_sourse2[i][j] 
            if D_value > 10000:
                num=sum(List_sourse1[i][2])+List_sourse1[28][3]
                rank=List_sourse1[i][j]/num
                vrius_result=(List_sourse1[i][0],rank)
    print(vrius_result)
    for i in vrius_result:
        fp.write(i)
        fp.write("\n")
    fp1.close()
    fp2.close()
    fp.close()
if __name__=="__mian__":
    (options,args)=parseCommand()
    if options.input1 == None:
        print ("see -h for help")
    if options.input2 == None:
        print ("see -h for help")
    if options.output == None:
        print ("see -h for help")
    vriuscount(options.input1,options.input2,options.output)

    

    
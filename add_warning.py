#!/usr/bin/env python
#config:utf-8

import os
import time
from optparse import OptionParser

def parseCommand():
    usage = "usages: ./add_warning.py -1 warning.csv -2  "
    parser = OptionParser(usage= usage)
    parser.add_option("-1","--in_file1",dest="input1",help="please input warning file")
    parser.add_option("-2","--in_file2",dest="input2",help="please input curl file")
    return parser.parse_args()

def add_warning(in_file1,in_file2):
    result=os.path.exists(in_file1)
    if(result == "True"):
        df=
        with open('in_file1','ab') as f:
            f.write(open('in_file2','rb').read())
    else:
        print("no warning file")

if __name__ == "__main__":
    (options,args)=parseCommand()
    add_warning(options.in_file1,options.in_file2)
  

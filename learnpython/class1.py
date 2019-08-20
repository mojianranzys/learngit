#!/usr/bin/python
# -*- coding: UTF-8 -*-
###例子l:有四个数字：1、2、3、4，能组成多少个互不相同且无重复数字的三位数？各是多少？
count = 0
for i in range(1,5):
    for j in range(1,5):
        for k in range(1,5):
            if( i != k ) and (i != j) and (j != k):
                count = count +1
                print (i,j,k)
print("count = ",count)

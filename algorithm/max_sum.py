#!/usr/bin/env python
#coding:utf-8
##最大连续子数组，求一个有正，有负数的数组(有正和负数，没有全是负数的情况)，连续子数组之最大和。要求时间复杂度为O(n)

def max_array(l):
  max_sum=0
  it_sum=0
  for i in l:
     it_sum=it_sum+i
     if it_sum>max_sum:
        max_sum=it_sum
     elif it_sum<0:
        it_sum=0
  return max_sum

l=[-1,3,5,4,-2,7]
print max_array(l)
  

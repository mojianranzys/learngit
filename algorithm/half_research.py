#!/usr/bin/env python
#coding:utf-8

#****查找某元素在列表中的位置*****
##方法一：

#lst=sorted([2,5,4,7,9,3])
#result=lst.index(4)
#print result

##方法二：折半法（二分法）

def half_research(lst,value,left,right):
    length=len(lst)
    while left < right:
          middle=(right-left)/2
          if lst[middle] > value:
              right=middle-1
          elif lst[middle] < value:
              left=middle+1
          else:
               return middle

if __name__=="__main__":
   lst=sorted([1,4,7,9,6,8,3,2])
   length=len(lst)
   value=3
   left=0 
   right=length -1
   result=half_research(lst,value,left,right)
   if result:
      print result
   else:
      print 'NO this value'

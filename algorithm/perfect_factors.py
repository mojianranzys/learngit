###******perfect_factors:6(6=1+2+3  'is 6'yueshu(not contain  itself)')****
#!/usr/bin/env python
#coding:utf-8

def factors(n):
    a=[]
    for i in range(2,n/2+1):
        if n%i==0:
           a.append(i)
    return a
def perfect(n):
    c=[]
    for i in range(2,n+1):
        if (sum(factors(i))+1)==i:
            c.append(i)
    return c
if __name__=='__main__':
  print perfect(30)



#def factors(n):
#   return[i for i in range(2,n/2+1) if n%i==0]
#
#
#def perfect(n):
#    return [i for i in range(2,n+1) if (sum(factors(i))+1)==i]
#if __name__=='__main__':
#    print perfect(30)

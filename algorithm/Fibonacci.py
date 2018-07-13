#********finonacci sequence:0,1,1,2,3,5,8,......x,y,x+y,....
#!/usr/bin/env python
print "****fibonacci sequence******\n"
def fibonacci():
   x=input('the len of fibonacci sequence:' )
   a=0
   b=1
   c=[]
   c.append(a)
   c.append(b)
   while(x!=2):
        e=a+b
        a=b
        b=e
        c.append(e)
        x=x-1
   print c

fibonacci()

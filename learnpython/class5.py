#!/usr/bin/python
# -*- coding: UTF-8 -*-
#question:输入三个整数x,y,z，请把这三个数由小到大输出。
###ways1
x = int(input("x :"))
y = int(input("y: "))
z = int(input("z: "))

num = [x,y,z]
print(num)

num.sort()        #从小到大
print(num)
num_re = [x,y,z]
num_re.sort(reverse= True)   #从大到小
print(num_re)

#ways2

num = []
for i in range(3):
    x = int(input("data: "))
    num.append(x)

print(num)
num.sort()
print(num)

    







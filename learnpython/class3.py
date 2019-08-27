#！/usr/bin/python
# -*- coding: UTF-8 -*-
#例子3：一个整数，它加上100后是一个完全平方数，再加上168又是一个完全平方数，请问该数是多少？
#解析：x+100=n^2 ; x+268=m^2 ; m^2 - n^2 =168 ;
for m in range(168):
    for n in range(168):
        if m**2 - n**2 == 168:
            x = n**2 -100
            print(x)
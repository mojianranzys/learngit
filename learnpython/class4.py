#!/usr/bin/python
# -*- coding : UTF-8 -*-
#例子4：输入某年某月某日，判断这一天是这一年的第几天？

years = int(input("years is:\n"))
month = int(input("month is:\n"))
day = int(input("day is:\n"))
count = 0

if  0 < month <= 12:
    print("the month is True")
else print("the month is False")

if years % 100 != 0 & years % 4 ==0 :
    if month >= 2:
        count = count - 1



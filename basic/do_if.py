#!/usr/bin/env python3
###input() will return string
###int() can transform string into int

age=int(input('please enter your age:'))
if age >=18:
  print('Adult')
elif age >=6:
  print('teenager')
else:
  print('kid')

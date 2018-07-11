#!/usr/bin/env python
# -*- coding: utf-8 -*-
print '您好'
import sys
reload(sys)
sys.setdefaultencoding('utf8')
s='python 中文'
b=s.encode('utf-8')
print b
print b.decode('utf-8')


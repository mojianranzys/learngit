#!/usr/bin/python
#coding:UTF-8

'''import json

jsonData = '{"a":1,"b":2,"c":3,"d":4}';

test = json.loads(jsonData)
print(test) '''

import json
print(json.dumps({'a':'Runoob','b':7},sort_keys=True, indent=4, separators=(',',': ')))



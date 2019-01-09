#!/usr/bin/env python3
# -*- coding : utf-8 -*-
##windows 版多进程：multiprocessing 模块提供了一个Process类来代表一个进程对象
from multiprocessing import Process
import os
###子进程要执行的代码
def run_proc(name):
    print('Run child process %s (%s)...'% (name, os.getpid()))

if __name__=='__main__':
    print('Parent process %s.'% os.getpid())
    p = Process(target=run_proc, args=('test',))
    print('Child process will start.')
    p.start() #启动
    p.join()  #可以等待子进程结束后再继续往下运行，通常用于进程间的同步
    print('Child process end.')
# !/usr/bin/env python3
# -*- coding : utf-8 -*-
#  Pool 进程池
from multiprocessing import Pool
import os, time, random
def long_time_task(name):
    print("Run task %s (%s)..." %(name,os.getpid()))
    start = time.time()
    time.sleep(random.random()*3)
    end = time.time()
    print('Task %s runs %0.2f seconds.' %(name,(end - start)))

if __name__=='__main__':
    print("Parent process is %s" % os.getpid())
    p = Pool(4)
    for i in range(5):
        res = p.apply_async(long_time_task, args=(i,))
        res.get()
        print('Wainting for all subprocess done...')
        p.close()
        p.join() #调用join()之前必须先调用close(),调用close()之后就不能继续添加新的Process了
        print('All subprocess done.')
import requests
import re
import json
import time
import random
from multiprocessing import Pool

MAXSLEEPTIME = 3
MINSLEEPTIME = 1
MAX_PAGE_NUM = 10
STAUS_OK = 200
CLIENT_ERROR_MIN = 400
CLIENT_ERROR_MAX = 500
SERVER_ERROR_MIN = 500
SERVER_ERROR_MAX = 600
#1.对URL发起HTTP请求http request,得到相应的http response响应,我们所需的数据就在resqonse的响应体里
def get_one_page(URL,num_retries=5):
    #UA改为浏览器UA
    if num_retries == 0:
        return None
    ua_headers = {'User-Agent':'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.26 Safari/537.36 Core/1.63.5478.400 QQBrowser/10.1.1550.400'}
    response = requests.get(URL,headers=ua_headers)
    if response.status_code == STAUS_OK:     #状态码为200
        return response.text
    elif SERVER_ERROR_MIN < response.status_code <SERVER_ERROR_MAX:
        time.sleep(MINSLEEPTIME)
        get_one_page(URL,num_retries-1)
    elif CLIENT_ERROR_MIN < response.status_code < CLIENT_ERROR_MAX:
        if response.status_code == 404:
            print('Page not found')
        elif response.status_code == 403:
            print('Have no right')
        else:
            pass

    return None

#2.用正则表达式 Xpath BS4精确的获取数据
def parse_itemurl(html):
    patter = re.compile('id="searchlist"> <a  href="([\s\S]*?)"')
    items = re.findall(patter,html)
    for it in items:
        yield it

def parse_one_page(html):
    patter = re.compile(' <span class="name">([\s\S]*?)</span>[\s\S]*?</i>([\s\S]*?)<i[\s\S]*?</i>([\s\S]*?)<i[\s\S]*?</i>([\s\S]*?)<i[\s\S]*?</i>([\s\S]*?)<[\s\S]*?</i>([\s\S]*?)</small>')
    items = re.findall(patter,html)
    for it in items:
        yield {
            'title':it[0].replace('<em>','').replace('</em>','').strip(),
            'name':it[1].strip(),
             'time':it[2].strip(),
            'capital':it[3].strip(),
            'industry':it[4].strip(),
            'address':it[5].strip()
            }

#3.存到本地的文件系统或数据库中
def write_to_file(item):
    with open('企查查.txt','a',encoding='utf-8') as f:
        f.write(json.dumps(item,ensure_ascii=False)+'\n')

#4.控制整个爬取一页的流程
def crawl_one_page(offset):
    #拼出一个url
    time.sleep(1)
    print('正在爬取第%d页...'%offset)
    url = 'https://www.qichacha.com/g_AH_' + str(offset) + '.html'
    #下载这个url
    html = get_one_page(url)
    for item in parse_one_page(html):
        write_to_file(item)
    time.sleep(random.randint(MINSLEEPTIME,MAXSLEEPTIME))


if __name__ == '__main__':
    p = Pool(10)
    p.map(crawl_one_page,[i for i in range(1,30)])
    p.close()
p.join()
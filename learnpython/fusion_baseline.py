#coding=utf-8
import pymysql
import io
import json
import argparse
import re
import csv
import os
import commands
import logging


parser = argparse.ArgumentParser()
parser.add_argument("-f", "--file", nargs='?', action="store" , type=str, help="json file name")
parser.add_argument("-d", "--directory", nargs='?', action="store" , type=str, help="directory and subdirectory ")
parser.add_argument("--delete", nargs='?', action="store" , type=str, help="delete hupnum")
parser.add_argument("-b", "--bam", nargs='?', action="store" , type=str, help="rg_bam") 
args = parser.parse_args()

def todb(data):     #传入数据
    plus = [['healthgdna_wesplus','wesgdnabl'],['ffpedna_wesplus','wesplusfb'],['healthgdna','gdnabl'],['healthcfdna','healthcfdb'],['cfdna','cfdnadb']]
    cursor = connect.cursor()
    sql = "INSERT INTO fusiondb (hapnum,time,total_count,unique_count,left_gene,left_chr,left_exon,left_exonid,left_strand,right_gene,right_chr,right_exon,right_exonid,right_strand,left_position,right_position,special) VALUES  ('%d', '%s', '%d','%d', '%s','%s','%s','%d','%s', '%s','%s','%s','%d','%s','%d','%d','%d' )"
    cursor.execute(sql % data)
    connect.commit()
    cursor.close()

    cursor = connect.cursor()
    
    for i in plus:
        if i[0] in jsonfile:
            sql = "INSERT INTO {S1} (hapnum,time,total_count,unique_count,left_gene,left_chr,left_exon,left_exonid,left_strand,right_gene,right_chr,right_exon,right_exonid,right_strand,left_position,right_position) VALUES  ('%d', '%s', '%d','%d', '%s','%s','%s','%d','%s', '%s','%s','%s','%d','%s','%d','%d')".format(S1=i[1])
            break
        else:
            sql = "INSERT INTO ffpednadb (hapnum,time,total_count,unique_count,left_gene,left_chr,left_exon,left_exonid,left_strand,right_gene,right_chr,right_exon,right_exonid,right_strand,left_position,right_position) VALUES  ('%d', '%s', '%d','%d', '%s','%s','%s','%d','%s', '%s','%s','%s','%d','%s','%d','%d')"

    cursor.execute(sql % data[:-1])
    connect.commit()
    cursor.close()
    
def getbaseline(data,tumor):   #从数据库中获取基线
    cursor = connect.cursor()
    sql = "SELECT unique_count, total_count FROM fusiondb WHERE left_gene = '%s' AND left_exon = '%s' AND left_exonid = '%d' AND right_gene = '%s' AND right_exon = '%s' AND right_exonid = '%d' "
    sql_avg = "SELECT AVG(unique_count), AVG(total_count) FROM fusiondb WHERE left_gene = '%s' AND left_exon = '%s' AND left_exonid = '%d' AND right_gene = '%s' AND right_exon = '%s' AND right_exonid = '%d' "
    cursor.execute(sql % data)
    count = cursor.rowcount     #条目数

    cursor.execute(sql_avg % data)
    avg_count = cursor.fetchall()
    for row in avg_count:
        unique_count = row[0]   #平均数
        total_count = row[1]
    cursor.close()

    cursor = connect.cursor()
    sql = "SELECT unique_count, total_count FROM healthcfdb WHERE left_gene = '%s' AND left_exon = '%s' AND left_exonid = '%d' AND right_gene = '%s' AND right_exon = '%s' AND right_exonid = '%d' "
    sql_avg = "SELECT AVG(unique_count), AVG(total_count) FROM healthcfdb WHERE left_gene = '%s' AND left_exon = '%s' AND left_exonid = '%d' AND right_gene = '%s' AND right_exon = '%s' AND right_exonid = '%d' "
    cursor.execute(sql % data)
    count_hea = cursor.rowcount     #条目数

    cursor.execute(sql_avg % data)
    avg_count = cursor.fetchall()
    for row in avg_count:
        unique_count_hea = row[0]   #平均数
        total_count_hea = row[1]
    cursor.close()

    cursor = connect.cursor()
    if tumor == "ffpe":
        sql = "SELECT unique_count, total_count FROM ffpednadb WHERE left_gene = '%s' AND left_exon = '%s' AND left_exonid = '%d' AND right_gene = '%s' AND right_exon = '%s' AND right_exonid = '%d' "
        sql_avg = "SELECT AVG(unique_count), AVG(total_count) FROM ffpednadb WHERE left_gene = '%s' AND left_exon = '%s' AND left_exonid = '%d' AND right_gene = '%s' AND right_exon = '%s' AND right_exonid = '%d' "
    elif tumor == "cfdna":
        sql = "SELECT unique_count, total_count FROM cfdnadb WHERE left_gene = '%s' AND left_exon = '%s' AND left_exonid = '%d' AND right_gene = '%s' AND right_exon = '%s' AND right_exonid = '%d' "
        sql_avg = "SELECT AVG(unique_count), AVG(total_count) FROM cfdnadb WHERE left_gene = '%s' AND left_exon = '%s' AND left_exonid = '%d' AND right_gene = '%s' AND right_exon = '%s' AND right_exonid = '%d' "
    else:
        cursor.close()
        return [count,total_count,unique_count,count_hea,total_count_hea,unique_count_hea]

    cursor.execute(sql % data)
    count_tumor = cursor.rowcount     #条目数

    cursor.execute(sql_avg % data)
    avg_count = cursor.fetchall()
    for row in avg_count:
        unique_count_tumor = row[0]   #平均数
        total_count_tumor = row[1]
    cursor.close()

    return [count,total_count,unique_count,count_hea,total_count_hea,unique_count_hea,count_tumor,total_count_tumor,unique_count_tumor]

def getjson():   #json是传入的文件，提取json中的信息
    global jsonfile
    logging.info(jsonfile)
    tmp = []
    try:
        setting = json.load(f)
    except ValueError as e:
        print(e)
        return tmp
    try:
        num = re.compile(r'_(\d{4,6})[_|.]')   #正则匹配reads位置，返回一个列表
        hapnum = int(num.findall(jsonfile.split('/')[-1])[0])
    except AttributeError as e:
        return tmp
    except ValueError as e:
        return tmp
    except IndexError as e:
        return tmp
    if hapnum > 32767:
        return tmp

    try:
        time = (setting['time'])[:10]
    except KeyError as e:
        print(e)
        return tmp
    try:
        fusion = dict.keys(setting['fusions'])
    except KeyError as e:
        print(e)
        return tmp

    unique = []
    left_gene = []
    left_chr = []
    left_exon = []
    left_exonid = []
    left_strand = []
    left_position = []
    right_gene = []
    right_chr = []
    right_exon = []
    right_exonid = []
    right_strand = []
    right_position = []
    total = []
    a=0
    for i in fusion:
        left_gene.append(setting['fusions'][i]['left']['gene_name'])
        left_chr.append(setting['fusions'][i]['left']['gene_chr'])
        left_exon.append(setting['fusions'][i]['left']['exon_or_intron'])
        left_exonid.append(setting['fusions'][i]['left']['exon_or_intron_id'])
        left_strand.append(setting['fusions'][i]['left']['strand'])
        right_gene.append(setting['fusions'][i]['right']['gene_name'])
        right_chr.append(setting['fusions'][i]['right']['gene_chr'])
        right_exon.append(setting['fusions'][i]['right']['exon_or_intron'])
        right_exonid.append(setting['fusions'][i]['right']['exon_or_intron_id'])
        right_strand.append(setting['fusions'][i]['right']['strand'])
        unique.append(setting['fusions'][i]['unique'])
        pattern = re.search(r'total: (\d+)',i,re.M|re.I)
        total.append(int(pattern.group(1)))
        reposition = re.compile(r'[X|\d+]:(\d+)')   #正则匹配reads位置，返回一个列表
        result = reposition.findall(i) 
        left_position.append(int(result[0]))
        right_position.append(int(result[1]))
    tmp = [hapnum,time,total,unique,left_gene,left_chr,left_exon,left_exonid,left_strand,right_gene,right_chr,right_exon,right_exonid,right_strand,left_position,right_position]
    return tmp

def list_all_files(directory):    #遍历目录及其子目录获取json
    _files = []
    listdb = os.listdir(directory) #列出文件夹下所有的目录与文件
    for i in range(0,len(listdb)):
        path = os.path.join(directory,listdb[i])
        if os.path.isdir(path):
            _files.extend(list_all_files(path))
        if os.path.isfile(path):
            _files.append(path)
            if path.endswith('.json'):
                jsondb.append(path)
    return jsondb

def dup(data):    #检测数据库中是否有相同ID的信息
    cursor = connect.cursor()
    sql = "SELECT id FROM fusiondb WHERE hapnum = '%d' "
    cursor.execute(sql % data)
    if cursor.rowcount != 0:
        cursor.close()
        fdb = 0
    else:
        fdb = 1
    cursor.close()
    cursor = connect.cursor()
    sql = "SELECT id FROM hapfusion WHERE hapnum = '%d' "
    cursor.execute(sql % data)
    if cursor.rowcount != 0:
        cursor.close()
        hdb = 0
    else:
        hdb = 1
    cursor.close()
    return [fdb,hdb]

def deldate(num):  
    cursor = connect.cursor()
    sql = "DELETE FROM fusiondb WHERE hapnum = '%d' "
    cursor.execute(sql % num)
    connect.commit()
    cursor.close()
    print("delete success")

def tocosf(data):   #上传数据到cosf数据表中
    cursor = connect.cursor()
    sql = "INSERT INTO hapfusion (hapnum,time,total_count,unique_count,left_gene,left_chr,left_exon,left_exonid,left_strand,right_gene,right_chr,right_exon,right_exonid,right_strand,left_position,right_position) VALUES  ('%d', '%s', '%d','%d', '%s','%s','%s','%d','%s', '%s','%s','%s','%d','%s','%d','%d')"
    cursor.execute(sql % data)
    connect.commit()
    cursor.close()

def comparecosf():  #从数据表中获取COSF信息
    cursor = connect.cursor()
    sql = "select * from cosf "
    cosfdata=[]
    cursor.execute(sql)
    rows = cursor.fetchall()
    for row in rows:
        cosfdata.append([row[1],row[2]])
    cursor.close()
    return cosfdata

def get_depth(haptotal):
    if args.bam:
        (status1, output1) = commands.getstatusoutput('samtools depth -r '+ haptotal[5] + ':' + str(haptotal[14]) + '-' + str(haptotal[14]+1) + ' ' + args.bam)  
        (status2, output2) = commands.getstatusoutput('samtools depth -r '+ haptotal[5] + ':' + str(haptotal[15]) + '-' + str(haptotal[15]+1) + ' ' + args.bam)
    else:
        output1 = output2 = '1 1 10000000'
    if output1:    #计算丰度
        depth1 = output1.split()[2]
        if depth1.isalpha() == 1:
            depth1 = 10000000
        try:
            left_vaf = float(haptotal[3]*200) / int(depth1)
        except ZeroDivisionError as e:
            print("ZeroDivisionError", e)
            left_vaf = 0
        if left_vaf > 100 or left_vaf < 0.1:
            left_vaf = 0
    else:
        left_vaf = 0
    if output2:
        depth2 = output2.split()[2]
        if depth2.isalpha() == 1:
            depth2 = 10000000
        try:
            right_vaf = float(haptotal[3]*200) / int(depth2)
        except ZeroDivisionError as e:
            print("ZeroDivisionError", e)
            right_vaf = 0
        if right_vaf > 100 or right_vaf < 0.1:
            right_vaf = 0
    else:
        right_vaf = 0
    return [left_vaf,right_vaf]

def main():
    print(jsonfile)
    logging.basicConfig(level=logging.DEBUG, format='%(asctime)s %(filename)s %(levelname)s %(message)s',
                        datefmt='%a, %d %b %Y %H:%M:%S', filename=log, filemode='w')
    total=getjson()
    if total == 0:
        return 
    if len(total) > 0:
        booldb = dup(total[0])
        cosfdata = comparecosf()
        if total[3] == []:  #判断json中是否存在信息
            logging.info("fusion don't exist")
            return 0 
        csv_write = csv.writer(w,dialect='excel')
        if "cf" in jsonfile:
            title = ['hapnum','COSF','left_gene','right_gene','left_vaf','right_vaf','total','unique','left_exon','left_exonid','right_exon','right_exonid','strand','baseline_count','total_average','unique_average','health_baseline','health_total','health_unique','blood_baseline','blood_total','blood_unique']
        elif "cf" not in jsonfile:
            title = ['hapnum','COSF','left_gene','right_gene','left_vaf','right_vaf','total','unique','left_exon','left_exonid','right_exon','right_exonid','strand','baseline_count','total_average','unique_average','health_baseline','health_total','health_unique','tumor_baseline','tumor_total','tumor_unique']
        csv_write.writerow(title)

        for i in range(len(total[3])):
            haptotal = (total[0],total[1],total[2][i],total[3][i],total[4][i],total[5][i],total[6][i],total[7][i],total[8][i],total[9][i],total[10][i],total[11][i],total[12][i],total[13][i],total[14][i],total[15][i])
            #hapnum,time,total,unique,left_gene,left_chr,left_exon,left_exonid,left_strand,right_gene,right_chr,right_exon,right_exonid,right_strand,left_position,right_position
            if [(total[4][i]).split('_')[0],(total[9][i]).split('_')[0]] in cosfdata or [(total[9][i]).split('_')[0],(total[4][i]).split('_')[0]] in cosfdata:
                special = 1
                tcfdata = ((total[4][i]).split('_')[0],(total[9][i]).split('_')[0],total[0])
                if booldb[1] == 1:
                    tocosf(haptotal)
            else:
                special = 0

            depth = get_depth(haptotal)
            left_depth = depth[0]
            right_depth = depth[1]
            
            tuptotal = (total[0],total[1],total[2][i],total[3][i],total[4][i],total[5][i],total[6][i],total[7][i],total[8][i],total[9][i],total[10][i],total[11][i],total[12][i],total[13][i],total[14][i],total[15][i],special)
            if booldb[0] == 1:
                todb(tuptotal)
                logging.info("update data")
            getdata = (total[4][i],total[6][i],total[7][i],total[9][i],total[11][i],total[12][i])
            if "heal" in jsonfile:
                ut = getbaseline(getdata,"heathdna")
            elif "cf" in jsonfile:
                ut = getbaseline(getdata,"cfdna")
            else:
                ut = getbaseline(getdata,"ffpe")
            setin = [total[0],special,(total[4][i]).split('_')[0],(total[9][i]).split('_')[0],left_depth,right_depth,total[2][i],total[3][i],total[6][i],total[7][i],total[11][i],total[12][i],total[8][i]] + ut
            #hapnum,special,left_gene,right_gene,'left_vaf','right_vaf',total,unique,total_count,total_average,unique_average,left_exon,left_exonid,right_exon,right_exonid,strand

            csv_write.writerow(setin)

            del(tuptotal)
            del(getdata)
        if dup(total[0]) == 1:
            logging.info("insert succed"+len(total[3])+"row data")
        f.close()
        w.close()

connect = pymysql.connect(host="192.168.1.14",user="mutation",passwd="mutation001",db="mutation",port=3306,charset="utf8") #host为服务器地址，db为数据库名，port为接口
log = "fusion.log"
if args.delete!=None:
    delnum = int(args.delete)
    if type(args.delete) != int:
        print('please input a int')
        exit(0)
    deldate(delnum)
if args.file!=None:
    jsonfile=args.file
    if jsonfile.endswith('.json') == 0:
        print('please input a json file')
        exit(0)
    if not os.path.exists(jsonfile):
        os.system("mv {S2} {S1}".format(S2 = jsonfile[::-1].split('/',1)[1][::-1] + "/*.json" ,S1 = jsonfile))
    f = io.open(jsonfile,'r',encoding='utf-8')
    w = io.open((jsonfile[:-5]+'.csv') , 'wb')
    main()
if args.directory!=None:
    jsondb=[]
    jsonfile_list = list_all_files(args.directory)
    if jsondb==[]:
        print("this directory is empty")
        exit(1)
    for jsonfile in jsonfile_list:
        try:
            f = io.open(jsonfile,'r',encoding='utf-8')
        except IOError as e:
            continue
        try:
            w = io.open((jsonfile[:-5]+'.csv') , 'wb')
        except IOError as e:
            print("IOError", e)
            continue
        else:
            main()
connect.close() 

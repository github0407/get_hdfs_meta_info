# coding: utf-8

import MySQLdb
import os
import sys

name_list=[]
path_list=[]

db = MySQLdb.connect(host="****", port=3306, user="root", passwd="1234",db="****" ,charset="utf8" )
cur = db.cursor()

# 获取sample表数据
cur.execute("SELECT * FROM sample1")

# 打开一个文件用于存储样本数据
fo = open("foo.txt", "w")

for row in cur.fetchall():
    # 获得id,样本名、存储路径和上传者,is_checked
    fo.write(str(row[0])+"|||||"+row[31].encode('utf-8').strip()+"|||||"+row[21].encode('utf-8').strip()+"|||||"+row[20].encode('utf-8').strip()+"|||||"+row[34].encode('utf-8').strip()+"\n")
db.close()

# 关闭打开的文件
fo.close()
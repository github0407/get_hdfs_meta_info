# coding: utf-8

import MySQLdb
import sys
import os

# 插入样本数据至sample1表

# 打开数据库连接
db = MySQLdb.connect(host="****", port=3306, user="root", passwd="1234",db="****" ,charset="utf8" )

cursor = db.cursor()

print "update values : "+sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4],sys.argv[5],sys.argv[6],sys.argv[7],sys.argv[8],sys.argv[9],sys.argv[10],int(sys.argv[11])

# SQL 插入样本信息语句
sql = "update sample1 set file_type = '%s',samples_num = '%s',characs_num = '%s',default_value = '%s',pos_neg_ratio = '%s',dataset_status = '%s',\
file_size = '%s',file_list = '%s',data_preview = '%s',is_checked  = '%s' where id = %d" % \
       (sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4],sys.argv[5],sys.argv[6],sys.argv[7],sys.argv[8],sys.argv[9],sys.argv[10],int(sys.argv[11]))
try:
   # 执行sql语句
   cursor.execute(sql)
   # 执行sql语句
   db.commit()
   print("update ok")
except MySQLdb.Warning, w:
            sqlWarning =  "Warning:%s" % str(w)
            print("update fail!!!")
            db.rollback()

# 关闭数据库连接
db.close()
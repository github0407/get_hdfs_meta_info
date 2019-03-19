# coding: utf-8

import MySQLdb
import sys
import os

# 打开数据库连接
db = MySQLdb.connect(host="****", port=3306, user="root", passwd="1234",db="waic" ,charset="utf8" )
cursor = db.cursor()

# SQL 插入样本信息语句
sql = "INSERT INTO sample_not_exist(principal, sample_name ,storage_path ,link_path ) \
       VALUES ('%s', '%s', '%s', '%s')" % \
       (sys.argv[1],sys.argv[2],sys.argv[3],sys.argv[4] )
try:
   # 执行sql语句
   cursor.execute(sql)
   # 执行sql语句
   db.commit()
   print("insert ok")
# except MySQLdb.Error, e: 
   # 发生错误时回滚
except MySQLdb.Warning, w:
            sqlWarning =  "Warning:%s" % str(w)
            print("insert fail!!!")
            db.rollback()
# 关闭数据库连接
db.close()
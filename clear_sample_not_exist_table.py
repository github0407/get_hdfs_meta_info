# coding: utf-8

import MySQLdb
import sys
import os

# 打开数据库连接
# db = MySQLdb.connect(host="10.73.13.163", port=3306, user="waic", passwd="Test$1234",db="waic" ,charset="utf8" )
db = MySQLdb.connect(host="10.77.29.70", port=3306, user="root", passwd="1234",db="waic" ,charset="utf8" )
cursor = db.cursor()
# SQL 插入样本信息语句
sql = "truncate table sample_not_exist;" 
try:
   # 执行sql语句
   cursor.execute(sql)
   # 执行sql语句
   db.commit()
   print("delete ok")
except MySQLdb.Warning, w:
            sqlWarning =  "Warning:%s" % str(w)
            print("insert fail!!!")
            db.rollback()
# 关闭数据库连接
db.close()
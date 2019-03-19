# coding: utf-8
# coding=utf-8
import MySQLdb
import sendmail
from collections import defaultdict

# 新建map文件用于存储查询结果
d={}

# 打开数据库连接
db = MySQLdb.connect(host="****", port=3306, user="root", passwd="1234",db="waic" ,charset="utf8" )
# 使用cursor()方法获取操作游标
cursor = db.cursor()

# SQL 查询语句
sql = "SELECT * FROM sample_not_exist" 
try:
    # 执行SQL语句
    cursor.execute(sql)
    # 获取所有记录列表
    results = cursor.fetchall()
    for row in results:
        # 从查询结果中获得上传者、样本名、链接、存储位置
       principal = row[1].encode('utf-8').strip()
       sample_name = row[3].encode('utf-8').strip()
       link = row[2].encode('utf-8').strip()
       storage_path = row[4].encode('utf-8').strip()
       print principal+'||||||'+sample_name+'||||||'+link
       link_path="link_page:"+link
       print "link_path:----------"+link_path

       if d.has_key(principal):
           if d[principal].has_key(sample_name):
               d[principal][sample_name].append(link_path)
           else:
               d[principal][sample_name]=link_path
       else:
           d[principal]={}
           d[principal][sample_name]=link_path
    # 对以上传者为主键的丢失样本发送提醒邮件
    for k,v in d.iteritems():
       kalklk=sendmail.send_mail(k,str(v))
       sendmail.send(kalklk)
except MySQLdb.Warning, w:
    sqlWarning =  "Warning:%s" % str(w)
    print "get fail!!!"

# 关闭数据库连接
db.close()
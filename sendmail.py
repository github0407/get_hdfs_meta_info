# coding: utf-8

import sys 
import logging
import logging.config
import json
import time
import commands
import os
import urllib2
from urllib import urlencode


def send_mail(principal,sample):
    MIN_CNT=1

    JOB_COMPLETE_CONFIG = {
    "illustration": "此路径不存在请更改",
    "status": "1",
    "minCount": 1,
    "mail_info": {
            "source": "datasys",
            "debug": "0",
            "sv": "样本库更新",
            "service": "-----",
            "object": "路径不存在,需更新！",
            "ishtml": "1",
            "mailto": principal,
            "content": principal+"，你上传至样本库的样本，如下："+sample+"不存在.\n请于12月19至20号尽快更新页面信息或者删除相关条目！！!近期将对样本库进行整理，对不存在的样本将进行清理，请周知！！！对于正常的样本，须至http://waic.intra.weibo.com/#/console/dataplatform/datatable/add注册元数据。有问题可@kesen!"
            # "content" : "hello,world!   "
        }
    }

    return JOB_COMPLETE_CONFIG

############## 常量结束 ##############

def send(config):
    mail_info = {}

    mail_info['source'] = config['mail_info']['source']
    mail_info['debug'] = config['mail_info']['debug']
    mail_info['sv'] = config['mail_info']['sv']
    mail_info['service'] = config['mail_info']['service']
    mail_info['object'] = config['mail_info']['object']
    mail_info['subject'] = time.strftime('%Y%m%d',time.localtime(time.time()))
    mail_info['content'] = config['mail_info']['content']
    mail_info['ishtml'] = config['mail_info']['ishtml']
    mail_info['mailto'] = config['mail_info']['mailto']
    print "mail_info:"
    print mail_info
    
    alerturl = 'http://****/watch/alert/send.json?%s'
    req = urllib2.Request(alerturl)
    f = urllib2.urlopen(req, urlencode(mail_info), 10)
    data = f.read()
    print "发送邮件接口返回内容:",data
    return data

if __name__ == "__main__":
    rrr=send_mail("kk","iui")
    send(rrr)
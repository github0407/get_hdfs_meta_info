该工程用于从样本库数据库表中拉取样本数据可按时检测文件及文件夹的相关数据，该工程可通过相关工具提交或者直接在相关平台执行。

提交命令方式：

检测现有样本生成样本大小、格式、预览等信息。

环境要求python2.7,library MySQLDb

相关数据库信息已在文件中定义完整，将完整文件夹拷贝至****/目录下执行。

按顺序运行一下步骤

1.拉取样本，检测文件夹是否存在，将不存在的样本归类，存在的样本进行文件列表、大小、样本数、前两条样本获取。

sh sample_fetch.sh

2.对于不存在的样本，向上传者发送邮件提醒更新。

python get_sample_not_exist.py

文件列表解析：

check_sample.sh    
检测hdfs路径，生成样本文件属性信息

 clear_sample_not_exist_table.py    
 清除表数据
 
 get_sample_not_exist.py    
 获取表数据
 
 insert_not_exist_sample.py    
 插入表-不存在样本数据（样本名称、路径、上传者）
 
 insert_sample_info.py    
 生成原始样本数据
 
 sample_fetch.py    
 拉取样本数据
 
 sendmail.py    
 发送邮件

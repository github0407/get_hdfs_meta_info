#!/bin/bash

# 定义相关全局变量
file_size="0"
file_name=""
file_name_list=""
hangshu_zong=0
type_list=""
file_type_=""
file_type=""
yulan=""

# 检测文件夹是否存在
hadoop fs -test -e $1
thisone=$?

if [ $thisone -eq 0 ] && [ $5 = "0" ]
then
    echo 'directory exist!!!!!!!!!!!!!!!!!!!!!!!!!'
    lujing=$1
    echo $lujing

    # 将路径下文件信息写入缓存文件
    command="hadoop fsck "${lujing}" > hadoop_fsck.txt"
    eval $command
    # 获取文件夹总大小
    val=`awk '/Total size/ {print $3}' hadoop_fsck.txt`
    echo "val=${val}"

    # 计算文件大小的中间变量
    val_k=$[1024]
    val_m=$[1024*1024]
    val_g=$[1024*1024*1024]
    val_t=$[1024*1024*1024*1024]

    # 计算文件大小
    if [ `expr $val / $val_t` -gt 1 ]
    then
    file_size="`expr $val / $val_t`t"
    echo "file size:${file_size}"
    elif [ `expr $val / $val_g` -gt 1 ]
    then
    file_size="`expr $val / $val_g`g"
    echo "file size:${file_size}"
    elif [ `expr $val / $val_m` -gt 1 ]
    then
    file_size="`expr $val / $val_m`m"
    echo "file size:${file_size}"
    elif [ `expr $val / $val_k` -gt 1 ]
    then
    file_size="`expr $val / $val_k`k"
    echo "file size:${file_size}"
    fi
    # 获取文件夹数
    val1=`awk '/Total dirs/ {print $3}' hadoop_fsck.txt`
    echo "dirs num aa:$val1"
    # 获取文件数
    val2=`awk '/Total files/ {print $3}' hadoop_fsck.txt`
    echo "file num bb:$val2"

    val_k=$[1024]
    val_g=$[1024*1024*1024]
    val_t=$[1024*1024*1024*1024]
    val_m=$[1024*1024]

    command="hadoop fs -ls "${lujing}" > hadoop_ls.txt"
    eval $command

    command="grep "${lujing}" hadoop_ls.txt | head -1 | awk '{print \$6}'"
    echo "----------------------------*********************------------------------------------"
    echo $command
    # 创建时间
    chuangjianshijian=`eval $command`
    echo "create time ddd=${chuangjianshijian}"

    ff_num=0
    while read line
    do
        
        if [ ${line:0:5} = "Found" ] || [[ $line == *_SUCCESS* ]] || [ $ff_num -gt 10 ]
        then
            echo "header line pass，文件数太多"
        else
            ff_num=$[ ff_num + 1]
            #获取文件大小
            daxiao=`echo $line | awk -F ' ' '{print $5}'`
            #获取日期
            day=`echo $line | awk -F ' ' '{print $6}'`
            #获取时间
            time=`echo $line | awk -F ' ' '{print $7}'`
            #获取目录
            mulu=`echo $line | awk -F ' ' '{print $8}'`

            echo daxiao=$daxiao day=$day time=$time mulu=$mulu
            length=${#lujing}
            echo length=$length
            # 获取文件名称
            file_name=${mulu:length}
            echo file name=$file_name
            
            yulan_cn=0

            # 通过分割符"."分割文件名，获得切分词组
            a="$file_name"
            OLD_IFS="$IFS" 
            IFS="." 
            arr=($a) 
            IFS="$OLD_IFS" 
            _xrsh_cnt=0

            # 获得最后的词组作为文件名
            for s in ${arr[*]}
            do
                echo "$s"
                _xrsh_cnt=$(( $_xrsh_cnt + 1 ))
            done
            file_type_=$s

            # 分别判断hdfs,zip,gz,txt等文件格式并获得各文件前两行作为预览
            echo "_xrsh_cnt:$_xrsh_cnt"
            if [ $_xrsh_cnt -eq 1 ] && [ ${file_name:0:4} = "part" ]
            then
            #cat获得前两行存入预览
            if [ $yulan_cn -eq 0 ]
            then
            command="hadoop fs -cat "${mulu}" | head -2 > yulan.txt"
            eval $command
            yulan_cn=$(( $yulan_cn + 1 ))
            fi

            echo "file type:hdfs"
            if [[ $file_type != *hdfs* ]]
            then
            file_type=$file_type",hdfs"
            fi

            elif [ $_xrsh_cnt -gt 1 ]
            then
            echo "file type:$file_type_"
            if [[ $file_type != *$file_type_* ]]
            then
            file_type=$file_type",$file_type_"
            fi
            else
            echo "file type:其他"
            #预览
            if [ $yulan_cn -eq 0 ]
            then
            command="hadoop fs -cat "${mulu}" | head -2 > yulan.txt"
            eval $command
            yulan_cn=$(( $yulan_cn + 1 ))
            fi
            if [[ $file_type != *其他* ]]
            then
            file_type=$file_type",其他"
            fi
            fi
            echo "file type: $file_type"
            # 文件大小判断
            val=$daxiao

            # 计算各文件大小
            if [ `expr $val / $val_t` -gt 1 ]
            then
            echo "file size:`expr $val / $val_t`t"
            daxiao="`expr $val / $val_t`t"
            elif [ `expr $val / $val_g` -gt 1 ]
            then
            echo "file size:`expr $val / $val_g`g"
            daxiao="`expr $val / $val_g`g"
            elif [ `expr $val / $val_m` -gt 1 ]
            then
            echo "file size:`expr $val / $val_m`m"
            daxiao="`expr $val / $val_m`m"
            elif [ `expr $val / $val_k` -gt 1 ]
            then
            echo "file size:`expr $val / $val_k`k"
            daxiao="`expr $val / $val_k`k"
            fi
            echo "update time :day:$day,time:$time"
            
            length=${#daxiao}
            
            # 获取行数
            if [ ${daxiao:length-1} = "m" -a ${daxiao:0:length-1} -lt 10 ] || [ ${daxiao:length-1} = "k" ] 
            then
                command="hadoop fs -cat "${mulu}" | wc -l | sed -n '1p'"
                hangshu=`eval $command`
                echo "line num:$hangshu"
                hangshu_zong=$[ $hangshu_zong + $hangshu]
            fi
            file_name_list=$file_name_list" ${ff_num}:${file_name} size:${daxiao} line number:${hangshu}\n"

        fi
    done < hadoop_ls.txt
elif [ $thisone -gt 0 ] || [ $thisone -lt 0 ]
then
        echo 'Error! Directory not exist!!!!!!!!!!!!!!!!!!!!!!!!!'
        # 样本链接地址
        link="http://waic.intra.weibo.com/#/console/algorithmplatform/sample/detail2?sample_name="$2
        lujing=$1
        # 对于查询不到路径的样本，将信息插入数据库
        python insert_not_exist_sample.py "$3" "$2" "$lujing" "$link"
        echo "iiiiiiiiiiiiiiiiiiiiiiiiiiiiii"
        echo "$lujing"
        echo ${#lujing} 
        
        echo " " > yulan.txt
fi

cat yulan.txt
# 从缓存文件获取预览
yulan=$( cat yulan.txt )

#插入数据库表sample，样本信息
# `file_type` ,`samples_num` ,`characs_num` ,`default_value` ,`pos_neg_ratio` ,`dataset_status` ,
# `file_size` ,`file_list` ,`data_preview` ,`id`
if [ $5 = "0" ] && [ $thisone -eq 0 ]
then
python insert_sample_info.py "$file_type" "$hangshu_zong" "5"  "无" "1" "无" "$file_size" "$file_name_list" "$yulan" "1" "$4"
fi

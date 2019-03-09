#!/bin/bash
#readonly skill ##变量只读
for skill in Ada Coffe Action Java;
    do
    echo "I am good at ${skill}Script"
	done
#unset skill ##变量删除
echo ${skill}

fun1="invalid"
str='this is a "$fun" string' #单引号字符串中的变量是无效的
echo $str
fun2="effective"
str2="this is a \"$fun2\" string"
echo $str2

string="abcdef *gh"
#获取字符串长度
echo ${#string} 
echo `expr length "${string}"`
#提取子字符串(从0开始计算),5表示个数
new_str=${string:2:5} 
echo $new_str
echo `expr index "$string" db` #输出d或b的位置(从1开始计算)
echo &(expr index "$string" db)

echo `echo "this string is \$string"` #反引号中的$未被\转义
echo $(echo "this string is \$string") #$()中的$被转义未正常字符
echo `echo "this string is \\$string"`
echo $(echo "this string is \\$string")
##反引号需要用\\转义 而$()只需要\就可以转义
 
#数组
array_name=(1,3,5 2 3 4)    #以空格为分界
echo ${array_name[0]}
array_name[1]=6
echo ${array_name[@]}   # @ 和* 符号可以获取数组中的所有元素
echo ${array_name[*]}
length=${#array_name[@]} #length=${#array_name[*]}
echo $length
length_0=${#array_name[0]}
echo $length_0 

#字符串截取
var=http://www.aaa.com/123.htm
echo "var=$var"
#注意： ## 号截取，删除左边字符，保留右边字符。
echo ${var##*//}
echo ${var}
#注意：# 号截取，删除左边字符(删除该字符（第一次出现该字符）左边的所有字符，包括自身)，保留右边字符。
echo ${var#*a}
# % 和 %%都是从右边起，删除左，保留右，但是%是匹配的第一个出现该字符，而%%匹配的是最后出现的该字符
echo ${var%a*} 
echo ${var%%a*}
echo ${var:0-7} #0-7表示从右边起第7个字符开始
echo ${var:0-7:3}
echo ${var:7}
#注意：使用 expr 命令时，表达式中的运算符左右必须包含空格，如果不包含空格，将会输出表达式本身
expr 3*4
expr 3 \* 4 # *需要转义
expr 3 + 4

#键盘输入信息
read -p "please input const of a :" a
read -p "please input const of b :" b
c=$[a*b]
echo "$a * $b = $c"


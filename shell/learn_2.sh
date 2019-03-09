#!bin/bash
echo "----*learn to pass argument*------"
echo "the name of file:$0"
echo "please output the first arguement:$1";
echo "please output the number of arguement:$#";
echo "the arguement is :$*";
echo "the arguement is :$@";
echo "the process of ID:$$";
#假设在脚本运行时写了三个参数 1、2、3，，则 " * " 等价于 "1 2 3"（传递了一个参数），而 "@" 等价于 "1" "2" "3"（传递了三个参数）。
for i in "$*";
do
echo $i
done

for i in "$@";
do
echo $i
done

#用 -n -z 对变量进行判空，如果变量中含有空格，则[[ -n ${S1} ]]或[ -n "${S1}" ] 
S1="zys hh"
if [ -n "${S1}" ]; 
then
echo "包含该参数:${S1}"
else
echo "不包含该参数"
fi

S2="wxz zys hahhahah"
if [[ -z ${S2} ]];
then
echo "Yes"
else
echo "NO"
fi
# -n :结果为空，执行else，而 -z 结果为空，执行then
#注意：内容和[]之间要保持有空格


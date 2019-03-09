#!/bin/bash
array_my=(a b c d "e fg" g)
echo "the five of element:${array_my[4]}"
echo "the all of element:${array_my[*]}"

echo "-----for 循环遍历输出数组-----"
for i in ${array_my[@]};
do
echo $i
done

echo "------利用while循环输出 使用 let J++ ------"
j=0
while [ $j -lt ${#array_my[@]} ] 
do
    echo ${array_my[$j]}
    let j++ 
done
#-eq //等于; ne //不等于; -gt//大于 （greater ）; -lt//小于  （less）; -ge //大于等于; -le//小于等于;

echo "-------使用eval函数----"
eval a1=welcome
eval a2=to
eval a3=China

for i in 1 2 3;
do
    eval echo "\$a$i"
done

echo "------使用键盘输入数据的方式-------"
echo "please you want to input string:"
read str
i=0
for word in ${str};
do
    i=`expr $i + 1`
    eval a$i="$word"
    eval echo "数组第 $i 个元素为: \$a$i"
done
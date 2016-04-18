//: Playground - noun: a place where people can play

import Cocoa

//for-in语句
for number in 0...5{
    print(number)
}

print("--------------下划线替代变量名------------------------")
var sum = 0
for _ in 0...5{
    sum += 1
}
print("result of sum:\(sum)")

print("-----------------for-in遍历数组---------------------")
//for-in遍历数组=
let values = [1,2,3,4,5,6]
for value in values{
    print(value)
}

print("----------------遍历字典----------------------")
//遍历字典

let dicValues = ["name":"xiaowang","sex":"man","age":"21"]
for (key,value) in dicValues{
    print(key , value)
}

print("---------------经典for语句-----------------------")
//经典for语句
for var i = 0 ; i != 10 ;i++ {
    print(i)
}
print("---------------While-----------------------")
//While
var count = 0
while count < 10{
    count += 2
    print(count)
}
print("---------------repeat While-----------------------")
count = 5
while count < 5{
    print(count)
}
var countRepeat = 5
repeat{
    print(countRepeat)
}while count < 5

print("---------------条件语句-----------------------")

let xValue = 20

if xValue < 21{
    print(xValue)
}else if xValue == 21{
    
    print(xValue)
}else{
    
    print(xValue)
}
print("---------------Switch-----------------------")

let testStr = "abc"

switch testStr{
case "abc":
    print("testStr is :\(testStr)")
case "cde":
    print("testStr is :\(testStr)")
default:
    print("unknow str")
}
print("---------------值区间-----------------------")

let theNumber = 150
switch theNumber{
case 0...100:
    print("number is between 0 and 100")
case 101...200:
    print("number is between 101 and 200")
default:
    print("unknow")
}
print("---------------switc 元组-----------------------")

let tupleValue = (5,6)
switch tupleValue{
case (_,0):
    print("(any,0)")
case (-2...8,0...10):
    print("(-2...8,0...10)")
case (_,6):
    print("(any ,6)")
case (5,6):
    print("(5,6)")
default:
    print("unknow")
}
print("---------------值绑定-----------------------")
let aPoint = (3,5)
switch aPoint{
    
case (let x,0):
    print("(any , 0)")
    
case (3,let y):
    print("(3,any)")
case (let x , let y):
    print("(any , any)")
}

print("---------------where 增加额外条件-----------------------")
let anotherPoint = (10,5)
switch anotherPoint{
case let (x, y ) where x == y:
    print("x == y")
case let (x,y) where x % y == 0:
    print("x为y的倍数")
case let (x , y) where x > y:
    print("x > y")
case let (x , y) where x < y:
    print("x < y")
default:
    print("error")
}
print("---------------控制转移语句-----------------------")
print("---------------continue-----------------------")
let aArray = [1,2,3,4,5,6]
for i in aArray{
    if i % 3 == 0{
        continue
    }
    print(i)
}
print("---------------break-----------------------")
for i in aArray{
    if i % 3 == 0{
        break
    }
    print(i)
}
print("---------------break in switch-----------------------")
let breakValue = 5
switch breakValue{
case 0:
    break
case 1...100:
    print(breakValue)
    break
default:
    break
}
print("---------------Fallthrough-----------------------")
switch breakValue{
case 0:
    break
case 1...100:
    print(breakValue)
    fallthrough
case 101...200:
    print("101...200")
case 201...300:
    print("201...300")
default:
    break
}
print("---------------标签-----------------------")
outsideTag : for i in 0...2{
    insideTag : for j in 0...2{
        if i % 2 == 0 {
            continue outsideTag
        }
        if(j % 2 == 1){
            continue insideTag
        }
        print("i:\(i)__j\(j):")
    }
}
print("---------------提前退出-----------------------")

func exit(str : String?){
    guard let theString = str else{
        print("exit before print")
        return
    }
    print("not exit and print\(theString)")
}
var str1 : String?
var str2 : String?
str2 = "print str"
exit(str1)
exit(str2)
print("---------------检查api可用性----------------------")
if #available(OSX 10.10, *){
    print("available OSX 10.11")
}else{
}


var a = [1, 2, 3]
var b = a
var c = a

print("a === a: \(a == a), b === c: \(b == c)");

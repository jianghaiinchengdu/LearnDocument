//: Playground - noun: a place where people can play

import Cocoa

//赋值运算
var a = 10
let b = 20
a = b
//a为10

let (x,y,z) = (1,11,111)
print("x=\(x),y=\(y),z=\(z)")


//浮点求余
//let theInteger = 8 // 如果为Int类型会报错
let theInteger = 8.0
let theFloat = 2.5
print(theInteger % theFloat)

//一元正号
let minusSix = -6
let alsoMinusSix = +minusSix //minusSix  -6
print(alsoMinusSix)

//溢出运算
let maxUInt = UInt8.max
let minUInt = UInt8.min
let maxInt = Int8.max
let minInt = Int8.min
print("maxUInt:\(maxUInt &+ 1)")
print("minUInt:\(minUInt &- 1)")
print("maxInt:\(maxInt &+ 1)")
print("minInt:\(minInt &- 1)")

//复合赋值
var sampleValue = 500
sampleValue *= 3
print("sampleValue:\(sampleValue)")
sampleValue /= 2
print("sampleValue:\(sampleValue)")
sampleValue %= 19

print("sampleValue:\(sampleValue)")
sampleValue += 3
print("sampleValue:\(sampleValue)")
sampleValue -= 2
print("sampleValue:\(sampleValue)")
sampleValue <<= 2
print("sampleValue:\(sampleValue)")
sampleValue >>= 1
print("sampleValue:\(sampleValue)")
sampleValue &= 2
print("sampleValue:\(sampleValue)")
sampleValue ^= 2
print("sampleValue:\(sampleValue)")
sampleValue |= 1
print("sampleValue:\(sampleValue)")


//比较运算
var str1 : NSString  = NSString(string:"abc")
let str2 : NSString  = NSString(string:"abc")
var str3 = str1

if str1 == str2{
    print("str1==str2")
}
if str1 === str2{
    print("str1===str2")
}
if(str3 === str1){
    print("str1===str3")
}
str3 = "abc"

if(str3 === str1){
    print("str1===str3")
}
if(str3 == str1){
    print("str1==str3")
}
//三目运算

(str1 == str2) ? (str1 = "str1 == str2") : (str1 = "str1 not == str2")
print(str1)
(str3 === str2) ? (str3 = "str3 === str2") : (str3 = "str3 not === str2")
print(str3)

//空运算

var nilOperator : String?
print(nilOperator ?? "defaultValue1")
print(nilOperator ?? "defaultValue2")


//区间运算

var array1 : [Int] = [Int]()
var array2 : [Int] = [Int]()
for i in 0...5{
    array1.append(i)
}
for i in 0..<5{
    array2.append(i)
}
print(array1)
print(array2)

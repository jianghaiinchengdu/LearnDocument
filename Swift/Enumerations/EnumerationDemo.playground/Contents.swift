//: Playground - noun: a place where people can play

import UIKit

print("_______________________________________")

enum Direction{
    case Left
    case Right
    case Up
    case Down
}

enum Animatl{
    case Dog,Cat,Pig,Monkey
}


let aAnimal = Animatl.Pig

switch aAnimal{
case .Dog:
    print("dog")
case .Cat:
    print("cat")
case .Pig:
    print("pig")
case .Monkey:
    print("monkey")
}
//不能穷举情况，添加默认分支
switch aAnimal{
case .Pig:
    print("pig")
default:
    print("not a Pig")
}


enum CodeType{
    case QR(String)
    case UPCA(Int,Int,Int,Int)
}

var code1 = CodeType.QR("this is QR")
var code2 = CodeType.UPCA(0, 0, 0, 0)

code1 = .UPCA(1, 1, 1, 1)
code2 = .QR("new QR value")

switch code1{
case let .QR(str):
    print(str)
case .UPCA(let x,let y,let z,let t):
    print(x,y,z,t)
}
switch code2{
case let .QR(str):
    print(str)
case let .UPCA( x, y, z, t)://简写一个let
    print(x,y,z,t)
}



//原始值
enum WeekDay : Int{
    case Monday = 0 //自动推断后面的值
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
    
    //计算属性
    var value : Int{
        return self.rawValue * 10
    }
    //不能包含存储属性
//    var storedProperty = ""
}

enum  Seasons : String{  //默认值
    case Spring          //"Spring"
    case Summer          //"Summer"
    case Fall            //"Fall"
    case Winter          //"Winter"
}


//原始值初始化枚举

let aDay = WeekDay(rawValue: 3)
let season1 = Seasons(rawValue: "Spring")
let season2 = Seasons(rawValue: "Sprin")

if let seas = Seasons(rawValue: "x"){
    print(seas)
}else{
    print("raw is Wrong")
}


enum ArithmeticExpression {
    case Number(Int)
    indirect case Addition(ArithmeticExpression, ArithmeticExpression)
    indirect case Multiplication(ArithmeticExpression, ArithmeticExpression)
}
func evaluate(expression: ArithmeticExpression) -> Int {
    switch expression {
    case .Number(let value):
        return value
    case .Addition(let left, let right):
        return evaluate(left) + evaluate(right)
    case .Multiplication(let left, let right):
        return evaluate(left) * evaluate(right)
    }
}
//    (5+4)*2
let five = ArithmeticExpression.Number(5)
let four = ArithmeticExpression.Number(4)
let sum = ArithmeticExpression.Addition(five, four)
let product = ArithmeticExpression.Multiplication(sum, ArithmeticExpression.Number (2))
print(evaluate(product))
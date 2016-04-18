//: Playground - noun: a place where people can play

import UIKit

class Counter {
    var amount: Int = 0
    
    //类型方法
    static func classMethod_static(){
         print("\(self):\(__FUNCTION__)")
    }
    class func classMethod_class(){
         print("\(self):\(__FUNCTION__)")
    }
    
    //默认
    func incrementBy(amount: Int, numberOfTimes: Int) {
        self.amount += amount * numberOfTimes
    }
    //写全外部参数和内部参数
    func incrementBy1( amount amount: Int, numberOfTimes times: Int) {
        self.amount += amount * times
    }
    //省略外部参数
    func incrementBy2( amount: Int, _ times: Int) {
        self.amount += amount * times
    }
}

struct Point {
    var x = 0.0
    var y = 0.0
    
    mutating func changePointBy(X x : Double , Y y : Double){
        self.x += x
        self.y += y
    }
    
    mutating func changeValue(X x : Double , Y y : Double){
        self = Point(x: self.x + x, y: self.y + y)
    }

}
//不能在结构体类型的常量上调用可变方法，因为其属性不能被改变，即使属性是变量属性
//let point = Point(x: 1, y: 1)
var point = Point(x: 1, y: 1)
point.changePointBy(X: 1, Y: 1)
point.changeValue(X: 5, Y: 5)

enum Order{
    case First
    case Second
    case Third
    
    mutating func goNextLevel(){
        switch self{
        case .First:
            self = .Second
        case .Second:
            self = .Third
        case .Third:
            self = .First
        }
    }
}

var aOrder = Order.First
aOrder.goNextLevel()
aOrder.goNextLevel()
aOrder.goNextLevel()


class ChildCounter : Counter {
//    override class func classMethod_class(){
//        print("\(self):\(__FUNCTION__)")
//    }
//    override class func classMethod_static(){
//    }
    static var childAmount = 0
    
    static func changeAmount(childAmount : Int){
        print(self.childAmount)
        self.childAmount = childAmount
        print(self.childAmount)
    }
}
ChildCounter.changeAmount(10)
ChildCounter.classMethod_class()
ChildCounter.classMethod_static()
Counter.classMethod_class()
Counter.classMethod_static()

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backwards(s1: String, s2: String) -> Bool {
    return s1 < s2
}
var reversed = names.sort(backwards)
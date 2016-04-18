//: Playground - noun: a place where people can play

import UIKit


class Person {
     enum Sex {
        case Man
        case Woman
    }
    
    struct Info {
        let age : Int
        let sex : Sex
        let weight : Double
    }
    
    let personInfo : Info
    
    init(){
        self.personInfo = Info(age: 0, sex: .Man, weight: 0.0)
    }
}

let sex : Person.Sex = .Man



class BaseClass {
    
    let baseName = "baseName"
    static let baseName1 = "baseName1"
    
    class SubClass {
        private let name = "SubClassName"
        func log(){
        }
    }
    func accessSubClass(){
        let sub = SubClass()
        print(sub.name)

    }
}
class SubClass {
    private let value = 10
    func log(){
    }
}

let a = BaseClass.SubClass()
let b = SubClass()


//: Playground - noun: a place where people can play

import UIKit

protocol LanguageName{
    var name : String {get set }
}
class Chinese : NSObject, LanguageName {
    var name = "Chinese"
}
class English : LanguageName {
    var name = "English"
}

class Person {
    func SpreakChinese(language:Chinese){
        print("spreak \(language.name)")
    }
    func SpreakEnglish(language:English){
        print("spreak \(language.name)")
    }
    func Spreak<T : LanguageName where T : NSObject >(language:T){
        print("spreak \(language.name)")
    }
}

let person = Person()
person.Spreak(Chinese())

//person.Spreak(English())

struct Queue<T:Equatable> {
    var items = [T]()
    mutating func push(item:T){
        items.append(item)
    }
    mutating func pop()->T{
        return items.removeFirst()
    }
}

extension Queue{
    func findItem(item:T)->Bool?{
        for aItem in items{
            if aItem == item{
                return true
            }
        }
        return false
    }
    func printQueue(){
        for aItem in items{
            print(aItem)
        }
    }
}

var que = Queue<Int>()
que.push(5)
que.push(1)
que.push(3)
que.findItem(5)
que.printQueue()
que.pop()

protocol NewSkill{
    typealias ItemType
    func logSelf(item : ItemType)
}

extension Chinese : NewSkill{
    func logSelf(item : Chinese){
        print("Got New Skill")
    }
}
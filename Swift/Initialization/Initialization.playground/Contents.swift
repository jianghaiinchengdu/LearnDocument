//: Playground - noun: a place where people can play

import UIKit


struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
//    init(center: Point, size: Size) {
//        let originX = center.x - (size.width / 2)
//        let originY = center.y - (size.height / 2)
//        self.origin = Point(x: originX, y: originY)
//        self.size = size
//    }
}
extension Rect{
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.origin = Point(x: originX, y: originY)
        self.size = size
    }
}
//如果定义了自定义构造器则无法访问到默认构造器
//如果定义了自定义构造器还要能访问默认构造器可以将自定义构造器实现在extension中
let rec1 = Rect()
let rec2 = Rect(origin: Point(x: 0, y: 0), size: Size(width: 0, height: 0))
let rec3 = Rect(center: Point(x: 1, y: 1), size: Size(width: 2, height: 2))


class Man {
    let age : Int
    var name : String
    init() {
        age = 0
        name = ""
        
        print("\(__FUNCTION__)")
    }
    convenience init(name : String){
        self.init()
        self.name = name
        print("\(__FUNCTION__)")
    }
}
class YongMan: Man {
    let Job : String
    
    override init() {
        self.Job = ""
        super.init()
        print("child class \(__FUNCTION__)")
    }
    
    convenience init(name : String){//重写便利构造器不需要加override
        self.init(job: "")
        self.name = name
        
        print("\(__FUNCTION__)")
    }
    init(job : String) {
        self.Job = job
        super.init()
        
        print("\(__FUNCTION__)")
    }
}
let a = YongMan()



//指定构造器和便利构造器
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}
class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}
class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

//枚举可失败构造器
enum Direction{
    case Left
    case Right
    case Up
    case Down
    init?(value : Int){
        switch value{
        case 0:
            self = .Left
        case 1:
            self = .Right
        case 2:
            self = .Up
        case 3:
            self = .Down
        default:
            return nil
        }
    }
}
let ca = Direction(value: 8)
let ca1 = Direction(value: 0)

////类的可失败构造
//class Product {
//    let name: String
////    var name: String!
//    init?(name: String) {
//        if name.isEmpty { return nil }
//        self.name = name
//    }
//}
//struct Animal {
//    let species: String
//    init?(species: String) {
//        if species.isEmpty { return nil }
//        self.species = species
//    }
//}


class MyClass {
    var str:String
    required init(str:String) {
        self.str = str
    }
}

class MySubClass:MyClass
{
    let ss = ""
    func a(){}
}


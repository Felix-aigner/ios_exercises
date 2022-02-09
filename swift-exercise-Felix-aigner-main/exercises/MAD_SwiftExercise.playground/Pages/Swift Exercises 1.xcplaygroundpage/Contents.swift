//: # Swift Exercise
//: Welcome to the Swift Exercise. This document is an interactive Playground. The goal of this exercise is to familiarize yourself with the Swift syntax, terminology and concepts.
//:
//: If this text you're currently reading is being displayed as a code comment with `//:`, you can make it look prettier by selecting `Editor` --> `Show Rendered Markup` in the menu bar at the very top of your screen. You can switch back to the raw markup by clicking `Editor` --> `Show Raw Markup`. The document is designed to be viewed in Rendered Markup mode.
//:
//: You can type your Swift code in here and it'll automatically compile.
//: If the automatic compilation annoys you, you can turn it off by clicking-and-holding your mouse on the "Play" icon in the toolbar below. Then, select `Manually Run`.
//:
//: If you need help or have any questions, please feel free to contact me. You can find my contact info on the [course website](https://avf.github.io/mobile-app-dev/). I'm always happy to help!
//:
//: ## How to do the exercises
//: - Follow the instructions for the exercises.
//: - Please write any code that I ask for right into the playground.
//: - Any time I ask a question in an exercise, **please add a comment with the explanation in your own words.**
//:
//: Here's an example:
//:
//: Write a Hello World program in Swift in a single line. Why is this a valid Swift program?

print("Hello, World!") // This works because Swift programs by default execute statements in the global scope. A `main` function or similar is not required.

//: ## Exercises
//: ### Variables and Constants
//: 1. Declare a variable with value `42` that is implicitly assigned type `Int`.
//: 1. Declare a constant with value `42` that is implicitly assigned type `Int`.
//: 1. Declare a variable with value `42.5`. What type does it have?
//: 1. Declare a variable with explicit type `Float` and value `42.5`.
//: 1. Declare an uninitialized constant with type `String`. Will you ever be able to assign a value to this constant?
//1
var impliciteVariable = 42
//2
let impliciteConstant = 42
//3
var fractionValue = 42.5 //the implicite type declaration recognizes this as a Double
//4
var explicitFloatValue: Float = 42.5
//5
let uninitializedConstant: String //Yes, any constant may be initialized once, meaning if we dont do it now, we can do it later
//: ### Strings and String interpolation
//: 1. Create a constant of type `String` containing the text `"This is a String."`.
//: 1. Create a mutable String with `"This is an Int: "` as its initial value.
//: 1. Create an `Int` constant with value 42 and append it to the mutable string, resulting in the value: `"This is an Int: 42"`.
//: 1. Create another constant containing the same string, but this time use a string literal and string interpolation (the `\()` syntax) to create it.
//: 1. Create a multiline string using the multiline string literal.
//1
let constantString: String = "This is a String"
//2
var mutableString: String = "This is an Int: "
//3
let constantInteger: Int = 42
let combinedString = mutableString + String(constantInteger)
//or alternatively: mutableString += String(constantInteger)
//4
let otherString = "\(mutableString)\(constantInteger)"
//5
let multiLineLiteralString = """
first line
second line
third line
"""
//: ### Arrays and Dictionaries
//: Arrays
//: 1. Create an immutable array and initialize it with an array literal containing 3 `String` elements
//: 1. Create an empty mutable array of type `[String]`
//: 1. Append the second element of the first (immutable) array to the second (mutable) array.
//: 1. Can you modify one of the `String` elements in the first array (for example, append a word to it)? Why/why not? What if the elements were not of type `String`, but instead of a class?
//: 1. What happens if you modify the `String` element in the second array (for example, if you append a word to it)? Will the second element in the first array also change, or stay the same? Explain why.
//: 1. Create an immutable empty array of type `[Int]` without any literals, using the name of the class (`Array`) and the standard initializer for generic types (`var value = ClassName<GenericType>()`)
print("something")
//1
let immutableStringArray: [String] = ["one", "two", "three"]
//2
var mutableStringArray: [String] = []
//3
mutableStringArray.append(immutableStringArray[1])
//4
//a let is extremely strong in swift, hence it would not let me mutate any value contained in the Array nor the Array itself
//b it is possible to change a property of a class considering an array in the form of let [class], but it is not possible to change the value of the class object directly
//5
//If the value in the second (mutable) array is changed, the first will stay the same. This is because arrays are structs in swift, menaing they are value and not reference types.
//6
let immutableIntArray = Array<Int>()
//: Dictionaries
//: 1. Create a mutable empty Dictionary of type `[String: Double]`
//: 1. Set the value for the key `"Answer to Life, the Universe and Everything"` to `42`.
//1
var emptyDictionary: [String: Double] = [:]
//2
emptyDictionary["Answer to Life, the Universe and Everything"] = 42
//: ### Optionals
//: 1. Create an optional `String` variable and assign a non-nil value of your choice
//: 1. Print the String on the console. Make sure the variable is first unwrapped and only the actual value is printed. You may either force-unwrap the string or use an `if let` construct.
//: 1. What happens if you force-unwrap an optional variable that contains `nil`?
//: 1. Create another optional `String` variable and asign the value `nil`. Use the nil coalescing operator (`??`) to print the first unwrapped String from above.
//: 1. Do the same thing again, but this time use the ternary conditional operator `(a ? b : c)`.
//1
var optionalString: String? = "notNil"
//2
if let unwrappedOptionalString = optionalString {
    print(unwrappedOptionalString)
}
//3
// The program will crash
//4
var optionalNilString: String? = nil
let unwrappedString = optionalNilString ?? optionalString!
print(unwrappedString)
//5
print(optionalNilString != nil ? optionalNilString : optionalString!)
//: Optional chaining
//: 1. Consider the following `struct`. Use optional chaining to change the value of `anOptionalInt` in `instance` to a new value of your choice in a single line of code. What would happen if we executed that line while `instance` is `nil`?
//: 1. Use the `if let` conditional and optional chaining to print the value of `anOptionalInt` in `instance`. What would happen if `instance` or `anOptionalInt` were `nil`?
//: 1. Use optional chaining to call the method `sayHelloWorld` of `instance`. What would happen if `instance` were `nil`?

struct MyStruct {
    var anOptionalInt: Int? = 5
    
    func sayHelloWorld() {
        print("Hello, World!")
    }
}

var instance: MyStruct? = MyStruct()
//1
instance!.anOptionalInt! = 4
// The program would crash
//2
if let unwrappedInstance = instance {
    print(unwrappedInstance.anOptionalInt!)
}
// in this case if the instance was nil, the program would just skip this closure, the optionalInt being nil would crash the program
//3
instance!.sayHelloWorld()
// if instance was nil, the program would crash
//: ### Control flow
//: 1. Write a `for-in` loop that sums up all the values in `myNumbers`.
//: 1. Create an empty mutable `[Int: Int]` dictionary. Use a `for-in` loop to iterate over the elements in `myNumbers` and add each value to the dictionary, using the index of each element in `myNumbers` as its key. So for example, the dictionary should contain the key/value pair `0:12`, because 12 is element 0 of `myNumbers`.
let myNumbers = [12, 23, 1, 104]
//1
var sum: Int = 0
for num in myNumbers {
    sum += num
}
//2
var emptyMutableIntIntDic: [Int:Int] = [:]
for (index, number) in myNumbers.enumerated() {
    emptyMutableIntIntDic[index] = number
}

//: Closures
//: 1. Create an optional variable that holds a closure (with a `String` parameter and no return type) and assign `nil`.
//: 1. Call the closure using optional chaining. What will happen?
//: 1. Create a `typealias` for this type of closure.
//1
var optionalClosure: ((String) -> ())? = nil
//2
// Program would crash
//3
typealias simpleStringClosure = (String) -> ()
//: 1. Take a look at the following function, which takes a closure as parameter and calls it. This function is then called. For each of the following exercises, call the function again, but each time use one more simplification:
//:   * Omit closure parameter types.
//:   * Omit the closure return type
//:   * Omit the round brackets and argument label (we can do that since it's the last function parameter)
//:   * Omit the closure parameters completely. In the closure body, use the shorthand argument names (for example `$0`)
//:   * Omit the keyword `return`

func callAClosure(closure: (String, String) -> String) {
    print(closure("Hello", "World"))
}
callAClosure(closure: { (item1: String, item2: String) -> String in
    return "\(item1) \(item2)"
})

callAClosure(closure: { (item1, item2) -> String in
    return "\(item1) \(item2)"
})

callAClosure(closure: { (item1, item2) in
    return "\(item1) \(item2)"
})

callAClosure(closure: { item1, item2 in
    return "\(item1) \(item2)"
})

callAClosure(closure: {
    return "\($0) \($1)"
})

callAClosure(closure: {"\($0) \($1)"})

//: ### Classes
//: 1. Create a new class named `Person`. Add non-optional `firstName` and `lastName` properties and an initializer.
//: 1. Add a `name` computed property that returns a `String` containing the first and last name.
//: 1. Add a method named `greet` that returns the following `String`: `"Hi, I'm \(name)."`
//: 1. Create a subclass of `Person` and name it `Student`.
//: 1. Add a `Float?` optional property called `grade`. Use the `didSet` property observer to make sure that the grade is not lower than 1.0 and not higher than 5.0 after it was set. Clamp the new value to this interval - so if a value higher than 5.0 is set, set it to 5.0 afterwards. If a value lower than 1.0 is set, set it to 1.0 afterwards.
//: 1. Override the `greet` function from the superclass. If the `grade` property is set, it should now return `"Hi, I'm \(name). My grade is: \(grade)"`. If the `grade property isn't set, return the superclass's implementation.
//1-6
class Person {
    var firstName: String
    var lastName: String
    
    var name: String {
        get {
            return "\(firstName) \(lastName)"
            
        }
    }
    
    init(fName: String, lName: String) {
        firstName = fName
        lastName = lName
    }
    
    func greet() -> String {
        return "Hi, I'm \(name)."
    }
}

class Student: Person {
    var grade: Float? {
        didSet {
            if let unwrappedGrade = grade {
                if unwrappedGrade < 1 {
                    grade = 1
                } else if unwrappedGrade > 5 {
                    grade = 5
                }
            }
        }
    }
    override func greet() -> String {
        if let unwrappedGrade = grade {
            return "Hi, I'm \(name). My grade is: \(unwrappedGrade)"
        }
        return super.greet()
    }
}
//: ### Enums and Structs
//: 1. Create an enum named `PetType` with cases `dog` and `cat`
//: 1. In your new enum, create a function or computed property named `animalSound` that returns a `String`. Use a `switch` statement on `self` to differentiate between the cases and return `"woof"` for the `.dog` case and `"meow"` for the `.cat` case.
//: 1. Create a structure named `Pet`, with a `name` property of type `String` and a `type` constant of type `PetType` (both non-optional).
//: 1. Add a function to your structure named `makeNoise` that returns a `String`. In its implementation, return the `animalSound` of its `type`.
//: 1. Create 3 or more instances of your `Pet` struct and store them in `let` constants. Then create a new array that contains all your pets and store it in a variable.
//: 1. Change one of the names of the pets in your array. Does this change the name of any of the pets stored in the `let` constants? Explain why/why not.
//: 1. Can you change the name of one of the pets stored in the `let` constants? Explain why/why not.
//: 1. Create 3 or more instances of your `Student` class from above and store them in `let` constants. Then create a new array that contains all your students and store it in a variable.
//: 1. Change one of the names of the students in your array. Does this change the name of any of the students stored in the `let` constants? Explain why/why not.
//: 1. Can you change the name of one of the students stored in the `let` constants? Explain why/why not.
enum PetType {
    case dog
    case cat
    
    var animalSound: String {
        switch self {
        case .dog:
            return "woof"
        case .cat:
            return "meow"
        }
    }
}

struct Pet {
    var name: String
    let type: PetType
    func makeNoise() -> String {
        return type.animalSound
    }
}

let pet1 = Pet(name: "cat1", type: PetType.cat)
let pet2 = Pet(name: "cat2", type: PetType.cat)
let pet3 = Pet(name: "dog1", type: PetType.dog)

var petArray: [Pet] = [pet1, pet2, pet3]

petArray[0].name = "notaCat"
//6 This only changes the value of the name of the pet at index 0 of the array, not the "pet1" constant. this happens due to this being value types, not reference types (a class would be a reference type)

//7 mutability is derived from the storage of a struct (variable or constant), meaning if the storage (let in this case) is immutable, the struct with all properties becomes immutable aswell.
//: ### Protocols and extensions
//: 1. Create a protocol called `NamedThing`. Add a `get` variable of type `String`, with the name `name`.
//: 1. Use extensions to make your `Person` class and `Pet` structs from above conform to the new protocol.
//: 1. Create a new array that contains all the objects you declared as `let` constants above. You may have to explicitly specify the type of the array as `[NamedThing]`.
//: 1. Iterate over the objects in the array and print out their names.
//: 1. Create a protocol extension for `NamedThing` that contains a new computed property of type `String` called `initial`. Add a default implementation in your protocol extension, which returns the first character of the `name` property, or, if `name` is empty, an empty string.
//: 1. Print the new `initials` property in the loop you created above.
protocol NamedThing {
    var name: String {get}
}

extension Person : NamedThing {}
extension Pet : NamedThing {}

extension NamedThing {
    var initial: String { get {
            if name.isEmpty {
                return ""
            }
        return "\(name.prefix(1))"
        }
    }
}

let person1 = Person(fName: "some", lName: "dude")
let person2 = Person(fName: "other", lName: "dude")

var letArray: [NamedThing] = [pet1, pet2, pet3, person1, person2]

for namedThing in letArray {
    print(namedThing.initial)
}



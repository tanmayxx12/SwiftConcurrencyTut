import UIKit


// Brief Summary of: STRUCT / CLASS / ACTOR / STACK / HEAP --------- VALUE TYPES & REFERENCE TYEPS
/*
 LINKS:
 https://blog.onewayfirst.com/ios/post...
 https://stackoverflow.com/questions/2...
 https://medium.com/@vinayakkini/swift-basics-struct-vs-class-31b44ade28ae
 https://stackoverflow.com/questions/2...
 https://stackoverflow.com/questions/2...
 https://stackoverflow.com/questions/2...
 https://www.backblaze.com/blog/whats-...
 https://medium.com/doyeona/automatic-reference-counting-in-swift-arc-weak-strong-unowned-925f802c1b99
 
 VALUE TYPES:
 - Struct, Enum, String, Int, etc
 - Stored in the Stack
 - Faster
 - Thread safe
 - When you assign or pass value type, a new copy of data is created
 
 REFERENCE TYPES:
 - Class, Function, Actor
 - Stored in the heap
 - Slower, but synchronized
 - NOT Thread safe by default
 - When you assign or pass reference type a new reference to original instance is created
 
 - - - - - - - - - - - - - - - - - - - - - - - - -
 
 STACK:
 - Stores value types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast
 - Each Thread has it's own Stack
 
 HEAP:
 - Stores reference types
 - Shared across Threads
 
 - - - - - - - - - - - - - - - - - - - - - - - - -
 
 STRUCT:
 - Based on VALUES
 - Can be mutated(mutable)
 - Stored in the Stack
 
 CLASS:
 - Based on REFERENCES (INSTANCES)
 - Stored in the Heap
 - Can inherit from other classes like protocol
 
 ACTOR:
 - Same as class but thread-safe
 
 - - - - - - - - - - - - - - - - - - - - - - - - -
 
 Usage:
 
 - Structs: Data Models, Views
 - Classes: View Models
 - Actors: Shared 'Manager' and 'Data Store'
 
 
 */


struct MyStruct {
    var title: String
}

//class MyClass {
//    var   title: String
//    
//    init(title: String) {
//        self.title = title
//    }
//}

func structTest1() {
    let objectA = MyStruct(title: "Starting title")
    print("ObjectA: \(objectA.title)")
    
    print("Passing the VALUES of objectA to objectB.")
    var objectB = objectA
    print("ObjectB: \(objectB.title)")

    objectB.title = "Second title."
    print("ObjectB title changed.")
    
    print("ObjectA: \(objectA.title)")
    print("ObjectB: \(objectB.title)")
}

print("Struct: \n")
print("structTest1:")
structTest1()
print("--------------------------------------------------")


//--------------------------------------------------------------------------------------------------------------------------
func classTest1() {
    let objectA = MyClass(title: "Starting title")
    print("ObjectA: \(objectA.title)")
    
    print("Passing the REFERENCE of objectA to objectB")
    let objectB = objectA
    print("ObjectB: \(objectB.title)")
    
    objectB.title = "Second title."
    print("ObjecB title changed")
    
    print("ObjectA: \(objectA.title)")
    print("ObjectB: \(objectB.title)")
}
print("Class: \n")
print("classTest1: ")
classTest1()
print("--------------------------------------------------")
 
//--------------------------------------------------------------------------------------------------------------------------

print("Actor: \n")

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}
func actorTest() {
    Task {
        let objectA = MyActor(title: "Starting title")
        await print("ObjectA: \(objectA.title)")
        
        print("Passing the REFERENCE of objectA to objectB")
        let objectB = objectA
        await print("ObjectB: \(objectB.title)")
        
        await objectB.updateTitle(newTitle: "Second title")
        print("ObjectB title changed")
        
        await ("ObjectA: \(objectA.title)")
        await print("ObjectB: \(objectB.title)")
    }
}

actorTest()



print("--------------------------------------------------")
 
//--------------------------------------------------------------------------------------------------------------------------

print("Struct: \n")

// Immutable struct: (let)
struct CustomStruct {
    let title: String
    
    // Defining a function to return a new CustomStruct that updates the title of the existing struct:
    func updateTitle(newTitle: String) -> CustomStruct {
        return CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    var title: String
    
    // Defining a struct to change the title of the existing struct
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}

func structTest2() {
    print("structTest2: ")

    var struct1 = MyStruct(title: "Title1")
    print("Struct1: \(struct1.title)")
    struct1.title = "Title2" // Changed the title by mutating the struct
    print("Struct1: \(struct1.title)")
    
    var struct2 = CustomStruct(title: "Title1")
    print("Struct2: \(struct2.title)")
    struct2 = CustomStruct(title: "Title2") // Changed the title by creating a new struct (since we defined the CustomStruct immutable)
    print("Struct2: \(struct2.title)")
    
    var struct3 = CustomStruct(title: "Title1")
    print("Struct3: \(struct3.title)")
    struct3 = struct3.updateTitle(newTitle: "Title2") // Changed the title by using the updateTitle() function in the CustomStruct struct.
    print("Srtuct3: \(struct3.title)")
    
    var struct4 = MutatingStruct(title: "Title1")
    print("Struct4: \(struct4.title)")
    struct4.updateTitle(newTitle: "Title2") // Changed the title of the existing struct by using the updateTitle() function in the MutatingStruct
    print("Struct4: \(struct4.title)")
    
}

structTest2()
print("--------------------------------------------------")
 
//--------------------------------------------------------------------------------------------------------------------------
print("Class: \n")

class MyClass {
    var   title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
 
}

func classTest2() {
    print("classTest2:")
    
    let class1 = MyClass(title: "Title1")
    print("Class1: \(class1.title)")
    class1.title = "Title2" // Changed the title since MyClass is mutable
    print("Class1: \(class1.title)")
    
    let class2 = MyClass(title: "Title1")
    print("Class2: \(class2.title)")
    class2.updateTitle(newTitle: "Title2") // Changed the title using the updateTitle() function in the MyClass
    print("Class2: \(class2.title)")
    
}

classTest2()


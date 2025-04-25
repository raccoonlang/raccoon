# Memory Management

## Overview

Raccoon implements a hybrid memory management system that combines three complementary approaches:

1. Ownership-based memory management with implicit lifetimes
2. Scope-based resource management (similar to RAII)
3. Optional garbage collection for shared data structures

This hybrid approach provides:
- Memory safety without runtime overhead
- Predictable cleanup of resources
- Flexibility for complex data structures
- Clear ownership semantics
- Optional GC-free operation

## Default Mode: GC Enabled

By default, Raccoon runs with garbage collection enabled, offering a balance of performance and flexibility.

### Ownership Model

#### Basic Ownership Rules

1. Each value has exactly one owner at a time
2. Ownership transfers on assignment or function calls
3. When the owner goes out of scope, the value is deallocated

```raccoon
func example() {
    var data = [1, 2, 3];  // data owns the array
    processData(data);     // ownership transfers to processData
    // data is no longer valid here
}

func processData(values: [int]) {
    // values owns the array
    // array is deallocated when values goes out of scope
}
```

#### Borrowing

Values can be borrowed without transferring ownership:

```raccoon
func example() {
    var data = [1, 2, 3];
    processData(&data);    // borrow data
    // data is still valid here
    useData(data);        // can still use data
}

func processData(values: &[int]) {
    // can use values but doesn't own it
}
```

#### Shared Borrowing

Multiple immutable references are allowed:

```raccoon
func example() {
    var data = [1, 2, 3];
    var ref1 = &data;
    var ref2 = &data;     // OK: multiple immutable borrows

    println(ref1[0]);     // OK: can read through any reference
    println(ref2[0]);     // OK: can read through any reference
}
```

#### Mutable Borrowing

Raccoon does not support mutable borrowing within the same scope.

### Scope-Based Resource Management

Resources are automatically cleaned up when they go out of scope:

```raccoon
func example() {
    var file = File.open("data.txt");
    // file is automatically closed when it goes out of scope
}

struct File {
    handle: FileHandle;

    init(path: string) {
        this.handle = FileSystem.open(path);
    }

    deinit() {
        // Automatically called when File goes out of scope
        this.handle.close();
    }
}
```

The `deinit()` method is optional and is automatically added by the compiler when working with IO handlers in structs. For these cases, you don't need to implement it explicitly — the compiler understands the resource lifecycle and ensures proper cleanup.

```raccoon
struct DatabaseConnection {
    connection: Connection;  // An IO resource

    init(connectionString: string) {
        this.connection = Database.connect(connectionString);
    }

    // The compiler automatically adds a deinit() method that calls connection.close()
    // You don't need to write it explicitly unless you need custom cleanup logic
}
```

Additionally, IO handlers called directly in functions are automatically destroyed at scope end without requiring explicit cleanup code:

```raccoon
func readData() {
    var handle = FileSystem.open("data.txt");  // IO resource
    var content = handle.readAll();
    // No explicit cleanup needed - handle is automatically closed at scope end
    return content;
}
```

### Garbage Collection

When GC is enabled, the compiler automatically handles certain memory management scenarios:

#### When GC is Used

GC is used automatically for:
1. Circular references
2. Complex shared data structures
3. Async/await captured variables
4. Interface objects with unknown size

```raccoon
// Circular reference example
struct Node {
    next: Option<Node>;  // Circular references automatically handled by GC
}

// Complex sharing example
var shared = ComplexData();
var ref1 = &shared;
var ref2 = &shared;  // Multiple (readonly) references to same data
```

#### GC Control

GC can be controlled at compile time:

```raccoon
// Disable GC for a module
@GC(false)
module computation {
    // Must handle all memory manually
}

// Force GC for a type
@GC(true)
struct ComplexGraph {
    // Always uses GC
}
```

### Value Semantics

In GC-enabled mode, Raccoon uses value semantics for assignment:

```raccoon
var mut x = [1, 2, 3];
var y = x;      // Creates a immutable copy
x[0] = 10;      // Doesn't affect y
```

## GC-Disabled Mode

When compiling with GC disabled (`--gc=false`), Raccoon requires manual memory management using ownership rules.

### Understanding Smart Pointers

In GC-free mode, Raccoon provides smart pointers to manage memory safely without garbage collection. Smart pointers are special data types that act like regular pointers but provide additional memory management capabilities.

#### What Are Smart Pointers?

Smart pointers are objects that wrap raw memory pointers with automatic memory management logic. They ensure resources are properly cleaned up when no longer needed, preventing memory leaks and other common memory-related bugs. In Raccoon, smart pointers are essential tools for building complex data structures and managing shared data in GC-free mode.

Unlike raw pointers that require manual memory allocation and deallocation, smart pointers automatically handle this for you. They follow the principle of RAII (Resource Acquisition Is Initialization) - when a smart pointer goes out of scope, it automatically deallocates its associated memory.

#### Types of Smart Pointers in Raccoon

Raccoon offers several smart pointer types, each designed for specific memory management needs:

1. **Box\<T\>**: A single-owner, heap-allocated container.
   * Provides exclusive ownership of a value on the heap
   * Automatically deallocates memory when the Box goes out of scope
   * Useful for dynamic dispatch or very large objects that shouldn't be copied

2. **Rc\<T\>**: A Reference-Counted pointer for shared ownership.
   * Keeps track of how many references exist to a value
   * Deallocates only when the last reference is dropped
   * Thread-unsafe; use only within a single thread
   * Perfect for creating data structures with multiple owners, like trees and graphs

3. **Arc\<T\>**: Atomic Reference-Counted pointer for thread-safe sharing.
   * Like Rc, but safe to share across threads
   * Uses atomic operations for reference counting
   * Slightly higher performance cost than Rc due to thread synchronization
   * Essential for data shared between threads

4. **Weak\<T\>**: A non-owning reference to break reference cycles.
   * Does not keep its target alive
   * Must be upgraded to Rc/Arc before use (which may fail if target is gone)
   * Essential for breaking circular references in data structures

#### When to Use Each Smart Pointer

| Pointer Type | Use When | Example Use Case |
|--------------|----------|------------------|
| Box\<T\>     | You need exclusive ownership of a heap value | Large objects, trait objects, recursive types |
| Rc\<T\>      | Multiple parts of your code need to read the same data | Tree structures where nodes are referenced by multiple parents |
| Arc\<T\>     | Multiple threads need to access the same data | Shared configuration, thread pools with shared work queues |
| Weak\<T\>     | You need to break reference cycles | Parent-child relationships where children reference parents |

#### Smart Pointer Usage Examples

**Box\<T\> - Single ownership:**
```raccoon
// Store a large object on the heap instead of the stack
var largeData = Box.new(LargeDataStruct());

// Access members using the same syntax as direct values
println(largeData.name);
```

**Rc\<T\> - Shared ownership:**
```raccoon
// Create a shared string that multiple parts of the code can own
var sharedMessage = Rc.new(String("Important message"));

// Create another owner of the message
var anotherOwner = sharedMessage.clone(); // Increases reference count

// Both can read the value
println(sharedMessage.length());
println(anotherOwner.length());

// Memory is freed only when all owners go out of scope
```

**Arc\<T\> - Thread-safe sharing:**
```raccoon
// Create thread-safe shared configuration
var config = Arc.new(Configuration());

// Share with a new thread
var configCopy = config.clone(); // Increases reference count
spawn {
    // Use the configuration in another thread
    println(configCopy.serverUrl);
};
```

**Weak\<T\> - Breaking cycles:**
```raccoon
struct Parent {
    children: [Rc<Child>]
}

struct Child {
    // Weak reference prevents reference cycle
    parent: Weak<Parent>
}

func createFamily() {
    var parent = Rc.new(Parent { children: [] });

    // Create child with weak reference to parent
    var child = Rc.new(Child { parent: Rc.downgrade(parent) });

    // Add strong reference to child in parent
    parent.children.append(child);

    // Using weak reference requires upgrade
    var child = parent.children[0];
    var maybeParent = child.parent.upgrade();
    match maybeParent {
        Some(strongParent) => println("Parent found"),
        None => println("Parent was deallocated")
    }
}
```

#### Benefits of Smart Pointers

1. **Memory Safety**: Prevent leaks and use-after-free bugs
2. **Clear Ownership Semantics**: Make data sharing explicit and controlled
3. **Automatic Cleanup**: Resources are released deterministically when no longer needed
4. **Abstraction Without Overhead**: Smart pointers have minimal runtime cost
5. **Thread Safety Options**: Choose the right tool for single-threaded or multi-threaded code

By understanding and using the appropriate smart pointers, you can build complex, memory-safe applications without garbage collection, achieving both high performance and safety.

### Restrictions in GC-Free Mode

#### Circular References

Direct circular references are not allowed:

```raccoon
struct Node {
    // Error in GC-free mode:
    // next: Option<Node>;  // Would create circular reference

    // Solution: Use weak references
    mut next: Weak<Option<Node>>;
}
```

#### Collection Handling

Collections must have clear ownership:

```raccoon
struct Owner {
    // OK: Owner clearly owns the items
    mut items: [Item];

    // Error: Unclear ownership of shared items
    // mut shared: HashMap<String, SharedItem>;

    // Solution: Use explicit reference counting
    mut shared: HashMap<String, Arc<SharedItem>>;
}
```

#### Closures and Captures

In GC-free mode, the compiler automatically tracks variable lifetimes for closures in most common cases:

```raccoon
func example() {
    var data = [1, 2, 3];

    // Compiler automatically ensures data lives long enough
    var closure = () => {
        println(data);  // Safe to use 'data', compiler verifies its lifetime
    };

    // Works with multiple captures too
    var multiCapture = (count) => {
        println("Count: " + count + ", Data: " + data[0]);
    };
}
```

For complex scenarios where the compiler cannot determine lifetimes automatically, you can use the `^` symbol to explicitly specify captures:

```raccoon
func createComplexClosure(input: [int]): func(): int {
    // Explicit annotation needed because the closure escapes the function
    return (^input) => {
        return input[0];  // Safe to use 'input' because we've specified its lifetime
    };
}
```

The `^` symbol creates a clear link between the closure and the variables it depends on, ensuring those variables remain valid for the entire lifetime of the closure. This symbol visually suggests "accessing a variable from an outer scope."

#### Multiple Distinct Lifetimes

For advanced scenarios where you need to handle multiple distinct lifetimes, named lifetime annotations can be used:

```raccoon
func combineData<T>(shortLived: [T], longLived: [T]): func(): [T] {
    // Named lifetimes with a:shortLived and b:longLived
    return (^a:shortLived, ^b:longLived) => {
        // The compiler knows shortLived and longLived may have different lifetimes
        // It can enforce stricter lifetime rules based on how they're used
        return shortLived.concat(longLived);
    };
}

// In function parameters
func getLongest<T>(^a:first: &[T], ^b:second: &[T]): &[T] {
    if first.length > second.length {
        return first;  // Returns a reference with lifetime 'a'
    } else {
        return second; // Returns a reference with lifetime 'b'
                      // The compiler would flag this as an error since the
                      // return type needs to match one specific lifetime
    }
}

// Correct version specifying that both parameters and return value share a lifetime
func getLongest<T>(^a:first: &[T], ^a:second: &[T]): &[T] {
    if first.length > second.length {
        return first;
    } else {
        return second; // OK: Both parameters share lifetime 'a'
    }
}
```

This approach provides fine-grained control over lifetimes when needed while keeping the syntax more approachable.

#### Thread Safety

Thread-safe sharing requires explicit mechanisms:

```raccoon
// Error in GC-free mode: Unclear thread safety
// var shared = SharedData();

// Solution: Explicit thread-safe reference counting
var shared = Arc.new(SharedData());
var threadSafe = shared.clone();
spawn {
    use(threadSafe);
}
```

### Smart Pointers (GC-Free Mode Only)

In GC-free mode, smart pointers provide explicit memory management:

1. `Box<T>` - Single-owner heap allocation
2. `Rc<T>` - Reference-counted sharing
3. `Arc<T>` - Atomic reference-counted sharing
4. `Weak<T>` - Weak reference (breaks cycles)

```raccoon
var boxed = Box.new(LargeStruct());
var shared = Rc.new(SharedData());
var threadSafe = Arc.new(ThreadData());
var weak = Rc.downgrade(shared);
```

## Best Practices

1. Prefer stack allocation
2. Use ownership for clear data flow
3. Implement `deinit()` only when custom cleanup is needed (the compiler handles IO resources automatically)
4. Use GC only when necessary
5. Consider GC-free mode constraints
6. Profile memory usage patterns
7. Use appropriate memory management approach for your use case
8. Document ownership requirements

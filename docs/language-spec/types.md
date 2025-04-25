# Types in Raccoon

Raccoon provides a rich type system that combines safety with flexibility. This guide covers all available types and their usage patterns.

## Primitive Types

### Number Types

#### number
```raccoon
// Basic usage - compiler infers the most appropriate type
var n1 = 42;         // Compiler infers int
var n2 = 42.0;       // Compiler infers float
var n3 = 42.5;       // Compiler infers float

// Explicit number type - lets compiler choose int or float
var n4: number = 42;    // Compiler chooses int
var n5: number = 42.5;  // Compiler chooses float

// Mathematical operations
var n6 = n4 + n5;       // Compiler chooses float (42.0 + 42.5)
var n7 = n1 * 2;        // Compiler keeps as int (84)
var n8 = n1 * 2.5;      // Compiler converts to float (105.0)

// Function parameters can use number for flexibility
func calculate(value: number): number {
    if (value < 100) {
        return value * 2;      // Returns same type as input
    }
    return value / 2;          // Returns float if division isn't even
}

// Complex expressions
var n9 = calculate(42);        // Returns int (84)
var n10 = calculate(42.5);     // Returns float (85.0)
var n11 = calculate(101);      // Returns float (50.5)

// Arrays and collections
var numbers: [number] = [1, 2.5, 3, 4.7];  // Array of mixed int/float
var matrix: [[number]] = [
    [1, 2.5],
    [3.7, 4]
];

// Type inference in expressions
var sum = numbers.reduce((acc, n) => acc + n);  // Compiler infers float
var product = [1, 2, 3].map(n => n * 2);        // Compiler keeps as [int]
var mixed = [1, 2, 3].map(n => n * 2.5);        // Compiler converts to [float]

// Common mathematical operations
var n12 = sqrt(16);    // Returns float (4.0)
var n13 = pow(2, 3);   // Returns int (8) when both operands are int
var n14 = pow(2, 3.5); // Returns float (11.313...)

// Constants
const MAX_VALUE: number = 1000;    // Compiler chooses int
const PI: number = 3.14159;        // Compiler chooses float
const RATIO: number = 2/3;         // Compiler chooses float

// Type coercion examples
func printValue(x: number) {
    println(x);
}

printValue(42);        // Works with int
printValue(3.14);      // Works with float
printValue(2/3);       // Works with computed values

// Numeric limits are enforced at runtime
var n15 = 9223372036854775807;    // Max int64
var n16 = n15 + 1;                // Runtime error: integer overflow

// Pattern matching with number
match calculate(42) {
    n if n.isInt() => println("Got an integer: " + n),
    n => println("Got a float: " + n)
}
```

#### int
```raccoon
// 64-bit signed integer by default
var i1: int = 42;
var i2 = 42_000;  // Underscores for readability
var i3 = -17;

// Size-specific integers
var i4: int8 = 127;        // -128 to 127
var i5: int16 = 32767;     // -32768 to 32767
var i6: int32 = 2147483647;// -2147483648 to 2147483647
var i7: int64 = 42;        // -2^63 to 2^63-1

// Unsigned integers
var u1: uint = 42;         // 64-bit unsigned
var u2: uint8 = 255;       // 0 to 255
var u3: uint16 = 65535;    // 0 to 65535
var u4: uint32 = 4294967295;// 0 to 4294967295
var u5: uint64 = 42;       // 0 to 2^64-1
```

#### float
```raccoon
// 64-bit floating-point by default
var f1: float = 3.14;
var f2 = 3.14;      // Type inference
var f3 = 3.14e-10;  // Scientific notation
var f4 = -0.001;

// Size-specific floats
var f5: float32 = 3.14;  // Single precision
var f6: float64 = 3.14;  // Double precision (default)
```

### Other Primitives

#### bool
```raccoon
var b1: bool = true;
var b2 = false;     // Type inference
var b3 = !b1;       // Logical NOT
```

#### char
```raccoon
var c1: char = 'A';
var c2 = '🦝';      // Unicode support
var c3 = '\n';      // Special characters
```

#### string
```raccoon
// Basic string declaration
var s1: string = "Hello";
var s2 = "World";   // Type inference

// String interpolation with ${}
var name = "Alice";
var age = 30;
var greeting = "Hello, ${name}!";                    // "Hello, Alice!"
var info = "User ${name} is ${age} years old";      // "User Alice is 30 years old"

// Multi-line strings with interpolation
var multiline = """
    User Profile:
    Name: ${name}
    Age: ${age}
    Status: ${age >= 18 ? "Adult" : "Minor"}
    """;

// Expressions in interpolation
var x = 10;
var y = 20;
var calculation = "Sum of ${x} and ${y} is ${x + y}";  // "Sum of 10 and 20 is 30"

// Nested expressions
var items = ["apple", "banana", "orange"];
var list = "Items: ${items.map(item => item.toUpperCase()).join(", ")}";
// "Items: APPLE, BANANA, ORANGE"

// Object interpolation
struct Point {
    x: int;
    y: int;

    func toString(): string {
        return "(${this.x}, ${this.y})";
    }
}

var point = Point(10, 20);
var location = "Point at ${point}";  // "Point at (10, 20)"

// Conditional interpolation
var status = "Server is ${isOnline ? "online" : "offline"}";

// Function calls in interpolation
func getStatus(): string {
    return "active";
}
var message = "System is ${getStatus()}";  // "System is active"

// Escaping interpolation
var code = "To interpolate, use \${expression}";  // "To interpolate, use ${expression}"

// Complex expressions
var data = [1, 2, 3, 4, 5];
var stats = """
    Data Analysis:
    Values: ${data.join(", ")}
    Count: ${data.length}
    Sum: ${data.reduce((acc, n) => acc + n)}
    Average: ${data.reduce((acc, n) => acc + n) / data.length}
    """;

// Pattern matching in interpolation
var opt: int? = Some(42);
var result = "Value is ${match opt {
    Some(n) => n.toString(),
    None => "not available"
}}";  // "Value is 42"

// Format specifiers for numbers
var pi = 3.14159;
var formatted = "Pi is ${pi:.2}";  // "Pi is 3.14"
var padded = "Value: ${42:04}";    // "Value: 0042"

// Interpolation with raw strings
var path = r"C:\Users\${name}\Documents";  // "C:\Users\Alice\Documents"

// Unicode support in interpolation
var emoji = "🦝";
var animal = "Raccoon ${emoji}";    // "Raccoon 🦝"
```

#### unit
```raccoon
// Represents the absence of a value (similar to void)
func doNothing() {
    // Returns unit implicitly
}

// Explicit unit
var nothing: unit = ();
```

## Composite Types

### Tuple
```raccoon
// Basic tuple with two elements
var point: (int, int) = (10, 20);
var person = ("John", 30);  // Type inference: (string, int)

// Tuples with more elements
var rgb: (int, int, int) = (255, 0, 0);  // RGB color
var user = ("Alice", 28, true, "admin");  // (string, int, bool, string)
var record = (1, "apple", 0.99, true, [1, 2, 3]);  // Mixed types

// Raccoon supports tuples with up to 10 elements (indices .0 through .9)
var tenElements = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9);
var element0 = tenElements.0;  // 0
var element5 = tenElements.5;  // 5
var element9 = tenElements.9;  // 9

// Example with 10 different types
var mixed: (int, string, bool, float, char, [int], date, (int, int), func(int): int, Map<string, int>) = (
    42,                        // .0: int
    "hello",                   // .1: string
    true,                      // .2: bool
    3.14,                      // .3: float
    'A',                       // .4: char
    [1, 2, 3],                 // .5: array
    Date(2023, 5, 15),         // .6: date
    (10, 20),                  // .7: nested tuple
    (x) => x * 2,              // .8: function
    Map("key": 42)             // .9: map
);

// Accessing all elements
println(mixed.0);  // 42
println(mixed.1);  // "hello"
println(mixed.2);  // true
println(mixed.3);  // 3.14
println(mixed.4);  // 'A'
println(mixed.5);  // [1, 2, 3]
println(mixed.6);  // 2023-05-15
println(mixed.7);  // (10, 20)
println(mixed.8(21));  // 42
println(mixed.9["key"]);  // 42

// Accessing tuple elements (zero-indexed)
var name = person.0;   // First element
var age = person.1;    // Second element
var blue = rgb.2;      // Third element
var isActive = user.2; // Fourth element

// Named tuple fields for improved readability
var employee: (name: string, age: int, role: string) = (name: "Bob", age: 42, role: "Engineer");
var employeeName = employee.name;
var employeeRole = employee.role;

// More complex named tuples
var product: (
    id: int,
    name: string,
    price: float,
    categories: [string],
    inStock: bool
) = (
    id: 1001,
    name: "Laptop",
    price: 999.99,
    categories: ["Electronics", "Computers"],
    inStock: true
);

// Tuple destructuring
var (x, y) = point;
var (r, g, b) = rgb;
var (userName, userAge, isAdmin, userRole) = user;

// Destructuring all 10 elements
var (e0, e1, e2, e3, e4, e5, e6, e7, e8, e9) = tenElements;

// Partial destructuring with placeholders
var (userId, _, _, userType) = user;  // Ignore some elements
var (first, second, ...) = record;    // Take only what's needed

// Nested tuples
var nested = ((1, 2), (3, 4));
var ((a, b), (c, d)) = nested;  // Destructuring nested tuples

// Tuples in function returns
func getUserInfo(): (string, int, bool) {
    return ("Alice", 30, true);
}

var (userName, userAge, isActive) = getUserInfo();

// Use cases for larger tuples

// 1. Representing database records
var dbRow: (int, string, string, date, string) = (
    1, "Alice", "alice@example.com", Date(2023, 1, 15), "admin"
);

// 2. Multiple return values
func parseAddress(): (string, string, string, string, string) {
    // Returns (street, city, state, zip, country)
    return ("123 Main St", "Springfield", "IL", "62704", "USA");
}

// 3. Grouping related values
var geoLocation = (39.7456, -97.2398, 254.3); // (latitude, longitude, elevation)

// 4. Function parameters as tuples
func plotPoint(point: (float, float, float), color: (int, int, int)) {
    // Plot a 3D point with RGB color
}

// 5. Complex data transformations
var transformations = [
    (0.5, 0.5, 0.0, 0.0, 0.0), // (scaleX, scaleY, rotateZ, translateX, translateY)
    (1.0, 1.0, 90.0, 10.0, 0.0),
    (2.0, 0.5, 45.0, 0.0, 10.0)
];

// Working with tuples in collections
var points = [(1, 2), (3, 4), (5, 6)];
var firstPoint = points[0];
var allXValues = points.map(p => p.0);  // [1, 3, 5]

// Comparing tuples
func comparePoints(p1: (int, int), p2: (int, int)): bool {
    return p1 == p2;  // Tuples support equality comparison
}

// Sorting by tuple elements
var users = [("Bob", 25), ("Alice", 30), ("Charlie", 20)];
var sorted = users.sortBy(user => user.1);  // Sort by age

// Recommended tuple usage
// 1-4 elements: Ideal for quick grouping and multiple returns
// 5-10 elements: Use named tuples for clarity
// > 10 elements: Consider using a struct instead

// Note on Tuples vs Structs
/*
  IMPORTANT: While tuples are convenient for quickly grouping related values,
  we strongly recommend using structs for:

  1. Better memory management - Structs provide more predictable memory layout and optimization
  2. Improved code readability - Field names are always explicit
  3. Self-documenting code - Type names communicate intent
  4. Maintainability - Adding/removing fields is safer with compile-time checks
  5. Extensibility - Can add methods and implement interfaces

  Tuples are best for temporary groupings and multiple return values.
  For persistent data structures, favor structs.
*/

// Example: Converting a large tuple to a struct
var largeNamedTuple = (
    id: 1001,
    firstName: "Alice",
    lastName: "Smith",
    age: 30,
    email: "alice@example.com",
    phone: "555-1234",
    address: "123 Main St",
    city: "New York",
    zipCode: "10001",
    isActive: true
);

// Better as a struct
struct User {
    id: int;
    firstName: string;
    lastName: string;
    age: int;
    email: string;
    phone: string;
    address: string;
    city: string;
    zipCode: string;
    isActive: bool;
}
```

### Array
```raccoon
// Fixed-size or dynamic array of same-type elements
var numbers: [int] = [1, 2, 3, 4, 5];
var names = ["Alice", "Bob"];  // Type inference: [string]

// Multi-dimensional arrays
var matrix: [[int]] = [
    [1, 2, 3],
    [4, 5, 6]
];

// Array operations
var first = numbers[0];     // Indexing
var length = numbers.length;// Length property
```

### Option
```raccoon
// Represents optional values
var name: string? = "John";    // Syntactic sugar for Option<string>
var empty: string? = null;

// Pattern matching with options
match name {
    Some(value) => println("Name is " + value),
    None => println("No name provided")
}
```

### Result
```raccoon
// For error handling
var result: Result<int, string> = Ok(42);
var error: Result<int, string> = Err("something went wrong");

// Pattern matching with results
match result {
    Ok(value) => println("Success: " + value),
    Err(msg) => println("Error: " + msg)
}
```

## Type Modifiers

### mut
```raccoon
// For mutable variables
var mut count = 0;
count += 1;

// Mutable struct fields
struct Counter {
    mut value: int;
}
```

### ref
```raccoon
// Reference types (shared memory)
var &shared = SharedData();
var mut &counter = Counter();
```

## Type Inference Rules

1. **Default Number Types**:
   - Integer literals default to `int`
   - Floating-point literals default to `float`
   - Mathematical operations default to `float` when type is ambiguous

2. **Collection Types**:
   - Array type is inferred from elements
   - Tuple type is inferred from elements
   - Empty collections require explicit type

3. **Function Types**:
   - Return type can be inferred for simple expressions
   - Parameter types must be explicit

```raccoon
// Type inference examples
var number = 42;         // int
var pi = 3.14;           // float
var text = "Hello";      // string
var items = [1, 2, 3];   // [int]
var mixed = (1, "two");  // (int, string)

// Explicit type required
var emptyArray: [int] = [];
var emptyTuple: (int, string);
```

## Best Practices

1. **Number Type Selection**:
   - Use `number` when the specific numeric type isn't important
   - Use `int` for counting, indices, sizes
   - Use `float` for mathematical calculations
   - Use sized types (`int32`, `float64`) when memory or interop matters

2. **Tuple Usage**:
   - Use tuples for temporary grouping of related values
   - Prefer structs for long-term data structures
   - Use named tuples when field names add clarity

3. **Type Safety**:
   - Let the compiler infer types when obvious
   - Explicitly declare types for public APIs
   - Use the most specific type that makes sense

4. **Error Handling**:
   - Use `Option` for values that might be missing
   - Use `Result` for operations that might fail
   - Avoid using `null` except with `Option`

## Interface Definition

Interfaces in Raccoon define a contract of methods and properties that implementing types must satisfy. Unlike traditional OOP languages, Raccoon interfaces are purely about behavior, not inheritance.

```
// Basic syntax
interface <name> {
    // Method signatures
    func <method_name>(<param>: <type>, ...): <return_type>;

    // Property signatures
    <property_name>: <type>;
}
```

## Examples of Interfaces

```raccoon
// Basic interface for readable objects
interface Readable {
    func read(bytes: int): Buffer;
    func close();
}

// Interface with properties
interface User {
    id: string;
    name: string;
    email: string;

    func isAdmin(): bool;
}

// Interface composition
interface ReadWritable extends Readable {
    func write(data: Buffer): int;
    func flush();
}
```

## Struct Definition

Structs in Raccoon are used to define composite data types with values and optional methods.

```
// Basic syntax
struct <name> {
    // Properties
    <property_name>: <type>;

    // Constructor
    init(<param>: <type>, ...) {
        this.<property> = <value>;
        // ...
    }

    // Methods
    func <method_name>(<param>: <type>, ...): <return_type> {
        // Implementation
    }
}
```

## Examples of Structs

```raccoon
// Simple struct with properties
struct Point {
    x: float;
    y: float;

    // Default constructor is generated automatically
}

// Struct with custom constructor and methods
struct Rectangle {
    width: float;
    height: float;

    init(width: float, height: float) {
        this.width = width;
        this.height = height;
    }

    func area(): float {
        return width * height;
    }

    func perimeter(): float {
        return 2 * (width + height);
    }
}

// Struct with mutable state
struct Counter {
    mut count: int; // Mutable properties can't be modified outside the struct

    init(startValue: int = 0) {
        this.count = startValue;
    }

    func increment() {
        count += 1;
    }

    func reset() {
        count = 0;
    }

    func value(): int {
        return count; // Mutable properties can't be accessed outside the struct
    }
}
```

## Implementing Interfaces

Structs can implement interfaces using the `implements` keyword:

```raccoon
// File implementation that satisfies the Readable interface
struct File implements Readable {
    path: string;
    mut handle: FileHandle;

    init(path: string) {
        this.path = path;
        this.handle = FileSystem.open(path);
    }

    func read(bytes: int): Buffer {
        return handle.read(bytes);
    }

    func close() {
        handle.close();
    }
}
```

A struct can implement multiple interfaces:

```raccoon
struct Socket implements Readable, Writable {
    // Implementation
}
```

## Structural vs Nominal Typing

Raccoon uses structural typing for interfaces, meaning any type that has the required methods and properties satisfies the interface, regardless of explicit declaration:

```raccoon
interface Measurable {
    func length(): int;
}

struct String {
    // String implementation

    func length(): int {
        // Returns string length
    }
}

// This works even though String doesn't explicitly implement Measurable
func measure(m: Measurable): int {
    return m.length();
}

var str = "Hello";
var len = measure(str);  // Valid! String has a length() method
```

## Generic Types

Both interfaces and structs can be generic:

```raccoon
// Generic interface
interface Container<T> {
    func add(item: T);
    func get(index: int): T;
    func size(): int;
}

// Generic struct implementing generic interface
struct List<T> implements Container<T> {
    mut items: [T];

    init() {
        this.items = [];
    }

    func add(item: T) {
        items.append(item);
    }

    func get(index: int): T {
        return items[index];
    }

    func size(): int {
        return items.length;
    }
}
```

## Design Rationale

Raccoon's approach to types is influenced by several modern languages:

- **Interface-Based Polymorphism**: Like Go, focuses on behavior over inheritance hierarchies
- **Structural Typing**: Similar to TypeScript, promotes flexibility and composition
- **Explicit Mutability**: Like Rust, makes state changes clear and intentional
- **Value Semantics**: Similar to Swift, makes data flow more predictable
- **No Inheritance**: Favors composition over inheritance for more maintainable code

## Edge Cases

1. **Interface vs Abstract Class**: Raccoon has no abstract classes or inheritance, only interfaces and composition:
   ```raccoon
   // Instead of inheritance, use composition and delegation
   struct EnhancedRectangle {
       rectangle: Rectangle;
       color: string;

       func area(): float {
           return rectangle.area();
       }
   }
   ```

2. **Diamond Problem**: Without inheritance, Raccoon avoids the diamond problem entirely.

3. **Extension Methods**: Raccoon allows adding methods to existing types:
   ```raccoon
   extend string {
       func isPalindrome(): bool {
           // Implementation
       }
   }
   ```

4. **Self-Referential Types**: Types can reference themselves:
   ```raccoon
   struct Node<T> {
       value: T;
       next: Node<T>?;  // Optional reference to another Node
   }
   ```

## Raw Strings and Interpolation
// Raw strings (prefixed with 'r') treat backslashes as literal characters
// but still support interpolation with ${}

// Regular string - backslashes are escape characters
var regularPath = "C:\\Users\\Alice\\Documents";    // C:\Users\Alice\Documents
var newlineStr = "Line1\nLine2";                    // Two lines

// Raw string - backslashes are treated as literal characters
var rawPath = r"C:\Users\Alice\Documents";          // C:\Users\Alice\Documents
var rawNewline = r"Line1\nLine2";                  // Line1\nLine2

// Raw strings with interpolation
var username = "Alice";
var regularString = "C:\\Users\\${username}\\Docs"; // Needs double backslashes
var rawString = r"C:\Users\${username}\Docs";       // Cleaner syntax

// Common use cases for raw strings with interpolation:

// 1. File paths
var basePath = r"C:\Program Files";
var appPath = r"${basePath}\${appName}\config.ini";

// 2. Regular expressions
var pattern = r"^\d{2}-\d{2}-\d{4}$";
var datePattern = r"^${year}-\d{2}-\d{2}$";

// 3. SQL queries
var tableName = "users";
var query = r"""
    SELECT *
    FROM ${tableName}
    WHERE age > 18
    AND \${status} = 'active'    // \${status} is literal, not interpolated
    """;

// 4. Command line arguments
var scriptPath = r"${baseDir}\scripts\build.sh";
var command = r"bash ${scriptPath} --config=\${ENV}";  // \${ENV} will be literal

// 5. Network paths
var server = "fileserver";
var share = "public";
var networkPath = r"\\${server}\${share}";  // \\fileserver\public

// 6. Multi-line raw strings with selective escaping
var template = r"""
    <user>
        <name>${username}</name>
        <path>${r"C:\Users\${username}"}</path>   // Nested raw string
        <query>${r"SELECT * FROM \${table}"}</query>
    </user>
    """;

// Raw strings can be combined with format specifiers
var value = 42.123456;
var formatted = r"Value at ${path}\data.txt is ${value:.2}";

// Escaping ${} in raw strings requires \
var documentation = r"""
    To use variables in strings, use \${varName}
    Example: ${example}
    To show literal \${}, escape with backslash
    """;

// Raw strings preserve whitespace
var script = r"""
    function hello() {
        console.log("${message}");
        // \${name} will be replaced at runtime
    }
    """;
```

## Type Conversion

### Implicit Conversion
```raccoon
// Number type conversions
var i: int = 42;
var n: number = i;      // int -> number (always safe)
var f: float = 3.14;
var n2: number = f;     // float -> number (always safe)

// Numeric widening
var i8: int8 = 127;
var i16: int16 = i8;    // int8 -> int16 (safe)
var i32: int32 = i16;   // int16 -> int32 (safe)

// Array and slice conversions
var arr: [int] = [1, 2, 3];
var slice: &[int] = arr;  // Array to slice (safe)
```

### Explicit Conversion
```raccoon
// Using type constructors
var f = 3.14;
var i = int(f);        // float -> int (truncates)
var s = string(42);    // number -> string

// Safe conversions with Option
var f2 = 3.14;
var i2 = int.tryFrom(f2);  // Returns Option<int>
match i2 {
    Some(value) => println("Converted to ${value}"),
    None => println("Conversion failed")
}

// Safe conversions with Result
var s2 = "123";
var n2 = int.tryParse(s2);  // Returns Result<int, ParseError>
match n2 {
    Ok(value) => println("Parsed ${value}"),
    Err(e) => println("Parse error: ${e}")
}
```

## Type Aliases

```raccoon
// Simple type aliases
type UserId = int64;
type Username = string;
type Timestamp = int64;

// Generic type aliases
type List<T> = [T];
type Dict<K, V> = Map<K, V>;
type Callback<T> = func(T): void;

// Complex type aliases
type JsonValue = string | number | bool | null | [JsonValue] | {[string]: JsonValue};
type HttpHandler = func(Request): Result<Response, Error>;

// Using type aliases
func createUser(id: UserId, name: Username): Result<User, Error> {
    // Implementation
}

// Type aliases with constraints
type Numeric = int | float | int8 | int16 | int32 | int64;
type Ordered<T: Compare> = T;
```

## Type Constraints

```raccoon
// Interface constraints
func sort<T: Compare>(items: [T]) {
    // Implementation using Compare interface
}

// Multiple constraints
func process<T: Serialize | Clone>(item: T) {
    // Implementation using both interfaces
}

// Numeric constraints
func sum<T: number>(values: [T]): T {
    return values.reduce((acc, v) => acc + v);
}

// Custom constraints
interface DataProcessor<T> {
    func process(data: T): Result<T, Error>;
}

func processData<T, P: DataProcessor<T>>(processor: P, data: T): Result<T, Error> {
    return processor.process(data);
}
```

## Advanced Type Features

### Union Types
```raccoon
// Simple union
type Result<T> = Success<T> | Error;

// Pattern matching on unions
func handleResult(result: Result<int>) {
    match result {
        Success(value) => println("Got ${value}"),
        Error(msg) => println("Error: ${msg}")
    }
}

// Union with multiple types
type JsonNumber = int | float | int64;
```

### Intersection Types
```raccoon
// Combining interfaces
interface Readable {
    func read(): string;
}

interface Writable {
    func write(data: string);
}

// Using intersection type
func processStream(stream: Readable & Writable) {
    var data = stream.read();
    // Process data
    stream.write(data);
}
```

### Type Guards
```raccoon
// Type guard functions
func isNumber(value: any): value is number {
    return typeof value == "number";
}

// Using type guards
func process(value: any) {
    if (isNumber(value)) {
        // value is typed as number here
        return value * 2;
    }
    return 0;
}

// Built-in type guards
if (value.isInt()) {
    // value is known to be an integer
}
```

### Recursive Types
```raccoon
// Tree structure
type Tree<T> = {
    value: T,
    children: [Tree<T>]
};

// Linked list
type List<T> = {
    value: T,
    next: List<T>?
};

// JSON-like structure
type Json = {
    string |
    number |
    bool |
    null |
    [Json] |
    {[string]: Json}
};
```

### Type Inference in Complex Scenarios
```raccoon
// Function composition
func compose<A, B, C>(
    f: func(B): C,
    g: func(A): B
): func(A): C {
    return (x: A) => f(g(x));
}

// Generic type inference
var numbers = [1, 2, 3];
var doubled = numbers.map(n => n * 2);  // Type: [int]
var strings = doubled.map(n => n.toString());  // Type: [string]

// Inference with constraints
func minimum<T: Compare>(a: T, b: T): T {
    return a < b ? a : b;
}
```

## Memory Management and Types

### Value Semantics
```raccoon
// All types have value semantics by default
var point1 = Point(x: 10, y: 20);
var point2 = point1;  // Creates a new copy
point2.x = 30;        // Error: Cannot modify immutable value

// For mutable values, explicit mut is required
var mut point3 = Point(x: 10, y: 20);
point3.x = 30;  // OK: point3 is mutable
```

### Shared State
```raccoon
// When sharing is needed, use explicit thread-safe types
var counter = Atomic(0);
var cache = SharedMap<string, int>();
var queue = ConcurrentQueue<Task>();

// These types ensure thread-safety through internal synchronization
counter.add(1);
cache.insert("key", 42);
queue.push(task);
```

### Large Data Structures
```raccoon
// Efficient handling of large data structures through:

// 1. Copy-on-write semantics
var largeList = List([1, 2, 3, ...1000]);
var newList = largeList.append(1001);  // Efficient copy-on-write

// 2. Persistent data structures
var tree = Tree();
var newTree = tree.insert("key", "value");  // Shares structure

// 3. Slices for viewing data
var numbers = [1, 2, 3, 4, 5];
var slice = numbers.slice(1, 3);  // View into original data
```

### Collection Types
```raccoon
// Immutable collections by default
var list = [1, 2, 3];
var set  = Set(1, 2, 3);
var map  = Map("a": 1, "b": 2);

// Mutable collections need explicit mut
var mut mutableList = [1, 2, 3];
var mut mutableSet  = Set(1, 2, 3);
var mut mutableMap  = Map("a": 1, "b": 2);

// Thread-safe collections when needed
var sharedList = ConcurrentList([1, 2, 3]);
var sharedSet  = ConcurrentSet(1, 2, 3);
var sharedMap  = ConcurrentMap("a": 1, "b": 2);
```

### Memory Optimization
```raccoon
// Small String Optimization (SSO)
var shortString = "abc";  // Stored inline
var longString = "very long string...";  // Heap allocated

// Copy elision
func process(data: LargeStruct) {  // Passed by value, optimized by compiler
    // Use data
}

// Array optimization
var inlineArray: Array<int, 16>();  // Fixed-size array on stack
var heapArray = Array<int>();       // Dynamic array on heap
```

### Ownership and Borrowing
```raccoon
// Instead of references, use explicit ownership transfer
func transferOwnership(mut target: Container, source: Data) {
    target.data = source;  // Moves source into target
}

// Use return values instead of out parameters
func process(data: Data): (Result, Stats) {
    // Return multiple values instead of modifying through references
    return (result, stats);
}

// Iteration without references
for (var item in collection) {  // Items are copied by value
    // Use item
}

// Efficient iteration for large structures
for (var item in collection.iter()) {  // Iterator provides efficient access
    // Use item
}
```

### Thread Communication
```raccoon
// Use message passing instead of shared memory
var channel = Channel<Message>();

// Sender
channel.send(Message("hello"));

// Receiver
match channel.receive() {
    Ok(msg) => println("Got: ${msg}"),
    Err(e) => println("Error: ${e}")
}

// Multiple producers/consumers
var broadcast = Broadcast<Event>();
var queue = WorkQueue<Task>();
```

## Best Practices

1. **Value Semantics**:
   - Embrace immutability as the default
   - Use value types for clear ownership
   - Avoid mutable state when possible
   - Use explicit mut for mutable values

2. **State Management**:
   - Use message passing for thread communication
   - Choose appropriate collection types
   - Use persistent data structures for large immutable data
   - Leverage copy-on-write for efficiency

3. **Performance**:
   - Let the compiler optimize copies
   - Use appropriate collection types
   - Consider memory layout in hot paths
   - Use stack allocation when appropriate

4. **Thread Safety**:
   - Use message passing over shared memory
   - Choose thread-safe collections when needed
   - Avoid explicit synchronization
   - Use atomic types for simple shared state

5. **API Design**:
   - Return new values instead of modifying
   - Use tuples for multiple returns
   - Make immutability clear in APIs
   - Use builders for complex object construction

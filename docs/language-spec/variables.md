# Variables and Declarations

## Overview

Variables in Raccoon provide storage for values with a clear emphasis on immutability by default. This approach helps write safer, more predictable code while maintaining flexibility when needed.

## Basic Syntax

```raccoon
// Basic syntax
var <identifier>: <type> = <expression>;
var mut <identifier>: <type> = <expression>;  // Mutable variable

// Type can be inferred
var <identifier> = <expression>;
var mut <identifier> = <expression>;  // Mutable variable with inference
```

## Examples

### Basic Declaration

```raccoon
// Immutable variable with type inference
var name = "Raccoon";

// Immutable variable with explicit type
var count: int = 42;

// Mutable variable with type inference
var mut score = 0;

// Mutable variable with explicit type
var mut isActive: bool = true;

// Multiple declarations
var (x, y) = (10, 20);
var mut (width, height): (float, float) = (3.5, 4.2);
```

### Variable Scope

```raccoon
func example() {
    var x = 10;

    {
        var y = 20;     // y is only visible in this block
        var x = 30;     // Shadows the outer x
        println(x);     // Prints 30
        println(y);     // Prints 20
    }

    println(x);        // Prints 10
    // println(y);     // Error: y is not defined in this scope
}
```

### Constants

```raccoon
// Compile-time constants
const MAX_USERS = 1000;
const PI: float = 3.14159;
const APP_NAME = "Raccoon App";
const ENABLED = true;

// Compile-time evaluated expressions
const AREA = PI * (RADIUS * RADIUS);
const BUFFER_SIZE = 1024 * 4;
const CONFIG_PATH = "/etc/" + APP_NAME + "/config.json";
```

### Constants vs Immutable Variables

While both constants and immutable variables prevent changes to their values after initialization, they serve different purposes and have distinct behaviors:

- **Evaluation time**: Constants (`const`) are evaluated at compile time, while immutable variables (`var` without `mut`) are evaluated at runtime.
- **Use cases**: Constants are ideal for values known before program execution that never change (configuration settings, mathematical constants), whereas immutable variables can store the results of runtime calculations.
- **Expressions**: Constants can only use compile-time evaluable expressions, while immutable variables can use any runtime expressions or function calls.
- **Storage**: Constants typically don't consume runtime memory as they're embedded directly in the code, while variables always occupy memory space.
- **Scope and visibility**: Constants are often declared at module level with broader scope, while variables follow stricter scoping rules.
- **Type inference**: Both support type inference, but constants have more compile-time optimizations.

Using the appropriate choice between constants and immutable variables can improve both program clarity and performance.

### Type Inference

```raccoon
// Simple types
var number = 42;         // int
var float = 3.14;        // float
var text = "hello";      // string
var active = true;       // bool

// Complex types
var point = (10, 20);    // (int, int)
var items = [1, 2, 3];   // [int]
var map = {"a": 1, "b": 2};  // {string: int}

// Function types
var callback = (x: int) => x * 2;  // func(int): int
var handler = (name, age) => {
    println("${name} is ${age} years old");
};  // func(string, int): unit
```

### Value Semantics

Raccoon uses value semantics for assignment, meaning that values are copied by default when assigned to a new variable.

```raccoon
// Primitive types are copied
var a = 42;
var b = a;      // Copy of the value
a = 100;
println(b);     // Still 42

// Composite types are also copied
var original = [1, 2, 3];    // Immutable array
var copy = original;         // Creates an immutable copy of the array
println(original[0]);        // Still 1, not affected

// Mutation requires explicit mut
var mut mutable = [1, 2, 3];
mutable[0] = 99;             // Changes mutable
```

## Key Concepts

### Immutability by Default

Variables in Raccoon are immutable by default, meaning their values cannot be changed after initialization. This promotes safer, more predictable code.

```raccoon
var name = "Alice";
// name = "Bob";  // Error: cannot assign to immutable variable
```

### Explicit Mutability

When you need to change a variable's value, you must explicitly mark it as mutable using the `mut` keyword.

```raccoon
var mut counter = 0;
counter += 1;  // OK: counter is mutable
println(counter);  // 1
```

### Shadowing

Raccoon allows variable shadowing, where a new variable with the same name can be declared in an inner scope.

```raccoon
var value = "outer";
{
    var value = 42;  // Shadows the outer "value"
    println(value);  // Prints 42
}
println(value);  // Prints "outer"
```

### Destructuring

Variables can be declared through destructuring patterns:

```raccoon
// Tuple destructuring
var point = (10, 20, 30);
var (x, y, z) = point;

// Array destructuring
var [first, second, ...rest] = [1, 2, 3, 4, 5];

// Object destructuring
var user = {name: "Alice", age: 30};
var {name, age} = user;
```

## Design Rationale

Raccoon's approach to variables is influenced by modern languages while prioritizing safety and clarity:

- **Immutability by Default**: Similar to functional languages like Haskell and Rust's `let`, this encourages safer, more predictable code.
- **Explicit Mutability**: The `var mut <identifier>` syntax makes code changes more visible and follows a consistent pattern.
- **Type Inference**: Like TypeScript and Kotlin, Raccoon can infer types while maintaining static type safety.
- **Value Semantics**: Inspired by Swift, this makes code behavior more predictable by avoiding unintended side effects.

## Best Practices

1. **Prefer Immutability**: Use mutable variables only when necessary
2. **Use Explicit Types** for public APIs and when inference isn't clear
3. **Keep Variable Scope Small**: Declare variables close to where they're used
4. **Use Meaningful Names**: Clear, descriptive variable names improve readability
5. **Prefer Constants** for fixed values that won't change

## Edge Cases

1. **Shadowing**: Raccoon allows variable shadowing in nested scopes:
   ```raccoon
   var x = 10;
   {
       var x = 20;     // Shadows outer x
       println(x);     // Prints 20
   }
   println(x);         // Prints 10
   ```

2. **Lazy Initialization**: Variables must be initialized when declared, except in specific controlled contexts:
   ```raccoon
   // Error: variable must be initialized
   var mut value: int;

   // OK: initialized at declaration
   var mut initialized = computeValue();
   ```

3. **Partial Initialization in Blocks**:
   ```raccoon
   var result: string;
   if (condition) {
       result = "one";
   } else {
       result = "two";
   }
   // OK: compiler can verify result is definitely initialized
   ```

## Related Features

- [Types](types.md): Learn about the type system used with variables
- [Control Flow](control-flow.md): How variables interact with conditionals and loops
- [Memory Management](memory-management.md): How variables relate to memory and ownership

## Navigation

- **Previous**: [Types](types.md)
- **Next**: [Functions](functions.md)
- **Parent**: [Core Language](index.md#core-language)

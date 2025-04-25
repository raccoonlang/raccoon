# Functions

## Syntax

Functions in Raccoon are declared using the `func` keyword. Parameters are typed, and return types are specified after the parameter list.

```
// Basic syntax
func <name>(<param>: <type>, ...): <return_type> {
    <body>
}

// Function with no return value (returns unit type)
func <name>(<param>: <type>, ...) {
    <body>
}

// Async function
async func <name>(<param>: <type>, ...): <return_type> {
    <body>
}
```

## Examples

### Basic Functions

```raccoon
// Simple function with a return value
func add(a: int, b: int): int {
    return a + b;
}

// Function with no return value
func greet(name: string) {
    println("Hello, " + name);
}

// Function with multiple return values using tuples
func divideAndRemainder(dividend: int, divisor: int): (int, int) {
    return (dividend / divisor, dividend % divisor);
}
```

### Default Parameters and Named Arguments

```raccoon
// Function with default parameters
func createUser(name: string, age: int = 18, isActive: bool = true): User {
    return User(name, age, isActive);
}

// Using named arguments
var user = createUser(name: "Alice", isActive: false);
```

### Async Functions

```raccoon
// Async function for I/O operations
async func fetchUserData(userId: string): Result<UserData, Error> {
    var response = await httpClient.get("/users/" + userId);
    if (response.status == 200) {
        return Ok(response.parse<UserData>());
    } else {
        return Err(Error("Failed to fetch user: " + response.statusText));
    }
}

// Using an async function
func displayUserProfile(userId: string) {
    var userData = await fetchUserData(userId);
    match userData {
        Ok(data) => renderProfile(data),
        Err(error) => displayError(error)
    }
}
```

### Higher-Order Functions

```raccoon
// Function that takes a function as a parameter
func map<T, U>(items: [T], transform: func(T): U): [U] {
    var result: [U] = [];
    for (var item in items) {
        result.append(transform(item));
    }
    return result;
}

// Usage with lambda expression
var numbers = [1, 2, 3, 4, 5];
var squared = map(numbers, (n) => n * n); // short syntax
var squared = map(items: numbers, transform: (n) => n * n); // named parameters syntax
```

## Function Types

Functions are first-class values and can be assigned to variables:

```raccoon
// Function type
var calculator: func(int, int): int;

// Assigning a function
calculator = add;

// Calling a function through a variable
var result = calculator(5, 3);  // 8
```

## Pure Functions

Raccoon encourages pure functions (no side effects) and provides a `pure` annotation:

```raccoon
// Pure function annotation ensures no side effects
pure func multiply(a: int, b: int): int {
    return a * b;
}
```

## Design Rationale

Raccoon's function design aims to be familiar to developers from languages like TypeScript, Kotlin, and Go, while incorporating functional programming principles:

- **Clear Syntax**: Similar to Go and TypeScript for readability and familiarity
- **First-Class Functions**: Like JavaScript and Kotlin, functions are values
- **Async/Await**: Modern asynchronous programming model similar to JavaScript and Kotlin
- **Pure Functions**: Encourages functional style with explicit annotations
- **Multiple Return Values**: Practical feature from Go, implemented using tuples

## Edge Cases

1. **Function Overloading**: Raccoon does not support traditional function overloading. Instead, use default parameters and optional types:
   ```raccoon
   func process(data: string, options: Options? = null): Result<Data, Error> {
       // Implementation
   }
   ```

2. **Closures and Capturing**: Functions can capture variables from their enclosing scope:
   ```raccoon
   func makeCounter(): func(): int {
       mut count = 0;
       return () => {
           count += 1;
           return count;
       };
   }
   ```

3. **Generics**: Functions can be generic, with type parameters:
   ```raccoon
   func first<T>(items: [T]): T? {
       if (items.isEmpty()) {
           return null;
       }
       return items[0];
   }
   ```
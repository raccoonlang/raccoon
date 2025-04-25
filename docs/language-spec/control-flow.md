# Control Flow

Raccoon provides a rich set of control flow statements that are both familiar to developers from other languages and enhanced with functional programming patterns.

## Conditional Statements

### If-Else Statement

```raccoon
// Basic syntax
if (<condition>) {
    <statements>
} else if (<condition>) {
    <statements>
} else {
    <statements>
}
```

Example:

```raccoon
func checkTemperature(temp: float) {
    if (temp > 30.0) {
        println("It's hot outside");
    } else if (temp > 20.0) {
        println("It's pleasant outside");
    } else {
        println("It's cold outside");
    }
}
```

If statements can also be used as expressions:

```raccoon
var message = if (score > 90) {
    "Excellent!"
} else if (score > 70) {
    "Good job!"
} else {
    "Keep practicing!"
};
```

Ternary operator:

```raccoon
var message = (score > 90)
    ? "Excellent!"
    : (score > 70)
        ? "Good job!"
        : "Keep practicing!";
```

## Loops

### For Loop

```raccoon
// Collection iteration
for (var <item> in <collection>) {
    <statements>
}

// Range-based
for (var <item> in <start>..<end>) {
    <statements>
}

// Traditional three-part loop
for (var <init>; <condition>; <update>) {
    <statements>
}
```

Examples:

```raccoon
// Iterate over an array
var items = ["apple", "banana", "orange"];
for (var item in items) {
    println(item);
}

// Range-based iteration
for (var i in 1..5) {
    println(i);  // Prints 1, 2, 3, 4, 5
}

// Three-part loop
for (var i = 0; i < 5; i += 1) {
    println(i);  // Prints 0, 1, 2, 3, 4
}
```

### While Loop

```raccoon
// While loop
while (<condition>) {
    <statements>
}

// Do-while loop
do {
    <statements>
} while (<condition>);
```

Examples:

```raccoon
// Simple while loop
var mut count = 5;
while (count > 0) {
    println(count);
    count -= 1;
}

// Do-while loop
var mut number = 1;
do {
    println(number);
    number *= 2;
} while (number < 100);
```

## Pattern Matching

Pattern matching is a powerful feature in Raccoon for handling complex conditional logic in a concise and type-safe manner.

```raccoon
// Basic syntax
match <expression> {
    <pattern> => <expression>,
    <pattern> => {
        <statements>
    },
    _ => <default_expression>  // Wildcard pattern
}
```

### Matching on Types and Values

```raccoon
func describe(value: any): string {
    return match value {
        int => "an integer",
        float => "a floating-point number",
        string => "a string",
        bool => "a boolean",
        _ => "something else"
    };
}

func process(result: Result<int, Error>) {
    match result {
        Ok(value) => println("Success: " + value),
        Err(error) => println("Error: " + error.message)
    }
}
```

### Complex Pattern Matching with Guards

```raccoon
func gradeScore(score: int): string {
    return match score {
        90..100 => "A",
        80..89 => "B",
        70..79 => "C",
        60..69 => "D",
        0..59 => "F",
        _ => "Invalid score"
    };
}

func describe(point: Point) {
    match point {
        Point{x: 0, y: 0} => println("At origin"),
        Point{x, y} where x == y => println("On y=x line"),
        Point{x, y} where x == -y => println("On y=-x line"),
        Point{x, y} where x > 0 && y > 0 => println("In first quadrant"),
        _ => println("Somewhere else")
    }
}
```

### Destructuring in Pattern Matching

```raccoon
struct Person {
    name: string;
    age: int;
}

func processPerson(person: Person?) {
    match person {
        null => println("No person provided"),
        Person{name: "John", age} => println("Found John, age " + age),
        Person{name, age} where age < 18 => println(name + " is a minor"),
        Person{name, age} => println(name + " is " + age + " years old")
    }
}
```

## Flow Control Statements

### Break and Continue

```raccoon
// Breaking out of a loop
for (var mut i in 1..10) {
    if (i > 5) {
        break;  // Exit the loop
    }
    println(i);
}

// Skipping an iteration
for (var mut i in 1..10) {
    if (i % 2 == 0) {
        continue;  // Skip even numbers
    }
    println(i);  // Print odd numbers
}
```

### Return

```raccoon
func findIndex(items: [int], target: int): int? {
    for (var mut i = 0; i < items.length; i += 1) {
        if (items[i] == target) {
            return i;  // Early return when found
        }
    }
    return null;  // Not found
}
```

## Design Rationale

Raccoon's control flow design aims to be familiar to developers from mainstream languages while strongly emphasizing functional and declarative programming concepts:

- **Expressive If-Else**: Similar to Kotlin and Swift, with if as an expression
- **Declarative Collection Processing**: Prefers higher-order functions and comprehensions over imperative loops
- **Functional Composition**: Enables data transformation through function composition and pipelines
- **Pattern Matching**: Rust and Scala-inspired exhaustive pattern matching
- **Immutability by Default**: Reduces side effects and makes code easier to reason about
- **Laziness When Beneficial**: Supports lazy evaluation for better performance with infinite or large collections
- **No Switch Statement**: Replaced by more powerful pattern matching
- **No Goto**: Avoids unstructured control flow for code clarity

## Edge Cases

1. **Fallthrough in Pattern Matching**: Unlike switch statements in some languages, there is no implicit fallthrough in pattern matching:
   ```raccoon
   func describe(value: int) {
       match value {
           1 => println("One"),  // Only executes for value = 1
           2 => println("Two"),  // Only executes for value = 2
           _ => println("Other") // Executes for all other values
       }
   }
   ```

2. **Labeled Breaks**: For nested loops, labeled breaks can be used:
   ```raccoon
   outer: for (var i in 1..5) {
       for (var j in 1..5) {
           if (i * j > 10) {
               break outer;  // Breaks out of both loops
           }
           println(i * j);
       }
   }
   ```

3. **Exhaustiveness Checking**: The compiler ensures that pattern matching is exhaustive, requiring a wildcard or covering all possible patterns:
   ```raccoon
   func isPositive(n: int?): bool {
       return match n {
           null => false,
           n where n > 0 => true,
           _ => false
       };
       // Compiler error if the _ case was missing
   }
   ```

## Declarative Collection Operations

Raccoon emphasizes a declarative, functional approach to working with collections rather than imperative loops. These operations make code more concise, expressive, and less prone to errors.

### Collection Transformations

```raccoon
// Transforming collections with map
var numbers = [1, 2, 3, 4, 5];
var doubled = numbers.map(n => n * 2);  // [2, 4, 6, 8, 10]

// Filtering collections
var evens = numbers.filter(n => n % 2 == 0);  // [2, 4]

// Chaining operations
var sumOfSquaredEvens = numbers
    .filter(n => n % 2 == 0)
    .map(n => n * n)
    .reduce(0, (acc, n) => acc + n);  // 20 (4 + 16)
```

### Collection Comprehensions

Raccoon provides a concise syntax for collection transformations through method chaining rather than special comprehension syntax:

```raccoon
// Array transformation with map
var squares = [1..10].map(n => n * n);  // [1, 4, 9, ..., 100]

// With filtering
var evenSquares = [1..10]
    .filter(n => n % 2 == 0)
    .map(n => n * n);  // [4, 16, 36, 64, 100]

// Object creation from a collection
var usersByID = users.toMap(
    user => user.id,  // key selector
    user => user      // value selector
);

// Creating pairs with nested operations
var pairs = [1..3].flatMap(x =>
    ['a'..'c'].map(y => (x, y))
);  // [(1,'a'), (1,'b'), ...]
```

### Pipeline Operator

The pipeline operator `|>` enables clean, readable data transformation chains:

```raccoon
var result = data
    |> filter(predicate)
    |> map(transform)
    |> groupBy(key)
    |> sortBy(field);

// Equivalent to:
// var result = sortBy(groupBy(map(filter(data, predicate), transform), key), field);
```

### Collection Processing with Fold and Reduce

Raccoon provides two powerful functions for processing collections: `fold` and `reduce`. Both combine elements but serve different purposes and have different constraints.

#### Fold
```raccoon
// Signature: fold<T, U>(initial: U, fn: (acc: U, item: T) => U): U
// - T: Type of collection elements
// - U: Type of result (can be different from T)
// - initial: Starting value
// - fn: Function that combines accumulator (U) with each item (T)

// Basic number operations
var numbers = [1, 2, 3, 4];
var sum = numbers.fold(0, (acc, n) => acc + n);        // 10
var product = numbers.fold(1, (acc, n) => acc * n);    // 24

// String operations
var words = ["Hello", "World"];
var sentence = words.fold("", (acc, word) => acc + " " + word).trim();  // "Hello World"

// Type conversion
var numbers = [1, 2, 3, 4];
var formatted = numbers.fold("Numbers:", (acc, n) => acc + " " + n);  // "Numbers: 1 2 3 4"

// Safe with empty collections
var empty = [];
var sum = empty.fold(0, (acc, n) => acc + n);  // Returns 0 (initial value)
```

#### Reduce
```raccoon
// Signature: reduce<T>(fn: (acc: T, item: T) => T): T
// - T: Type of collection elements (same as return type)
// - fn: Function that combines accumulator (T) with each item (T)
// - First element is used as initial value

// Basic number operations
var numbers = [1, 2, 3, 4];
var sum = numbers.reduce((acc, n) => acc + n);      // 10
var max = numbers.reduce((acc, n) => acc > n ? acc : n);  // 4

// String operations (all elements must be strings)
var words = ["Hello", "beautiful", "world"];
var longest = words.reduce((acc, word) => acc.length > word.length ? acc : word);  // "beautiful"

// Error: Empty collections
var empty = [];
var sum = empty.reduce((acc, n) => acc + n);  // Runtime Error: Cannot reduce empty collection

// Error: Type conversion
var numbers = [1, 2, 3, 4];
// This won't compile - accumulator must be same type as elements
// var formatted = numbers.reduce((acc, n) => acc + " " + n);
```

#### When to Use Each

Use `fold` when you:
```raccoon
// 1. Need a different return type
var numbers = [1, 2, 3];
var asString = numbers.fold("", (acc, n) => acc + n);  // String from numbers

// 2. Need to handle empty collections
var maybeEmpty = [];
var sum = maybeEmpty.fold(0, (acc, n) => acc + n);  // Safe, returns 0

// 3. Need a specific initial value
var numbers = [1, 2, 3];
var withBase = numbers.fold(100, (acc, n) => acc + n);  // 106
```

Use `reduce` when you:
```raccoon
// 1. Want to use the first element as the starting point
var numbers = [1, 2, 3, 4];
var min = numbers.reduce((acc, n) => acc < n ? acc : n);  // 1

// 2. Are working with elements of the same type
var strings = ["a", "b", "c"];
var combined = strings.reduce((acc, s) => acc + s);  // "abc"

// 3. Know the collection isn't empty
var nonEmpty = [1, 2, 3];
var product = nonEmpty.reduce((acc, n) => acc * n);  // 6
```

#### Key Differences Summary

1. **Type Flexibility**
   - `fold`: Can return any type
   - `reduce`: Must return same type as elements

2. **Initial Value**
   - `fold`: Explicitly provided
   - `reduce`: Uses first element

3. **Empty Collections**
   - `fold`: Returns initial value
   - `reduce`: Runtime error

4. **Type Safety**
   - `fold`: Compiler enforces return type
   - `reduce`: Compiler enforces same type throughout
```

### FlatMap Operations

`flatMap` transforms each element into a collection and then flattens the results into a single collection.

Type signature:
```raccoon
flatMap<T, U>(fn: (T) => [U]): [U]
```

#### Basic Operations

```raccoon
// 1. Simple one-to-many transformation
var numbers = [1, 2, 3];
var doubled = numbers.flatMap(n => [n, n]);  // [1, 1, 2, 2, 3, 3]

// 2. Flattening nested arrays
var nested = [[1, 2], [3, 4], [5, 6]];
var flattened = nested.flatMap(arr => arr);  // [1, 2, 3, 4, 5, 6]

// 3. Transform and filter
var numbers = [1, 2, 3];
var evenDoubles = numbers.flatMap(n =>
    n % 2 == 0 ? [n * 2] : []
);  // [4]
```

#### Working with Optional Values

```raccoon
// Option type represents values that might be missing
var items = [
    Option.some(1),
    Option.none(),
    Option.some(3)
];
var values = items.flatMap(opt => opt.toArray());  // [1, 3]

// Result type for error handling
var results = [
    Result.ok(1),
    Result.err("failed"),
    Result.ok(3)
];
var successes = results.flatMap(result => result.toArray());  // [1, 3]
```

#### Data Transformations

```raccoon
// Simple data mapping
var data = [
    ("math", [90, 85, 95]),
    ("science", [88, 92, 85])
];

var summary = data.flatMap(subject =>
    subject.1.map(score =>
        subject.0 + ": " + score
    )
);  // ["math: 90", "math: 85", "math: 95", "science: 88", "science: 92", "science: 85"]

// Cartesian product with filtering
var xs = [1, 2, 3];
var ys = [1, 2, 3];
var pairs = xs.flatMap(x =>
    ys.map(y => (x, y))               // Create all possible pairs
    .filter(pair => pair.0 >= pair.1)  // Keep only pairs where x >= y
);  // [(1,1), (2,1), (2,2), (3,1), (3,2), (3,3)]
```

#### Working with Structured Data

```raccoon
// Database-like operations
var users = [
    User("alice", 1),
    User("bob", 2)
];

var posts = [
    Post(1, "Hello"),
    Post(1, "World"),
    Post(2, "Goodbye")
];

// Join users with their posts
var userPosts = users.flatMap(user =>
    posts
        .filter(post => post.userId == user.id)
        .map(post => (user.name, post.content))
);  // [("alice", "Hello"), ("alice", "World"), ("bob", "Goodbye")]

// Path combinations
var directories = ["home", "user"];
var files = ["config", "data"];
var paths = directories.flatMap(dir =>
    files.map(file => dir + "/" + file)
);  // ["home/config", "home/data", "user/config", "user/data"]
```

#### Advanced Use Cases

```raccoon
// Tree traversal
struct Node {
    value: int;
    children: [Node];
}

func flatten(node: Node): [int] {
    return [node.value].concat(
        node.children.flatMap(child => flatten(child))
    );
}

// URL parameter building
var params = [
    "color": ["red", "blue"],
    "size": ["S", "M", "L"]
];

func buildUrlParams(params: [string: [string]]): string {
    return params
        .flatMap((key, values) =>
            values.map(value =>
                key + "=" + String.urlEncode(value)
            )
        )
        .join("&");
}
// Result: "color=red&color=blue&size=S&size=M&size=L"
```

#### Key Points

1. Common Use Cases:
   - One-to-many transformations
   - Flattening nested structures
   - Filtering and transforming in one step
   - Working with optional values or results
   - Complex data transformations

2. Benefits:
   - Combines `map` and `flatten` operations efficiently
   - Makes code more readable for nested transformations
   - Handles null/empty cases elegantly
   - Enables complex data transformations in a functional style

3. Best Practices:
   - Use when transforming elements into variable-length collections
   - Prefer over nested loops for data transformations
   - Combine with `filter` and `map` for complex operations
   - Use with Option/Result types for clean error handling
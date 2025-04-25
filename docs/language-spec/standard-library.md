# Raccoon Standard Library

## Overview

The Raccoon standard library provides a comprehensive set of core types, functions, and modules to support application development. It emphasizes safety, performance, and clarity while keeping the API surface approachable.

## Core Types

### Basic Types

The standard library extends the built-in primitive types with additional functionality:

```raccoon
// String utilities
var s = "Hello, world!";
var upper = s.toUpperCase();        // "HELLO, WORLD!"
var replaced = s.replace(",", "");  // "Hello world!"
var sliced = s.slice(0, 5);         // "Hello"
var parts = s.split(", ");          // ["Hello", "world!"]

// Number utilities
var n = 42;
var isEven = n.isEven();            // true
var digits = n.toDigits();          // [4, 2]
var formatted = n.format("02d");    // "42"

// Parsing
var parsed = int.tryParse("42");    // Ok(42)
var invalid = float.tryParse("foo");// Err(ParseError)
```

### Option Type

Represents values that might be absent:

```raccoon
// Creating option values
var present: Option<int> = Some(42);
var absent: Option<int> = None();

// Pattern matching
match present {
    Some(value) => println("Got: ${value}"),
    None => println("Nothing")
}

// Transformations
var doubled = present.map(x => x * 2);           // Some(84)
var stringified = present.map(x => x.toString()); // Some("42")

// Chaining
var result = present
    .filter(x => x > 0)
    .map(x => x * 2)
    .unwrapOr(0);  // 84

// Converting to Result
var asResult = present.okOr("No value");  // Ok(42)
var absentResult = absent.okOr("No value"); // Err("No value")
```

### Result Type

Represents operations that might fail:

```raccoon
// Creating result values
var success: Result<int, string> = Ok(42);
var failure: Result<int, string> = Err("Something went wrong");

// Pattern matching
match success {
    Ok(value) => println("Success: ${value}"),
    Err(message) => println("Error: ${message}")
}

// Transformations
var doubled = success.map(x => x * 2);    // Ok(84)
var mappedErr = failure.mapErr(e => "Error: " + e);  // Err("Error: Something went wrong")

// Error handling
var unwrapped = success.unwrap();         // 42
var orDefault = failure.unwrapOr(0);      // 0
var orComputed = failure.unwrapOrElse(() => computeDefault());  // Computed value

// Chaining
func processResult(): Result<string, Error> {
    var x = getValue()?;  // Early return on error
    var y = processValue(x)?;  // Early return on error
    return Ok(formatValue(y));
}
```

## Collections

### Array

Dynamic, growable array collection:

```raccoon
// Creating arrays
var empty: [int] = [];
var numbers = [1, 2, 3, 4, 5];
var names = ["Alice", "Bob", "Charlie"];

// Accessing elements
var first = numbers[0];   // 1
var last = numbers[numbers.length - 1];  // 5

// Modifying arrays
var mut modified = numbers;
modified.append(6);       // [1, 2, 3, 4, 5, 6]
modified.insert(0, 0);    // [0, 1, 2, 3, 4, 5, 6]
modified.removeAt(3);     // [0, 1, 2, 4, 5, 6]

// Functional operations
var doubled = numbers.map(n => n * 2);  // [2, 4, 6, 8, 10]
var even = numbers.filter(n => n % 2 == 0);  // [2, 4]
var sum = numbers.reduce((acc, n) => acc + n);  // 15
```

### Map

Key-value collection:

```raccoon
// Creating maps
var empty: Map<string, int> = Map();
var scores = Map("Alice": 95, "Bob": 87, "Charlie": 92);

// Accessing elements
var aliceScore = scores["Alice"];  // 95
var hasKey = scores.containsKey("Dave");  // false

// Modifying maps
var mut modified = scores;
modified.insert("Dave", 78);  // Adds new entry
modified.remove("Bob");       // Removes entry
modified.update("Alice", 98); // Updates value

// Iterating
for (var (name, score) in scores) {
    println("${name}: ${score}");
}

// Transformations
var highScores = scores.filter((_, score) => score >= 90);
var namesByScore = scores.toMap(
    (name, _) => name,        // Key selector
    (_, score) => score       // Value selector
);
```

### Set

Collection of unique values:

```raccoon
// Creating sets
var empty: Set<string> = Set();
var colors = Set("red", "green", "blue");

// Querying
var hasRed = colors.contains("red");  // true
var count = colors.count();           // 3

// Modifying
var mut modified = colors;
modified.add("yellow");    // Adds if not present
modified.remove("green");  // Removes if present

// Set operations
var set1 = Set(1, 2, 3);
var set2 = Set(3, 4, 5);
var union = set1.union(set2);           // {1, 2, 3, 4, 5}
var intersection = set1.intersection(set2);  // {3}
var difference = set1.difference(set2);      // {1, 2}
```

## IO Operations

### File System

File system operations:

```raccoon
// Reading files
var content = File.readText("path/to/file.txt");
var bytes = File.readBytes("path/to/image.png");
var lines = File.readLines("path/to/data.csv");

// Writing files
File.writeText("path/to/output.txt", "Hello, world!");
File.writeBytes("path/to/output.bin", bytes);
File.writeLines("path/to/output.csv", lines);

// File information
var exists = File.exists("path/to/file.txt");
var size = File.size("path/to/file.txt");
var modified = File.lastModified("path/to/file.txt");

// File operations
File.copy("source.txt", "destination.txt");
File.move("old.txt", "new.txt");
File.delete("temp.txt");
```

### Console IO

Command-line input and output:

```raccoon
// Output
println("Hello, world!");
print("Enter your name: ");

// Formatted output
println("Name: ${name}, Age: ${age}");
println("Pi: ${pi:.2f}");  // With format

// Input
var name = readLine();
var number = readInt();
var confirmed = readBoolean();

// Error output
eprintln("Error: ${errorMessage}");
```

## Concurrency

### Tasks

High-level task management:

```raccoon
// Creating and running a task
var task = Task.run(() => {
    // Long-running operation
    return computeResult();
});

// Checking status
var isComplete = task.isComplete();
var isFailed = task.isFailed();

// Getting the result
var result = task.await();  // Waits if necessary
var tryResult = task.tryGet();  // Returns immediately, might be None

// Cancellation
task.cancel();
var isCancelled = task.isCancelled();

// Task composition
var combined = Task.all([task1, task2, task3]);  // Completes when all complete
var raceResult = Task.race([task1, task2]);      // Completes when first completes
```

### Channels

Thread communication:

```raccoon
// Creating channels
var channel = Channel<string>();
var boundedChannel = Channel<int>(capacity: 10);

// Sending and receiving
channel.send("Hello");  // Might block if unbuffered
var message = channel.receive();  // Blocks until message available
var tryReceive = channel.tryReceive();  // Non-blocking, returns Option

// Multiple channels
var selected = Channel.select([
    channel1, channel2, channel3
]);
var message = selected.receive();
var index = selected.index;  // Which channel had data

// Closing and status
channel.close();
var isClosed = channel.isClosed();
var isEmpty = channel.isEmpty();
```

## Networking

### HTTP Client

HTTP requests:

```raccoon
// Simple requests
var response = Http.get("https://api.example.com/data");
var postResponse = Http.post(
    "https://api.example.com/submit",
    body: "key=value"
);

// Request customization
var request = HttpRequest("https://api.example.com/users")
    .method("POST")
    .header("Content-Type", "application/json")
    .body(jsonString);

var response = Http.send(request);

// Response handling
var statusCode = response.status;
var headers = response.headers;
var content = response.text();
var jsonData = response.json();
var binaryData = response.bytes();
```

## Time and Date

Date and time handling:

```raccoon
// Current time
var now = DateTime.now();
var utcNow = DateTime.utc();

// Creating dates
var date = DateTime(2023, 5, 15, 10, 30, 0);
var fromString = DateTime.parse("2023-05-15T10:30:00Z");

// Formatting
var formatted = date.format("yyyy-MM-dd");

// Date arithmetic
var tomorrow = now.addDays(1);
var nextMonth = now.addMonths(1);
var duration = date.durationSince(now);

// Time components
var year = date.year;
var month = date.month;
var day = date.day;
var hour = date.hour;
var minute = date.minute;
```

## Navigation

- **Previous**: [Build and Deploy](compilation.md)
- **Next**: *(Coming Soon)*
- **Parent**: [Language Specification](index.md)
# Error Handling

## Overview

Raccoon uses a Result type for error handling rather than exceptions. This approach:
- Makes error paths explicit
- Ensures errors are handled at compile time
- Provides better performance than exceptions
- Enables functional-style error handling

## Result Type

### Basic Usage

```raccoon
// Define a Result type
type Result<T, E> {
    // Internal implementation
}

// Create success value
func Ok<T, E>(value: T): Result<T, E> {
    // Implementation
}

// Create error value
func Err<T, E>(error: E): Result<T, E> {
    // Implementation
}

// Example usage
func divide(a: float, b: float): Result<float, string> {
    if (b == 0.0) {
        return Err("Division by zero");
    }
    return Ok(a / b);
}

// Using the result
var result = divide(10.0, 2.0);
if (result.isOk()) {
    println("Result: " + result.unwrap());
} else {
    println("Error: " + result.unwrapErr());
}
```

### Result Methods

```raccoon
// Check result state
var isSuccess = result.isOk();
var isError = result.isErr();

// Get values (panics if wrong state)
var value = result.unwrap();
var error = result.unwrapErr();

// Get values with defaults
var value = result.unwrapOr(defaultValue);
var value = result.unwrapOrElse(() => computeDefault());

// Transform values
var mapped = result.map(value => value * 2);
var mappedErr = result.mapErr(err => CustomError(err));

// Chain operations
var chained = result.andThen(value => processValue(value));
var orElse = result.orElse(err => recoverFromError(err));
```

### Error Propagation

The `?` operator provides convenient error propagation:

```raccoon
func processData(): Result<Data, Error> {
    var file = openFile("data.txt")?;
    var content = file.readToString()?;
    var parsed = parseJson(content)?;
    return Ok(parsed);
}
```

This is equivalent to:

```raccoon
func processData(): Result<Data, Error> {
    var fileResult = openFile("data.txt");
    if (fileResult.isErr()) {
        return Err(fileResult.unwrapErr());
    }
    var file = fileResult.unwrap();

    var contentResult = file.readToString();
    if (contentResult.isErr()) {
        return Err(contentResult.unwrapErr());
    }
    var content = contentResult.unwrap();

    var parsedResult = parseJson(content);
    if (parsedResult.isErr()) {
        return Err(parsedResult.unwrapErr());
    }
    var parsed = parsedResult.unwrap();

    return Ok(parsed);
}
```

### Error Types

```raccoon
// Define custom error type
struct NetworkError {
    code: int;
    message: string;

    init(code: int, message: string) {
        this.code = code;
        this.message = message;
    }
}

// Error type composition
type AppError = NetworkError | DatabaseError | ValidationError;

// Function returning composed error
func fetchData(): Result<Data, AppError> {
    // Can return any of the error types
}
```

### Error Context

```raccoon
// Add context to errors
struct ErrorContext<E> {
    error: E;
    context: string;
    stackTrace: StackTrace;

    init(error: E, context: string) {
        this.error = error;
        this.context = context;
        this.stackTrace = StackTrace.capture();
    }
}

// Usage
func process(): Result<Data, ErrorContext<AppError>> {
    return fetchData()
        .mapErr(err => ErrorContext(err, "Failed to fetch data"));
}
```

## Pattern Matching

Results can be handled with pattern matching:

```raccoon
match result {
    Ok(value) => {
        // Handle success
        processValue(value);
    }
    Err(NetworkError{code: 404}) => {
        // Handle specific error
        handleNotFound();
    }
    Err(err) => {
        // Handle other errors
        logError(err);
    }
}
```

## Async Error Handling

```raccoon
// Async function with error handling
async func fetchData(): Result<Data, NetworkError> {
    try {
        var response = await http.get(url)?;
        var data = await response.json()?;
        return Ok(data);
    } catch (e: NetworkError) {
        return Err(e);
    }
}

// Using async results
async func process() {
    match await fetchData() {
        Ok(data) => {
            await processData(data);
        }
        Err(err) => {
            await handleError(err);
        }
    }
}
```

## Error Conversion

```raccoon
// Convert between error types
trait Into<T> {
    func into(): T;
}

// Implement conversion
impl Into<AppError> for NetworkError {
    func into(): AppError {
        return AppError.fromNetwork(this);
    }
}

// Use conversion
func fetch(): Result<Data, NetworkError> {
    // Implementation
}

func process(): Result<Data, AppError> {
    return fetch().mapErr(err => err.into());
}
```

## Best Practices

1. Use Specific Error Types
   ```raccoon
   // Good
   func validate(data: Data): Result<ValidData, ValidationError>

   // Avoid
   func validate(data: Data): Result<ValidData, string>
   ```

2. Provide Context
   ```raccoon
   // Good
   return Err(NetworkError(404, "User profile not found"));

   // Avoid
   return Err("Failed");
   ```

3. Handle All Cases
   ```raccoon
   // Good
   match result {
       Ok(value) => handleSuccess(value),
       Err(NetworkError) => handleNetwork(err),
       Err(ValidationError) => handleValidation(err),
       Err(err) => handleUnknown(err)
   }
   ```

4. Use Type System
   ```raccoon
   // Good
   type UserError = NotFoundError | ValidationError | PermissionError;

   // Avoid
   type UserError = string;
   ```

5. Chain Operations Safely
   ```raccoon
   // Good
   return getData()
       .andThen(validate)
       .andThen(process)
       .mapErr(addContext);
   ```

## Testing

```raccoon
test "division by zero returns error" {
    var result = divide(10.0, 0.0);
    assert(result.isErr());
    assert(result.unwrapErr() == "Division by zero");
}

test "successful division works" {
    var result = divide(10.0, 2.0);
    assert(result.isOk());
    assert(result.unwrap() == 5.0);
}
```
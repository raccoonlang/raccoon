# Collection Processing

Raccoon provides a powerful, integrated system for working with collections following functional programming principles. The focus is on readability, composability, and type safety.

## Method Chaining

The primary way to work with collections in Raccoon is through method chaining, which makes data flow clear and explicit:

```raccoon
// Basic method chaining
var results = collection
    .filter(item => item.isActive)
    .map(item => item.name);
```

## Standard Collection Operators

### Filtering

```raccoon
// Filter - keep elements that match a predicate
var activeUsers = users.filter(user => user.isActive && user.age > 18);

// Take/Skip - pagination
var pagedResults = items.skip(page * pageSize).take(pageSize);

// Distinct - remove duplicates
var uniqueCountries = users.map(user => user.country).distinct();
```

### Transformation

```raccoon
// Map - transform elements
var userNames = users.map(user => user.name);

// FlatMap - flatten nested collections
var allTags = posts.flatMap(post => post.tags);

// Transform to structured data
var summaries = users.map(user => {
    name: user.name,
    age: user.age,
    isAdult: user.age >= 18
});
```

### Sorting

```raccoon
// Sort - order elements
var sortedUsers = users.sortBy(user => user.lastName);

// Multiple sort criteria
var complexSort = users
    .sortBy(user => user.lastName)
    .thenBy(user => user.firstName)
    .thenByDescending(user => user.age);
```

### Grouping

```raccoon
// Group - organize elements by key
var usersByCountry = users.groupBy(user => user.country);

// Processing groups
var countryCounts = users
    .groupBy(user => user.country)
    .map(group => {
        country: group.key,
        count: group.count()
    });
```

### Joining

```raccoon
// Join - combine collections
var results = users.join(
    orders,
    user => user.id,
    order => order.userId,
    (user, order) => {
        userName: user.name,
        orderDate: order.date,
        amount: order.amount
    }
);

// Left join
var usersWithOrders = users.leftJoin(
    orders,
    user => user.id,
    order => order.userId,
    (user, matchingOrders) => {
        user: user,
        orders: matchingOrders
    }
);
```

### Aggregation

```raccoon
// Built-in aggregation operators
var stats = {
    count: users.count(),
    totalAge: users.sumBy(user => user.age),
    averageAge: users.averageBy(user => user.age),
    minAge: users.minBy(user => user.age),
    maxAge: users.maxBy(user => user.age)
};

// Aggregation with grouping
var countryStats = users
    .groupBy(user => user.country)
    .map(group => {
        country: group.key,
        userCount: group.count(),
        averageAge: group.averageBy(user => user.age)
    });
```

## Array Literals with Mapping

Raccoon provides a concise syntax for array creation with mapping:

```raccoon
// Explicit mapping function in array creation
var squares = [1..10].map(n => n * n);

// With filtering
var evenSquares = [1..10].filter(n => n % 2 == 0).map(n => n * n);
```

## Lazy Evaluation

Raccoon's collection operations use lazy evaluation for efficiency. Operations are not executed until the results are actually needed:

```raccoon
// Query definition - not yet executed
var query = users
    .filter(user => user.age > 30)
    .sortBy(user => user.lastName)
    .map(user => user.name);

// Execution happens here
var names = query.toArray();

// Or during iteration
for (var name in query) {
    println(name);
}
```

This allows working with potentially infinite sequences and optimizes performance by only computing what's needed.

## Collection Adapters

The collection system works with different data sources through adapters:

```raccoon
// In-memory collections
var results = users
    .filter(user => user.isActive)
    .map(user => user.name);

// Database queries (automatically translated to SQL)
var results = db.users
    .filter(user => user.lastLogin > DateTime.now().minusDays(30))
    .toArray();

// Remote APIs (translated to API calls)
var results = api.products
    .filter(product => product.inStock && product.price < 100)
    .toArray();
```

## Type Safety and Inference

All collection operations are strongly typed, with the compiler inferring result types:

```raccoon
// Compiler knows this is [string]
var names = users.map(user => user.name);

// Compiler knows this is [{country: string, count: int}]
var stats = users
    .groupBy(user => user.country)
    .map(group => {
        country: group.key,
        count: group.count()
    });
```

## Integration with Pattern Matching

Collection operations integrate with pattern matching for powerful data processing:

```raccoon
var results = collection.map(item => match item {
    User(name, _) => "User: " + name,
    Product(name, price) => "Product: " + name + " ($" + price + ")",
    _ => "Unknown item"
});
```

## Performance Optimizations

The collection system includes several optimizations:

1. **Operation fusion**: Multiple operations are combined into efficient single passes
2. **Deferred execution**: Only the required elements are processed
3. **Short-circuit evaluation**: Early termination for operations like `first()`, `any()`
4. **Specialized implementations**: Optimized paths for common collection types

## Design Rationale

Raccoon's collection processing system draws inspiration from several sources:

- **Kotlin Sequences/Collections**: Consistent method naming and chaining
- **Rust Iterators**: Zero-cost abstractions and performance focus
- **Swift Sequences**: Clear, type-safe transformations
- **JavaScript Arrays**: Familiar functional methods

The design prioritizes:
- **Consistency**: All operations follow the same pattern and naming conventions
- **Readability**: Data flow is explicit and follows left-to-right reading order
- **Performance**: Lazy evaluation and optimizations happen behind the scenes
- **Composability**: Operations can be easily combined and reused

## Edge Cases

1. **Capture semantics**: Variables captured in lambdas follow Raccoon's normal closure rules:
   ```raccoon
   var threshold = 18;
   var adults = users.filter(user => user.age > threshold);  // Captures threshold by value
   ```

2. **Operation reuse**: Operations can be extracted and reused:
   ```raccoon
   func activeItems<T>(items: [T], isActive: func(T): bool): [T] {
       return items.filter(isActive);
   }
   ```

3. **Infinite sequences**: Care must be taken with infinite sequences:
   ```raccoon
   var natural = sequence(1, n => n + 1);

   // OK: Takes only what's needed
   var first10 = natural.take(10).toArray();

   // Error: Would never complete
   // var all = natural.toArray();
   ```

4. **Adapter-specific limitations**: Some operations may not be available for all adapters:
   ```raccoon
   // May not be translatable to SQL
   var results = db.users
       .filter(user => complexLocalFunction(user.data))
       .toArray();
   ```
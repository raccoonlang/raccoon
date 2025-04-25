# Concurrency

## Overview

Concurrency in Raccoon is designed to be powerful yet approachable. It allows your program to handle multiple tasks simultaneously without the complexity of traditional threading models. This is achieved through green threads (lightweight threads managed by Raccoon), async/await for handling non-blocking operations, and channels for safe communication between concurrent tasks.

## Green Threads

Green threads are lightweight threads managed by Raccoon's runtime rather than the operating system. Unlike OS threads which are heavy and limited in number, you can create thousands of green threads with minimal overhead. When a green thread would normally block (for example, waiting for I/O), Raccoon's runtime automatically switches to another thread, ensuring efficient use of system resources.

```raccoon
// Spawn a new green thread
spawn {
    // Code runs concurrently
    println("Hello from green thread!");
}

// Named function in a green thread
func background() {
    // Background processing
}

spawn background();

// Spawn with parameters
spawn (data: [int]) {
    processData(data);
}
```

### Thread Management

Thread management in Raccoon provides tools to control and monitor green threads. Each green thread has a unique ID and can be controlled through priority settings. The runtime automatically schedules threads based on their priority and state (running, sleeping, or waiting for I/O).

```raccoon
// Get current green thread ID
var id = Thread.current().id();

// Sleep current green thread
Thread.sleep(Duration.fromMillis(100));

// Set green thread priority
Thread.current().setPriority(Priority.High);

// Check if green thread is alive
var isAlive = Thread.current().isAlive();

// Wait for a green thread to complete
var thread = spawn background();
thread.join();

// Get green thread status
var status = thread.status();  // Returns: Running, Sleeping, Completed, or Failed
```

## Async/Await

Async/await is a pattern that makes it easier to write code that performs long-running operations without blocking. When you mark a function as `async`, it can use `await` to pause execution while waiting for operations to complete, allowing other code to run in the meantime. This is particularly useful for operations like network requests, file I/O, or any task that involves waiting.

```raccoon
// Basic async function
async func fetchData(url: string): Result<string, Error> {
    var response = await http.get(url);
    return response.text();
}

// Multiple awaits
async func processUrls(urls: [string]): [string] {
    var results: [string] = [];
    for (var url in urls) {
        var data = await fetchData(url);
        if (data.isOk()) {
            results.append(data.unwrap());
        }
    }
    return results;
}

// Parallel execution
async func parallel() {
    var [result1, result2] = await parallel([
        fetchData(url1),
        fetchData(url2)
    ]);
}
```

### Error Handling

Error handling in async code follows Raccoon's Result type pattern. When async operations fail, they return errors as part of the Result type rather than throwing exceptions. This makes error handling explicit and ensures you consider error cases in your concurrent code.

```raccoon
// Function that returns a Result type
async func fetchData(url: string): Result<string, NetworkError> {
    // If any error occurs, automatically returns Err(NetworkError)
    var response = await http.get(url);
    return Ok(response.text());
}

// Using Result types with async/await
async func example(): Result<Data, Error> {
    // When calling a function that returns Result, we must either:
    // 1. Use 'try' keyword to handle potential errors
    // 2. Return a Result type ourselves

    // Using try keyword - compiler enforces error handling
    var response = try await fetchData(url);
    var processed = try await processData(response);

    return Ok(processed);
}

// Example of compiler enforcing Result type
async func badExample() {
    var response = await fetchData(url);  // Compiler Error: Function returns Result<string, NetworkError>.
                                         // Use 'try' keyword or change return type to Result
}

// Handling different error types
async func complexExample(): Result<Data, ProcessError> {
    // Using pattern matching with Result
    var response = try await fetchData(url);

    match try await processData(response) {
        Ok(data) => return Ok(data),
        Err(ProcessError.InvalidFormat) => return Err(ProcessError.InvalidData),
        Err(ProcessError.Timeout) => return Err(ProcessError.ServiceUnavailable)
    }
}

// Working with multiple Results
async func multipleResults(): Result<Data, Error> {
    var results = await parallel([
        fetchData(url1),  // Returns Result<string, NetworkError>
        fetchData(url2)   // Returns Result<string, NetworkError>
    ]);

    // Pattern matching on multiple results
    match results {
        [Ok(data1), Ok(data2)] => {
            var combined = try combineData(data1, data2);
            return Ok(combined);
        },
        _ => return Err(Error.PartialFailure)
    }
}
```

## Channels

Channels provide a safe way for different parts of your program to communicate and share data. Think of a channel as a pipe where one part of your program can send messages and another part can receive them. Channels ensure that data is safely transferred between green threads without the need for explicit locking or shared memory.

```raccoon
// Create a bounded channel
var channel = Channel<int>.new(capacity: 10);

// Blocking operations - will block the current green thread until complete
channel.send(42);              // Blocks if channel is full
var value = channel.receive(); // Blocks if channel is empty

// Non-blocking operations - return Result type immediately
var sendResult = channel.trySend(42);      // Returns Ok(()) if sent, Err(SendError) if full
var receiveResult = channel.tryReceive();  // Returns Ok(value) if received, Err(ReceiveError) if empty

// Usage in async context
async func example() {
    // In async context, blocking operations don't block the OS thread
    // They only block the current green thread
    await channel.send(42);
    var value = await channel.receive();

    // Non-blocking operations can be used directly
    var result = channel.trySend(42);
    match result {
        Ok(_) => println("Sent successfully"),
        Err(e) => println("Channel full: " + e)
    }
}
```

### Multiple Channel Operations

When working with multiple channels, you often need to handle data from whichever channel has something ready first. The `Channel.await` function provides a clean way to wait for any channel to have data available, with built-in support for timeouts to prevent infinite waiting.

```raccoon
// Channel.await allows handling multiple channel operations
async func example() {
    var c1 = Channel<string>.new(1);
    var c2 = Channel<int>.new(1);

    // Wait for any channel to have data, with timeout
    var result = await Channel.await([
        c1,                      // Channel<string>
        c2,                      // Channel<int>
        Duration.fromSeconds(1)  // Timeout
    ]);

    // Pattern match on the result
    match result {
        Channel.at(0, value) => println("Got string: " + value),
        Channel.at(1, value) => println("Got number: " + value),
        Channel.timeout => println("Operation timed out")
    }
}

// More complex example with different channel types
async func processMessages(
    commands: Channel<Command>,
    events: Channel<Event>,
    timeout: Duration
): Result<void, Error> {
    loop {
        var result = await Channel.await([
            commands,  // Channel<Command>
            events,   // Channel<Event>
            timeout
        ]);

        match result {
            Channel.at(0, cmd) => {
                try processCommand(cmd);
            },
            Channel.at(1, evt) => {
                try processEvent(evt);
            },
            Channel.timeout => {
                return Ok(());  // Clean timeout
            }
        }
    }
}
```

The `Channel.await` function:
- Takes an array of channels and optional timeout
- Returns a pattern-matchable result with `Channel.at(index, value)` for received values
- Uses `Channel.timeout` for timeout cases
- Automatically handles channel closing and errors
- Works seamlessly with async/await
- Supports timeouts as a first-class concept

## Thread-Safe Data Structures

Thread-safe data structures are special collections and types that can be safely shared between multiple green threads without causing data races or corruption. These structures handle synchronization internally, making it easier to write correct concurrent code.

### Atomic Types

Atomic types provide a way to perform simple operations that are guaranteed to happen as a single, uninterruptible action. This is essential for building thread-safe counters, flags, and other shared state. Unlike regular variables, atomic operations never show partial updates to other threads.

```raccoon
// Create atomic values
var counter = Atomic<int>.new(0);
var flag = Atomic<bool>.new(false);

// Basic operations
counter.store(42);              // Set value
var value = counter.load();     // Get value
counter.add(10);               // Add value atomically
counter.subtract(5);           // Subtract value atomically

// Increment/Decrement
counter.increment();           // Atomic += 1
counter.decrement();          // Atomic -= 1

// Compare and swap - atomic update only if value matches expected
var didUpdate = counter.compareAndSwap(
    expected: 47,  // Only swap if current value is 47
    new: 100       // New value to set
);

// Example: Thread-safe flag for coordination
spawn {
    // Do some work...
    flag.store(true);  // Signal completion
};

spawn {
    // Wait for flag to be set
    while (!flag.load()) {
        Thread.sleep(Duration.fromMillis(10));
    }
    println("Work completed!");
};
```

### Concurrent Collections

Concurrent collections are data structures specifically designed for use across multiple green threads. They handle internal synchronization automatically, making them safe to use in concurrent code without explicit locking. Each collection type is optimized for different use cases.

```raccoon
// Thread-safe hash map
var cache = ConcurrentMap<string, int>.new();

// Multiple threads can safely modify the map
spawn {
    cache.insert("counter", 1);
    cache.update("counter", value => value + 1);
};

spawn {
    if (var value = cache.get("counter")) {
        println("Counter: " + value);
    }
};

// Lock-free queue - great for work distribution
var workQueue = LockFreeQueue<Task>.new();

// Producer thread
spawn {
    for (var i in 1..100) {
        workQueue.enqueue(Task.new(i));
    }
};

// Consumer threads
for (var _ in 1..3) {  // Create 3 worker threads
    spawn {
        while (var task = workQueue.tryDequeue()) {
            processTask(task);
        }
    }
};

// Concurrent set with atomic operations
var activeUsers = ConcurrentSet<UserId>.new();

spawn {
    // Add/remove users safely from multiple threads
    activeUsers.add(user1);
    activeUsers.remove(user2);
};

spawn {
    // Safe to iterate while other threads modify
    for (var userId in activeUsers) {
        updateUserStatus(userId);
    }
};

// Thread-safe priority queue
var jobQueue = ConcurrentPriorityQueue<Job>.new();

// Multiple producers
spawn {
    jobQueue.enqueue(Job.new("high", priority: 1));
    jobQueue.enqueue(Job.new("low", priority: 5));
};

// Multiple consumers - always get highest priority job
spawn {
    while (var job = jobQueue.tryDequeue()) {
        executeJob(job);
    }
};
```

These thread-safe data structures follow these key principles:
- No external locking required
- Operations are atomic and consistent
- Designed for high concurrency
- Optimized for specific use cases
- Safe iteration during concurrent modifications
- Clear failure modes (e.g., `tryDequeue` returns null when empty)

## Synchronization Primitives

Synchronization primitives are tools for coordinating between multiple green threads. While channels are often the preferred way to communicate, sometimes you need lower-level control over concurrent access to shared resources.

### Mutex

A Mutex (mutual exclusion) ensures that only one green thread can access protected data at a time. It's like a lock on a bathroom door - only one person can enter at a time, and others must wait their turn.

```raccoon
// Create a mutex
var mutex = Mutex<Data>.new(initialData);

// Lock and access
{
    var data = mutex.lock();
    // Data access is protected
    data.update();
} // Automatically unlocked

// Try lock
if (var data = mutex.tryLock()) {
    // Lock acquired
    data.update();
}
```

### ReadWriteLock

A ReadWriteLock (read-write lock) allows multiple readers to access data simultaneously, but ensures exclusive access for writers. This is useful when data is read frequently but written to infrequently.

```raccoon
// Create read-write lock
var lock = ReadWriteLock<Data>.new(initialData);

// Read access
{
    var data = lock.read();
    // Multiple readers allowed
    use(data);
}

// Write access
{
    var data = lock.write();
    // Exclusive access
    data.modify();
}
```

### Semaphore

A semaphore controls access to a limited resource by maintaining a count of available permits. It's like a parking lot with a fixed number of spaces - only a certain number of cars can enter at once.

```raccoon
// Create semaphore
var sem = Semaphore.new(permits: 3);

// Acquire permit
sem.acquire();
try {
    // Limited concurrent access
} finally {
    sem.release();
}
```

## Memory Model

The memory model defines how different threads see changes to shared memory. Understanding this is crucial for writing correct concurrent code, especially when working with atomic operations and synchronization primitives.

### Happens-Before Relationships

Happens-before relationships guarantee that memory operations in one thread are visible to another thread in a predictable order. This ensures that when you modify data in one thread, other threads see those modifications in a consistent way.

```raccoon
// Sequential consistency for atomic operations
var flag = Atomic<bool>.new(false);
var data = 0;

spawn {
    data = 42;
    flag.store(true);
}

spawn {
    if (flag.load()) {
        // Guaranteed to see data = 42
        println(data);
    }
}
```

### Memory Fences

Memory fences provide explicit control over memory operation ordering. While most code doesn't need to use fences directly, they're essential for implementing low-level synchronization primitives and ensuring memory consistency in performance-critical code.

```raccoon
// Full memory fence
Fence.full();

// Acquire fence
Fence.acquire();

// Release fence
Fence.release();
```

## Configuration

Runtime configuration allows you to tune how Raccoon manages concurrency for your specific needs. This includes controlling the number of worker threads, stack sizes, and scheduling strategies.

```raccoon
Runtime.configure({
    workerThreads: 4,
    stackSize: 2 * MB,
    schedulerType: "work-stealing",
    maxBlockingThreads: 32,
    ioThreads: 2
});
```
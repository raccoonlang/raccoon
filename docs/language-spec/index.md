# Raccoon Programming Language - Language Specification

*Version: 0.1.0 (Draft)*

This document describes the syntax, semantics, and standard library of the Raccoon programming language.

## Learning Path

Raccoon's documentation is organized to provide both progressive learning and quick reference:

1. **Beginner Path**: New to Raccoon? Start with the **[Core Language](#core-language)** section, then move to **[Error Handling](#error-handling)**.
2. **Reference Path**: Looking for specific features? Use the **[Table of Contents](#table-of-contents)** to jump directly to relevant sections.
3. **Advanced Path**: Ready for deeper concepts? Explore **[Memory Management](#memory-management)** and **[Concurrency](#concurrency)**.

## Table of Contents

1. [Introduction](#introduction)
2. [Core Language](#core-language)
   - [Types](types.md) - Type system, primitives, structs, interfaces, tuples
   - [Variables](variables.md) - Declaration, mutability, value semantics
   - [Functions](functions.md) - Declaration, parameters, return values, closures
   - [Control Flow](control-flow.md) - Conditionals, loops, pattern matching
   - [Collections](collections-query.md) - Array operations, functional transformations
3. [Error Handling](#error-handling)
   - [Result Type](error-handling.md) - Error propagation, matching, context
4. [Memory Management](#memory-management)
   - [Value Semantics](memory-management.md#value-semantics) - Copying, performance
   - [Ownership](memory-management.md#ownership) - Transfer, borrowing
   - [Resource Management](memory-management.md#scope-based-resource-management) - Automatic cleanup
   - [GC-Free Mode](memory-management.md#gc-free-mode) - Restrictions and patterns
5. [Concurrency](#concurrency)
   - [Green Threads](concurrency.md#green-threads) - Lightweight threading
   - [Async/Await](concurrency.md#async-await) - Non-blocking operations
   - [Channels](concurrency.md#channels) - Message passing
   - [Thread-Safe Types](concurrency.md#thread-safe-data-structures) - Atomics, concurrent collections
6. [Code Organization](#code-organization)
   - [Modules](packages.md#package-system) - Visibility, imports
   - [Packages](packages.md#package-management) - Declaration, structure
7. [Build and Deploy](#build-and-deploy)
   - [Compilation Options](compilation.md#optimization) - Optimization levels
   - [Distribution](compilation.md#distribution) - Output types, runtime options
   - [Cross-Platform](compilation.md#platform-support) - Target platforms
8. [Standard Library](#standard-library) *(Coming Soon)*
   - Core Types
   - IO Operations
   - Collections
   - Networking
9. [Tooling](#tooling) *(Coming Soon)*
   - IDE Support
   - Debugging
   - Testing

## Introduction

Raccoon is a statically-typed, compiled programming language designed for modern software development. It combines intuitive syntax with advanced memory management and built-in concurrency features.

### Key Features

- **Clean, Approachable Syntax**: Inspired by Kotlin, TypeScript, and Go
- **Immutability by Default**: With explicit mutability markers
- **Value Semantics**: Makes code behavior more predictable
- **Modern Concurrency**: Green threads and async/await built-in
- **Result Type**: For safe, explicit error handling
- **Interface-Based Design**: Composition over inheritance
- **Hybrid Memory Management**: Combining ownership, scope-based management
- **Dual Compilation**: AOT and optional JIT support

### Design Principles

Raccoon follows these core principles:
1. **Clarity Over Brevity**: Code is read more often than written
2. **Explicit Over Implicit**: Behaviors should be obvious from the code
3. **Composition Over Inheritance**: Build complex behavior from simple parts
4. **Safety By Default**: Make the easy path the safe path
5. **Performance Without Complexity**: High performance should not require obscure code
6. **Functional Patterns**: Functional programming without excessive jargon

## Core Language

The core language features provide the foundation for Raccoon development:

### Types

Raccoon provides [a rich type system](types.md) with primitives, composites, and user-defined types:

- **Primitive Types**: `int`, `float`, `number`, `bool`, `char`, `string`, `unit`
- **Composite Types**: Arrays, tuples, options, results
- **User-Defined Types**: Structs and interfaces
- **Type Inference**: Write less, get full type safety

[Learn more about Raccoon's type system →](types.md)

### Variables

[Variables in Raccoon](variables.md) are immutable by default, with explicit mutability:

- **Immutability**: `var x = 42`
- **Explicit Mutability**: `var mut y = 10`
- **Type Annotations**: `var z: float = 3.14`
- **Value Semantics**: Clear copying behavior

[Learn more about variables →](variables.md)

### Functions

[Functions in Raccoon](functions.md) are first-class values with powerful features:

- **Basic Definition**: `func add(a: int, b: int): int { return a + b }`
- **Default Parameters**: `func greet(name: string = "World")`
- **Named Arguments**: `createUser(name: "Alice", age: 30)`
- **Higher-Order Functions**: Functions that take functions

[Learn more about functions →](functions.md)

### Control Flow

[Control flow statements](control-flow.md) include traditional constructs and pattern matching:

- **Conditionals**: if-else, ternary
- **Loops**: for, while, collection iteration
- **Pattern Matching**: Powerful, expressive match statements

[Learn more about control flow →](control-flow.md)

### Collections

[Collection operations](collections-query.md) support functional programming patterns:

- **Transformations**: map, filter, reduce
- **Queries**: sort, group, join
- **Lazy Evaluation**: Efficient processing of large data sets

[Learn more about collections →](collections-query.md)

## Error Handling

Raccoon uses [the Result type](error-handling.md) instead of exceptions for error handling:

- **Explicit Errors**: `func divide(a: float, b: float): Result<float, string>`
- **Error Propagation**: `?` operator for concise error handling
- **Pattern Matching**: `match result { Ok(value) => ..., Err(e) => ... }`

[Learn more about error handling →](error-handling.md)

## Memory Management

Raccoon employs [a hybrid memory management approach](memory-management.md):

- **Value Semantics**: Predictable copying and ownership
- **Scope-Based Resources**: Automatic cleanup when objects go out of scope
- **Large Data Structures**: Efficient handling through persistent data structures and copy-on-write
- **Thread Communication**: Message passing between threads

[Learn more about memory management →](memory-management.md)

## Concurrency

[Concurrency in Raccoon](concurrency.md) is built on green threads and message passing:

- **Green Threads**: Lightweight, efficient concurrency
- **Async/Await**: Non-blocking operations
- **Channels**: Type-safe message passing
- **Thread-Safe Types**: Atomics and concurrent collections

[Learn more about concurrency →](concurrency.md)

## Code Organization

Raccoon code is organized into [modules and packages](packages.md):

- **Modules**: Code organization units
- **Visibility Control**: public, internal, private
- **Package Management**: Dependencies and versioning

[Learn more about code organization →](packages.md)

## Build and Deploy

Raccoon supports [various compilation and distribution options](compilation.md):

- **Optimization Levels**: Debug to aggressive
- **Output Types**: Executables, libraries, WebAssembly
- **Distribution Options**: Static, dynamic, embedded assets

[Learn more about build and deploy →](compilation.md)

## Coming Soon

These sections are under development:

### Standard Library

The standard library documentation will cover core types and functions.

### Tooling

Information about IDE support, debugging, and development tools.

## Navigation Guide

- **Previous Topic**: [Introduction](#introduction)
- **Next Topic**: [Types](types.md)

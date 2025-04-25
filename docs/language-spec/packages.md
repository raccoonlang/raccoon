# Modules and Packages

Raccoon's package system provides a way to organize code into reusable components, control visibility, and manage dependencies.

## Package System

### Package Declaration

A package is a collection of related code elements (functions, types, constants, etc.). Each file automatically creates a package with the name derived from the file path.

```
// Basic package structure
package <namespace>[.<subpackage>];

// Imports
import <module_path>;
import <module_path> as <alias>;
import <module_path>.{<name1>, <name2>};
```

### Example

```raccoon
// File: math/vector.rn
package math.vector;

struct Vector2D {
    x: float;
    y: float;

    func length(): float {
        return Math.sqrt(x * x + y * y);
    }

    func normalize(): Vector2D {
        var len = this.length();
        return Vector2D(x / len, y / len);
    }
}

func dot(a: Vector2D, b: Vector2D): float {
    return a.x * b.x + a.y * b.y;
}
```

### Using Modules

```raccoon
// File: game/physics.rn
package game.physics;

// Import the entire package
import math.vector;

// Or specific elements
import math.vector.{Vector2D, dot};

// Or with an alias
import math.vector as vec;

func calculateForce(position: Vector2D, velocity: vec.Vector2D): Vector2D {
    // Implementation
}
```

## Visibility and Access Control

Raccoon provides visibility control through export and import mechanisms:

- By default, all declarations are internal/local (no keyword required)
- Use `export` keyword to expose functions, types, and constants
- Items that aren't exported are only accessible within the same package

```raccoon
package core.collections;

// Export this struct to make it accessible from outside
export struct List<T> {
    // Implementation
}

// Internal type, only accessible within the package (no keyword needed)
struct ListNode<T> {
    value: T;
    next: ListNode<T>?;
}

// Internal function, only accessible within this package (no keyword needed)
func rebalance<T>(list: List<T>) {
    // Implementation
}
```

## Package Management

### Package Declaration

A package is a collection of packages that are distributed and versioned together. Packages are defined in a `package.rn` file:

```raccoon
// File: package.rn
package {
    name: "vector-math",
    version: "1.0.0",
    description: "Vector mathematics library for Raccoon",
    author: "Raccoon Team",
    license: "MIT",
    dependencies: {
        "core-utils": "^2.0.0",
        "math-helpers": "~1.2.0"
    }
}
```

### Package Structure

A typical Raccoon package has the following structure:

```
vector-math/
├── package.rn         # Package manifest
├── src/               # Source code
│   ├── vector.rn      # Vector package
│   ├── matrix.rn      # Matrix package
│   └── transform.rn   # Transform package
├── tests/             # Test code
│   ├── vector_test.rn
│   └── matrix_test.rn
└── examples/          # Example code
    └── rotation.rn
```

## Package Resolution

Raccoon resolves packages using the following order:

1. Local packages in the workspace
2. Packages in the user's local cache
3. Packages from the Raccoon package registry

```raccoon
// Import from specific packages
import vector_math.vector.Vector2D;
import math_helpers.geometry.Angle;
```

## Submodules and Reexports

Modules can be organized hierarchically and can reexport elements from other packages:

```raccoon
// File: math/mod.rn
package math;

// Reexport submodules
export math.vector;
export math.matrix;
export math.transform;

// This allows users to import from the parent package:
// import math.{Vector2D, Matrix3x3};
```

## Conditional Compilation

Raccoon supports conditional compilation for platform-specific or feature-specific code:

```raccoon
#if platform == "windows"
func getPathSeparator(): string {
    return "\\";
}
#else
func getPathSeparator(): string {
    return "/";
}
#endif

#feature "advanced-math"
func complexCalculation(): float {
    // Advanced implementation
}
#else
func complexCalculation(): float {
    // Basic implementation
}
#endfeature
```

## Package Initialization

Packages can contain initialization code that runs when the package is first loaded:

```raccoon
package app.startup;

    // Package initialization code
init {
    println("Initializing startup package...");
    loadConfiguration();
    setupLogging();
}

func loadConfiguration() {
    // Implementation
}

func setupLogging() {
    // Implementation
}
```

## Design Rationale

Raccoon's package system is designed based on best practices from modern languages:

- **File-Based Modules**: Like Rust, each file defines a package, making structure clear
- **Hierarchical Organization**: Like Java and Kotlin, supports namespaced hierarchy
- **Explicit Imports**: Like Python and TypeScript, requires explicit imports
- **Visibility Controls**: Like Kotlin and Swift, provides granular access control
- **Declarative Package Management**: Like Cargo (Rust) and npm, makes dependencies explicit

## Edge Cases

1. **Circular Dependencies**: Raccoon detects and prevents circular dependencies between packages:
   ```raccoon
   // package A imports B, B imports A
   // Compiler error: "Circular dependency detected between packages A and B"
   ```

2. **Name Conflicts**: When multiple imported items have the same name, you must use aliases or fully qualified names:
   ```raccoon
   import graphics.Color;
   import styling.Color as StyleColor;

   func example() {
       var graphicsColor = Color(255, 0, 0);
       var styleColor = StyleColor("red");
   }
   ```

3. **Split Modules**: A package can be split across multiple files using directory-based organization:
   ```
   math/
   ├── mod.rn          # Main package file
   ├── vector.rn       # Submodule
   └── matrix.rn       # Submodule
   ```

4. **Reexporting Patterns**: Modules can selectively reexport items to create a clean public API:
   ```raccoon
   // lib.rn
   package mylib;

   // Internal packages
   import mylib.internal.utils;
   import mylib.internal.core;

   // Only reexport specific items for the public API
   export mylib.internal.utils.{formatString, parseTime};
   export mylib.internal.core.Engine;
   ```
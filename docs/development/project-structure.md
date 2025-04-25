# Raccoon Programming Language - Project Structure

```
raccoon/
├── .github/                         # GitHub-specific files
│   ├── ISSUE_TEMPLATE/              # Templates for bug reports, feature requests
│   └── workflows/                   # CI/CD workflows
│
├── docs/                            # Documentation
│   ├── language-spec/               # Language specification documents
│   ├── memory-management/           # Memory management documentation
│   ├── api/                         # API documentation
│   ├── tutorials/                   # Tutorials and guides
│   └── contributing.md              # Contribution guidelines
│
├── src/                             # Source code
│   ├── compiler/                    # Compiler implementation
│   │   ├── lexer/                   # Lexical analysis
│   │   ├── parser/                  # Syntax analysis and AST generation
│   │   ├── semantic/                # Semantic analysis
│   │   │   ├── types/               # Type checking and inference
│   │   │   └── ownership/           # Ownership and lifetime analysis
│   │   ├── ir/                      # Intermediate representation
│   │   ├── codegen/                 # Code generation
│   │   └── utils/                   # Utility functions
│   │
│   ├── runtime/                     # Runtime implementation
│   │   ├── memory/                  # Memory management implementation
│   │   │   ├── ownership/           # Ownership tracking
│   │   │   ├── gc/                  # Garbage collector
│   │   │   └── scope/               # Scope-based resource management
│   │   ├── concurrency/             # Concurrency runtime
│   │   │   ├── scheduler/           # Green thread scheduler
│   │   │   ├── async/               # Async/await implementation
│   │   │   └── channels/            # Communication channels
│   │   └── io/                      # I/O subsystem
│   │
│   ├── stdlib/                      # Standard library
│   │   ├── core/                    # Core data structures and algorithms
│   │   ├── io/                      # I/O operations
│   │   ├── net/                     # Networking
│   │   ├── concurrent/              # Concurrency utilities
│   │   └── text/                    # Text processing
│   │
│   └── cli/                         # Command-line interface
│       ├── commands/                # CLI commands implementation
│       ├── package/                 # Package management
│       └── tools/                   # Developer tools
│
├── tests/                           # Test suite
│   ├── unit/                        # Unit tests
│   │   ├── compiler/                # Compiler unit tests
│   │   ├── runtime/                 # Runtime unit tests
│   │   └── stdlib/                  # Standard library unit tests
│   ├── integration/                 # Integration tests
│   ├── benchmarks/                  # Performance benchmarks
│   └── samples/                     # Sample programs for testing
│
├── tools/                           # Development tools
│   ├── devenv/                      # Development environment setup
│   ├── lsp/                         # Language Server Protocol implementation
│   ├── formatter/                   # Code formatter
│   └── docgen/                      # Documentation generator
│
├── examples/                        # Example Raccoon programs
│   ├── basics/                      # Basic language features
│   ├── concurrency/                 # Concurrency examples
│   ├── memory/                      # Memory management examples
│   └── applications/                # Sample applications
│
├── .gitignore                       # Git ignore file
├── LICENSE                          # License file with Apache 2.0 + Additional Terms
├── TRADEMARK_POLICY.md              # Trademark policy
├── README.md                        # Project overview
├── CONTRIBUTING.md                  # Contribution guidelines
├── CODE_OF_CONDUCT.md               # Community code of conduct
├── SECURITY.md                      # Security policy
└── build.config                     # Build configuration
```

## Directory Purpose Overview

### Top-Level Structure

- **`.github/`**: Contains GitHub-specific files like issue templates and CI/CD workflows.
- **`docs/`**: Comprehensive documentation for the language.
- **`src/`**: All source code for the compiler, runtime, standard library, and CLI tools.
- **`tests/`**: Tests for all components of the language.
- **`tools/`**: Development tools for the language ecosystem.
- **`examples/`**: Example programs showcasing language features.

### Source Code (`src/`)

#### Compiler

- **`lexer/`**: Tokenizes source code into lexical tokens.
- **`parser/`**: Transforms tokens into an Abstract Syntax Tree (AST).
- **`semantic/`**: Performs semantic analysis, including type checking and ownership analysis.
- **`ir/`**: Converts AST to an intermediate representation.
- **`codegen/`**: Generates executable code from the IR.

#### Runtime

- **`memory/`**: Implements the hybrid memory management system.
- **`concurrency/`**: Implements green threads, async/await, and channels.
- **`io/`**: Provides system-level I/O operations.

#### Standard Library

Contains modules for core data structures, I/O, networking, concurrency, and text processing.

#### CLI

Implements the command-line interface, package management, and developer tools.

### Tests (`tests/`)

- **`unit/`**: Unit tests for individual components.
- **`integration/`**: Tests that verify interactions between components.
- **`benchmarks/`**: Performance tests.
- **`samples/`**: Sample programs for testing language features.

### Tools (`tools/`)

- **`devenv/`**: Development environment setup tools.
- **`lsp/`**: Language Server Protocol for IDE integration.
- **`formatter/`**: Code formatting tool.
- **`docgen/`**: Documentation generation tools.

## Build System Recommendations

For building the Raccoon language implementation, consider using:

1. **CMake** for cross-platform build configuration
2. **Ninja** for fast builds
3. **LLVM** toolchain for code generation
4. **GoogleTest** for testing framework

## Initial Implementation Focus

When beginning implementation, focus on these directories first:

1. `src/compiler/lexer/`
2. `src/compiler/parser/`
3. `tests/unit/compiler/`
4. `examples/basics/`

This will allow you to quickly develop a parser that can validate syntax, which provides a foundation for the rest of the implementation.

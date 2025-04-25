# Getting Started with Raccoon

This guide will walk you through creating your first Raccoon project, from installation to running a simple application.

## Installation

### Install the Raccoon Compiler

```bash
# On macOS using Homebrew
brew install raccoon

# On Linux
curl -sSL https://get.raccoonlang.org | sh

# On Windows using PowerShell
iwr -useb https://get.raccoonlang.org/win | iex
```

Verify the installation:

```bash
raccoon --version
```

### Install the IDE Extension

Raccoon has extensions for popular IDEs:

- **VS Code**: Search for "Raccoon Language" in the extension marketplace
- **IntelliJ IDEA**: Search for "Raccoon" in the plugins marketplace
- **Vim/Neovim**: Install the `raccoon-vim` plugin

## Create Your First Project

### Project Initialization

Create a new Raccoon project:

```bash
# Create a new directory for your project
mkdir hello-raccoon
cd hello-raccoon

# Initialize a new Raccoon project
raccoon init
```

This creates a basic project structure:

```
hello-raccoon/
├── src/
│   └── main.rn
├── tests/
│   └── main_test.rn
├── project.rn
└── README.md
```

### Understand the Project Files

- **src/main.rn**: Main entry point for your application
- **tests/main_test.rn**: Unit tests for your application
- **project.rn**: Project configuration file

Let's look at the generated `main.rn`:

```raccoon
func main() {
    println("Hello, Raccoon!");
}
```

### Modify the Code

Let's make the example more interesting by adding a greeting function:

```raccoon
func greet(name: string) {
    println("Hello, ${name}!");
}

func main() {
    println("Welcome to Raccoon!");

    var name = "World";
    greet(name);

    // Try with a different name
    greet("Raccoon");
}
```

## Build and Run Your Project

### Compile the Project

```bash
# Compile in debug mode
raccoon build

# Or compile with optimizations
raccoon build --release
```

This creates an executable in the `target` directory.

### Run the Program

```bash
# Run the compiled program
./target/debug/hello-raccoon

# Or use the raccoon run command
raccoon run
```

Output:
```
Welcome to Raccoon!
Hello, World!
Hello, Raccoon!
```

## Add Dependencies

Let's add a dependency to use more features:

1. Edit the `project.rn` file:

```raccoon
project {
    name: "hello-raccoon",
    version: "0.1.0",

    dependencies: {
        "raccoon-json": "1.0.0"
    }
}
```

2. Update your code to use the dependency:

```raccoon
import raccoon_json.{Json, JsonValue};

func parseJson(jsonStr: string): Result<JsonValue, string> {
    return Json.parse(jsonStr);
}

func main() {
    println("Welcome to Raccoon!");

    var name = "World";
    greet(name);

    // Parse and use JSON
    var jsonStr = """
    {
        "name": "Raccoon",
        "version": "0.1.0",
        "features": ["Fast", "Safe", "Friendly"]
    }
    """;

    match parseJson(jsonStr) {
        Ok(json) => {
            var features = json["features"].asArray();
            println("Raccoon features:");
            for (var feature in features) {
                println("- ${feature.asString()}");
            }
        },
        Err(e) => println("Error parsing JSON: ${e}")
    }
}

func greet(name: string) {
    println("Hello, ${name}!");
}
```

3. Update dependencies:

```bash
raccoon update
```

4. Build and run:

```bash
raccoon run
```

Output:
```
Welcome to Raccoon!
Hello, World!
Raccoon features:
- Fast
- Safe
- Friendly
```

## Create a Simple Web Server

Let's create a simple HTTP server:

1. Add the HTTP server dependency:

```raccoon
// project.rn
project {
    name: "hello-raccoon",
    version: "0.1.0",

    dependencies: {}
}
```

2. Create a new file `src/server.rn`:

```raccoon
import raccoon.http.{Server, Request, Response};

// Start a simple HTTP server
func startServer(port: int): Result<Server, string> {
    var server = Server().port(port);

    // Add a route for the root path
    server.get("/", (req: Request) => {
        return Response.json({
            "message": "Hello from Raccoon!",
            "path": req.path,
            "time": DateTime.now().toString()
        });
    });

    // Add a route with path parameters
    server.get("/users/:id", (req: Request) => {
        var userId = req.params["id"];
        return Response.json({
            "user": {
                "id": userId,
                "name": "User ${userId}"
            }
        });
    });

    // Start the server
    println("Starting server on port ${port}...");
    return server.start();
}

func main() {
    match startServer(3000) {
        Ok(server) => {
            println("Server started successfully");
            server.wait();  // Keep the server running
        },
        Err(e) => {
            println("Failed to start server: ${e}");
        }
    }
}
```

3. Run the server:

```bash
raccoon run --bin server
```

4. Test the server:
```bash
# In another terminal
curl http://localhost:3000/
curl http://localhost:3000/users/123
```

## Next Steps

Congratulations! You've created your first Raccoon project. Here are some next steps:

1. Explore the [Language Specification](../language-spec/index.md)
2. Learn about [Memory Management](../language-spec/memory-management.md)
3. Understand [Concurrency](../language-spec/concurrency.md)
4. Check out the [Standard Library](../language-spec/standard-library.md)

For more examples, visit the [Raccoon examples repository](https://github.com/raccoonlang/examples).
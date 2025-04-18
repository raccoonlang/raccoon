# Raccoon Programming Language

<p align="center">
  <img src="https://avatars.githubusercontent.com/u/155933902?s=200&v=4" alt="Raccoon Language Logo" />
  <br>
  <em>A modern compiled language with innovative memory management</em>
</p>

## About Raccoon

Raccoon is a modern programming language designed with an intuitive syntax and advanced memory safety features, while providing modern concurrency capabilities like async I/O and green threads. The language features:

- **Intuitive Syntax**: Clean, straightforward syntax for easy adoption
- **Smart Memory Management**: Hybrid approach combining ownership tracking, scope-based cleanup, and selective garbage collection
- **Modern Concurrency**: Green threads and async/await built into the language core
- **Performance Focus**: Compiled to native code for maximum speed
- **Developer Experience**: Clear error messages and excellent tooling


## Raccoon CLI

Raccoon comes with a powerful command-line interface that handles project management, dependency management, package publishing, and project scaffolding.

```bash
# Create a new Raccoon project
raccoon init my-project

# Add dependencies
raccoon add web-framework

# Install project dependencies
raccoon install

# Run your project
raccoon run
```

## Project Structure and Roadmap

- [Project Structure](docs/development/PROJECT_STRUCTURE.md): Overview of the Raccoon project directory structure
- [Project Roadmap](docs/development/PROJECT_ROADMAP.md): Our development plans and milestones
- [Language Specification](docs/language-spec/index.md): The syntax and semantics of the Raccoon language

## Getting Involved

Raccoon is currently in the early development stages. Here's how you can get involved:

- **Star the repository** to show your interest
- **Watch for updates** as we progress through our roadmap
- **Join the discussion** in our community forums (coming soon)
- **Contribute** to the language design and implementation

### Contributing

We welcome contributions from the community! Please see our [Contributing Guidelines](CONTRIBUTING.md) for information on how to get started. All contributors are expected to follow our [Code of Conduct](CODE_OF_CONDUCT.md).

If you discover a security vulnerability, please follow our [Security Policy](SECURITY.md) for responsible disclosure.

## Development Processes

- [Contributing Guidelines](CONTRIBUTING.md): How to contribute to the Raccoon project
- [Versioning](docs/development/VERSIONING.md): Our semantic versioning and conventional commits approach
- [Release Process](docs/development/RELEASE_PROCESS.md): How we manage the release process

## Code Examples

```
// Basic Raccoon program
func main() {
    var greeting = "Hello, World!";
    println(greeting);
}

// Ownership and scope-based resource management
func processFile() {
    var file = File.open("data.txt");
    // file is automatically closed when it goes out of scope

    var data = file.readData();
    processData(data);
}

// Async programming with green threads
async func fetchData() {
    var response = await httpClient.get("https://api.example.com/data");
    return processResponse(response);
}

func main() {
    // Start multiple concurrent operations
    var results = await parallel([
        fetchData(),
        fetchData(),
        fetchData()
    ]);

    for (var result in results) {
        println(result);
    }
}
```

## License

Raccoon is licensed under the Apache License 2.0 with Additional Terms. This license allows:
- Commercial use of the software
- Modification and distribution
- Private use
- Patent use

While requiring:
- License and copyright notice
- Statement of changes
- Compliance with the additional terms regarding usage of the Raccoon name and branding

See [LICENSE](LICENSE.md) for the complete terms and [TRADEMARK_POLICY](TRADEMARK_POLICY.md) for details on the usage of the Raccoon name and branding.

## Acknowledgments

Raccoon draws inspiration from multiple modern programming paradigms and techniques while creating its own unique approach to language design.

# Raccoon Programming Language - Contributing Guidelines

Thank you for your interest in contributing to the Raccoon programming language! This document outlines the process for contributing to the project and how to get started as a contributor.

## Development Workflow

1. **Fork the Repository**: Start by forking the repository to your GitHub account.

2. **Clone Your Fork**: Clone your fork to your local machine.
   ```bash
   git clone https://github.com/your-username/raccoon.git
   cd raccoon
   ```

3. **Create a Branch**: Create a branch for your work.
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make Changes**: Implement your changes, following the coding standards below.

5. **Test Your Changes**: Ensure all tests pass and add new tests for your feature.
   ```bash
   raccoon test
   ```

6. **Commit Your Changes**: Commit with a descriptive message following conventional commits.
   ```bash
   git commit -m "feat: add new feature"
   ```

7. **Push to Your Fork**: Push your changes to your fork on GitHub.
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request**: Submit a pull request from your branch to the main Raccoon repository.

## Coding Standards

1. **Code Style**:
   - Follow the project's established code style
   - Use meaningful variable and function names
   - Keep functions small and focused on a single responsibility

2. **Documentation**:
   - Document all public APIs
   - Add inline comments for complex logic
   - Update documentation when changing functionality

3. **Testing**:
   - Write unit tests for new functionality
   - Ensure existing tests pass with your changes
   - Aim for high test coverage

4. **Commit Messages**:
   - Follow the [Conventional Commits](https://www.conventionalcommits.org/) standard
   - Use types such as: feat, fix, docs, style, refactor, perf, test, chore
   - Example: `feat(parser): add support for template literals`

## Pull Request Process

1. **PR Template**: Fill out the pull request template completely.

2. **Scope**: Keep PRs focused on a single feature or fix to simplify review.

3. **Review Process**:
   - Maintainers will review your code for quality and adherence to standards
   - Address any requested changes in a timely manner
   - Once approved, a maintainer will merge your PR

4. **Continuous Integration**:
   - Ensure all CI checks pass before requesting review
   - Fix any issues that arise from automated testing

## Getting Help

If you need help with your contribution:

- **Discussions**: Post questions in GitHub Discussions
- **Issues**: Comment on the relevant issue for context-specific questions
- **Community Channels**: Join our community channels (see README for links)

## Code of Conduct

All contributors are expected to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md).

## License

By contributing to Raccoon, you agree that your contributions will be licensed under the project's [license](LICENSE.md).
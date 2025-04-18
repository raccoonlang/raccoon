# Raccoon Programming Language - Versioning

This project follows [Semantic Versioning](https://semver.org/) principles, with version numbers in the format of `MAJOR.MINOR.PATCH` where:

- **MAJOR** version increases when incompatible API changes are made
- **MINOR** version increases when functionality is added in a backward-compatible manner
- **PATCH** version increases when backward-compatible bug fixes are made

## Conventional Commits

We enforce [Conventional Commits](https://www.conventionalcommits.org/) format for all commit messages to automate version management and changelog generation.

### Commit Message Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Commit Types and Version Impact

| Type | Description | Version Impact |
|------|-------------|---------------|
| `feat` | A new feature | `MINOR` |
| `fix` | A bug fix | `PATCH` |
| `docs` | Documentation changes only | None |
| `style` | Changes that don't affect code functionality | None |
| `refactor` | Code changes that neither fixes bugs nor adds features | None |
| `perf` | Performance improvements | `PATCH` |
| `test` | Adding or updating tests | None |
| `build` | Changes to build system or dependencies | None |
| `ci` | Changes to CI configuration | None |
| `chore` | Other changes that don't modify src or test files | None |
| `revert` | Reverts a previous commit | None |

### Breaking Changes

Breaking changes (which trigger a `MAJOR` version increment) can be indicated in two ways:

1. Add a `!` before the colon in the commit message:
   ```
   feat!: change API behavior
   ```

2. Include a footer with `BREAKING CHANGE:` followed by a description:
   ```
   feat: add new feature

   BREAKING CHANGE: existing API has changed
   ```

## Usage

### Git Hook Installation

The commit message format is enforced by a Git hook that validates your commit messages automatically. The hook is installed in `.git/hooks/commit-msg`.

### Interactive Commit Helper

We provide a helper script to guide you through creating properly formatted commit messages:

```bash
./scripts/commit.sh
```

### Version Management

To determine the next version based on commits since the last version tag:

```bash
./scripts/version.sh [current_version]
```

If `current_version` is not provided, it defaults to `0.1.0`.

## Examples

Examples of valid commit messages:

```
feat(parser): add ability to parse arrays
```
```
fix: address null pointer exception in logger
```
```
docs: update installation instructions
```
```
feat!: redesign vm memory management
```
```
fix(runtime): correct lambdas handling

BREAKING CHANGE: The format of query parameters has changed from comma-separated to array notation
```
# Raccoon Release Process

This document outlines the process for creating and publishing releases of the Raccoon programming language.

## Version Numbering and Commit Conventions

Raccoon follows Semantic Versioning with Conventional Commits as detailed in our [Versioning Guide](VERSIONING.md).

This approach allows us to automatically determine version increments and generate changelogs based on commit messages.

## Release Workflow

The release process is automated via GitHub Actions:

1. **Code Contribution**:
   - Developers submit PRs with conventional commit messages
   - PRs are reviewed and merged into the main branch

2. **Automatic Release Creation**:
   - When commits are pushed to main, the release workflow runs
   - It determines the next version based on commit messages since last release
   - It updates version numbers in relevant files
   - It generates a changelog from commit messages

3. **Release Publication**:
   - A GitHub release is created with the changelog as release notes
   - The package is published to appropriate package registries
   - Documentation is updated

4. **Post-Release**:
   - Announcements are posted to communication channels
   - The roadmap is updated to reflect the completed work

## Release Cadence

- **Patch releases**: As needed for bug fixes
- **Minor releases**: Every 4-8 weeks during active development
- **Major releases**: Scheduled according to the project roadmap

## Hotfix Process

For critical bugs that require immediate fixing:

1. Create a branch from the latest release tag
2. Fix the issue and use a `fix:` commit message
3. Submit a PR to both the release branch and main
4. When merged to the release branch, a hotfix release will be automatically created

## Release Candidates

Before major releases, we may publish release candidates:

```
x.y.z-rc.n
```

Where `n` is the release candidate number, starting at 1.

## Documentation Updates

With each release:

- API documentation is regenerated
- The language specification is updated
- Release notes are published
- Migration guides are created for breaking changes
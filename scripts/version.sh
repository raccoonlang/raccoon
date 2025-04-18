#!/bin/bash

# Script to determine version changes based on conventional commits
# Usage: ./version.sh [current_version]

current_version=${1:-"0.1.0"}

# Parse current version
IFS='.' read -r major minor patch <<< "$current_version"

# Check commits since last tag
echo "Analyzing commits since last version tag..."

# Get commits since last tag or all commits if no tag exists
last_tag=$(git describe --tags --abbrev=0 2>/dev/null)
if [ $? -eq 0 ]; then
  commits=$(git log ${last_tag}..HEAD --pretty=format:"%s" 2>/dev/null)
else
  commits=$(git log --pretty=format:"%s" 2>/dev/null)
fi

# Initialize flags
has_breaking_change=false
has_new_feature=false
has_bug_fix=false

# Analyze commit messages
while IFS= read -r commit; do
  if [[ "$commit" == *"BREAKING CHANGE:"* || "$commit" =~ ^.*!:.*$ ]]; then
    has_breaking_change=true
    echo "Breaking change detected: $commit"
  elif [[ "$commit" =~ ^feat(\([^)]+\))?:.*$ ]]; then
    has_new_feature=true
    echo "New feature detected: $commit"
  elif [[ "$commit" =~ ^fix(\([^)]+\))?:.*$ ]]; then
    has_bug_fix=true
    echo "Bug fix detected: $commit"
  fi
done <<< "$commits"

# Determine new version
new_version="$current_version"
if [ "$has_breaking_change" = true ]; then
  ((major++))
  minor=0
  patch=0
  new_version="$major.$minor.$patch"
  echo "Major version bump due to breaking changes"
elif [ "$has_new_feature" = true ]; then
  ((minor++))
  patch=0
  new_version="$major.$minor.$patch"
  echo "Minor version bump due to new features"
elif [ "$has_bug_fix" = true ]; then
  ((patch++))
  new_version="$major.$minor.$patch"
  echo "Patch version bump due to bug fixes"
else
  echo "No version change needed"
fi

echo "Current version: $current_version"
echo "New version: $new_version"

# Output new version (can be captured by other scripts)
echo "$new_version"
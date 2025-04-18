#!/bin/bash

# Interactive helper script for conventional commits
# Usage: ./commit.sh

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# List of commit types
types=("feat" "fix" "docs" "style" "refactor" "perf" "test" "build" "ci" "chore" "revert")
types_desc=(
  "A new feature"
  "A bug fix"
  "Documentation changes"
  "Changes that don't affect code (formatting, whitespace, etc.)"
  "Code changes that neither fix bugs nor add features"
  "Performance improvements"
  "Adding or modifying tests"
  "Changes to build system or external dependencies"
  "Changes to CI configuration"
  "Other changes that don't modify source or test files"
  "Revert a previous commit"
)

echo -e "${BLUE}=== Conventional Commit Helper ===${NC}"
echo "This script will help you create a commit message following the Conventional Commits specification."
echo -e "Format: ${GREEN}<type>[optional scope]: <description>${NC}"
echo ""

# Choose type
echo -e "${BLUE}Select the type of change:${NC}"
for i in "${!types[@]}"; do
  echo -e "$i: ${GREEN}${types[$i]}${NC} - ${types_desc[$i]}"
done
read -p "Enter number for type (0-$((${#types[@]}-1))): " type_num

if ! [[ "$type_num" =~ ^[0-9]+$ ]] || [ "$type_num" -ge "${#types[@]}" ]; then
  echo -e "${RED}Invalid selection. Exiting.${NC}"
  exit 1
fi

type="${types[$type_num]}"

# Ask for scope (optional)
read -p "Enter scope (optional, press Enter to skip): " scope
scope_text=""
if [ ! -z "$scope" ]; then
  scope_text="($scope)"
fi

# Breaking change?
read -p "Is this a breaking change? (y/N): " breaking_change
breaking_text=""
if [[ "$breaking_change" =~ ^[Yy]$ ]]; then
  breaking_text="!"
fi

# Description
read -p "Enter a short description: " description
if [ -z "$description" ]; then
  echo -e "${RED}Description cannot be empty. Exiting.${NC}"
  exit 1
fi

# Longer body (optional)
echo "Enter a longer description (optional, press Enter followed by Ctrl+D to finish, or just Ctrl+D to skip):"
body=""
while IFS= read -r line; do
  body="${body}${line}
"
done

# Breaking changes description
breaking_change_desc=""
if [[ "$breaking_change" =~ ^[Yy]$ ]]; then
  echo "Enter description for the breaking change (press Enter followed by Ctrl+D to finish):"
  breaking_change_desc=""
  while IFS= read -r line; do
    breaking_change_desc="${breaking_change_desc}${line}
"
  done
fi

# Build commit message
commit_msg="${type}${scope_text}${breaking_text}: ${description}"

if [ ! -z "$body" ]; then
  commit_msg="${commit_msg}

${body}"
fi

if [ ! -z "$breaking_change_desc" ]; then
  commit_msg="${commit_msg}

BREAKING CHANGE: ${breaking_change_desc}"
fi

# Show the commit message
echo -e "${BLUE}=== Your Commit Message ===${NC}"
echo -e "${GREEN}$commit_msg${NC}"
echo ""

# Confirm and commit
read -p "Proceed with this commit? (Y/n): " proceed
if [[ ! "$proceed" =~ ^[Nn]$ ]]; then
  echo "$commit_msg" > /tmp/commit_msg
  git commit -F /tmp/commit_msg
  rm /tmp/commit_msg
  echo -e "${GREEN}Commit created successfully!${NC}"
else
  echo -e "${YELLOW}Commit cancelled.${NC}"
fi
#!/bin/bash

set -e

echo
echo "  'Generate GH Pages Action' is using the following input:"
echo "    - user_name = $INPUT_USER_NAME"
echo "    - user_email = $INPUT_USER_EMAIL"
echo

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

URI=https://api.github.com
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token $GITHUB_TOKEN"
pr_resp=$(curl -X GET -s -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/$GITHUB_REPOSITORY")
if [[ "$(echo "$pr_resp" | jq -r .fork)" != "false" ]]; then
  echo "'Generate GH Pages Action' is disabled for forks ."
  exit 0
fi

git remote set-url origin https://x-access-token:${GITHUB_TOKEN}@github.com/$GITHUB_REPOSITORY.git
git config --global user.name "$INPUT_USER_NAME"
git config --global user.email "$INPUT_USER_EMAIL"

set -o xtrace

# Update remote repository
git fetch origin --prune

# Generate the gh-pages
./tools/gen-gh-pages.sh

# Push the branch
git push --force ${remote} gh-pages

#!/usr/bin/env bash

set -euo pipefail

function replace-tokens {
  local token=$1
  local replacement=$2

  echo "Replacing $token with $replacement"

  files=$(grep --exclude rename.sh -rl "$token" .)

  if grep -q "GNU sed" <<<$(sed --version 2>/dev/null); then
    xargs sed -i "s/$token/${replacement//\//\\/}/g" <<<"$files"
  else
    xargs sed -i '' "s/$token/${replacement//\//\\/}/g" <<<"$files"
  fi
}

function title-case {
  set ${*,,}
  echo ${*^}
}

if [ "$#" -ne 2 ]; then
  echo "Usage: rename.sh <licensor-name> <github-org>"
  echo "e.g. rename.sh 'Some Licensor' some-github-org"
  exit 1
fi

licensor=$1
github_org=$2

echo
echo "Renaming Project"
echo "= = ="
echo
echo "Licensor: $licensor"
echo "GitHub Organization: $github_org"

if [ "${PROMPT:-on}" = "on" ]; then
  echo
  echo "If everything is correct, press return (Ctrl+c to abort)"
  read -r
fi

echo
echo "Replacing tokens"
echo "- - -"
replace-tokens "TEMPLATE-LICENSOR" "$licensor"
replace-tokens "TEMPLATE-GITHUB-ORG" "$github_org"

echo
echo "Writing README"
echo "- - -"
mv -v TEMPLATE-README.md README.md

echo
echo "Deleting rename.sh"
echo "- - -"
rm -v rename.sh

echo
echo "- - -"
echo "(done)"

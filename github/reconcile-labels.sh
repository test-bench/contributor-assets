#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "GITHUB_TOKEN must be set"
  exit 1
fi

echo
echo "Start ($(basename "$0"))"

echo
echo "Reconciling Labels"
echo "= = ="

source labels.sh

org_name="${GIT_AUTHORITY_PATH#git@github.com:}"

labels=$(IFS=$'\n'; echo "${labels[*]}")

LABELS="$labels" ORG_NAME=$org_name ./reconcile_org_labels.rb

echo
echo "Done ($(basename "$0"))"

#!/usr/bin/env bash

set -eEuo pipefail

cmd=$1

dry_run="${DRY_RUN:-off}"

if [ "$dry_run" = "on" ]; then
  echo "- (DRY RUN) $cmd"
else
  echo "- $cmd"
  eval "$cmd"
fi

#!/usr/bin/env bash

set -e

projects_dir="$(dirname "${BASH_SOURCE[0]}")"

ruby_projects=(
  template-ruby-project
  test-bench-isolated
  test-bench-random
  test-bench-telemetry
  test-bench-session
)

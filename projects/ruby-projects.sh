#!/usr/bin/env bash

set -e

projects_dir="$(dirname "${BASH_SOURCE[0]}")"

ruby_projects=(
  template-ruby-project
  import-constants
  test-bench-bootstrap
  test-bench-random
  test-bench-telemetry
  test-bench-session
  test-bench-output
  test-bench-fixture
  test-bench-run
  test-bench-executable
  test-bench
)

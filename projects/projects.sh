#!/usr/bin/env bash

set -e

projects_dir="$(dirname "${BASH_SOURCE[0]}")"

source "$projects_dir/ruby-projects.sh"

projects=(
  "${ruby_projects[@]}"
)

release_projects=(
  "${ruby_release_gem_projects[@]}"
)

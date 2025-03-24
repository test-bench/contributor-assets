#!/usr/bin/env bash

set -e

projects_dir="$(dirname "${BASH_SOURCE[0]}")"

source "$projects_dir/ruby-development-gem-projects.sh"
source "$projects_dir/ruby-assembly-projects.sh"
source "$projects_dir/ruby-release-gem-projects.sh"

ruby_projects=(
  "${ruby_development_gem_projects[@]}"
  "${ruby_assembly_projects[@]}"
  "${ruby_release_gem_projects[@]}"
)

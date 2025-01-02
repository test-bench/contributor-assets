#!/usr/bin/env bash

set -e

projects_dir="$(dirname "${BASH_SOURCE[0]}")"

source "$projects_dir/ruby-development-gem-projects.sh"
source "$projects_dir/ruby-master-projects.sh"
source "$projects_dir/ruby-release-gem-projects.sh"

ruby_projects=(
  "${ruby_development_gem_projects[@]}"
  "${ruby_master_projects[@]}"
  "${ruby_release_gem_projects[@]}"
)

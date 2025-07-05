#!/usr/bin/env bash

set -e

projects_dir="$(dirname "${BASH_SOURCE[0]}")"

source "$projects_dir/ruby-projects.sh"
source "$projects_dir/other-projects.sh"
source "$projects_dir/template-projects.sh"

projects=(
  "${ruby_projects[@]}"
  "${other_projects[@]}"
  "${template_projects[@]}"
)

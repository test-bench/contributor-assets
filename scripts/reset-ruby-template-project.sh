#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

function get_gemspec_attr() {
  gemspec_file=$1
  attr=$2
  metadata_attr=${3:-}

  ruby_cmd="puts Gem::Specification.load('$gemspec_file').$attr"

  if [ -n "$metadata_attr" ]; then
    ruby_cmd="$ruby_cmd['$metadata_attr']"
  fi

  ruby -ryaml -rrubygems -e "$ruby_cmd"
}

echo
echo "Reset Template Project"
echo "= = ="

export PROMPT=off

if [ -z "${TEST_BENCH_BOOTSTRAP:-}" ]; then
  echo "TEST_BENCH_BOOTSTRAP isn't set. Default of 'on' will be used."
  export TEST_BENCH_BOOTSTRAP=on
fi

source ../projects/projects.sh

working_copies=("${ruby_projects[@]}")
#working_copies=(...)

for project in "${working_copies[@]}"; do
  echo
  echo "Update $project"
  echo "- - -"

  pushd $PROJECTS_HOME/$project

  gem_name=$(get_gemspec_attr *.gemspec name)
  echo "Gem Name: $gem_name"

  namespace=$(get_gemspec_attr *.gemspec metadata namespace)
  echo "Namespace: $namespace"

  homepage=$(get_gemspec_attr *.gemspec homepage)
  echo "Homepage: $homepage"

  initial_commit=$(git log master --grep="Initial commit" --format="%h")
  echo "Initial Commit: $initial_commit"

  implementation_commit=$(git log master --grep="Implementation is imported" --format="%h")
  echo "Implementation Commit: $implementation_commit"

  echo
  echo "If everything is correct, press return (Ctrl+c to abort)"
  read -r

  git reset --hard "$initial_commit"

  rm -rf *

  cp -rv ../template-ruby-project/* .
  cp -v ../template-ruby-project/.gitignore .gitignore

  git add .
  git --no-pager diff --cached --word-diff

  echo
  echo "If everything is correct, press return (Ctrl+c to abort)"
  read -r

  git commit --amend --no-edit

  ./rename.sh "$gem_name" "$namespace" "$homepage"

  git add .

  git commit -m 'Project is renamed'

  git cherry-pick "$implementation_commit"

  ./install-gems.sh
  ./test.sh

  git push --force-with-lease

  popd
done

echo
echo "Done ($(basename "$0"))"

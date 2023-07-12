#!/usr/bin/env bash

set -eu -o pipefail

echo

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

remote_authority_path="git@github.com:test-bench"

if [ ! -z ${GIT_AUTHORITY_PATH+x} ]; then
  echo "The GIT_AUTHORITY_PATH environment variable is set: $GIT_AUTHORITY_PATH. It will be used for this script."
  remote_authority_path=$GIT_AUTHORITY_PATH
fi

function clone-repo {
  name=$1

  remote_repository_url="$remote_authority_path/$name.git"

  echo "Cloning: $remote_repository_url"

  clone_cmd="git clone $remote_repository_url"
  run-cmd "$clone_cmd"
}

function pull-repo {
  name=$1

  echo "Pulling: $name (main branch only)"

  dir=$name
  pushd $dir > /dev/null

  current_branch=$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
  if [ main != $current_branch ]; then
    checkout_cmd="git checkout main"
    run-cmd "$checkout_cmd"
  fi

  pull_cmd="git pull --rebase $remote_name"
  run-cmd "$pull_cmd"

  if [ main != "$current_branch" ]; then
    co_crnt_cmd="git checkout $current_branch"
    run-cmd "$co_crnt_cmd"
  fi

  popd > /dev/null
}

source ./projects/projects.sh
source ./utilities/run-cmd.sh

working_copies=(
  "${projects[@]}"
)

remote_name=${1:-}
if [ -z "$remote_name" ]; then
  echo "The remote was not specified as the argument to this script. Using \"origin\" by default."
  remote_name="origin"
fi

echo
echo "Getting code from $remote_authority_path ($remote_name)"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo $name
  echo "- - -"

  dir=$name

  if [ ! -d "$dir/.git" ]; then
    clone-repo $name
  else
    pull-repo $name
  fi

  echo
done

popd > /dev/null

echo "= = ="

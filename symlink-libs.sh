#!/usr/bin/env bash

set -eu -o pipefail

echo

if [ -z ${PROJECTS_HOME+x} ]; then
  echo "PROJECTS_HOME is not set"
  exit
fi

if [ -z ${LIBRARIES_HOME+x} ]; then
  echo "LIBRARIES_HOME is not set"
  exit
fi

source ./projects/projects.sh

working_copies=(
  "${projects[@]}"
)

echo
echo "Symlinking libraries"
echo "= = ="
echo

pushd $PROJECTS_HOME > /dev/null

for name in "${working_copies[@]}"; do
  echo $name
  echo "- - -"

  dir=$name

  pushd $dir > /dev/null

  ./symlink-lib.sh

  popd > /dev/null

  echo
done

popd > /dev/null

echo "= = ="

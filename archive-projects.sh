#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

echo
echo "Archiving Obsolete Projects"
echo "= = ="
echo

source env.sh

source ./projects/archived-projects.sh

working_copies=(
  "${archived_projects[@]}"
)

cd "$PROJECTS_HOME"

if [ ! -d ".archive" ]; then
  echo
  echo "Creating archive directory for obsolete libraries"
  mkdir_cmd="mkdir .archive"
  contributor-assets/run-cmd.sh "$mkdir_cmd"
fi

for name in "${working_copies[@]}"; do
  echo
  echo "Archiving $name"

  if [ ! -d "$name" ]; then
    echo "$name not found in $PROJECTS_HOME. Skipping."
  else
    if [ -d ".archive/$name" ]; then
      echo ".archive/$name already exists. Already archived."
      rm_cmd="rm -rf $name"
      contributor-assets/run-cmd.sh "$rm_cmd"
    else
      mv_cmd="mv $name/ .archive/$name/"
      contributor-assets/run-cmd.sh "$mv_cmd"
    fi
  fi
done

echo
echo "Done ($(basename "$0"))"

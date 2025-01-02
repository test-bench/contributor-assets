#!/usr/bin/env bash

set -eEuo pipefail

trap 'printf "\n\e[31mError: Exit Status %s (%s)\e[m\n" $? "$(basename "$0")"' ERR

cd "$(dirname "$0")"

echo
echo "Start ($(basename "$0"))"

echo
echo "Packaging"
echo "= = ="

function get_gemspec_attr() {
  gem_file=$1
  attr=$2
  metadata_attr=${3:-}

  ruby_cmd="puts YAML.parse(STDIN.read).to_ruby"

  if [ -n "$metadata_attr" ]; then
    ruby_cmd="$ruby_cmd['$metadata_attr']"
  fi

  gem spec $gem_file $attr | ruby -ryaml -rrubygems -e "$ruby_cmd"
}

warning=0

for gemspec in $(find . -maxdepth 2 -name '*.gemspec'); do
  echo
  echo "Gem: $(basename "$gemspec")"
  echo "- - -"

  path="$(dirname "$gemspec")"
  gem -C "$path" build --force "$(basename "$gemspec")"

  gem="$(ls -t $path/$(basename "$gemspec" .gemspec)-*.gem | head -1)"

  license="$(get_gemspec_attr "$gem" license)"
  allowed_push_host="$(get_gemspec_attr "$gem" metadata 'allowed_push_host')"

  echo
  echo "License: ${license:-(none)}"
  echo "Allowed Push Host ${allowed_push_host:-(none)}"

  if [ -z "$license" ]; then
    if [ -z "$allowed_push_host" ]; then
      printf "\e[31mWarning: gem has no license specified, but allowed_push_host isn't set\e[m\n"

      warning=1
    fi
  else
    if [ -n "$allowed_push_host" ]; then
      printf "\e[31mWarning: gem has an open source license specified, but allowed_push_host is set ($allowed_push_host)\e[m\n"

      warning=1
    fi
  fi
done

if ! git diff --quiet; then
  echo
  printf "\e[31mWarning: There are local changes\e[m\n"

  warning=1
fi

unpushed_commit_count=$(git rev-list origin/master.. --count)
if [ "$unpushed_commit_count" -ne 0 ]; then
  echo
  printf "\e[31mWarning: There are %d unpushed commits\e[m\n" "$unpushed_commit_count"

  warning=1
fi

if [ "$warning" = 1 ] && [ "${PERMIT_WARNINGS:-}" != "on" ]; then
  false
fi

echo
echo "Done ($(basename "$0"))"

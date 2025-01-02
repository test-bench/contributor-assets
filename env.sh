#!/usr/bin/env bash

if [ -z "${PROJECTS_HOME:-}" ]; then
  printf "\e[31mError: PROJECTS_HOME is not set\e[m\n"
  return 1
fi

if [ -z "${LIBRARIES_HOME:-}" ]; then
  printf "\e[33mWarning: LIBRARIES_HOME is not set; library symlinks will be ignored\e[m\n"
fi

if [ -z "${LICENSOR:-}" ]; then
  export LICENSOR="TEMPLATE-LICENSOR"
else
  printf "\e[1mNotice: LICENSOR is overridden: $LICENSOR\e[m\n"
fi

if [ -z "${GIT_AUTHORITY_PATH:-}" ]; then
  export GIT_AUTHORITY_PATH="git@github.com:TEMPLATE-GITHUB-ORG"
else
  printf "\e[1mNotice: GIT_AUTHORITY_PATH is overridden: $GIT_AUTHORITY_PATH\e[m\n"
fi

if [ -z "${RUBYGEMS_PUBLIC_AUTHORITY:-}" ]; then
  export RUBYGEMS_PUBLIC_AUTHORITY="https://rubygems.org"
else
  printf "\e[1mNotice: RUBYGEMS_PUBLIC_AUTHORITY is overridden: $RUBYGEMS_PUBLIC_AUTHORITY\e[m\n"
fi

if [ -z "${RUBYGEMS_PUBLIC_AUTHORITY_ACCESS_KEY:-}" ]; then
  printf "\e[33mWarning: RUBYGEMS_PUBLIC_AUTHORITY_ACCESS_KEY is not set; publishing public facing gems won't be possible\e[m\n"
fi

if [ -z "${RUBYGEMS_PRIVATE_AUTHORITY:-}" ]; then
  export RUBYGEMS_PRIVATE_AUTHORITY="https://rubygems.pkg.github.com/TEMPLATE-GITHUB-ORG"
else
  printf "\e[1mNotice: RUBYGEMS_PRIVATE_AUTHORITY_PATH is overridden: $RUBYGEMS_PRIVATE_AUTHORITY\e[m\n"
fi

if [ -z "${RUBYGEMS_PRIVATE_AUTHORITY_ACCESS_KEY:-}" ]; then
  printf "\e[33mWarning: RUBYGEMS_PRIVATE_AUTHORITY_ACCESS_KEY is not set; publishing internal gems won't be possible\e[m\n"
fi

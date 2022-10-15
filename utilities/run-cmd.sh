source ./utilities/boolean-env-var.sh

function run-cmd {
  cmd=$1

  dry_run=$(boolean-env-var DRY_RUN)

  if $dry_run; then
    echo "(DRY RUN) $cmd"
  else
    echo "$cmd"
  fi

  if [ $dry_run = "false" ]; then
    eval $cmd
  fi
}

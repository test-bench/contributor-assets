function boolean-env-var {
  variable_name=$1
  default=${2:-off}

  val=${!variable_name:=$default}

  if [ $val = "on" ]; then
    echo 'true'
  elif [ $val = "off" ]; then
    echo 'false'
  else
    echo "Environment variable \$$variable_name is set to \`$val' which is not a boolean value" >&2
    echo >&2
    exit 1
  fi
}

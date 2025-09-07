#! /bin/bash


set -eu


usage() {
  cat << __EOF__
usage: $0 [-h] file [...]

    -h            display this help and exit.

__EOF__
}

abort() {
  echo "$@" 1>&2
  exit 1
}


while getopts h OPT; do
  case "${OPT}" in
    h)  usage; exit 0;;
    *)  usage; exit 1;;
  esac
done

shift $((OPTIND - 1))


if [ $# -eq 0 ]; then
  abort "invalid arguments."
fi


for path in "$@"; do
  echo "<img src=\"$(basename ${path})\" alt=\"$(basename ${path})\" class=\"grid-w33\" />"
done

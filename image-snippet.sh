#! /bin/bash


set -eu


usage() {
  cat << __EOF__
usage: $0 [-h] [-i | -f] [-c class] file [...]

    -h, --help        display this help and exit.
    -i, --img         output img tags. (default)
    -f, --figure      output Hugo figure shortcodes.
    -c, --class       set class attribute.
                      default: grid-w33 for img, w33 for figure.

__EOF__
}

abort() {
  echo "$@" 1>&2
  exit 1
}


format="img"
class=""

while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      usage
      exit 0
      ;;
    -i|--img)
      format="img"
      shift
      ;;
    -f|--figure)
      format="figure"
      shift
      ;;
    -c|--class)
      if [ $# -lt 2 ]; then
        abort "missing argument for $1."
      fi
      class="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    -*)
      usage
      exit 1
      ;;
    *)
      break
      ;;
  esac
done


if [ $# -eq 0 ]; then
  abort "invalid arguments."
fi

if [ -z "${class}" ]; then
  case "${format}" in
    img) class="grid-w33" ;;
    figure) class="w50" ;;
  esac
fi


for path in "$@"; do
  filename="$(basename "${path}")"

  case "${format}" in
    img)
      echo "<img src=\"${filename}\" alt=\"${filename}\" class=\"${class}\" />"
      ;;
    figure)
      cat << __EOF__
{{< figure
    src="${filename}"
    alt="${filename}"
    caption="${filename}"
    class="${class}"
    >}}

__EOF__
      ;;
  esac
done

#! /bin/bash


set -eu


##########################################################################
# params
##########################################################################

magick_cmd="magick"
copyright="© 2024 mkt (md.irohas@gmail.com)"
image_size="2560x1440^"
image_quality=75

exiftool_cmd="exiftool"


##########################################################################
# usage
##########################################################################

usage() {
  cat << __EOF__
usage: $0 [-h] [-s image_size] [-q image_quality] command input_image [input_image ...]

    -h                display this help and exit.
    -s  image_size    image size (passed to -resize option of imagemagick). The default is '${image_size}'.
    -q  image_quality image quality (passed to -quality option of imagemagick). The default is '${image_quality}'.

    command       command to execute (copyright, shrink, exifdel, and all)
    input_image   path to input image. the input image will be lost.

description:
  This script is a wrapper of ImageMagick to processe images in this web site.

__EOF__
}

abort() {
  echo "$@" 1>&2
  exit 1
}


##########################################################################
# command arguments
##########################################################################

# check if commnads exist.
which "${magick_cmd}" > /dev/null 2>&1 || abort "${magick_cmd} (imagemagick) not found."
which "${exiftool_cmd}" > /dev/null 2>&1 || abort "${exiftool_cmd} (exiftool) not found."


# parse command arguments.
while getopts s:q:h OPT; do
  case "${OPT}" in
    s)  image_size="${OPTARG}" ;;
    q)  image_quality="${OPTARG}" ;;
    h)  usage; exit 0;;
    *)  usage; exit 1;;
  esac
done

shift $((OPTIND - 1))

if [ $# -lt 2 ]; then
  abort "invalid arguments."
fi


# check if commnad is valid.
command="$1"

case "${command}" in
  copyright|shrink|exifdel|all) ;;
  *)  abort "invalid command: ${command}"
esac

shift


# check if files exist.
for input_image in "$@"; do
  if [ ! -f "${input_image}" ]; then
    abort "input_image not found: ${input_image}"
  fi
done


##########################################################################
# functions
##########################################################################

make_backup() {
  local input_image
  local backup_file
  input_image="$1"
  backup_file="${input_image%.*}-orig.${input_image##*.}"

  echo "* making a backup file."
  cp -vi "${input_image}" "${backup_file}"
}

add_copyright() {
  local input_image
  input_image="$1"

  echo "* adding a copyright to the image."
  ${magick_cmd} mogrify \
    -fill '#ffffff80' -undercolor '#00000000' -pointsize 24 \
    -gravity SouthEast -annotate +24+24 "${copyright}" \
    "${input_image}"
}

shrink_image() {
  local input_image
  input_image="$1"

  echo "* shrinking the image."
  ${magick_cmd} mogrify \
    -quality "${image_quality}" -resize "${image_size}" \
    "${input_image}"
}

delete_exif() {
  local input_image
  input_image="$1"

  echo "* deleting exif info in the image."
  ${exiftool_cmd} -all= "${input_image}"
}


##########################################################################
# main
##########################################################################

for input_image in "$@"; do
  case "${command}" in
    copyright)
      make_backup "${input_image}"
      add_copyright "${input_image}"
      ;;
    shrink)
      make_backup "${input_image}"
      shrink_image "${input_image}"
      ;;
    exifdel)
      make_backup "${input_image}"
      delete_exif "${input_image}"
      ;;
    all)
      make_backup "${input_image}"
      shrink_image "${input_image}"
      add_copyright "${input_image}"
      delete_exif "${input_image}"
      ;;
  esac
done

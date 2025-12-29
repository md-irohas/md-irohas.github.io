#! /bin/bash


set -eu


##########################################################################
# params
##########################################################################

copyright="© 2025 mkt (md.irohas@gmail.com)"
image_size="2560x1440^"
image_quality=75

exiftool_cmd="exiftool"

skip_backup=1


##########################################################################
# usage
##########################################################################

usage() {
  cat << __EOF__
usage: $0 [-h] [-S] [-s image_size] [-q image_quality] command input_image [input_image ...]

    -h                display this help and exit.
    -s  image_size    image size (passed to -resize option of imagemagick). The default is '${image_size}'.
    -q  image_quality image quality (passed to -quality option of imagemagick). The default is '${image_quality}'.

    -S      skip making backups.

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

# detect ImageMagick (support both v6 and v7)
# - prefer `magick` (ImageMagick 7) when available
# - otherwise use the legacy `mogrify` (ImageMagick 6) command
im_mode=""
if command -v magick >/dev/null 2>&1; then
  if magick -version 2>/dev/null | grep -q 'ImageMagick 7'; then
    im_mode="magick7"
  else
    im_mode="magick"
  fi
fi

if [ -z "${im_mode}" ] && command -v mogrify >/dev/null 2>&1; then
  im_mode="mogrify"
fi

if [ -z "${im_mode}" ]; then
  abort "ImageMagick (magick or mogrify) not found."
fi

which "${exiftool_cmd}" > /dev/null 2>&1 || abort "${exiftool_cmd} (exiftool) not found."


# parse command arguments.
while getopts Ss:q:h OPT; do
  case "${OPT}" in
    S)  skip_backup=0;;
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

# wrapper to invoke mogrify in a way that works for ImageMagick 6 and 7
im_mogrify() {
  if [ "${im_mode}" = "magick7" ] || [ "${im_mode}" = "magick" ]; then
    magick mogrify "$@"
  else
    mogrify "$@"
  fi
}

add_copyright() {
  local input_image
  input_image="$1"

  echo "* adding a copyright to the image."
  im_mogrify \
    -fill '#ffffff80' -undercolor '#00000000' -pointsize 24 \
    -gravity SouthEast -annotate +24+24 "${copyright}" \
    "${input_image}"
}

shrink_image() {
  local input_image
  input_image="$1"

  echo "* shrinking the image."
  im_mogrify \
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
      if [ ! ${skip_backup} -eq 0 ] ;then
        make_backup "${input_image}"
      fi
      add_copyright "${input_image}"
      ;;
    shrink)
      if [ ! ${skip_backup} -eq 0 ] ;then
        make_backup "${input_image}"
      fi
      shrink_image "${input_image}"
      ;;
    exifdel)
      if [ ! ${skip_backup} -eq 0 ] ;then
        make_backup "${input_image}"
      fi
      delete_exif "${input_image}"
      ;;
    all)
      if [ ! ${skip_backup} -eq 0 ] ;then
        make_backup "${input_image}"
      fi
      shrink_image "${input_image}"
      add_copyright "${input_image}"
      delete_exif "${input_image}"
      ;;
  esac
done

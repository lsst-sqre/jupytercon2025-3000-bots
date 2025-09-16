#!/usr/bin/env bash

# based on https://gitlab.com/olberger/docker-org-teaching-export

# Launch the org-mode exporter inside docker

# example: ./exporter.sh pdf slides.org
# example: ./exporter.sh html index.org

SCRIPTNAME="$(basename "$0")"
USAGE=`sed "s/__SCRIPTNAME__/$SCRIPTNAME/g" <<"EOF"
__SCRIPTNAME__ [-h] [-d] [pdf|html] document.org -- converts org-mode file to pdf or (Reveal.js) html

where:
    -h : show this help text
    -d : debug : doesn't quit emacs, runs interactively (to allow debugging)
    [pdf | html] : export format
    document.org : source org-mode document to export
EOF
`

DEBUG=""
CONSOLE=""

while getopts 'hd' option; do
  case "$option" in
    h) echo "$USAGE"
       exit
       ;;
    d) set -x
       DEBUG=1
        ;;
  esac
done
shift $((OPTIND - 1))

if [ $# -lt 2 ]; then
    echo "Error: format and document required" >&2
    echo >&2
    echo "$USAGE" >&2
    exit 1
fi

docker_image=athornton/export-org

# Debug: do not quit emacs after export
if [ "x$DEBUG" != "x" ]; then
    KILLARG=''
else
    KILLARG="--kill"
fi

EMACS_START_FILE="--load /emacs/export.el"
EMACS_NO_WINDOWING="-nw"

uid=$(id -u)

export_format=$1

case ${export_format} in
    "pdf")
	exp_fn="org-latex-export-to-pdf"
	;;
    "html")
	exp_fn="org-reveal-export-to-html"
	;;
    *)
	echo "Export format must be one of 'html' or 'pdf'" >&2
	echo $USAGE >&2
	exit 1
	;;
esac
	
BATCH="--batch"
INTERACTIVE=""
if [ "x$DEBUG" != "x" ]; then
    echo "Starting emacs, and waiting for user input of export commands to perform:"
    echo "for instance, here: M-x $exp_fn"
    echo
    echo "To debug further, you can quit Emacs (C-x C-c), and test launching:"
    echo " docker run --rm -i -t -v $(pwd):$(pwd) --workdir=$(pwd) -e USER=root -e UID=$uid -e DEBUG=$DEBUG $docker_image /bin/bash"
    echo "and inside it, execute:"
    echo " USER=user /startup.sh emacs $EMACS_NO_WINDOWING $EMACS_START_FILE --file $2 --eval '($exp_fn)'"
    BATCH=""
    INTERACTIVE="-it"
fi

docker run ${INTERACTIVE} --rm -v $(pwd):$(pwd) --workdir=$(pwd) -e "UID=${uid}" $docker_image emacs ${BATCH} "${EMACS_START_FILE}" --file "$2" --eval "($exp_fn)" $KILLARG

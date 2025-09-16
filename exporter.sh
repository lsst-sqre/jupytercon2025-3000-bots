#!/bin/sh

# based on https://gitlab.com/olberger/docker-org-teaching-export

# Launch the org-mode exporter inside docker

# example: ./docker-org-teaching-export pdf slides.org
# example: ./docker-org-teaching-export html talk.org
# example: ./docker-org-teaching-export reveal index.org

SCRIPTNAME="$(basename "$0")"
USAGE=`sed "s/__SCRIPTNAME__/$SCRIPTNAME/g" <<"EOF"
__SCRIPTNAME__ [-h] [-d] [pdf|reveal] document.org -- converts org-mode file using org-mode exporter function ORG_EXPORT_FUNCNAME

where:
    -h : show this help text
    -d : debug : doesn't quit emacs, runs interactively (to allow debugging)
    [pdf | reveal ] : export format
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
    echo "Error: I need 2 args" >&2
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
EMACS_WINDOWING="-nw"

uid=$(id -u)

export_format=$1

case ${export_format} in
    "pdf")
	exp_fn="org-latex-export-to-pdf"
	;;
    "reveal")
	exp_fn="org-reveal-export-to-html"
	;;
    *)
	echo "Export format must be one of 'reveal' or 'pdf'" >&2
	echo $USAGE >&2
	exit 1
	;;
esac
	

if [ "x$DEBUG" != "x" ]; then
    echo "Starting emacs, and waiting for user input of export commands to perform:"
    echo "for instance, here: M-x $exp_fn"
    echo
    echo "To debug further, you can quit Emacs (C-x C-c), and test launching:"
    echo " docker run --rm -i -t -v $(pwd):$(pwd) --workdir=$(pwd) -e USER=root -e UID=$uid -e DEBUG=$DEBUG $docker_image /bin/bash"
    echo "and inside it, execute:"
    echo " USER=user /startup.sh emacs $EMACS_WINDOWING $EMACS_START_FILE --file $2 --eval '($exp_fn)'"
fi

docker run -v $(pwd):$(pwd) --workdir=$(pwd) -e "UID=$uid" $docker_image emacs --batch $EMACS_START_FILE --file $2 --eval "($exp_fn)" $KILLARG

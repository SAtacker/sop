#!/usr/bin/bash

if ! which inotifywait >/dev/null; then
    echo "Run sudo apt instal inotify-tools -y"
    exit 1
fi

if ! which xelatex >/dev/null; then
    echo "Install xelatex"
    exit 1
fi

if ! which pdftoppm >/dev/null; then
    echo "Install poppler-utils"
    exit 1
fi

xelatex statement_of_purpose.tex --quiet
pdftoppm statement_of_purpose.pdf statement_of_purpose -png

inotifywait -r -m -e modify statement_of_purpose.tex |
    while read -r file_path file_event file_name; do
        echo "${file_path}${file_name} event: ${file_event}"
        xelatex statement_of_purpose.tex --quiet
        pdftoppm statement_of_purpose.pdf statement_of_purpose -png
    done

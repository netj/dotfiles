#!/usr/bin/env bash
# latexmk might not be in PATH, so source bashrc to set it correctly
PATH=$(source ~/.bashrc; echo "$PATH")

# parse arguments
set -eu 
[ $# -ge 1 ] || { echo "Usage: latexmk.sh [pdf|ps|dvi] [clean|TEXFILE...]"; exit 2; }
fmt=$1; shift

# look for the main .tex file if none was given
if [ $# -eq 0 ]; then
    for f in *.tex.latexmain *.tex.project.vim; do
        [ -e "$f" ] || continue
        main=${f%.tex.*}.tex
        set -- "$main"
    done
fi

# just clean with latexmk
case $1 in
    clean)
        latexmk -c
        exit
        ;;
esac

# compile each input with latexmk, postprocessing its output to be friendly
# with Vim-LaTeX-Suite's errorformat: ) ( -> must be broken into separate lines
for input; do (
    cd "$(dirname "$input")"
    max_print_line=1024 \
        latexmk -$fmt -latexoption="    \
            -interaction=nonstopmode    \
            -file-line-error            \
            -synctex=1                  \
            " "$(basename "$input")" 2>&1|
        sed 's/)  *(/)\n(/g'
); done

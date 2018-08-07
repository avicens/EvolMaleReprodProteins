find . -type d -iname 'M0~*' -depth -exec bash -c 'mv "$1" "${1//~*/}"' -- {} \;


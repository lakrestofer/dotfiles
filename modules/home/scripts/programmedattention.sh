#!/bin/sh

# set -e # exit if any step has a nonzero exit code
# set -o pipefail # including in the middle of a pipe

# this script's purpose is to act as a tool to direct my attention
# towards stuff that I find important/want to do


zathura_db='/home/fincei/.local/share/zathura/bookmarks.sqlite'
document_dir='/home/fincei/vault/reference/reading'
DB='/home/fincei/vault/data/document.sqlite'

sqlite3 "$DB" <<EOF
CREATE TABLE IF NOT EXISTS document (
  path TEXT PRIMARY KEY,
  total_pages integer not null default 0,
  n_pages integer not null
);
EOF

input=$(ls $document_dir | fuzzel --dmenu)

if [[ -z "${input//[[:space:]]/}" ]]; then
  exit 0
fi

input="$document_dir/$input"

echo "$input"

result=$(sqlite3 $DB "select 1 from document where path = '$input' limit 1;")


if [[ -z "$result" ]]; then
  total_pages=$(pdfinfo "$input" | awk '/^Pages:/ {print $2}')
  echo "total pages: $total_pages"
  sqlite3 $DB "insert into document (path, total_pages) values ('$input', $total_pages)"
fi

# sqlite3 $zathura_db "select file,page,pages from fileinfo WHERE file LIKE '/home/fincei/vault/%' order by time desc limit 10"

# echo "$input"



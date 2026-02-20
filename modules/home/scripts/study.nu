#!/usr/bin/env nu
let DATA_DIR_PATH = $"($env.SPBASED_ROOT)/data"
let DOCUMENT_DB = "document.sqlite"
let DOCUMENT_DB_PATH = $"($DATA_DIR_PATH )/($DOCUMENT_DB)"

let DB_INIT_PATH = "~/dotfiles/home/scripts/study.sql"
let DB_INIT = open --raw $DB_INIT_PATH

def init [--force (-f)] {
  if (not $force) and ($DOCUMENT_DB_PATH | path exists) {
    return
  }
  let db = stor open
  $db | query db $DB_INIT | stor export --file-name $DOCUMENT_DB_PATH;
}

def main [] {
  init
}

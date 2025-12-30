#!/bin/bash
# menu.sh – CPS510 Assignment 5 main menu

OUTDIR=outputs
mkdir -p "$OUTDIR"

# Function: run one .sql file and save output
run_sqlfile() {
  local sqlfile="$1"
  local outfile="$OUTDIR/$(basename "$sqlfile" .sql).txt"
  echo "=== Running $sqlfile -> $outfile ==="
  sqlplus -S /nolog <<EOF > "$outfile"
connect $ORACLE_CRED
SET PAGESIZE 80
SET LINESIZE 150
SET FEEDBACK OFF
SET VERIFY OFF
PROMPT ----- Running: $sqlfile -----
@$sqlfile
EXIT;
EOF
  echo "Saved -> $outfile"
  echo "Last few lines of output:"
  tail -n 12 "$outfile"
  echo
  read -p "Press Enter to continue..."
}

# ---- optional placeholders for drop/create/populate ----
drop_tables()      { run_sqlfile drop_all.sql; }
create_tables()    { run_sqlfile create_tables.sql; run_sqlfile views.sql; }
insert_data()  { run_sqlfile insert_data.sql; }

# ---- submenu for queries ----
query_menu() {
  while true; do
    cat <<EOF
====================================================
Query Menu
====================================================
 1) Run q1.sql
 2) Run q2.sql
 3) Run q3.sql
 4) Run q4.sql
 5) Run q5.sql
 6) Run ALL queries (pause after each)
 0) Back to Main Menu
====================================================
EOF
    read -p "Choose: " opt
    case "$opt" in
      1) run_sqlfile q1.sql ;;
      2) run_sqlfile q2.sql ;;
      3) run_sqlfile q3.sql ;;
      4) run_sqlfile q4.sql ;;
      5) run_sqlfile q5.sql ;;
      6)
         for f in q1.sql q2.sql q3.sql q4.sql q5.sql; do
           run_sqlfile "$f"
         done
         ;;
      0) break ;;
      *) echo "Invalid option" ;;
    esac
  done
}

# ---- main loop ----
if [ -z "$ORACLE_CRED" ]; then
  echo "Please export ORACLE_CRED='username/password@oracle.scs.ryerson.ca'"
fi

while true; do
  cat <<EOF
====================================================
Assignment 5 Main Menu
====================================================
 1) Drop Tables/Views
 2) Create Tables & Views
 3) Populate Tables
 4) Query Tables (run advanced queries)
 5) Run demo (create → populate → run all queries)
 0) Exit
====================================================
EOF
  read -p "Choose: " opt
  case "$opt" in
    1) drop_tables ;;
    2) create_tables ;;
    3) populate_tables ;;
    4) query_menu ;;
    5)
       create_tables
       populate_tables
       for f in q1.sql q2.sql q3.sql q4.sql q5.sql; do
         run_sqlfile "$f"
       done
       ;;
    0) echo "Good-bye"; exit 0 ;;
    *) echo "Invalid option" ;;
  esac
done

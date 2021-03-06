#!/usr/bin/env bash
# Performance of sort vs hash
#

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump |gzip`
set -o pipefail
# Turn on traces, useful while debugging but commented out by default
# set -o xtrace
# verbose mode, Prints shell input lines as they are read.
# set -o verbose


# sort using -n built in parameter
time tr ' ' '\n' < file.txt | sort -nu > /dev/null

# Sort uniq uniq
time tr ' ' '\n' < file.txt |  sort | uniq > /dev/null

# Sort uniq hashing
declare -A items=()
time while IFS=' ' read -r item; do items[$item]=$item; done < file.txt
echo "${items[@]}"

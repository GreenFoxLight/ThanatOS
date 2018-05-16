#!/bin/sh

# Usage: <stage2.bin>
NBYTES=$(wc -c <"$1")
NSECS=$(echo ${NBYTES} | awk '{ if ($1 % 512 == 0) print $1 / 512; else print int($1 / 512) + 1 ;}')

echo "dw ${NSECS}"

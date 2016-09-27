#!/usr/bin/env bash

read -r -d '' USAGE <<_EoM

== USAGE ==
$0 <dye name>

Utility to link the appropriate dye files to use in the sampling calculations.

If ran without any argument, prints this notice and a list of the available dyes.

Bye Bye!
_EoM

rm -f toppar/dye.top toppar/dye.param

if [ $# -ne 1 ]
then
  echo "========================================="
  echo "==== List of available dye molecules ===="
  echo "========================================="
  counter=0
  for dye_top in $( ls toppar | egrep ".top$" | egrep -v "protein.top")
  do
    ((counter++))
    echo "  ${counter}.  ${dye_top%%.top}"
  done
  echo "========================================="
  echo
  echo "$USAGE"
  exit 1
else
  if [ ! -f toppar/${1}.top ]
  then
    echo "Error: dye molecule ($1) not found in toppar/"
    echo "Run this script without any arguments for help."
    echo
    exit 1
  else
    echo "Linking dye topology and parameters for ${1}"
    cd toppar
    ln -s ${1}.top dye.top
    ln -s ${1}.param dye.param
  fi
fi

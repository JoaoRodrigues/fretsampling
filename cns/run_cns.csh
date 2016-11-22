#!/usr/bin/env tcsh

# Dummy script to launch CNS

if (! $?CNS_SOLVE ) then
  echo '$CNS_SOLVE is not defined'
  exit 1
else
  if ( "$CNS_SOLVE" == "" ) then
    echo '$CNS_SOLVE is empty'
    exit 1
  else
    source /home/software/cns_solve_1.3-UU/cns_solve_env
  endif
endif

cns < $1

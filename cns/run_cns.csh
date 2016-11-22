#!/usr/bin/env tcsh

# Dummy script to launch CNS

#source /home/software/cns_solve_1.3-UU/cns_solve_env
source $HOME/software/cns_solve_1.3-UU/cns_solve_env

if (! $?CNS_SOLVE ) then
  echo '$CNS_SOLVE is not defined'
  exit 1
else
  if ( "$CNS_SOLVE" == "" ) then
    echo '$CNS_SOLVE is empty'
    exit 1
  endif
endif

cns < $1

#!/usr/bin/env bash

read -r -d '' USAGE <<_EoM

$0 [-n N] [-local] <pdb file> <dye name>

Creates an ensemble of models that sample possible orientations
of a dye molecule. The option -n allows you to specify the
number of models generated, by default 500.

The '-local' option launches the jobs on the local machine,
instead of using the 'qsub' queueing system as default.

_EoM

# Parse input from user

if [ "$#" -eq 0 ]
then
  echo "$USAGE" >&2
  exit 1
fi

n_models=500
local="False"
while test -n "$1"
do
  case "$1" in
    -n|-n_models)
      n_models="$2"
      shift 2
    ;;
    -local)
      local="True"
      shift 1
    ;;
    *)
      break
  esac
done

if [ "$#" -ne 2 ]
then
  echo "$USAGE"
  exit 1
else
  pdbFile="$1"
  dyeName="$2"
fi

# Make links for dye
./make_links.sh $2

# Make directory to store results
curTime=$( date "+%Y%m%d%H%M%S" )
runDir="run_${curTime}"
mkdir $runDir

# Make README file with parameters
echo "Initial File: $pdbFile" > ${runDir}/README
echo "Dye: $2" >> ${runDir}/README
echo "Number of models: $n_models" >> ${runDir}/README

#
# Copy input PDB file & patch
pdbBaseName=$( basename $pdbFile )
cp $pdbFile ${runDir}/${pdbBaseName}
cp dye_linkage.def  ${runDir}/
cp -r toppar ${runDir}/
cp cns/run_cns.csh ${runDir}/

# Make bundle of molecule and dye
cat $pdbFile | egrep '^ATOM' > ${runDir}/system.pdb
echo "TER" >> ${runDir}/system.pdb
cat molecules/dye.pdb | egrep '^ATOM' >> ${runDir}/system.pdb
echo "END" >> ${runDir}/system.pdb

# Create N sampler files
for n in $( seq 1 $n_models )
do
  echo "s/output_root=\"model\"/output_root=\"model_${n}\"/" > sed.temp
  echo "s/coordinate_infile=\"\";/coordinate_infile=\"system.pdb\";/" >> sed.temp
  echo "s/seed=66664;/seed=${RANDOM};/" >> sed.temp
  sed -f sed.temp cns/sample_dye.inp > ${runDir}/sample_dye_${n}.inp

  echo "#!/usr/bin/env bash" > ${runDir}/sample_dye_${n}.job
  echo "cd ${PWD}/${runDir}" >> ${runDir}/sample_dye_${n}.job
  echo "./run_cns.csh sample_dye_${n}.inp" >> ${runDir}/sample_dye_${n}.job
  chmod a+x ${runDir}/sample_dye_${n}.job
done
rm -f sed.temp

# Launch jobs to queueing system
cd $runDir
jobList=$( ls sample_dye_*job )
for job in $jobList
do
  if [ "$local" == "True" ]
  then
    ./${job}
  else
    qsub -q short $job
  fi
done

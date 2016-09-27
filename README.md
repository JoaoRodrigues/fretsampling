# Dye Sampling Protocol from Axel Brunger

## Description
This protocol uses CNS to sample the position of a dye (or any molecule really) that is covalently
attached to a particular residue in a protein. The dye is first placed next to its matching residue
with a simple rigid body energy minimization. Then the position of the dye is sampled via torsion
angle dynamics and simulated annealing. This protocol is described (minus the RBEM) in the CNS tutorial
webpage ([link](http://cns-online.org/v1.3/tutorial/fret/dye_simulations/text.html)).

## Usage
1. Run `make_links.sh` to link the appropriate dye parameters in the `toppar` folder.

2. Edit `sample_dye.inp` at the following points:

    line  23: coordinate_infile => the name of the PDB file with your molecule (and dye).

    line 114: atom_fixed => define a selection of atoms that are to be kept fixed during the sampling.

    line 196: num_trials => define the number of models to generate.


3. Edit `dye_linkage.def` to define the attachment point of the dye.

4. Run `cns < sample_dye.inp`. The models will be deposited in the `models/` folder.

## Questions
Feel free to send me an e-mail if you have any Qs on the code/usage: joaor@stanford.edu

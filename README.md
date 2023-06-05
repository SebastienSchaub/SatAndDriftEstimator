# SatAndDriftEstimator

## Goal

Estimate Saturation and Correct Z Drift for visualization


It uses great tools :
- Bioformats from OME (Open Microscopy Environnement)
 http://www.openmicroscopy.org/bio-formats/
- inpaint_nans  from John D'Errico
 https://fr.mathworks.com/matlabcentral/fileexchange/4551-inpaint_nans?s_tid=srchtitle
 
## How to use

lanches SatAndDriftEstimator.m then follow the 2 steps that you can apply or skip 
- Estimates the saturated pixels (based on inpaint_nans
- Align the Stack due to Z drift. 

The newly calculated Stack is saved in the orginal stack folder with suffix "Mod.tif"

## references

- SatAndDriftEstimator has been published in ..., ***Paper under submission, TO BE UPDATED***

- for information contact sebastien.schaub@imev-mer.fr

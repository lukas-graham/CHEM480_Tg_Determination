# **A High-Throughput Methodology for Tg Estimation in Semiconducting Polymers**
2 examples are included in the ‘Examples’ folder from the group of 15 SCPs used in this study: TIFBT and DPP1T. Their coordinate information is contained in the .gro file, and force field information is in the .itp file. The .top file contains the topology which links the .gro and .itp files. The tables described by the input .xvg files represent custom bonded interactions. All scripts are available in the “Scripts” folder.
The following describes the method used for Tg determination of SCPs using Anaconda3 2022.10 and GROMACS Cuda 2022:
## 1)	Temperature Annealing NPT Simulation
-	Input files: tg.mdp, “polymer”.gro, “polymer”.top, “table”.xvg
-	Run.sh
-	Output: tg.tpr, tg.edr
## 2)	VT data extraction
-	Input: tg.edr
-	Gmx energy -f tg.edr -o tg.xvg
-	Output: tg,xvg
## 3)	VT data analysis
-	Input: tg.xvg
-	VT_asymptote.ipynb
-	VT_hyperbola.ipynb
-	Output: Tg estimation
## 4)	MSD data extraction
-	Input: tg.tpr
-	Msdcalc.sh
-	Tempavg.sh
-	Output: msd.dat + avgtemp.dat -> temp_vs_MSD.dat
## 5)	MSD data analysis
-	Input: temp_vs_MSD.dat
-	MSD_asymptote.ipynb
-	MSD_hyperbola.ipynb
-	Output: Tg estimation

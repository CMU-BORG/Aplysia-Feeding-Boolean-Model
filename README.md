# Aplysia-Feeding-Boolean-Model
Discrete time, discrete state representation of Aplysia central pattern generator for multifunctional feeding behavior, coupled to continuous, (relatively) low biomechanics.  


Authors:

Vickie Webster Wood, CMU.

Peter Thomas, CWRU.

Jeff Gill, CWRU.

in consultation with Hillel Chiel, CWRU.



Last Update: 8/10/2020

This Model contains two MATLAB .m files for simulating Aplysia-like multifunctional feeding behavior. The two files are as follows:

1. AplysiaFeeding_driver.m

This file is the driver function which contains code sections for running the following behaviors

	A. Biting
	B. Swallowing
	C. Rejection
	D. Swallowing seaweeds of varying strength
	E. Transitions from swallowing to Rejection
	F. Transitions from biting to swallowing
	G. Stimulation of the B4/B5 interneuron during swallowing
	
AplysiaFeeding_driver.m uses the AplysiaFeeding class to create an aplysia object and perform simulation and plotting tasks.
	
2. AplysiaFeeding.m

This file is a class to establish, run, and plot the hybrid Boolean/continuous model of the Aplysia feeding circuitry and biomechanics.



------------------------------------------------------------------------------------------------------------------
To generate figures 11-13, open the AplysiaFeeding_driver.m file. Initialize the AplysiaFeeding object (line 9) and run sections A-F. Make sure that the variable aplysia.use_hypothesized_connections = 0.

To generate figure 14, open the AplysiaFeeding_driver.m file. Initialize the AplysiaFeeding object (line 9) and run sections G. Make sure that the variable aplysia.use_hypothesized_connections = 1.



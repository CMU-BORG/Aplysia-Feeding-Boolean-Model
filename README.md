# Aplysia-Feeding-Boolean-Model
Discrete time, discrete state representation of Aplysia central pattern generator for multifunctional feeding behavior, coupled to continuous, (relatively) low biomechanics.  


Authors:

Vickie Webster Wood, CMU.

Peter Thomas, CWRU.

in consultation with Hillel Chiel, CWRU.

in consultation with Jeff Gill, CWRU

Last Update: 7/10/2020

This Model contains three MATLAB .m files for simulating Aplysia-like multifunctional feeding behavior. The three files are as follows:

1. Multibehavior_driver_withfrictionImplicit.m

This file is the driver function which contains code sections for running the following behaviors

	A. Biting
	B. Swallowing
	C. Rejection
	D. Swallowing seaweeds of varying strength
	E. Transitions from swallowing to Rejection
	F. Transitions from biting to swallowing
	G. Stimulation of the B4/B5 interneuron during swallowing
	
Multibehavior_driver_withfrictionImplicit.m call two helper functions:
	
2. Aplysia_boolean_model_withfrictionImplicit.m

This file is the hybrid Boolean/continuous model of the Aplysia feeding circuitry and biomechanics.


3. Plot_behavior.m

This is a helper function to plot the neural activity, relative grasper position, and force on the seaweed following simulation of a given behavior



------------------------------------------------------------------------------------------------------------------
To generate figures 11-13, open the Aplysia_boolean_model_withfrictionImplicit.m file and ensure that the code for CBI-2 and CBI-3 is using the lines for the %without hypothesized connections sections. Run Multibehavior_driver_withfrictionImplicit.m

To generate figure 14, comment our the %without hypothesized connections lines and uncomment the %with hypothesized connections codes to enable these connections. Run Multibehavior_driver_withfrictionImplicit.m



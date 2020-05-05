# Aplysia-Feeding-Boolean-Model
Discrete time, discrete state representation of Aplysia central pattern generator for multifunctional feeding behavior, coupled to continuous, (relatively) low biomechanics.  


Authors:

Vickie Webster Wood, CMU.

Peter Thomas, CWRU.

in consultation with Hillel Chiel, CWRU.

in consultation with Jeff Gill, CWRU

Last Update: 5/4/2020

This Model contains three MATLAB .m files for simulating Aplysia-like multifunctional feeding behavior. The three files are as follows:

1. Multibehavior_driver.m

This file is the driver function which contains code sections for running the following behaviors

	A. Biting
	B. Swallowing
	C. Rejection
	D. Swallowing seaweeds of varying strength
	E. Transitions from swallowing to Rejection
	F. Transitions from biting to swallowing
	G. Stimulation of the B4/B5 interneuron during swallowing
	
Multibehavior_driver.m call two helper functions:
	
2. Aplysia_boolean_model.m

This file is the hybrid Boolean/continuous model of the Aplysia feeding circuitry and biomechanics.

3. Plot_behavior.m

This is a helper function to plot the neural activity, relative grasper position, and force on the seaweed following simulation of a given behavior



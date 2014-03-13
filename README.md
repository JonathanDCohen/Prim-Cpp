Jon-Cohen-Code-Sample
=====================

Matlab and shell script code samples related to Besov image denoising

The important files are BesovChambollePock.m, findMus.m and decomp.sh

BesovChambollePock is the entry point for Besov image denoising as described in the upcoming paper "Pointwise Image Denoising in Besov Spaces" by Buzzerd, Chambolle, Cohen, Levine, and Lucier.  

findMus.m is the implementation of the algorithm I contributed to the project.  It projects a sequence of vector fields onto the unit norm ball in the dual to the function space B^1_inf(L1) by finding the root of an implicity defined function mapping a KKT variable, nu, to a sequence of limiters, mu.  This algorithm runs in log time, whereas the previous algorithm used when I entered the project ran in quadratic time, and switchin in this algorithm cut our running time from about 10 hours to about 30 seconds, depending on image size. 

decomp.sh is a shell script I wrote for testing the image denoising and related image decomposition algorithms remotely, without having to keep a connection to Duquesne's cluster.  It asks the user for the testing parameters and writes a matlab script which calls a pre-written decomposition test script, using each of the parameters in turn.  The scripts are called using nohup to run in the background.

Jon-Cohen-Code-Sample
=====================

Matlab and C++ code samples.

The important files in the Besov Denoising folder are BesovChambollePock.m and findMus.m

besovChambollePock is the entry point for Besov image denoising as described in the upcoming paper "Pointwise Image Denoising in Besov Spaces" by Buzzerd, Chambolle, Cohen, Levine, and Lucier.  A test image, girl-noisy-16.pgm is included, and the default paramters for the function are fairly suitable for that image. 

findMus.m is the implementation of the algorithm I contributed to the project.It projects a sequence of vector fields onto the unit norm ball in the dual to the function space B^1_inf(L1) in O(j*log N) time, where j is the number of image scales being considered and N is the number of pixels in the image.  This is opposed to the algorithm being used when I first started on the project which ran in O(j*N^2) time. 

The C++ project in the Minimum Spanning Tree folder are an implementation of Prim's Algorithm using an adjacency list and priority queue.  It was originally intended as a response to [this programming challenge](http://www.reddit.com/r/dailyprogrammer/comments/20cydp/14042014_challenge_152_hard_minimum_spanning_tree/) on the dailyprogrammer subreddit, but I decided to clean it up for use here, sticking more or less to the Google C++ coding standards.  The code was not submitted for the challenge so there is no cunfusion about whether or not the code is actually mine.  It has been tested to compile cleanly with the command g++ *.cpp --std=c++11 -stdlib=libc++ -Wall on Mac OSX (make sure it compiles on Ububntu as well) using gcc4.7, and takes a filename containing the proper input as an argument.  The file "challenge.txt" contains the challenge input from the original programming challenge on reddit.

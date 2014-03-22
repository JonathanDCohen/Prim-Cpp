Jonathan-Cohen-Code-Sample
=====================

C++ code sample.

The C++ project is an implementation of Prim's Algorithm using an adjacency list and priority queue.  It was originally intended as a response to [this programming challenge](http://www.reddit.com/r/dailyprogrammer/comments/20cydp/14042014_challenge_152_hard_minimum_spanning_tree/) on the dailyprogrammer subreddit, but I decided to clean it up for use here, sticking more or less to the Google C++ coding standards.  The code was not submitted for the challenge so there is no confusion about whether or not the code is actually mine.  It has been tested to compile cleanly with the command g++ *.cpp --std=c++11 -stdlib=libc++ -Wall on Mac OSX (make sure it compiles on Ububntu as well) using gcc4.7, and takes a filename containing the proper input as an argument.  The file "challenge.txt" contains the challenge input from the original programming challenge linked to above.

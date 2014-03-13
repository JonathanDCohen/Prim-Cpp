#!/usr/bin/env bash

#Creates a matlab test file for testing Besov image decomposition
#for running remotely in the background.  This way I don't need to
#maintain a connection to the cluster while tests are running.

if [ "$1" = "help" ]; then
	echo "usage: sh decomp.sh."
	echo "creates and runs a matlab script in the background using nohup"
	echo "Make sure to include the extension in the image file name"
	exit
fi

#read in command line arguments
####################################################################


echo "Image file name?"
read cleanImageName

echo "prefix for test result naming?"
read imPrefix

echo "noise standard deviation?"
read sigma

echo "Decomposition Type?"
read decompType

echo "How many lambdas to test?"
read numLambdas

echo "Enter each lambda on it's own line"
lambdaName=""
muName=""

for ((i=0; i<$numLambdas; i++))
do
	read lambdas[i]
	lambdaName="$lambdaName-${lambdas[i]}"
done

echo "number of mus?"
read numMus

echo "Enter each on it's own line"
for((i=0; i<$numMus; i++))
do
	read mus[i]
	muName="$muName-${mus[i]}"
done

####################################################################

#build script
####################################################################
rm decomp.m
echo "function decomp" >> decomp.m
echo "im = imread('$cleanImageName');" >> decomp.m
echo "lambdas = [${lambdas[@]}];" >> decomp.m
echo "mus = [${mus[@]}];" >> decomp.m
echo "decompScript(im, '$imPrefix', $sigma, '$decompType', mus, lambdas);" >> decomp.m
####################################################################

#run script in the background

nohup matlab -nosplash -nodisplay < decomp.m >> decomp-mus$muName-lambdas$lambdaName.txt  &

cat decomp.m >> decomp-mus$muName-lambdas$lambdaName.txt
echo "------" >> decomp-mus$muName-lambdas$lambdaName.txt


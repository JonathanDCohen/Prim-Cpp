function [out mu] = limiterF(nu, nuj, muj)
%Calculates function F of nu for which we are trying ot find a root.  F is
%the sum of the limiters mu induced by KKT variable nu, minus 1.  The
%limiters are defined implicitly and are calculated through a modified
%binary search method and a linear interpolation in between entries in muj.
%
%INPUTS
%   nu - KKT variable which is a potential root of F.
%   nuj - list of "guide points" which are the value of nu inducing the
%       corresponding entries in muj.
%   muj - sorted vector fields which correspond to "guide points" for
%   limiter values.  The map from nu to mu is piecewise linear.
%
%OUTPUS
%   out - function value of F at nu
%   mu - the set of limiters induced by nu
%
%Code by Jonathan Cohen, Duquesne University, April 2013

jMax = size(nuj, 2);
mu = zeros(1, jMax);
for j = 1:jMax
    if nu >= nuj(end, j)
        continue
    end
       
    index = binarySearch(nuj(:, j), nu);
    mu(j) = linInterp(nu, nuj(index, j), nuj(index + 1, j), ...
                          muj(index, j), muj(index + 1, j));
end
out = sum(mu) - 1;
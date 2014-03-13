function [u, v] = besovCartoonTexture(f, mu, lambda, err)
%Uses Besov regularization to perform cartoon/texure decomposition on input
%image f as in Aujol et al, 2005.
%
%INPUTS:
%   f - image to be decomposed.  F is uint8 [0,255]
%   mu - unnormalized Lagrange multiplier for finding v.
%   lambda - unnormalized Lagrange multiplier for finding u.
%   err - error bound for stopping criteria for each denoising iteration
%
%OUTPUTS:
%   u - smooth image
%   v - texture image
%
%Code by Jonathan Cohen, Duquesne University, March 2013.

if nargin < 4
    err = .25;
end
if (nargin < 3) || (nargin > 4)
    error('Incorrect number of inputs');
end

u = zeros(size(f));
v = zeros(size(f));
oldU = inf(size(f));
oldV = inf(size(f));

while max(Lp(u - oldU, 2), Lp(v - oldV, 2)) > .01
    oldV = v;
    v = - besovChambollePock(f - u, mu, err) + f - u;

    oldU = u;
    u = besovChambollePock(f - v, lambda, err);
end

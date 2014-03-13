function y = linInterp(x, x0, x1, y0, y1)
%Unsafe linear interpolation.  Avoids the overhead of Matlab's interp1
%function.  This should not be used for general purpose linear
%interpolation
%
%INPUTS
%   x - value at which to calculate the interpolation
%   x0, x1 - x values in between which to interpolate
%   y0, y1 - function values at x0 and x1
%
%OUTPUTS
%   y - interpolated function value.  This is exactly the value of a
%   specific limiter mu_j at input nu, as shown by the KKT conditions.
%
%Code by Jonathan Cohen, Duquesne Unversity, April 2013
y = y0 + (y1 - y0) * (x - x0) / (x1 - x0);
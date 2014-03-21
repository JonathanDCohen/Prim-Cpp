function out = besovChambollePock(im, lambda, errBound)
%[OUT] = BESOVCHAMBOLLEPOCK(IM, LAMBDA, NOTIFY) denoises the noisy input
%image by minimizing the functional ||out - im|| + lambda *
%|out|(B^1_inf(L1)), as in Buzzerd, Chambolle, Cohen, Levine, and Lucier,
%"Pointwise Besov Space Smoothing of Images", using the Chambolle-Pock
%primal-dual method.
%
%INPUTS:
%   im: noisy image to be cleaned.  It must be integer valued from 0 to 255
%   lambda: unnormalized Lagrange multiplier.  Default is 12.
%   errBound: Stopping criterion in the number of gray scales of squared
%       error.  Default is .5
%OUTPUTS:
%   out: cleaned ouput image
%
%Code written by Jonathan Cohen, Duquesne University, April 2013
%Most recent update by Jonathan Cohen, February 2014

% - * - PREPROCESSING - * - %

% - Check Inputs - %
if isinteger(im)
    x = double(im);
    imIsInt = true;
else
    error('image should be integer valued from 0 to 255');
end

if nargin < 3
    errBound = 0.5;
end
if nargin < 2
    lambda = 12;
end
if (nargin < 1) || (nargin > 3)
    error('Invalid input.')
end

% - Initializations - %
MAXSCALES = 30;                 % Maximum allowed number of scales
jmax = 4;                       % Initial working number of scales
zmin = 4;                       % Minimum maintained number of zero scales

[M, N] = size(x);
hHorz = 1/N;                            %\
hVert = 1/M;                            %-Grid Sizes    
hDiag = sqrt(hHorz^2 + hVert^2);        %/
L = 3*pi/sqrt(hHorz*hVert);             % Operator norm of K

lambda = sqrt(hHorz*hVert) * lambda;    % Normalized Lagrange Multiplier
gamma = 1/lambda;                       % Constant of Uniform Convexity
tau = 1024 / (gamma);                   % Primal Step Size
sigma = 1 / (L^2 * tau);                % Dual Step Size    


x = padarray(x, 2*[MAXSCALES MAXSCALES], 'symmetric');      %Primal variable
x0 = x;                                                     %Holds input image for threshold operation
xbar = x0;                                                  %Linear Extrapolation result used in Dual step
y = zeros(M + 2*MAXSCALES, N + 2*MAXSCALES, 4, MAXSCALES);  %Dual variable

%Convolution masks for computing 2nd gradient and divergence
mask = buildMask(MAXSCALES, hVert, hHorz, hDiag); 

inIters = 10;
err = inf;

% - * - MAIN LOOP - * - %
while err > errBound
    for inner = 1:inIters
        
    % - Update vector fields - %
        for scale = 1:jmax
            for dim = 1:4
                z = conv2(xbar, mask{dim, scale}, 'valid');
                z = z((MAXSCALES + 1 - scale):(end - MAXSCALES + scale),...
                    (MAXSCALES + 1 - scale):(end - MAXSCALES + scale));
                y(:, :, dim, scale) = y(:, :, dim, scale) + sigma*z;
            end
        end

    % - Project onto the Besov dual-space unit ball - %
        yMags = sqrt(sum(y .^ 2, 3));
        
        % Sort the magnitudes, find limiters, and project to the dual unit ball %
        muj = sort(...
            reshape(yMags((MAXSCALES + 1):(end - MAXSCALES), ...
                          (MAXSCALES + 1):(end - MAXSCALES), 1:jmax), M*N, jmax), 'descend');
        mu = findMus(muj);

        for scale = 1:jmax
            mults = min(1, mu(scale) ./ yMags(:, :, scale));
            for dim = 1:4
                y(:, :, dim, scale) = y(:, :, dim, scale) .* mults;
            end
        end

    % - Update output image - %
    
        % Find x - tau * K'y %
        div = zeros(M, N);
        for scale = 1:jmax
            for dim = 1:4
                z = conv2(y(:, :, dim, scale), mask{dim, scale}, 'valid');
                div = div + z((MAXSCALES + 1 - scale):(end - MAXSCALES + scale),...
                    (MAXSCALES + 1 - scale):(end - MAXSCALES + scale));
            end
        end

        %Update extrapolation parameter 
        theta = 1/sqrt(1 + 2*gamma*tau);     
        xbar = -theta * x;
        
        % Find new guess for output image %
        x = x - tau * padarray(div, 2*[MAXSCALES MAXSCALES], 'symmetric');

        %Linearly extrapolate for next iteration %
        xbar = xbar + (1 + theta) * x;
        
        %Update Step Sizes
        tau = theta * tau;
        sigma = sigma / theta;
    end
    
% - Update working number of scales - %
    scale = jmax;
    numZeroScales = 0;
    while(mu(scale) == 0)
        numZeroScales = numZeroScales + 1;
        scale = scale - 1;
    end   
    jmax = min(jmax + zmin - numZeroScales, MAXSCALES);
    
% - Check Error Bound - %
    err = errorCheck(x0, x, y, div, lambda, .5*(hHorz + hVert), jmax, mask)
end

% - OUTPUT - %
out = x((2*MAXSCALES + 1):(end - 2*MAXSCALES), (2*MAXSCALES + 1):(end - 2*MAXSCALES));

if imIsInt
    out = uint8(out);
end




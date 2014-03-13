function err = errorCheck(x0, x, y, div, lambda, h, jMax, mask)
%Checks the A posteriori error bound in the denoising iterations:
%|x-x^*|^2 <= 2*lambda(F(Kx)-<Kx,y>) + |x+lambda * K^*y-x^0|^2, obtained
%from the duality gap.  In this case, K is the second gradient operator and
%K* its dual, the second divergence operator.
%
%INPUTS
%   x0 - input image
%   x - current primal variable
%   y - current dual variable
%   div - second divergence of y
%   lambda - Lagrange multiplier
%   h - gemoetric mean of grid sizes
%   jMax - number of working scales
%   mask - cell array of convolution masks
%
%OUTPUTS
%   err - Upper bound error approximation
%
%Code by Jonathan Cohen, Duquesne University, April 2013

MAXSCALES = size(mask, 2);

% - Find Kx - %
Kx = zeros(size(y));
for scale = 1:jMax
    for dim = 1:4
        z = conv2(x, mask{dim, scale}, 'valid');
        z = z((MAXSCALES + 1 - scale):(end - MAXSCALES + scale),...
              (MAXSCALES + 1 - scale):(end - MAXSCALES + scale));
        Kx(:, :, dim, scale) = z;
    end
end

% - Strip padding - %
x = x((2*MAXSCALES + 1):(end - 2*MAXSCALES), (2*MAXSCALES + 1):(end - 2*MAXSCALES));
x0 = x0((2*MAXSCALES + 1):(end - 2*MAXSCALES), (2*MAXSCALES + 1):(end - 2*MAXSCALES));
y = y((MAXSCALES + 1):(end - MAXSCALES), (MAXSCALES + 1):(end - MAXSCALES), :, :);
Kx = Kx((MAXSCALES + 1):(end - MAXSCALES), (MAXSCALES + 1):(end - MAXSCALES), :, :);

% - Calculate Error Bound - %
% Estimate dual error %
%                     v------------|Kx|(B^1_inf(L1))-----------v
dual = 2*lambda*h^2*(max(sum(sum(sqrt(sum(Kx .^ 2, 3)), 1), 2), [], 4) ...
                      - sum(sum(sum(sum(Kx .* y, 3)))))
%                       ^----------<Kx, y>-----------^
                       
% Estimate primal error %
primal = h^2*norm(x + lambda * div - x0, 'fro')^2

err = sqrt(dual + primal);
function mu = findMus(muj)
%MU + FINDMUS(MUJ) finds limiters for projecting onto the unit bal in the
%dual space to B^1_inf(L1).  See Section 6 in Buzzard, Chambolle, Cohen,
%Levine, and Lucier "POINTWISE BESOV SPACE SMOOTHING OF IMAGES"
%
%INPUTS
%   muj - sorted vector field magnitudes.  Each column is a single vector
%   field
%Code by Jonathan Cohen: Duquesne University, April 2013

%Check if vector fields are already in the unit ball
mu = muj(1, :);
if sum(mu) <= 1
    return
end

% --- *** --- PREPROCESSING --- *** --- %
[Nsqd, jMax] = size(muj);
err = 1e-10;

% Calculate Discrete Nu's %
muj = [muj; zeros(1, jMax)];
l = repmat((0:Nsqd)', 1, jMax); %(a:b) is a row vector
cSum = [zeros(1, jMax); cumsum(muj(1:(end-1), :))];
nuj = cSum - l .* muj;

% Initialize bracketing values for Ridders' Method %
nu1 = 0;           
nu2  = max(nuj(:)); 
fNu1 = sum(mu) - 1; 
fNu2 = -1;
fNu4 = inf;

% --- *** --- MAIN LOOP --- *** --- %
while abs(fNu4) > err
    % Update nu using Ridders' Method %
    nu3 = .5*(nu1 + nu2);
    fNu3 = limiterF(nu3, nuj, muj);

    nu4 = nu3 + (nu3 - nu1) * fNu3 / sqrt(fNu3^2 - fNu1*fNu2);
    [fNu4, mu] = limiterF(nu4, nuj, muj);

    % Re-bracket the true nu %
    if fNu4 > 0
        nu1 = nu4;
        fNu1 = fNu4;
        if fNu3 < 0
            nu2 = nu3;
            fNu2 = fNu3;
        end
    elseif fNu4 < 0
        nu2 = nu4;
        fNu2 = fNu4;
        if fNu3 > 0
            nu1 = nu3;
            fNu1 = fNu3;
        end
    end

end




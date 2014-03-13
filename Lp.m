function out = Lp(im, p)
if isfinite(p)
    out = sum(sum((abs(double(im)) .^ p)/numel(im))) ^ (1/p);
elseif p > 0
    out = max(max(abs(double(im))));
else 
    out = min(min(abs(double(im))));
end
function decompScript(im, imName, sigma, type, mus, lambdas)
%{
Tests cartoon-texture decompositions of image im, both with and without
added noise, with various values of Lagrange Multipliers.  Saves resultant
images both as full-contrast viewable images and csv files of the raw data.
Adds all created files to a zip file so they can be sent to collaborators.

Created October 2013, Jon Cohen, Duquesne University
The Goo Goo Dolls were on at the completion of this script.
%}


imn = imnoise(im, 'gaussian', 0, (sigma/255)^2);

imwrite(im, strcat(imName, '_128.tif'));
imwrite(imn, strcat(imName, '_128_sigma_', num2str(sigma), '.tif'));

files = {strcat(imName, '_128.tif'), strcat(imName, '_128_sigma_', num2str(sigma), '.tif')};

if nargin < 5
    mus = [.01 .1 1 10 20 40];
    if strcmp(type, 'Besov - G')
        mus = 1./ mus;
    end

    lambdas = [.1 1 10 20 40 80];
end

for mu = mus
    for lambda = lambdas
        disp(imName)
        
        disp(strcat('Mu: ', num2str(mu), ' Lambda: ', num2str(lambda), ...
            'Sigma: ', num2str(sigma)))

        [un vn] = decompose(imn, mu, lambda,...
            makeFileName(imName, 'log', mu, lambda, sigma), type);
        
        disp(strcat('Mu: ', num2str(mu), ' Lambda: ', num2str(lambda)))

        [u v] = decompose(im, mu, lambda,...
            makeFileName(imName, 'log', mu, lambda, false), type);
        
        files = writeStuff(files, imName, u, v, im, mu, lambda, false);
        files = writeStuff(files, imName, un, vn, imn, mu, lambda, sigma);
    end
end

zip(strcat('BBstarTest_', imName, '.zip'), files);

end



function files = writeStuff(files, imName, u, v, f, mu, lambda, sigma)
    if nargin == 7
        sigma = false;
    end

    res = double(im2uint8(mat2gray(f))) - double(u) - double(v);

    names.u = makeFileName(imName, 'u', mu, lambda, sigma);
    names.v = makeFileName(imName, 'v', mu, lambda, sigma);
    names.res = makeFileName(imName, 'res', mu, lambda, sigma);

    %First write decompositions to image files
    imwrite(im2uint8(mat2gray(u)), strcat(names.u, '.tif'));
    imwrite(im2uint8(mat2gray(v)), strcat(names.v, '.tif'));
    imwrite(im2uint8(mat2gray(res)), strcat(names.res, '.tif'));

    %Then save raw data just in case
    csvwrite(strcat(names.u, '.csv'), u);
    csvwrite(strcat(names.v, '.csv'), v);
    csvwrite(strcat(names.res, '.csv'), res);

    %And then save filenames for reference in making zip file
    varNames = fieldnames(names);
    for i = 1:length(varNames)
        files = horzcat(files, strcat(names.(varNames{i}), '.tif'), ...
                                 strcat(names.(varNames{i}), '.csv'));
    end
    files = horzcat(files,... 
        strcat(makeFileName(imName, 'log', mu, lambda, false), '.txt'), ...
        strcat(makeFileName(imName, 'log', mu, lambda, sigma), '.txt'));
end



function fileName = makeFileName(imName, varName, mu, lambda, sigma)
    fileName = strcat(imName, '_', varName, '_mu_', num2str(mu),... 
        '_lambda_', num2str(lambda), sigmaWrite(sigma));
end



function sigStr = sigmaWrite(sigma)
    if sigma
        sigStr = strcat('_sigma_', num2str(sigma));
    else
        sigStr = '';
    end
end



function [u v] = decompose(f, mu, lambda, title, type)
    if strcmp(type, 'Besov - Dual Besov')
        [u v] = BesovCartoonTexture(f, mu,lambda, .25, title);
    elseif strcmp(type, 'Besov - G')
        [u v] = BesovGCartoonTexture(f, mu, lambda, .25, title);
    else
        error('Use either "Besov - Dual Besov" or "Besov - G"')
    end
end

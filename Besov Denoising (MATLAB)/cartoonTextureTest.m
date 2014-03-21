function cartoonTextureTest

imn = imread('girl-noisy-16.pgm');

ml = [.00390625 .015625
.0078125 .0078125
.0078125 .015625
.015625 .0078125
.015625 .03125
.015625 .0625
.03125 .0078125
.03125 .01171875
.046875 .01171875
.046875 .015625
.0625 .0078125]'; 

for mulam = ml
   filename = strcat('girl-noisy-16-', num2str(mulam(1)), '-', num2str(mulam(2)));
   [u v] = besovCartoonTexture(imn, mulam(1)*512, mulam(2)*512, 16, filename);
   imwrite(u, strcat(filename, '-u'), 'png');
   imwrite(v, strcat(filename, '-v'), 'png');
end
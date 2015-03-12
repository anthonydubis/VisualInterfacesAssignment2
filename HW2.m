
% Number of segments to divide 255 channel into - bins = segments^3
num_segments = 6;

img = imread('ppm/i01.ppm');
hist = getColorHistogram(img, num_segments)
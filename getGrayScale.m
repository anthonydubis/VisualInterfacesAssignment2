function [ gray ] = getGrayScale( img )
% Returns the grayscale of an image 
% Might want to try using MATLAB's rgb2gray() function

% OPTION 1
% gray = rgb2gray(img);

% OPTION 2
sz   = size(img);
imgD = double(img);
gray = zeros(sz(1), sz(2));

for i=1:sz(1)
    for j=1:sz(2)
        gray(i,j) = (imgD(i,j,1) + imgD(i,j,2) + imgD(i,j,3)) / 3;
    end
end
        
end


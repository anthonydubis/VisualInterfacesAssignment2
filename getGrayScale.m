function [ gray ] = getGrayScale( img )
% Returns the grayscale of an image 
% Might want to try using MATLAB's rgb2gray() function

% OPTION 1
gray = rgb2gray(img);

% % OPTION 2
% sz    = size(img);
% img16 = int16(img);
% gray  = zeros(sz(1), sz(2));
% 
% for i=1:sz(1)
%     for j=1:sz(2)
%         gray(i,j) = (img16(i,j,1) + img16(i,j,2) + img16(i,j,3)) / 3;
%     end
% end
% 
% % I'm not sure why this extra step is needed to display the gray images
% % properly. Use off the shelf rgb2gray for now.
% gray = gray / 255;
        
end


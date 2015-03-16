function [ hist ] = getNormalizedColorHistogram( img, sgmts )
% getColorHistogram takes in a color image and returns a 3D histogram made
% up of a number of bins (sgmts^3)
% img   = the 3D array representing RGB colors at each pixel of an image
% sgmts = the number of segments each color component (rgb) is broken into
% hist  = the histogram with pixel counts per bin

hist       = zeros(sgmts, sgmts, sgmts);
channels   = 255;
sgmt_len   = channels / sgmts;
img_size   = size(img);
sig_pixels = 0;

for i=1:img_size(1)
    for j=1:img_size(2)
        % Find rbg segments for pixels and increment their bin in hist
        % Max the value was 1 to handle cases where pixel value is 0
        rs = max(ceil(img(i, j, 1) / sgmt_len), 1);
        gs = max(ceil(img(i, j, 2) / sgmt_len), 1);
        bs = max(ceil(img(i, j, 3) / sgmt_len), 1);
        
        % Ignore pixels that are almost completely black - the "first" bin
        if rs > 1 || gs > 1 || bs > 1
            hist(rs, gs, bs) = hist(rs, gs, bs) + 1;
            sig_pixels = sig_pixels + 1;
        end
    end
end

hist = hist/sig_pixels;

end


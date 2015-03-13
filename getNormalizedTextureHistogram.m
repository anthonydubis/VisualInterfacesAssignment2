function [ hist ] = getNormalizedTextureHistogram( laplacian, bins )
%{
This function will return the normalized texture histogram for a given
laplacian image. 

laplacian = the laplacian image passed in
bins      = number of bins
hist      = the normalized texture histogram 
%}

laplacian = abs(laplacian);
sz        = size(laplacian);
hist      = zeros(1, bins);
total     = 0;
max_val   = 255*8;
bin_range = max_val / bins;

for i=1:sz(1)
    for j=1:sz(2)
        val = laplacian(i,j);
        if val ~= 0
            total = total + 1;
            bin = ceil(val / bin_range);
            hist(bin) = hist(bin) + 1;
        end
    end
end

hist = hist / total;

end


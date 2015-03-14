function [ hist ] = getNormalizedTextureHistogram( laplacian, bins, max )
%{
This function will return the normalized texture histogram for a given
laplacian image. 

laplacian = the laplacian image passed in
bins      = number of bins
hist      = the normalized texture histogram 
%}

sz        = size(laplacian);
hist      = zeros(1, bins);
total     = 0;
bin_range = max / bins;

for i=1:sz(1)
    for j=1:sz(2)
        val = laplacian(i,j);
        if val ~= -1
            total = total + 1;
            if (val == 0)
                hist(1) = hist(1) + 1;
            else
                bin = ceil(val / bin_range);
                hist(bin) = hist(bin) + 1;
            end
        end
    end
end

hist = hist / total;

end


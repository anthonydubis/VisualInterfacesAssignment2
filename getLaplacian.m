function [ result, max_val ] = getLaplacian( gray )
% This function takes in a grayscale image and returns its Laplacian
% Background pixels (grayscale < thresh) are assigned 0 as their value

sz = size(gray);
result = zeros(sz);
threshold = 45;
max_val = 0;

for i=1:sz(1)
    for j=1:sz(2)
        if gray(i,j) < threshold
            result(i,j) = -1;
            continue;
        else
            val = getValue(gray, i, j);
            result(i,j) = val;
            max_val = max(max_val, val);
        end
    end
end

end

function val = getValue(gray, row, col)
sz = size(gray);
val = 0;
n_neighbors = 0;

for i=(row-1):(row+1)
    for j=(col-1):(col+1)
        if i < 1 || i > sz(1) || j < 1 || j > sz(2)
            continue;
        else
            n_neighbors = n_neighbors + 1;
            val = val - gray(i,j);
        end
    end
end

val = val + (gray(row,col) * n_neighbors);
val = abs(val);
end


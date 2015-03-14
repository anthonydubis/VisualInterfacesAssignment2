function [ ] = printResultsWithImages( results, images)
%{
This function prints the results using the provided images. It formats the
prints to have five rows and the same number of columns as results.
%}

[rows, cols] = size(results);
for i=1:rows
    if (mod(i-1,5) == 0) figure(); end
    
    for j=1:cols
        img = images{results(i,j)};
        pos = mod(i-1,5) * cols + j;
        subplot(5,cols,pos); subimage(img); axis off;
        title(results(i,j));
    end
end

end


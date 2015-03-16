function [ ri ] = getRandIndex( N, c1, c2 )
% This function outputs the rand index between two clusters
% N = the number of elements. 1 to N will serve as indexes for the images
% c1 = cluster 1
% c2 = cluster 2

agreed = 0;
total = 0;

for i=1:N
    for j=(i+1):N
        total = total + 1;
        if ((c1(i) == c1(j)) && (c2(i) == c2(j))) || ...
                ((c1(i) ~= c1(j)) && (c2(i) ~= c2(j)))
            agreed = agreed + 1;
        end
    end
end

ri = agreed / total;

end


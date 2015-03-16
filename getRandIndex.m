function [ ri ] = getRandIndex( c1, c2 )
% This function outputs the rand index between two clusters
% c1 = cluster 1
% c2 = cluster 2

N = length(c1);
total = 0;
agreed = 0;

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


function [ clusters ] = clusterSimilarities( D, num_clust, option )
% D = distance matrix (N x N)
% num_clust = the desired number of clusters
% clustering = cluster labels for each index (N) of D

N = length(D);

% Initialize clusters
clusters = cell(N,1);
for i=1:N
    clusters{i} = i;
end

% Initialize cluster comparisons for memoization; -1 means not calculated
c_compares = ones(N,N);
c_compares = c_compares * -1;

while length(clusters) > num_clust
    C = length(clusters);
    dist = 1;
    c_to_join = [];
    for i=1:C
        for j=(i+1):C
            % Only computer if necessary
            if (c_compares(i,j) == -1)
                c_compares(i,j) = getDist(D, clusters{i}, clusters{j}, ... 
                    option);
            end
            current_distance = c_compares(i,j);
            if (current_distance < dist)
                dist = current_distance;
                c_to_join = [i; j];
            end
        end
    end
    
    % Join the clusters into c_to_join(1), remove the second
    c1 = c_to_join(1);
    c2 = c_to_join(2);
    clusters{c1}   = [clusters{c1} clusters{c2}];
    clusters(c2,:) = [];
    
    % Flag c1 as needing to be compared again - remove c2
    c_compares(c1,:) = -1;
    c_compares(:,c1) = -1;
    c_compares(c2,:) = [];
    c_compares(:,c2) = [];
end

end

function distance = getDist(D, c1, c2, option)
distance = 0;
if option == Opts.Single
    distance = 1;
end

n1 = size(c1,2);
n2 = size(c2,2);
for i=1:n1
    for j=1:n2
        current_dist = D(c1(i),c2(j));
        if option == Opts.Complete
            distance = max(distance, current_dist);
        else
            distance = min(distance, current_dist);
        end
    end
end
end
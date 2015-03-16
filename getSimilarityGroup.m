function [ results ] = getSimilarityGroup( cmps, opts )
% This function returns the most similar set of 4 images as described
% below. A set is ranked by their score, which is the sum of all pairwise
% comparisons within the set.
%
% cmps = the similarity comparisons already computer (NxN)
% results = the set of 4 images

findSimilar = true;
if (opts == Opts.Dissimilar)
    findSimilar = false;
end

N = size(cmps,1);
results = zeros(1,4);
score = 0;
if (~findSimilar) score = 4; end;

for i=1:N
    for j=(i+1):N
        for k=(j+1):N
            for l=(k+1):N
                imgs = [i j k l];
                current_score = getScore(cmps, imgs, findSimilar);
                if (findSimilar && current_score > score) ...
                        || (~findSimilar && current_score < score)
                    results = imgs;
                    score = current_score;
                end
            end
        end
    end
end
end

function score = getScore(cmps, imgs, findSimilar)
% Get the similarity score for the set of 4 images
% The score equals the sum of all pairwise comparisons of the set

score = 0;
N = length(imgs);
for i=1:(N-1)
    for j=(i+1):N
        score = score + cmps(imgs(i),imgs(j));
    end
end

end


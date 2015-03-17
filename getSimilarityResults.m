function [ results ] = getSimilarityResults( comps )
%{
Returns the results as specified by the assignment. 

comps = 2D matrix that shows the similary comparisons for each image (could
be on colors or texture - values will be in the range [0, 1])

results = a 2D matrix of size (# of images x 7)
    - The first images is the image we are finding similarities against
    - The next three images are those that are the most similar, from most
    similar to third most similar
    - The last three images are those that are least similar, from third
    least similar to most least similar

Reference https://www.mathworks.com/matlabcentral/newsreader/view_thread/
248731 for sorting by a particular column. 
%}

n = size(comps,1);
results = zeros(n, 7);

for i=1:n
    % Get similarities of other images with this image in ascending order
    img_cmps = [1:n; comps(i,:)];
    [~,I] = sort(img_cmps(2,:));
    img_cmps = img_cmps(:,I);
    
    results(i,1) = img_cmps(1,n);
    results(i,2) = img_cmps(1,n-1);
    results(i,3) = img_cmps(1,n-2);
    results(i,4) = img_cmps(1,n-3);
    results(i,5) = img_cmps(1,3);
    results(i,6) = img_cmps(1,2);
    results(i,7) = img_cmps(1,1);
end


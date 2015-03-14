%% Step 0

% debug
print_color_results = false;
print_texture_results = true;

% Number of segments to divide 255 channel into - bins = segments^3
num_segments = 6;

% Get the image filenames
imgPath      = 'ppm/';
imgType      = '*.ppm'; % change based on image type
imgFiles     = dir([imgPath imgType]);
rgbs         = cell(length(imgFiles), 1);
N            = length(imgFiles);

% Load images
for i=1:N
    filename = [imgPath imgFiles(i).name];
    rgbs{i} = imread(filename);
end

%% Step 1

% Create array of normalized histogram vectors for each image
color_hists = zeros(N, num_segments^3);
for i=1:N
    hist3D = getNormalizedColorHistogram(rgbs{i}, num_segments);
    color_hists(i,:) = reshape(hist3D, [1 num_segments^3]);
end

% Perform comparisons between images
color_cmps = zeros(N,N);
for i=1:N
    for j=(i):N
        comp = l1Compare(color_hists(i,:), color_hists(j,:));
        color_cmps(i,j) = comp;
        color_cmps(j,i) = comp;
    end
end

% Gets results with image names as specified by assignment (40 x 7)
color_match_results = getSimilarityResults(color_cmps);

% Print results of comparisons
if print_color_results
    printResultsWithImages(color_match_results, rgbs);
end

%% Step 2

% Get gray-scale images
grays = cell(N, 1);
for i=1:N
    grays{i} = getGrayScale(rgbs{i});
end

% BOTTLENECK
% Get Laplacian images
laplacians = cell(N, 1);
for i=1:N
    laplacians{i} = getLaplacian(int16(grays{i}));
end

% Turn Laplacians into histograms
bins = 100;
text_hists = zeros(N, bins);
for i=1:N
    text_hists(i,:) = getNormalizedTextureHistogram(laplacians{i}, bins);
end

% Perform texture comparisons between images
texture_cmps = zeros(N,N);
for i=1:N
    for j=(i):N
        comp = l1Compare(text_hists(i,:), text_hists(j,:));
        texture_cmps(i,j) = comp;
        texture_cmps(j,i) = comp;
    end
end

% Gets results with image names as specified by assignment (40 x 7)
texture_match_results = getSimilarityResults(texture_cmps);

% Print results of comparisons
if print_texture_results
    printResultsWithImages(texture_match_results, rgbs);
end

% 
% %{
% An issue that still needs to be overcome is discovering the most similar
% and least similar for both the color and texture classifiers. 
% 
% What's the brute force solution? Create all possible groups of 4. Calculate
% the similarity values between each pair in the group and sum them up. We
% should be able to use our results from earlier comparisons to fill in these
% values (rather than recomputing them). 
% 
% There's an issue here. Suppose through images are highly similar (.9, .8,
% .85 values between the three), but the closest image to these is .2 in
% similarity for all of the comparisons.  However, imagine another group of
% images where the similarity values are .6, .7, .65, .55.  This group seems
% to make more sense because there is clearly an "odd man out" in the former.
% 
% So, instead of taking the group with the highest total similarity values,
% perhaps take the one with the lowest minimum value.
% 
% As for the most unlike group, we could use the converse of these.  Either
% the group with the lowest total similarity score, or the group with the
% lowest max.
% %}
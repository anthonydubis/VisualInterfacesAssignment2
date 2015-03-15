clc; close all;

%% Step 0

% debug
print_color_results = false;
print_texture_results = false;

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
% Get the four most similar and dissimilar based on color
color_most_similar = getSimilarityGroup(color_cmps, Opts.Similar);
color_most_dissimilar = getSimilarityGroup(color_cmps, Opts.Dissimilar);
overall_color_matches = [color_most_similar; color_most_dissimilar];

% Print results of comparisons
if print_color_results
    printResultsWithImages(color_match_results, rgbs);
    printResultsWithImages(overall_color_matches, rgbs);
end


%% Step 2

% Get gray-scale images
grays = cell(N, 1);
for i=1:N
    grays{i} = getGrayScale(rgbs{i});
end

% Get Laplacian images
laplacians = cell(N, 1);
max_l = 0;
for i=1:N
    [laplacians{i}, max_val] = getLaplacian(grays{i});
    max_l = max(max_l, max_val);
end

% Turn Laplacians into histograms
bins = 200;
text_hists = zeros(N, bins);
for i=1:N
    text_hists(i,:) = getNormalizedTextureHistogram(laplacians{i}, ... 
        bins, max_l);
end

% figure(); imshow(rgbs{1});
img1_gray = grays{1};
img1_lapl = laplacians{1};
img1_hist = text_hists(1,:);

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
% Get the four most similar and dissimilar based on texture
text_most_similar = getSimilarityGroup(texture_cmps, Opts.Similar);
text_most_dissimilar = getSimilarityGroup(texture_cmps, Opts.Dissimilar);
overall_text_matches = [text_most_similar; text_most_dissimilar];

% Print results of comparisons
if print_texture_results
    printResultsWithImages(texture_match_results, rgbs);
    printResultsWithImages(overall_text_matches, rgbs);
end


%% Step 3
% Use MATLAB's Agglomerative Hierarchical Cluster Tree functionality

% Determine pairwise distances
r = 0.8;
S = r * color_cmps + (1.0 - r) * texture_cmps;
D = 1 - S;
n_clusters = 7;

% Group the data using linkage
Z = linkage(D,'complete');
c = cluster(Z,'maxclust',n_clusters);
for i=1:n_clusters
    mat = vec2mat(find(c == i), 7);
    printResultsWithImages(mat, rgbs);
end

Y = linkage(D,'single');
b = cluster(Y,'maxclust',n_clusters);
for i=1:n_clusters
    mat = vec2mat(find(b == i), 7);
    printResultsWithImages(mat, rgbs);
end
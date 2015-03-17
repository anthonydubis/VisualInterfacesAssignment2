clc; clear; close all;

%% Step 0

% debug
print_color_results = false;
print_texture_results = false;
print_user_input = false;

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

% Number of segments to divide 255 channel into; bins = segments^3
num_segments = 7;

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
bins = 350;
text_hists = zeros(N, bins);
for i=1:N
    text_hists(i,:) = getNormalizedTextureHistogram(laplacians{i}, ... 
        bins, max_l);
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
% Cluster the images using Complete and Single Links

% Determine pairwise distances
r = 0.2;
S = r * texture_cmps + (1.0 - r) * color_cmps;
D = 1 - S;
n_clusters = 7;

% OPTION 1: % Use MATLAB's Agglomerative Hierarchical Cluster Tree funcs
% Group the data using linkage
% Z = linkage(D,'complete');
% sys_c = cluster(Z,'maxclust',n_clusters);
% for i=1:n_clusters
%     mat = vec2mat(find(sys_c == i), 7);
%     printResultsWithImages(mat, rgbs);
% end

% OPTION 2: Self-made clustering algorithm
sys_c = clusterSimilarities(D, n_clusters, Opts.Complete);
for i=1:length(sys_c)
    mat = vec2mat(find(sys_c == i),7);
    printResultsWithImages(mat, rgbs);
end

%% Step 4

n_users = 4;

% Initialize scores array for three users [usr colors textures clusters]
scores = [1 0 0 0 0 0; 2 0 0 0 0 0; 3 0 0 0 0 0; 4 0 0 0 0 0];

% Load user surveys for first two steps
surveys = cell(n_users,1);
surveys{1} = csvread('data/SurveyOne.csv');
surveys{2} = csvread('data/SurveyTwo.csv');
surveys{3} = csvread('data/SurveyThree.csv');
surveys{4} = csvread('data/SurveyFour.csv');

% Print images
if print_user_input
    for i=1:n_users
        printResultsWithImages(surveys{i}, rgbs);
    end
end

% Get survey scores
for i=1:n_users
    submitted = surveys{i};
    scores(i,2:3) = getScore(color_match_results(:,2:7), submitted(:,2:3));
    scores(i,4:5) = getScore(texture_match_results(:,2:7), submitted(:,4:5));
end

% Load clustering data for third step
clusters = cell(n_users,1);
clusters{1} = csvread('data/ClusterOne.csv');
clusters{2} = csvread('data/ClusterTwo.csv');
clusters{3} = csvread('data/ClusterThree.csv');
clusters{4} = csvread('data/ClusterFour.csv');

if print_user_input
    for i=1:n_users
        cluster = clusters{i}(:,2);
        for j=1:n_clusters
            mat = vec2mat(find(cluster == j), 7);
            printResultsWithImages(mat, rgbs);
        end
    end
end

for i=1:n_users
    cluster = clusters{i};
    scores(i,6) = getRandIndex(sys_c, cluster(:,2));
end

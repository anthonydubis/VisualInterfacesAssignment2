% debug
print_color_results = false;
print_texture_results = true;

% Number of segments to divide 255 channel into - bins = segments^3
num_segments = 6;

% Get the image filenames
imgPath      = 'ppm/';
imgType      = '*.ppm'; % change based on image type
imgFiles     = dir([imgPath imgType]);

%% Step 1
% Initialize cells for hist vectors and images
hist_vectors = cell(length(imgFiles), 1);
rgbs         = cell(length(imgFiles), 1);

% Create array of normalized histogram vectors for each image
for i=1:length(imgFiles)
    % Read the image
    filename = [imgPath imgFiles(i).name];
    % fprintf(imgFiles(i).name); fprintf('\n');
    rgbs{i} = imread(filename);
    
    % Get the vector with normalized bin values
    hist3D = getNormalizedColorHistogram(rgbs{i}, num_segments);
    hist_vectors{i} = reshape(hist3D, [1 num_segments^3]);
end

% Perform comparisons between images
% Redundant work is done, but it isn't an issue given our input size.
all_img_cmps = cell(length(hist_vectors), 1);
for i=1:length(hist_vectors)
    % Compare image i to all other images 
    img_cmps = zeros(length(hist_vectors), 2);
    for j=1:length(hist_vectors)
        img_cmps(j, 1) = j;
        img_cmps(j, 2) = colorCompare(hist_vectors{i}, hist_vectors{j});
    end
    % Sort comparisons for this image by similarity
    [Y,I] = sort(img_cmps(:,2));
    img_cmps = img_cmps(I,:);
    
    % Add sorted comparisons for image to all_img_cmps
    all_img_cmps{i} = img_cmps;
end
     
image_one_color_cmps = all_img_cmps{1};

% Determine the best and worst matches for each image and print them out
imgs_to_print = zeros(length(all_img_cmps), 7);
for i=1:length(all_img_cmps)
    img_cmps = all_img_cmps{i};
    num_imgs = length(img_cmps);
    imgs_to_print(i,1) = i;
    imgs_to_print(i,2) = img_cmps(num_imgs-1,1);
    imgs_to_print(i,3) = img_cmps(num_imgs-2,1);
    imgs_to_print(i,4) = img_cmps(num_imgs-3,1);
    imgs_to_print(i,5) = img_cmps(3,1);
    imgs_to_print(i,6) = img_cmps(2,1);
    imgs_to_print(i,7) = img_cmps(1,1);
end

% Print results of comparisons
if print_color_results
    printResultsWithImages(imgs_to_print, rgbs);
end

%% Step 2

% Get gray-scale images
grays = cell(length(rgbs), 1);
for i=1:length(rgbs)
    grays{i} = getGrayScale(rgbs{i});
end

fprintf('About to get laplacians\n');
% THIS IS VERY CLEARLY A BOTTLENECK
% Get Laplacian images
laplacians = cell(length(grays), 1);
for i=1:length(grays)
    laplacians{i} = getLaplacian(int16(grays{i}));
end
fprintf('Finished getting laplacians\n');

fprintf('About to get textured histograms\n');
% Turn Laplacians into histograms
bins = 100;
text_hists = cell(length(laplacians), 1);
for i=1:length(laplacians)
    text_hists{i} = getNormalizedTextureHistogram(laplacians{i}, bins);
end
fprintf('Finished getting textured histograms\n');

fprintf('About to do texture comparisons\n');
% Perform comparisons between images
% Redundant work is done, but it isn't an issue given our input size.
all_text_cmps = cell(length(text_hists), 1);
for i=1:length(text_hists)
    % Compare image i to all other images 
    text_cmps = zeros(length(text_hists), 2);
    for j=1:length(text_hists)
        text_cmps(j, 1) = j;
        text_cmps(j, 2) = colorCompare(text_hists{i}, text_hists{j});
    end
    % Sort comparisons for this image by similarity
    [Y,I] = sort(text_cmps(:,2));
    text_cmps = text_cmps(I,:);
    
    % Add sorted comparisons for image to all_img_cmps
    all_text_cmps{i} = text_cmps;
end

image_one_text_cmps = all_text_cmps{1};

% Determine the best and worst matches for each image and print them out
texture_prints = zeros(length(all_img_cmps), 7);
for i=1:length(all_img_cmps)
    text_cmps = all_text_cmps{i};
    num_imgs = length(text_cmps);
    texture_prints(i,1) = i;
    texture_prints(i,2) = text_cmps(num_imgs-1,1);
    texture_prints(i,3) = text_cmps(num_imgs-2,1);
    texture_prints(i,4) = text_cmps(num_imgs-3,1);
    texture_prints(i,5) = text_cmps(3,1);
    texture_prints(i,6) = text_cmps(2,1);
    texture_prints(i,7) = text_cmps(1,1);
end

% Print results of comparisons
if print_texture_results
    printResultsWithImages(texture_prints, rgbs);
end

%{
An issue that still needs to be overcome is discovering the most similar
and least similar for both the color and texture classifiers. 

What's the brute force solution? Create all possible groups of 4. Calculate
the similarity values between each pair in the group and sum them up. We
should be able to use our results from earlier comparisons to fill in these
values (rather than recomputing them). 

There's an issue here. Suppose through images are highly similar (.9, .8,
.85 values between the three), but the closest image to these is .2 in
similarity for all of the comparisons.  However, imagine another group of
images where the similarity values are .6, .7, .65, .55.  This group seems
to make more sense because there is clearly an "odd man out" in the former.

So, instead of taking the group with the highest total similarity values,
perhaps take the one with the lowest minimum value.

As for the most unlike group, we could use the converse of these.  Either
the group with the lowest total similarity score, or the group with the
lowest max.
%}
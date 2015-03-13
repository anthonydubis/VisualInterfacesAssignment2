% debug
print_images = false;

% Number of segments to divide 255 channel into - bins = segments^3
num_segments = 6;

% Get the image filenames
imgPath      = 'ppm/';
imgType      = '*.ppm'; % change based on image type
imgFiles     = dir([imgPath imgType]);

%% Step 1
% Initialize cells for hist vectors and images
hist_vectors = cell(length(imgFiles), 1);
rgbs       = cell(length(imgFiles), 1);

% Create array of normalized histogram vectors for each image
for i=1:length(imgFiles)
    % Read the image
    filename = [imgPath imgFiles(i).name];
    fprintf(imgFiles(i).name); fprintf('\n');
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
if print_images
    printResultsWithImages(imgs_to_print, rgbs);
end

%% Step 2

% Convert images to 16-bit ints using int16(matrix)

grays = cell(length(rgbs), 1);
for i=1:length(rgbs)
    grays{i} = getGrayScale(rgbs{i});
end

gray = grays{1};
figure(); imshow(gray);

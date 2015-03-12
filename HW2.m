
% Number of segments to divide 255 channel into - bins = segments^3
num_segments = 6;

% Get the image filenames
imgPath      = 'ppm/';
imgType      = '*.ppm'; % change based on image type
imgFiles     = dir([imgPath imgType]);
hist_vectors = cell(length(imgFiles), 1);

% Create array of normalized histogram vectors for each image
for i=1:length(imgFiles)
    % Read the image
    filename = [imgPath imgFiles(i).name];
    fprintf(imgFiles(i).name); fprintf('\n');
    img = imread(filename);
    
    % Get the vector with normalized bin values
    hist3D = getNormalizedColorHistogram(img, num_segments);
    hist_vectors{i} = reshape(hist3D, [1 num_segments^3]);
end

comparisons = zeros(length(hist_vectors), 2);
for i=1:length(hist_vectors)
    comparisons(i, 1) = i;
    comparisons(i, 2) = colorCompare(hist_vectors{1}, hist_vectors{i});
end

[Y, I] = sort(comparisons(:, 2));
comparisons = comparisons(I, :);

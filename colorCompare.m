function [ similarity ] = colorCompare( vec1, vec2 )
%{
This function compares the normalized color vectors of two images and
returns a real number between 0 and 1 based on their similarilty.

vec1 = color vector for image 1
vec2 = color vector for image 2
similarity = degree of similarity (0 = not similar, 1 = perfectly similar)
%}

abs_diff = abs(vec1 - vec2);
similarity = 1 - (sum(abs_diff) / 2);

end


function [ score ] = getScore( sys, usr )
% This function returns the system's score against the user input
% sys = (40 x 6) matrix - three most/worst similar ordered from 1 to 40
% usr = (40 x 2) matrix - users most and least similar ordered from 1 to 40

score = 0;
N = size(sys,1);

for i=1:N
    % Handle similar matches
    switch usr(i,1)
        case sys(i,1)
            score = score + 3;
        case sys(i,2)
            score = score + 2;
        case sys(i,3)
            score = score + 1;
    end
    
    % Handle dissimilar matches
    switch usr(i,2)
        case sys(i,6)
            score = score + 3;
        case sys(i,5)
            score = score + 2;
        case sys(i,4)
            score = score + 1;
    end
end


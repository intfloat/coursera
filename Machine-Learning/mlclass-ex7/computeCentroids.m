function centroids = computeCentroids(X, idx, K)
%COMPUTECENTROIDS returs the new centroids by computing the means of the 
%data points assigned to each centroid.
%   centroids = COMPUTECENTROIDS(X, idx, K) returns the new centroids by 
%   computing the means of the data points assigned to each centroid. It is
%   given a dataset X where each row is a single data point, a vector
%   idx of centroid assignments (i.e. each entry in range [1..K]) for each
%   example, and K, the number of centroids. You should return a matrix
%   centroids, where each row of centroids is the mean of the data points
%   assigned to it.
%

% Useful variables
[m n] = size(X); % a m*n matrix

% You need to return the following variables correctly.
centroids = zeros(K, n); % a K*n matrix


% ====================== YOUR CODE HERE ======================
% Instructions: Go over every centroid and compute mean of all points that
%               belong to it. Concretely, the row vector centroids(i, :)
%               should contain the mean of the data points assigned to
%               centroid i.
%
% Note: You can use a for-loop over the centroids to compute this.
%
% iterate over every cluster
for i=1:K
    indicator = (idx==i); % idx is m*1 matrix
    total = sum(indicator);
    inst = zeros(1, n); % 1*n matrix
    for j=1:m
        if indicator(j)==1
            inst = inst+X(j, :);
        end
    end
    inst = inst/total;
    centroids(i, :) = inst;
end







% =============================================================


end


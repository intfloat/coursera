clear; close all; 

fprintf('Start reading data from file...\n');
% read in training data
fid = fopen('train.dat', 'r');
xTrain = zeros(1000, 20);
yTrain = zeros(1000, 1);
for i=1:1000
    for j=1:20        
        xTrain(i, j) = fscanf(fid, '%f', 1);
    end
    yTrain(i) = fscanf(fid, '%d', 1);
end
% xTrain is 1000*21 matrix
% yTrain is 1000*1 matrix
xTrain = [ones(1000, 1) xTrain];
N = size(xTrain, 1);
% w is 21*1 matrix
w = zeros(21, 1);
grad = zeros(21, 1);
fprintf('Finish data loading.\n');

iterNumber = 2000;
lambda = 0.01;
% iterate for enough times
for i=1:iterNumber
    tmp = -(xTrain*w).*yTrain;
    % tmp is 1000*1 matrix
    tmp = sigmoid(tmp);
    % t is 1000*21 matrix
    t = zeros(1000, 21);
    for j=1:1000
        t(j, :) = -xTrain(j, :).*yTrain(j);
    end
    grad = (1/N)*(t'*tmp);
    % update weight
    w = w-lambda*grad;
end
% evaluate on test set
predY = sigmoid(xTrain*w);
for i=1:size(predY, 1)
    if predY(i)>0.5
        predY(i) = 1;
    else predY(i) = -1;
    end
end
correct = sum(yTrain==predY);
acc = correct/size(yTrain, 1);
fprintf('Accuracy on training set is: %f\n', acc);

% read in test data
fid = fopen('test.dat', 'r');
xTest = zeros(3000, 20);
yTest = zeros(3000, 1);
for i=1:3000
    for j=1:20
        xTest(i, j) = fscanf(fid, '%f', 1);
    end
    yTest(i) = fscanf(fid, '%d', 1);
end
% xTest is 3000*21 matrix
xTest = [ones(3000, 1) xTest];

% evaluate on test set
predY = sigmoid(xTest*w);
for i=1:size(predY, 1)
    if predY(i)>0.5
        predY(i) = 1;
    else predY(i) = -1;
    end
end
correct = sum(yTest==predY);
acc = correct/size(yTest, 1);
fprintf('Accuracy on test set is: %f\n', acc);

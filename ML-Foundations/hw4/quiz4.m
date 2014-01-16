clear; close all; clc;

fprintf('Start reading data from file...\n');
% 200 instances in training data
xTrain = zeros(200, 2);
yTrain = zeros(200, 1);
fid = fopen('train.dat', 'r');
for i=1:200
    for j=1:2
        xTrain(i, j) = fscanf(fid, '%f', 1);
    end
    yTrain(i) = fscanf(fid, '%d', 1);
end
% add bias column
xTrain = [ones(200, 1) xTrain];

% 1000 instances in test data
xTest = zeros(1000, 2);
yTest = zeros(1000, 1);
% just open another file for reading
fid = fopen('test.dat', 'r');
for i=1:1000
    for j=1:2
        xTest(i, j) = fscanf(fid, '%f', 1);
    end
    yTest(i) = fscanf(fid, '%d', 1);
end
xTest = [ones(1000, 1) xTest];
fprintf('Finish loading data...\n');

lambda = 10;
% get weight vector using a function implementing normal equation
% w is 3*1 matrix
w = getw(xTrain, yTrain, lambda);

% for Q13
%evaluate on training set
acc = evaluate(w, xTrain, yTrain);
%fprintf('Accuracy on training set is %f\n', acc);

%evaluate on test set
% xTest is 1000*3 matrix
acc = evaluate(w, xTest, yTest);
%fprintf('Accuracy on test set is %f\n', acc);

% for Q14 and Q15
lambda = 2:-1:-10;
newlam = 10.^lambda;
n = size(lambda, 2);
for i=1:n
    w = getw(xTrain, yTrain, newlam(i));
    acc = evaluate(w, xTrain, yTrain);
    %fprintf('Accuracy on training set with lam=%f is: %f\n', lambda(i), acc);
    acc = evaluate(w, xTest, yTest);
    %fprintf('Accuracy on test set with lam=%f is: %f\n', lambda(i), acc);
end

% for Q16 and Q17
% split original training data into two parts
x1Train = xTrain(1:120, :);
xVal = xTrain(121:200, :);
y1Train = yTrain(1:120, :);
yVal = yTrain(121:200, :);

% try different values of lambda
for i=1:n
    w = getw(x1Train, y1Train, newlam(i));
    acc = evaluate(w, x1Train, y1Train);
    %fprintf('Accuracy on split train data with lam=%f is: %f\n', lambda(i), acc);
    acc = evaluate(w, xVal, yVal);
    %fprintf('Accuracy on validation data with lam=%f is: %f\n', lambda(i), acc);
    acc = evaluate(w, xTest, yTest);
    %fprintf('Accuracy on test data with lam=%f is: %f\n\n', lambda(i), acc);
end

% for Q18
% optimal lambda is 1
w = getw(xTrain, yTrain, 1);
acc = evaluate(w, xTrain, yTrain);
%fprintf('Accuracy on train data is: %f\n', acc);
acc = evaluate(w, xTest, yTest);
%fprintf('Accuracy on test data is: %f\n', acc);

% for Q19
% use D-fold cross validation
for i=1:n
    acc = 0;
    for j=1:5
        xVal = xTrain(40*j-39:40*j, :);
        yVal = yTrain(40*j-39:40*j, :);
        x1Train = xTrain; y1Train = yTrain;
        % delete some rows and columns in validation set
        x1Train(40*j-39:40*j, :) = [];
        y1Train(40*j-39:40*j, :) = [];
        w = getw(x1Train, y1Train, newlam(i));
        acc = acc+evaluate(w, xVal, yVal);
    end
    % average accuracy over 5 experiments
    acc = acc/5;
    %fprintf('Average across validation accuracy with lam=%f is: %f\n', lambda(i), acc);
end

% for Q20
% optimal lambda is 10^(-8)
lambda = 10^(-8);
w = getw(xTrain, yTrain, lambda);
acc = evaluate(w, xTrain, yTrain);
fprintf('Accuracy on train set is: %f\n', acc);
acc = evaluate(w, xTest, yTest);
fprintf('Accuracy on test set is: %f\n', acc);

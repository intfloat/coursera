% For coursera Machine Learning Foundation class, quiz 3
clear; close all; clc
iterNumber = 3;
for i=1:iterNumber
    fprintf('%d iteration...\n', i);
    % xTrain is 1000*4 matrix
    % yTrain is 1000*1 matrix
    [xTrain, yTrain] = generateData();
    theta = inv((xTrain'*xTrain))*xTrain'*yTrain; % 4*1 matrix
    theta
    % yPred is 1000*1 matrix
    yPred = xTrain*theta;
    for j=1:size(yPred, 1)
        if yPred(j)<0
            yPred(j) = -1;
        else yPred(j) = 1;
        end
    end
    correct = sum(yPred==yTrain);
    ratio = correct/size(yPred, 1);
    fprintf('Training Accuracy: %f\n', ratio);
end

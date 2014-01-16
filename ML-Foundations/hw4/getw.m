function w = getw(xTrain, yTrain, lambda)
% use normal equation to solve regularized linear regression
% problem.

row = size(xTrain, 1);
col = size(xTrain, 2);
% xTrain is 200*3 matrix
% (3*3) * (3*200*200*1)
w = inv(xTrain'*xTrain + lambda*eye(col))*(xTrain'*yTrain);

end

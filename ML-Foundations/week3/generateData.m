function [xTrain, yTrain] = generateData()
    xTrain = zeros(1000, 6);
    yTrain = zeros(1000, 1);
    myX = rand(1000, 2)*2-1;    
    xTrain(:, 1) = ones(1000, 1);
    xTrain(:, 2:3) = myX;
    xTrain(:, 4) = myX(:, 1).*myX(:, 2);
    xTrain(:, 5:6) = myX.^2;
    % generate training data
    for j=1:1000
        res = myX(j, 1)^2 + myX(j, 2)^2 - 0.6;
        if res>=0
            yTrain(j) = 1;
        else yTrain(j) = -1;         
        end % end if clause
        % add some noise to training data
        if rand()<0.1
            yTrain(j) = -1*yTrain(j);
        end
    end % end for loop
end


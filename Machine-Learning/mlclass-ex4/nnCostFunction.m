function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%

% iterate over every sample and add up all the cost
% those variables are only needed to compute once
myx = [ones(m, 1) X];
x2 = sigmoid(myx*Theta1');
myx2 = [ones(m, 1) x2];
res = sigmoid(myx2*Theta2');
for i=1:m
    %fprintf(['i=%f\n'], i);
    yi = zeros(num_labels, 1);
    yi(y(i)) = 1;
    %size(res)
    inst = res(i, :);
    J = J+(-log(inst)*yi-log(1-inst)*(1-yi));
end
J = (1/m)*J;

% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
grad1 = zeros(size(Theta1));
grad2 = zeros(size(Theta2));
for i=1:m
    a1 = myx(i, :); % 1*401
    z2 = a1*Theta1'; % 1*25
    a2 = [1 sigmoid(z2)]; % 1*26
    z3 = a2*Theta2'; % 1*10
    a3 = sigmoid(z3); % 1*10
    yi = zeros(num_labels, 1); % 10*1
    yi(y(i)) = 1;
    delta3 = a3'-yi; % 10*1
    myz2 = [0 z2]'; % 26*1
    % (26*10) (10*1) (26*1)
    delta2 = (Theta2'*delta3).*sigmoidGradient(myz2);
    % 25*1
    delta2 = delta2(2:end);    
    % 25*401
    grad1 = grad1 + delta2*a1;
    % 10*26
    grad2 = grad2 + delta3*a2;
end

Theta1_grad = (1/m)*grad1;
Theta2_grad = (1/m)*grad2;

% take regularization into consideration
Theta1_grad = Theta1_grad+(lambda/m)*Theta1;
Theta1_grad(:, 1) = Theta1_grad(:, 1) - (lambda/m)*Theta1(:, 1);
Theta2_grad = Theta2_grad+(lambda/m)*Theta2;
Theta2_grad(:, 1) = Theta2_grad(:, 1) - (lambda/m)*Theta2(:, 1);
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
tt1 = Theta1(:, 2:(input_layer_size+1));
tt2 = Theta2(:, 2:(hidden_layer_size+1));
mytheta1 = tt1.*tt1;
mytheta2 = tt2.*tt2;
J = J+(lambda/(2*m))*(sum(sum(mytheta1)')+sum(sum(mytheta2)'));

















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end

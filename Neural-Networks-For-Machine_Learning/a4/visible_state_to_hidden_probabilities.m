function hidden_probability = visible_state_to_hidden_probabilities(rbm_w, visible_state)
% <rbm_w> is a matrix of size <number of hidden units> by <number of visible units>
% <visible_state> is a binary matrix of size <number of visible units> by <number of configurations that we're handling in parallel>.
% The returned value is a matrix of size <number of hidden units> by <number of configurations
% that we're handling in parallel>.
% This takes in the (binary) states of the visible units, and returns the activation probabilities of the hidden units conditional on those states.
    %error('not yet implemented');
    
    % we will get a matrix with dimension <number of hidden units> by <number of configurations>
    prob = rbm_w * visible_state;
    prob = logistic(prob);
    % calculate denominator of softmax function
    %s = sum(prob);
    % divide every item by partition function
    %for i = 1:size(prob, 2)
    %    prob(:, i) = prob(:, i)./s(i);
    %end
    hidden_probability = prob;
end

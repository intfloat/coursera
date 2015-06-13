function d_G_by_rbm_w = configuration_goodness_gradient(visible_state, hidden_state)
% <visible_state> is a binary matrix of size <number of visible units> by <number of configurations 
% that we're handling in parallel>.

% <hidden_state> is a (possibly but not necessarily binary) matrix of size <number of hidden units> 
% by <number of configurations that we're handling in parallel>.

% You don't need the model parameters for this computation.
% This returns the gradient of the mean configuration goodness (negative energy, 
% as computed by function <configuration_goodness>) with respect to the model parameters. 
% Thus, the returned value is of the same shape as the model parameters, 
% which by the way are not provided to this function. Notice that we're talking about the mean over data cases 
% (as opposed to the sum over data cases).
    %error('not yet implemented');
    
    % result should be a <number of hidden units> by <number of visible units> vector
    vrow = size(visible_state, 1);
    hrow = size(hidden_state, 1);
    d_G_by_rbm_w = hidden_state * visible_state';
    d_G_by_rbm_w = d_G_by_rbm_w / size(hidden_state, 2);
    % for i = 1:hrow
    %  for j = 1:vrow
    %    t1 = visible_state(j, :);
    %    t2 = hidden_state(i, :);
    %    d_G_by_rbm_w(i, j) = mean(t1 .* t2);
    %  end
    %end
end

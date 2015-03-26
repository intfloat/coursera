function ret = cd1(rbm_w, visible_data)
% <rbm_w> is a matrix of size <number of hidden units> by <number of visible units>
% <visible_data> is a (possibly but not necessarily binary) matrix of size 
% <number of visible units> by <number of data cases>
% The returned value is the gradient approximation produced by CD-1. It's of the same shape as <rbm_w>.
    %error('not yet implemented');
    
   visible_data = sample_bernoulli(visible_data);
   % result should be <number of hidden units> by <number of visible units>
   [m, n] = size(rbm_w);
   ret = zeros(m, n);
   % step 1: sample hidden state
   prob_hidden = visible_state_to_hidden_probabilities(rbm_w, visible_data);
   sampled_hidden = sample_bernoulli(prob_hidden);
   % this corresponds to positive phase
   ret = configuration_goodness_gradient(visible_data, sampled_hidden);
   % step 2: sample visible state
   prob_visible = hidden_state_to_visible_probabilities(rbm_w, sampled_hidden);
   sampled_visible = sample_bernoulli(prob_visible);
   % step 3: sample hidden state
   % for question 7, we need to comment these two lines
   % prob_hidden = visible_state_to_hidden_probabilities(rbm_w, sampled_visible);
   % sampled_hidden = sample_bernoulli(prob_hidden);
   new_hidden = visible_state_to_hidden_probabilities(rbm_w, sampled_visible);
   % step 4: get an estimation of goodness gradient
   % this corresponds to negative phase
   % ret = ret - configuration_goodness_gradient(sampled_visible, sampled_hidden);
   ret = ret - configuration_goodness_gradient(sampled_visible, new_hidden);

end

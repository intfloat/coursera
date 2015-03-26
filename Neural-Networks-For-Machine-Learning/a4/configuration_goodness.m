function G = configuration_goodness(rbm_w, visible_state, hidden_state)
% <rbm_w> is a matrix of size <number of hidden units> by <number of visible units>
% <visible_state> is a binary matrix of size <number of visible units> by <number of configurations that we're handling in parallel>.
% <hidden_state> is a binary matrix of size <number of hidden units> by <number of configurations that we're handling in parallel>.
% This returns a scalar: the mean over cases of the goodness (negative energy) of the described configurations.
    %error('not yet implemented');
    total = 0;
    for i = 1:size(visible_state, 2)
        tmp = hidden_state(:, i) * visible_state(:, i)';
        tmp = rbm_w.*tmp;
        total += sum(sum(tmp));
    end
    G = total/size(visible_state, 2);
end

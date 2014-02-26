
% this is for simple portfolio problem
cvx_begin
    variable x(n);
    minimize(x'*S*x);
    subject to
        ones(n, 1)'*x == 1;
cvx_end

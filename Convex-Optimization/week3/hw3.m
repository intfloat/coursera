% this is for first question
cvx_begin
    variable x(2);
    minimize(x(1)+x(2));
    subject to
        x >= 0;
        2*x(1)+x(2) >= 1;
        x(1)+3*x(2) >= 1;
cvx_end

% this is for second question
cvx_begin
    variable x(2);
    minimize(x(1)*x(1)+9*x(2)*x(2));
    subject to
        x >= 0;
        2*x(1)+x(2) >= 1;
        x(1)+3*x(2) >= 1;
cvx_end

% this is for simple portfolio problem
cvx_begin
    variable x(n);
    minimize(x'*S*x);
    subject to
        ones(n, 1)'*x = 1;
cvx_end

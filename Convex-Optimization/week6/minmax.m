clear all; close all;

% solve minmax problem using CVX

% generate corresponding data
i = 1:201;
t = -3+(6*(i-1))/200;
% dimension of x is 201*3
x = [ones(201, 1) t' (t.^2)'];

% correct values
y_true = exp(t)';


% use CVX to solve optimization problems
left = 0; right = 10;
res = 9999999;
aa = zeros(1, 3);
bb = zeros(1, 3);
while((right-left)>0.001)
    middle = (left+right)/2.0;
    cvx_begin
        cvx_quiet(true)
        variables a(3) b(3)
        minimize(middle)
        subject to
            b(1) == 1
            x*b >= 0
            abs(x*a-(y_true.*(x*b))) <= middle*(x*b)
    cvx_end
    cvx_status
    % see if this problem is solved
    if(strcmp(cvx_status, 'Solved')==1)
        right = middle;
        if(middle < res)
            res = middle;
            aa = a;
            bb = b;
        end
    else
        left = middle;
    end
end


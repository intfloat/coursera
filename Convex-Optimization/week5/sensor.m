
% solve censor problem, step 1
cvx_begin
    variables myc(20) yy(75)
    minimize(norm([y; yy]-X'*myc))
    subject to
        % lower bound constraint
        yy >= max(y)*ones(75, 1)
cvx_end

myc1 = myc;

% solve censor problem, step 2
partX = X(:, 1:25);
cvx_begin
    variables myc(20)
    minimize(norm(y-partX'*myc))
cvx_end

myc2 = myc;

% output relevant result
res1 = sqrt(sum((c_true-myc1).^2))/sqrt(sum(c_true.^2));
fprintf('The value of residual: %f\n', res1);

res2 = sqrt(sum((c_true-myc2).^2))/sqrt(sum(c_true.^2));
fprintf('The value of residual in step 2: %f\n', res2);



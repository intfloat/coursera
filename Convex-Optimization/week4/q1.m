% when optimizing quadratic function x'Px,
% P should be a symmetric semidefinite matrix
P = [1 -0.5; -0.5 2];
A = [1 2; 1 -4; 5 76];
b = [-2 -3 1]';
cvx_begin
    variable x(2)
    dual variable lambda
    minimize(quad_form(x, P)-x(1))
    subject to
        lambda : A*x <= b
cvx_end

% perturbation problem solver
opt = cvx_optval;
pert = [-0.1 0 0.1];
p_exac = [];
p_pred = [];
for i = 1:3
    for j = 1:3
        b_new = b;
        b_new(1) = b_new(1)+pert(i);
        b_new(2) = b_new(2)+pert(j);
        cvx_begin
            variable x(2)
            %dual variable lambda
            minimize(quad_form(x, P)-x(1))
            subject to
                A*x <= b_new
        cvx_end
        p_exac = [p_exac cvx_optval];
        p_pred = [p_pred opt-lambda(1)*pert(i)-lambda(2)*pert(j)];
    end
end
% output relevant result
fprintf('exact optimal values: \n');
p_exac
fprintf('\npredicted optimal values: \n');
p_pred
res = p_exac - p_pred

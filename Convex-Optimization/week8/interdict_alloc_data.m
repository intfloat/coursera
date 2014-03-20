% ATTENTION: line 66 still has a type error, but i don't know how to fix it yet...

clear all; close all; clc;

rand('state',0);

% m is the number of edges in graph
% n is the number of nodes in graph
n=10;m=20;
% twenty edges in total
edges=[[1 1 1 2 2 2 3 3 4 4 5 5 6 6 7 7 8 7 8 9]'...
    [2 3 4 6 3 4 5 6 6 7 8 7 7 8 8 9 9 10 10 10]'];
A=zeros(n,m);
for j=1:size(edges,1)
    A(edges(j,1),j)=-1;
    A(edges(j,2),j)=1;
end
a=2*rand(m,1);
% x_max is upper bound for resources allocated to this edge
% x_max is 20*1 matrix
x_max = 1+rand(m,1);

% B is total amount of resources which can be allocated
B=m/2;

% code to plot the graph (if you have biograph)
%G=sparse(edges(:,1),edges(:,2),1,n,n);
%view(biograph(G));

% parameter to optimize is x, which is a m*1(20*1) matrix
fprintf('Solving the case of allocating resources uniformly...\n');
% need to use dynamic programming to find shortest path
% dp(i) denote minimum of negative log-likelihood probability from node1 to node i
dp = ones(n, 1)*100000; % initialize to large enough numbers
dp(1) = 0;

resource = ones(m, 1);
resource = resource*(B/m);
% iterate for n times
for i = 1:n
    % iterate for every edge
    for j = 1:m
        node1 = edges(j, 1);
        node2 = edges(j, 2);
        dp(node2) = min(dp(node2), dp(node1)+resource(j)*a(j));
    end
end

ans = exp(-dp(n));
fprintf('Answer of uniformly allocating resources is: %f\n\n', ans);

fprintf('Start optimizing the resource allocation...\n');
cvx_begin
    variables res(m)
    cvx_quiet(true)
    dp = ones(n, 1)*100000;
    dp(1) = 0;
    % iterate for n times
    for i = 1:n
        % iterate for every edge
        for j = 1:m
            node1 = edges(j, 1);
            node2 = edges(j, 2);
            % this line cause 'conversion to double from cvx is not possible ' error,
            % I still can't figure out how to fix it.
            dp(node2) = min(power(dp(node2), 1), ...
                power(dp(node1), 1)+power(a(j), 1)*res(j) );
        end
    end
    minimize(dp(n))
    subject to
        sum(res) == B
        res >= 0 % resources allocated should be non-negative
        res <= x_max % upper bound given by problem
cvx_end

fprintf('Problem status: %s\n', cvx_status);
fprintf('Following is optimized resource allocation matrix: \n');
res % output corresponding allocation scheme
ans = exp(-dp(n));
fprintf('Optimal value is: %f\n', ans);


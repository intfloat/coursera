clear all; close all; clc;

% teams are numbered from 1 to 10
n = 10;
% number of rows in training data
m = 45;
% number of rows in test data
m_test = 45;
% sigma is standard deviation of given normal distribution
sigma= 0.250;
% training data
train=[1 2 1;
1 3 1;
1 4 1;
1 5 1;
1 6 1;
1 7 1;
1 8 1;
1 9 1;
1 10 1;
2 3 -1;
2 4 -1;
2 5 -1;
2 6 -1;
2 7 -1;
2 8 -1;
2 9 -1;
2 10 -1;
3 4 1;
3 5 -1;
3 6 -1;
3 7 1;
3 8 1;
3 9 1;
3 10 1;
4 5 -1;
4 6 -1;
4 7 1;
4 8 1;
4 9 -1;
4 10 -1;
5 6 1;
5 7 1;
5 8 1;
5 9 -1;
5 10 1;
6 7 1;
6 8 1;
6 9 -1;
6 10 -1;
7 8 1;
7 9 1;
7 10 -1;
8 9 -1;
8 10 -1;
9 10 1;
];
% test data
test=[1 2 1;
1 3 1;
1 4 1;
1 5 1;
1 6 1;
1 7 1;
1 8 1;
1 9 1;
1 10 1;
2 3 -1;
2 4 1;
2 5 -1;
2 6 -1;
2 7 -1;
2 8 1;
2 9 -1;
2 10 -1;
3 4 1;
3 5 -1;
3 6 1;
3 7 1;
3 8 1;
3 9 -1;
3 10 1;
4 5 -1;
4 6 -1;
4 7 -1;
4 8 1;
4 9 -1;
4 10 -1;
5 6 -1;
5 7 1;
5 8 1;
5 9 1;
5 10 1;
6 7 1;
6 8 1;
6 9 1;
6 10 1;
7 8 1;
7 9 -1;
7 10 1;
8 9 -1;
8 10 -1;
9 10 1;
];


% simply predict who wons last year will win this year
pred = train(:, 3);
gold = test(:, 3);
acc = sum(pred==gold)/m;
fprintf('Simple prediction method got accuracy: %f\n', acc);

% estimate maximum log-likelihood of given training data
cvx_begin
    variables a(10)
    cvx_quiet(true)
    ml = 0;
    % calculate accumulated log-likelihood
    for i = 1:m
        fir = train(i, 1); % first team in this match
        sec = train(i, 2); % second team in this match
        if train(i, 3)==1
            ml = ml + log_normcdf(a(fir)-a(sec));
        end
        if train(i, 3)==-1
            ml = ml + log_normcdf(a(sec)-a(fir));
        end
    end
    maximize(ml)
    subject to
        a >= 0
        a <= 1        
cvx_end

opt = a;
fprintf('Predicted matrix is following: \n');
opt % display predicted matrix
pred = sign(opt(train(:, 1))-opt(train(:, 2)));
acc = sum(pred==gold)/m;
fprintf('Maximum likelihood method got accuracy: %f\n', acc);



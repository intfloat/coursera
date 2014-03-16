clear all; close all; clc;

% data for online ad display problem
rand('state',0);
n=100;      %number of ads
m=30;       %number of contracts
T=60;       %number of periods

% I is 60*1 matrix
I=10*rand(T,1);  %number of impressions in each period
% R is 100*60 matrix
R=rand(n,T);    %revenue rate for each period and ad
% q is 30*1 matrix
q=T/n*50*rand(m,1);     %contract target number of impressions
% p is 30*1 matrix
p=rand(m,1);  %penalty rate for shortfall
% Tcontr is 60*30 matrix
Tcontr=(rand(T,m)>.8); %one column per contract. 1's at the periods to be displayed
for i=1:n   
	contract=ceil(m*rand);
    % Acontr is 100*30 matrix
	Acontr(i,contract)=1; %one column per contract. 1's at the ads to be displayed
end

fprintf('Start solving advertising display problem...\n');

cvx_begin
    variables Nit(100, 60)
    cvx_quiet(true)
    profit = sum(sum(Nit.*R));
    s = 0;
    % for each contract
    for cont = 1:m
        counter = 0;
        % for each period
        for ti = 1:T
            % for each ad
            for ad = 1:n
                % check if it is in contract
                if(Tcontr(ti, cont)==1 && Acontr(ad, cont)==1)
                    counter = counter+Nit(ad, ti);
                end
            end% end ad for loop
        end% end period for loop
        s = s+max(0, q(cont)-counter)*p(cont);
    end% end contract for loop
    profit = profit-s;
    maximize(profit)
    subject to
        sum(Nit)==I'
        Nit >= 0
cvx_end

fprintf('Problem status: %s\n', cvx_status);

% calculate result
net_profit = cvx_optval;
revenue = sum(sum(Nit.*R));
penalty = revenue-net_profit;

% output result
fprintf('Maximal net profit is: %f\n', net_profit);
fprintf('Corresponding total revenue is: %f\n', revenue);
fprintf('Corresponding penalty is: %f\n', penalty);


fprintf('\nSolving second problem...\n');


cvx_begin
    variables Nit(100, 60)
    cvx_quiet(true)
    profit = sum(sum(Nit.*R));
    maximize(profit)
    subject to
        sum(Nit)==I'
        Nit >= 0
cvx_end

revenue = cvx_optval;

% calculate penalty
s = 0;
% for each contract
for cont = 1:m
    counter = 0;
    % for each period
    for ti = 1:T
        % for each ad
        for ad = 1:n
            % check if it is in contract
            if(Tcontr(ti, cont)==1 && Acontr(ad, cont)==1)
                counter = counter+Nit(ad, ti);
            end
        end% end ad for loop
    end% end period for loop
    s = s+max(0, q(cont)-counter)*p(cont);
end% end contract for loop

penalty = s;
net_profit = revenue-penalty;

fprintf('Problem status: %s\n', cvx_status);

% output result
fprintf('Maximal net profit is: %f\n', net_profit);
fprintf('Corresponding total revenue is: %f\n', revenue);
fprintf('Corresponding penalty is: %f\n', penalty);



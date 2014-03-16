clear all; clc; close all;

% data file for flux balance analysis in systems biology
% From Segre, Zucker et al "From annotated genomes to metabolic flux
% models and kinetic parameter fitting" OMICS 7 (3), 301-316. 

% Stoichiometric matrix
S = [
%	M1	M2	M3	M4	M5	M6	
	1	0	0	0	0	0	%	R1:  extracellular -->  M1
	-1	1	0	0	0	0	%	R2:  M1 -->  M2
	-1	0	1	0	0	0	%	R3:  M1 -->  M3
	0	-1	0	2	-1	0	%	R4:  M2 + M5 --> 2 M4
	0	0	0	0	1	0	%	R5:  extracellular -->  M5
	0	-2	1	0	0	1	%	R6:  2 M2 -->  M3 + M6
	0	0	-1	1	0	0	%	R7:  M3 -->  M4
	0	0	0	0	0	-1	%	R8:  M6 --> extracellular
	0	0	0	-1	0	0	%	R9:  M4 --> cell biomass
	]';

[m,n] = size(S);
vmax = [
	10.10;	% R1:  extracellular -->  M1
	100;	% R2:  M1 -->  M2
	5.90;	% R3:  M1 -->  M3
	100;	% R4:  M2 + M5 --> 2 M4
	3.70;	% R5:  extracellular -->  M5
	100;	% R6:  2 M2 --> M3 + M6
	100;	% R7:  M3 -->  M4
	100;	% R8:  M6 -->  extracellular
	100;	% R9:  M4 -->  cell biomass
	];

cvx_begin
    variables v(9)
    cvx_quiet(true)
    maximize v(9)
    subject to
        v <= vmax
        v >= 0
        S*v == 0
cvx_end

fprintf('Maximal growth rate is: %f\n', cvx_optval);

% save this variable for later usage
opt = cvx_optval;

fprintf('Trying to figure out which variable has most effect...\n');

tvmax = vmax;
res = zeros(9, 1);
for i = 1:size(vmax)
    tvmax = vmax;
    % add some perturbation
    tvmax(i) = tvmax(i)+0.01;
    t = zeros(9, 1);
    cvx_begin
        variables v(9)
        cvx_quiet(true)
        maximize v(9)
        subject to
            v <= tvmax
            v >= 0
            S*v == 0
    cvx_end
    res(i) = cvx_optval;
end

% R5 is wrong answer... what a pity, need more work to figure it out...
%res

fprintf('Trying to find essential genes...\n');

% this is the lower bound for judging essential genes
low_bound = 0.2*opt;
for i = 1:size(vmax)
    cvx_begin
        variables v(9)
        cvx_quiet(true)
        maximize v(9)
        subject to
            v <= vmax
            v >= 0
            S*v == 0
            v(i) == 0 % to eliminate the effect of ith reaction
    cvx_end
    res(i) = cvx_optval;
end

% R1 and R9 corresponds to essential genes
%res

fprintf('Trying to find synthetic lethals...\n');

res = zeros(9, 9);
for i = 1:size(vmax)
    for j = (i+1):size(vmax)
        cvx_begin
            variables v(9)
            cvx_quiet(true)
            maximize v(9)
            subject to
                v <= vmax
                v >= 0
                S*v == 0
                % to eliminate the effect of ith and jth reactions
                v(i) == 0
                v(j) == 0
        cvx_end
        res(i, j) = cvx_optval;
    end
end

%res



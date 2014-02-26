function answer = bsxfun(op, arg1, arg2)
% Hacky replacement for bsxfun for old Matlab that doesn't have it.
% See: http://www.mathworks.com/access/helpdesk/help/techdoc/ref/bsxfun.html

% Iain Murray, January 2008

sz1 = size(arg1);
sz2 = size(arg2);
% Workarounds for the stupid Matlab behaviour where final singleton dimensions
% are tossed out:
l1 = length(sz1);
l2 = length(sz2);
if l1 > l2
    sz2 = [sz2, ones(1, l1 - l2)];
end
if l2 > l1
    sz1 = [sz1, ones(1, l2 - l1)];
end

mask1 = sz1 > 1;
mask2 = sz2 > 1;
rep1 = double(mask1);
rep2 = double(mask2);
rep1(~mask1) = sz2(~mask1);
rep2(~mask2) = sz1(~mask2);

answer = op(repmat(arg1, rep1), repmat(arg2, rep2));


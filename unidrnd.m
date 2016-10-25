function r = unidrnd(n,mm,nn)
%UNIDRND Random matrices from the discrete uniform distribution.
%   R = UNIDRND(N) returns a matrix of random numbers chosen 
%   uniformly from the set {1, 2, 3, ... ,N}.
%
%   The size of R is the size of N. Alternatively, 
%   R = UNIDRND(N,MM,NN) returns an MM by NN matrix. 

%   Copyright 1993-2002 The MathWorks, Inc. 
%   $Revision: 2.10 $  $Date: 2002/03/31 22:26:56 $

if nargin == 1
    [errorcode rows columns] = rndcheck(1,1,n);
elseif nargin == 2
    [errorcode rows columns] = rndcheck(2,1,n,mm);
elseif nargin == 3
    [errorcode rows columns] = rndcheck(3,1,n,mm,nn);
else
    error('Requires at least one input argument.'); 
end

if errorcode > 0
    error('Size information is inconsistent.');
end

r = ceil(n .* rand(rows,columns));

% Fill in elements corresponding to illegal parameter values
if prod(size(n)) > 1
    r(n < 0 | round(n) ~= n) = NaN;
elseif n < 0 | round(n) ~= n
    r(:) = NaN;
end

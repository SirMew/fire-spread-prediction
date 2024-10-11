%get uniform and exponetial evidence
%use a mixture distribution
%p(y|D) = w*U(y;a,b) + (1-w)*E(y;lambda)
%where U(y;a,b) is a uniform distribution and E(y;lambda) is a exponential
%distribution and w is a weight (0 <= w <= 1)
%w/(b-a) = height of uniform distribution
% w = (1 - E(L2;lambda) - E(L1;lambda))/((U(L2;a,b)- U(L1;a,b)) - E(L2;lambda) + E(L1;lambda))
% L2 = 300;
% L1 = 20;
% w = (1 - lambda*exp(-lambda*L2) - lambda*exp(-lambda*L1))/(((1/(b - a))- 1/(b - a)) - lambda*exp(-lambda*L2) + lambda*exp(-lambda*L1));

%            { 1/(b-1) if a<= y < = b
% U(y;a,b) = |
%            { 0  otherwise
% 
%               { 1/(b-1) if a<= y < = b
% E(y;lambda) = |
%               { 0  otherwise

%w/(b-a) = (1-w)lambda
function evidence = uniformPlusExponentEvidence(x,a,b,lambda)

w= 1/((1/((b-a)*lambda)) + 1);

if (w < 0 || w>=1)
   error("Er... should that red light be flashing? The sign next to it says '0<=w<=1' ")
end

evidence = w*10*log10(1/(b - a)) + (1-w)*10*log10(lambda*exp(-lambda*x));
% evidence = 10*log10(1/(b - a)) + 10*log10(lambda*exp(-lambda*x));
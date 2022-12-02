function T = static_resid_tt(T, y, x, params)
% function T = static_resid_tt(T, y, x, params)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%
% Output:
%   T         [#temp variables by 1]  double   vector of temporary terms
%

assert(length(T) >= 10);

T(1) = 1/y(1)*params(1);
T(2) = y(2)^params(4);
T(3) = y(9)^(params(3)-1);
T(4) = params(3)*y(12)*T(3);
T(5) = y(3)^(params(3)-1);
T(6) = T(4)*T(5);
T(7) = y(2)^(1-params(3));
T(8) = y(9)^params(3);
T(9) = y(3)^params(3);
T(10) = y(2)^(-params(3));

end
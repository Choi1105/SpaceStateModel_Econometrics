function g1 = static_g1(T, y, x, params, T_flag)
% function g1 = static_g1(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   g1
%

if T_flag
    T = rbc.static_g1_tt(T, y, x, params);
end
g1 = zeros(14, 14);
g1(1,5)=(-(params(4)*T(4)*1/T(3)));
g1(1,14)=1;
g1(2,1)=(-T(10));
g1(2,4)=(-(T(10)*(-(params(6)/params(5)*getPowerDeriv(y(4),params(5),1)))));
g1(2,9)=1;
g1(3,1)=(-1);
g1(3,6)=1;
g1(3,7)=(-1);
g1(3,8)=(-(1/y(8)));
g1(4,5)=(-(1-1/y(14)));
g1(4,8)=1/y(8);
g1(4,14)=(-y(5))/(y(14)*y(14));
g1(5,2)=(-(T(6)*y(3)*getPowerDeriv(y(2),params(3),1)));
g1(5,3)=(-(T(6)*T(7)));
g1(5,4)=(-(y(3)*T(7)*getPowerDeriv(y(4),1-params(3),1)));
g1(5,6)=1;
g1(6,2)=(-(1-(1-params(2))));
g1(6,7)=1;
g1(7,9)=1-params(9)*y(14);
g1(7,14)=(-(params(9)*y(9)));
g1(8,2)=(-((1-params(3))*y(3)*1/y(4)*T(11)));
g1(8,3)=(-((1-params(3))*T(8)));
g1(8,4)=params(6)*getPowerDeriv(y(4),params(5)-1,1)-(1-params(3))*y(3)*T(11)*(-y(2))/(y(4)*y(4));
g1(9,2)=(-(params(9)*y(9)*params(3)*y(3)*(-y(4))/(y(2)*y(2))*T(12)));
g1(9,3)=(-(params(9)*y(9)*params(3)*T(9)));
g1(9,4)=(-(params(9)*y(9)*params(3)*y(3)*T(12)*1/y(2)));
g1(9,9)=1-params(9)*(1-params(2)+params(3)*y(3)*T(9));
g1(10,6)=(-((-log(y(8)))/(y(6)*y(6))));
g1(10,8)=(-(1/y(8)/y(6)));
g1(10,10)=1/y(10);
g1(11,11)=1;
g1(12,12)=1;
g1(13,13)=1;
g1(14,3)=1/y(3)-params(7)*1/y(3);
if ~isreal(g1)
    g1 = real(g1)+2*imag(g1);
end
end

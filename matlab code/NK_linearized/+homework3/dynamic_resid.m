function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
% function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = homework3.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(4, 1);
lhs = y(3);
rhs = y(7)-1/params(1)*(y(4)-y(8));
residual(1) = lhs - rhs;
lhs = y(5);
rhs = T(1)*(y(3)*(params(1)+params(4))-(1+params(4))*y(6))+y(8)*params(3);
residual(2) = lhs - rhs;
lhs = y(6);
rhs = params(6)*y(2)+x(it_, 1);
residual(3) = lhs - rhs;
lhs = y(4);
rhs = (1-params(7))*(1/params(3)-1)+params(7)*y(1)+y(5)*(1-params(7))*params(5)+x(it_, 2);
residual(4) = lhs - rhs;

end

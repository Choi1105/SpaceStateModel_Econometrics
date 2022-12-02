%% Parameter constraint
% input: psi, Sn (paramters, structure parameters)
% output: valid = 1, parameter constraint satisfied
%         valid = 0, otherwise

function [valid] = paramconst(theta,Data)
% Pre-allocation
validm = ones(30,1);

% a0 > 0
validm(1) = theta(5) > 0;

% a1 + gam1 < 1
validm(2) = theta(6) + theta(7) < 1;

% a1 > 0
validm(3) = theta(6) > 0;

% gam > 0
validm(4) = theta(7) > 0;

valid = minc(validm);

end
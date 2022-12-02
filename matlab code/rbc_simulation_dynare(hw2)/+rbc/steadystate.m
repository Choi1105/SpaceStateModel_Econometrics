function [ys_, params, info] = steadystate(ys_, exo_, params)
% Steady state generated by Dynare preprocessor
    info = 0;
    ys_(3)=1;
    ys_(6)=1;
    k_n=((1/params(8)-(1-params(1)))/params(2))^(1/(params(2)-1));
    ys_(4)=0.3;
    ys_(2)=k_n*ys_(4);
    ys_(7)=ys_(2)*params(1)/ys_(6);
    ys_(5)=ys_(4)*k_n^params(2);
    ys_(1)=ys_(4)*(ys_(2)/ys_(4))^params(2)-params(1)*ys_(2);
    ys_(8)=1/ys_(1);
    % Auxiliary equations
end

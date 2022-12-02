%% Compute log likelihood function

function [lnL] = lnlik(theta,Data)

Y = Data(:,1);
X = Data(:,2:7);
T = rows(Y);

beta = theta(1:6);
sig2 = theta(7);

lnLm = zeros(T,1);

for t = 1:T
    
    yt = Y(t);
    xt = X(t,:);
    yf = xt*beta;
    lnLm(t) = lnpdfn(yt, yf, sig2);
    
end

lnL = sumc(lnLm);

end


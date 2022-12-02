% /* Note that in this versioin, f is a function of the parameters!!! 
% **
% ** INPUTS
% ** &f: name of function to be maximized using SA
% ** &const: constraint proc: output of 1 means constraints satisfied
% ** SF: scale factor -- any number greater than 0
% ** arg: full vector of argument
% ** index: index of argument components to be maximized over
% ** a: temperature reduction factor -- (0, 1)
% ** IT: initial temperature
% ** b: stage length increment
% ** cs: scalar adjustment factor to SF at the end of each stage
% ** IM: length of first stage
% ** n: total number of stages
% ** eps: required precision of maximum
% ** maxiter: max number of desired iterations for deterministic optimizer -- >= 1
% ** co : = 1 if constrained optimizer, and 0 otherwise.
% ** Note that in case of unconstrained optimization, 'const' is an arbitrary procedure.
% ** printi: =1 to print intermediate information
% **
% ** OUPUTS
% ** mu: maxima (full vector)
% ** fmax: maximized value of function
% ** g:  gradient at argmax
% ** V: Cov computed as inverse of negative Hessian (or a nearby p.d. matrix)
% ** Vinv: -Hessian

function [mu,fmax,g,V,Vinv] = SA_CRK1(FUN,constr,SF,arg,index,a,IT,b,cs,IM,n,mr,eps,maxiter,co,printi,Sn) 

theta0 = arg;

if co == 1
    valid = constr(theta0);  %/* check if parameter constraints are valid for initial value */
    
    if valid == 1
        lik0 = FUN(theta0,Sn);  % /* initial value of function */
    else
        disp('Starting values do not satisfy parameter constraints')
        disp('Setting initial likelihood to large negative value. Please check initial values.')
        disp(theta0)
        return
    end

 else
    lik0 = FUN(theta0,Sn);
end

likg = lik0;    %/* storage for global function max */
argg = theta0;  %/* storage for global maxima */

if printi==1
	disp('-------------------------------------');
	disp(['initial function value  ',num2str(lik0)]);
end

if n == 0 && maxiter > 0   % when n=0, swith to deterministic optimizer 
     % deterministic maximizer 
    mu = real(argg);
    [mu,fmax,g,V,Vinv] = DO_CKR(FUN,constr,mu,index,maxiter,co,printi,Sn);
end

if n > 1
  tau = recserar(zeros(n,1),IT,a); % temperatures reduction schedule 
  m = recserar(b*ones(n,1),IM,1); % stage lengths 
elseif n==1
  tau = IT; % temperatures reduction schedule 
  m = IM;
end

rate = zeros(rows(index),n);
acceptm = zeros(rows(index),n);   % total number of M-H acceptances in each stage

reject = 0;
j = 1; %  j: index of stage 
while j <= n;   %  stage indicator 
    tic; % timer starts
    mj = m(j);
    trialm = zeros(rows(index),1);
    tauj = tau(j);


    i = 1; % i: index of iteration within stage 
    while i <= mj && reject <=mr;

        if co == 1;     % constrained problem 
            valid = 0;
            while valid == 0;
                thetap = theta0;
                currentj = thetap(index);
                newparamj = currentj; % proposal generator for SA optimizer 

                ind = randitg(rows(currentj),1);  % first draw a random integer to determine the component to perturb      
                
                newparamj(ind) = currentj(ind) + randn(rows(ind),1)/SF(ind); % proposed move  
  
                thetap(index) = newparamj;
                valid = constr(thetap);
            end

        else            % unconstrained problem 
            thetap = theta0;
            currentj = thetap(index);
            newparamj = currentj; % proposal generator for SA optimizer 
                
                   ind = randigt(rows(currentj),1);  % first draw a random integer to determine the component to perturb      
                   newparamj(ind) = currentj(ind) + randn(rows(ind),1)/SF(ind); % proposed move  
                
            thetap(index) = newparamj;
        end
        
        trialm(ind) = trialm(ind) + 1;

        likp = FUN(thetap,Sn);

        if likp > likg;  % update global max and maxima if higher function value found 
            likg = likp;
            argg = thetap;
        end

        dlik =  likp - lik0;

        if dlik > eps
            alpha = 1;      % higher function evaluations are always accepted 
        else
            alpha = exp(dlik/tauj);     % prob of accepting lower function evaluations 
        end

        accept = rand(1,1) < alpha;
        theta1 = thetap*accept + theta0*(1-accept);
        lik1 = likp*accept + lik0*(1-accept);
        acceptm(ind,j) = acceptm(ind,j) + accept;
        theta0 = theta1;
        lik0 = lik1;
        
        if accept == 0;
            reject = reject + 1;
        else
            reject = 0;
        end

    i = i + 1;
    end

    if reject > mr  % if there are too many rejections, the SA terminates
            break;
    end
    
    rate(ind,j) = acceptm(ind,j)/trialm(ind);
            if rate(ind,j) > 0.7
            SF(ind) = SF(ind)/(1 + cs*(rate(ind,j) - 0.7)/.3);
        elseif (rate(ind,j) < .2)
            SF(ind) = SF(ind)*(1 + cs*((0.2 - rate(ind,j))/0.2));
            end
            
        	% adjust scale factor so that roughly 20-70% of proposals are accepted 
%     for i = 1:rows(index)
%             if rate(i,j) > 0.7
%             SF(i) = SF(i)/(1 + cs*(rate(i,j) - 0.7)/.3);
%         elseif (rate(i,j) < .2)
%             SF(i) = SF(i)*(1 + cs*((0.2 - rate(i,j))/0.2));
%             end
%     end


    
    iter_End = toc; % timer ends
	
    % print detailed interim output if requested 
    if printi == 1	
        disp(['current temperature  ',num2str(tau(j))]);
      	disp(['current scale factor  ',num2str(SF')]);
      	disp(['M-H rate in stage  ',num2str(j), '    ',num2str(rate(:,j)'*100)]);
      	disp(['current function value  ',num2str(likg)]);
        disp('-------------------------------------');
        disp('     indices  argmax  ');
        disp('-------------------------------------');
        disp([index, argg(index)]);
        disp('-------------------------------------');
        TotalCT = n*iter_End/3600;
        RemainingCT = (n-j)*iter_End/3600;
        disp( ['Computing time of each SA iteration in min is =  ', num2str(iter_End/60)]);
        disp( ['Total SA computing time in hours is =  ', num2str(TotalCT)]);
        disp( ['Remaining SA computing time in min is =  ', num2str(RemainingCT*60)]);
        disp( ['Remaining SA computing time in hours is =  ', num2str(RemainingCT)]);
        disp( ['Remaining SA computing time in days is =  ', num2str(RemainingCT/24)]);
        disp('==========================================================================');
    end

j = j + 1;
end

% Now the SA part is completed.

if maxiter == 0;    % if maxiter = 0, skip the deterministic optimizer  
    mu = argg;      % and calculate things that need to be output 
    fmax = likg;
    g = Gradpnew1(FUN,mu,index,Sn);  % gradient 
%   H = -HESSPnew1(FUN,mu,index,Sn); % variance-covariance 
    H = -FHESSnew1(FUN,mu,index,Sn); % variance-covariance 
    H = real(H);
    H = 0.5*(H + H');
    
    if rows(H) > 1

	    [V, err] = invpd(H);
	    if err == 1
	        [Vinvc,err_chol] = cholmod(H);
	        Vinv = Vinvc'*Vinvc;
		    Vc = invuptr(Vinvc);
		    V = Vc*Vc';
        else
	        Vinv = H;
        end

     else  % in case H is a scalar 
        Vinv = maxc([abs(H);1e-016]);
        V = 1/Vinv;
     end

end

if n > 0 && maxiter > 0

    % deterministic maximizer 
    mu = real(argg);
    [mu,fmax,g,V,Vinv] = DO_CKR(FUN,constr,mu,index,maxiter,co,printi,Sn);
end

if printi==1;
    disp('==================================');
	disp(['final function value	is ',num2str(fmax)]);
    disp('----------------------------------');
    disp('indices  argmax ');
    disp([index,mu(index)]);
	disp('==================================');
end
end

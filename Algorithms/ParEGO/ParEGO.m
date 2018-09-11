function ParEGO(Global)
% <algorithm> <O-Z>
% ParEGO: A Hybrid Algorithm With On-Line Landscape Approximation for
% Expensive Multiobjective Optimization Problems
% IFEs --- 10000 --- Internal GA evals per iteration
% operator       --- EAreal

%--------------------------------------------------------------------------
% The copyright of the PlatEMO belongs to the BIMK Group. You are free to
% use the PlatEMO for research purposes. All publications which use this
% platform or any code in the platform should acknowledge the use of
% "PlatEMO" and reference "Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu
% Jin, PlatEMO: A MATLAB Platform for Evolutionary Multi-Objective
% Optimization, 2016". We need to acknowledge that this file is provided by
% Cheng He (chenghehust@gmail.com).
%--------------------------------------------------------------------------

% Copyright (c) 2016-2017 Cheng He

    %% Parameter setting
    IFEs = Global.ParameterSet(10000);

    %% Generate the weight vectors and random population
	[W,Global.N] = UniformPoint(Global.N,Global.M);
    N            = 11*Global.D-1;
    PopDec       = lhsamp(N,Global.D);
    Population   = INDIVIDUAL(repmat(Global.upper-Global.lower,N,1).*PopDec+repmat(Global.lower,N,1));
	theta        = 10.*ones(1,Global.D);
    
    %% Optimization
    while Global.NotTermination(Population)
        % Randomly select a weight vector and preprocess the data
        lamda  = W(randi(size(W,1)),:); 
        PopObj = Population.objs;
        [N,D]  = size(Population.decs);
        PopObj = (PopObj-repmat(min(PopObj,[],1),N,1))./repmat((max(PopObj,[],1)-min(PopObj,[],1)),N,1);
        PCheby = max(PopObj.*repmat(lamda,N,1),[],2)+0.05.*sum(PopObj.*repmat(lamda,N,1),2); 
        if N > 11*D-1+25
            [~,index] = sort(PCheby);
            Next      = index(1:11*D-1+25);
        else
            Next = true(N,1);
        end
        PDec   = Population(Next).decs;
        PCheby = PCheby(Next);
        
        % Eliminate the solutions having duplicate decision variables
        [~,distinct] = unique(PDec,'rows');
        PDec         = PDec(distinct,:);
        PCheby       = PCheby(distinct);
        
        % Surrogate-assisted prediction
        dmodel     = dacefit(PDec,PCheby,'regpoly1','corrgauss',theta,1e-5.*ones(1,D),20.*ones(1,D));
        theta      = dmodel.theta;
        PopDec     = EvolALG(Global,PCheby,Population.decs,dmodel,IFEs);
        Population = [Population,INDIVIDUAL(PopDec)];
    end
end
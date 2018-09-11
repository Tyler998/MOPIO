function VaEA(Global)
% <algorithm> <O-Z>
% A Vector Angle based Evolutionary Algorithm for Unconstrained
% Many-Objective Optimization

%--------------------------------------------------------------------------
% The copyright of the PlatEMO belongs to the BIMK Group. You are free to
% use the PlatEMO for research purposes. All publications which use this
% platform or any code in the platform should acknowledge the use of
% "PlatEMO" and reference "Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu
% Jin, PlatEMO: A MATLAB Platform for Evolutionary Multi-Objective
% Optimization, 2016".
%--------------------------------------------------------------------------

% Copyright (c) 2016-2017 BIMK Group

    %% Generate random population
    Population = Global.Initialization();

    %% Optimization
    while Global.NotTermination(Population)
        MatingPool = randi(Global.N,1,Global.N);
        Offspring  = Global.Variation(Population(MatingPool));    
        Population = EnvironmentalSelection([Population,Offspring],Global.N);
    end
end
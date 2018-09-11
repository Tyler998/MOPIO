function varargout = IMMOEA_F9(Operation,Global,input)
% <problem> <IMMOEA>
% A Multiobjective Evolutionary Algorithm using Gaussian Process based
% Inverse Modeling
% operator --- EAreal

%--------------------------------------------------------------------------
% The copyright of the PlatEMO belongs to the BIMK Group. You are free to
% use the PlatEMO for research purposes. All publications which use this
% platform or any code in the platform should acknowledge the use of
% "PlatEMO" and reference "Ye Tian, Ran Cheng, Xingyi Zhang, and Yaochu
% Jin, PlatEMO: A MATLAB Platform for Evolutionary Multi-Objective
% Optimization, 2016".
%--------------------------------------------------------------------------

% Copyright (c) 2016-2017 BIMK Group

    switch Operation
        case 'init'
            Global.M        = 2;
            Global.M        = 2;
            Global.D        = 30;
            Global.lower    = zeros(1,Global.D);
            Global.upper    = [1,zeros(1,Global.D-1)+10];
            Global.operator = @EAreal;

            PopDec    = rand(input,Global.D).*repmat(Global.upper-Global.lower,input,1) + repmat(Global.lower,input,1);
            varargout = {PopDec};
        case 'value'
            X = input;
            D = size(X,2);
            
            t = X(:,2:D).^(1./(1+3*repmat(2:D,size(X,1),1)/D)) - repmat(X(:,1),1,D-1);
            g = sum(t.^2/4000,2) - prod(cos(t./repmat(sqrt(1:Global.D-1),size(X,1),1)),2) + 2;
            PopObj(:,1) = X(:,1);
            PopObj(:,2) = g.*(1-sqrt(PopObj(:,1)./g));
            
            PopCon = [];
            
            varargout = {input,PopObj,PopCon};
        case 'PF'
            f(:,1)    = (0:1/(input-1):1)';
            f(:,2)    = 1 - sqrt(f(:,1));
            varargout = {f};
    end
end
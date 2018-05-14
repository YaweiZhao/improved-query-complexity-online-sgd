function [ s_hyp ] = init_parameters( )

s_hyp = struct();
%settings of dynamic environment
%s_hyp.model_opt = 'portfolio';
%s_hyp.modular = 'STOCASTIC';
s_hyp.model_opt = 'ridge_regression';
s_hyp.modular = 'GD';

s_hyp.dynamic_variation_base = 0.01;
%s_hyp.n_dynamic = 10;%
s_hyp.n_dynamic = 10;%stochastic
%other settings
s_hyp.n = 200000; %divide n_dynamic
s_hyp.d = 5;
%s_hyp.d = 100;
s_hyp.T = s_hyp.n;  
s_hyp.kappa = 1e3;
s_hyp.scale_D = 1e2;
s_hyp = generate_dynamic_data_stream(s_hyp);

%optmization
s_hyp.ALGO = 'MOGD';%our method
%s_hyp.ALGO = 'OMGD';%Lijun Zhang
%s_hyp.ALGO = 'OGD';%CDC 2016
%s_hyp.ALGO = 'MOGD-SGD';%MOGD equppied SGD
%s_hyp.ALGO = 'MOGD-GD';
%s_hyp.ALGO = 'MOGD-SVRG';
%s_hyp.ALGO = 'MOGD-SVRG-BB';

%model settings
s_hyp.alpha = 1e1;%regularization constant
%s_hyp.eta = 1e-2/sqrt(s_hyp.T); % for stochastic setting
s_hyp.eta = 1e-6;




















end


function [ s_hyp ] = init_parameters( )

s_hyp = struct();
%settings of dynamic environment
s_hyp.model_opt = 'portfolio';
s_hyp.modular = 'STOCASTIC';

s_hyp.dynamic_variation_base = 0.01;
s_hyp.n_dynamic = 50;%10 in default

%other settings
s_hyp.n = 20000; %divide n_dynamic
s_hyp.d = 100;%5
s_hyp.T = s_hyp.n;  
s_hyp.kappa = 2;
s_hyp = generate_dynamic_data_stream(s_hyp);

%optmization
%ALGO = 'MOGD';%our method
%ALGO = 'OMGD';%Lijun Zhang
%ALGO = 'OGD';%CDC 2016
%s_hyp.ALGO = 'MOGD-SGD';%MOGD equppied SGD
%s_hyp.ALGO = 'MOGD-GD';
s_hyp.ALGO = 'MOGD-SVRG';

%model settings
s_hyp.alpha = 1e1;%regularization constant
s_hyp.eta = 1/sqrt(s_hyp.T); % for stochastic setting




















end


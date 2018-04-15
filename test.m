clear all;
clc;

rng('default');
%settings of dynamic environment
%model_opt = 'ridge_regression';
model_opt = 'logistic_regression';
modular = 'GD';
dynamic_variation_base = 0.01;
n_dynamic = 2;

%other settings
n = 50000; %divide n_dynamic
d = 5;%5
T = 5000; %iterations for MOGD
%T = 4000; %iterations for OMGD

[A, y] = generate_dynamic_data_stream(n, d, model_opt,dynamic_variation_base,n_dynamic);

%optmization
ALGO = 'MOGD';%our method
%ALGO = 'OMGD';%Lijun Zhang
%ALGO = 'OGD';%CDC 2016
[x_seq, f_t_seq, f_seq, time_seq] = online_optimization(A, y, T, model_opt,  modular, ALGO);

%plot
[sum_x_seq, sum_squared_x_seq, sum_f_seq] = get_sum_seq(x_seq, f_t_seq, f_seq);
save('sum_x_seq.txt', 'sum_x_seq', '-ascii');
save('sum_squared_x_seq.txt', 'sum_squared_x_seq', '-ascii');
save('sum_f_seq.txt', 'sum_f_seq', '-ascii');
save('time_seq.txt', 'time_seq', '-ascii');
%plot_lines(sum_x_seq, sum_squared_x_seq, sum_f_seq, T, model_opt, modular,dynamic_variation_base, n_dynamic);










clear all;
clc;
rng('default');
s_hyp = init_parameters( );

[x_seq, f_t_seq, f_seq, time_seq] = online_optimization(s_hyp);

%plot
[sum_x_seq, sum_squared_x_seq, sum_f_seq, sum_time_seq] = get_sum_seq(x_seq, f_t_seq, f_seq, time_seq);
save('sum_x_seq.txt', 'sum_x_seq', '-ascii');
save('sum_squared_x_seq.txt', 'sum_squared_x_seq', '-ascii');
save('sum_f_seq.txt', 'sum_f_seq', '-ascii');
save('sum_time_seq.txt', 'sum_time_seq', '-ascii');
%plot_lines(sum_x_seq, sum_squared_x_seq, sum_f_seq, T, model_opt, modular,dynamic_variation_base, n_dynamic);
%fprintf('algorithm: %s | modular: %s  \n', s_hyp.ALGO, s_hyp.module);
fprintf('algorithm: %s\n', s_hyp.ALGO);










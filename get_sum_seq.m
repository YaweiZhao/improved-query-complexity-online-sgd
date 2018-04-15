function [regret_path_seq,regret_squared_path_seq, regret_f_seq, sum_time_seq] = get_sum_seq(x_seq, f_t_seq, f_seq, time_seq)
diff_x_temp = diff(x_seq) ;
diff_x_seq = sqrt(sum(diff_x_temp .* diff_x_temp,2));
n_x = length(diff_x_seq);
sum_temp_x = tril(ones(n_x, n_x));
regret_path_seq = sum_temp_x * diff_x_seq;
regret_squared_path_seq = sum_temp_x * (diff_x_seq .* diff_x_seq);

diff_f_seq = f_t_seq - f_seq;
n_f = length(diff_f_seq);
sum_temp_f = tril(ones(n_f, n_f));
regret_f_seq = sum_temp_f * diff_f_seq;

sum_time_seq = tril(ones(n_f, n_f)) * time_seq;

end


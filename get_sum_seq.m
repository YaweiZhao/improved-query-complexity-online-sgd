function [regret_path_seq,regret_squared_path_seq, regret_f_seq, sum_time_seq] = get_sum_seq(x_seq, f_t_seq, f_seq, time_seq)
diff_x_temp = diff(x_seq) ;
nonzero_index = find(diff_x_temp);
last_nonzero_index_diff_x = nonzero_index(length(nonzero_index));
diff_x_temp = diff_x_temp(1:last_nonzero_index_diff_x);

% regularized path
diff_x_seq = sqrt(sum(diff_x_temp .* diff_x_temp,2));
n_x = length(diff_x_seq);
sum_temp_x = tril(ones(n_x, n_x));
regret_path_seq = sum_temp_x * diff_x_seq;
regret_squared_path_seq = sum_temp_x * (diff_x_seq .* diff_x_seq);
% regret accumulated sum
diff_f_seq = f_t_seq - f_seq;
nonzero_index = find(diff_f_seq);
last_nonzero_index_diff_f = nonzero_index(length(nonzero_index));
diff_f_seq = diff_f_seq(1:last_nonzero_index_diff_f);

n_f = length(diff_f_seq);
sum_temp_f = tril(ones(n_f, n_f));
regret_f_seq = sum_temp_f * diff_f_seq;

% time
nonzero_index = find(time_seq);
last_nonzero_index_time_seq = nonzero_index(length(nonzero_index));
time_seq = time_seq(1:last_nonzero_index_time_seq);
sum_time_seq = tril(ones(n_f, n_f)) * time_seq;

end


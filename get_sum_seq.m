function [regret_path_seq,regret_squared_path_seq, regret_f_seq, sum_time_seq] = get_sum_seq( x_seq, f_t_seq, f_seq, time_seq)
diff_x_temp = diff(x_seq) ;
nonzero_index = find(diff_x_temp);
last_nonzero_index_diff_x = nonzero_index(length(nonzero_index));
diff_x_temp = diff_x_temp(1:last_nonzero_index_diff_x);

% regularized path
diff_x_seq = sqrt(sum(diff_x_temp .* diff_x_temp,2));
n_x = length(diff_x_seq);
regret_path_seq = zeros(n_x,1);
regret_squared_path_seq = zeros(n_x,1);
for i=1:n_x 
    regret_path_seq(i,:) = sum(diff_x_seq(1:i));
    regret_squared_path_seq(i,:) = sum(diff_x_seq(1:i) .* diff_x_seq(1:i));
end

% time
nonzero_index = find(time_seq);
last_nonzero_index_time_seq = nonzero_index(length(nonzero_index));
time_seq = time_seq(1:last_nonzero_index_time_seq);
n_t = length(time_seq);
sum_time_seq = zeros(n_t,1);
for i=1:n_t
    sum_time_seq(i,:) = sum(time_seq(1:i));
end

% % regret accumulated sum
% diff_f_seq = f_t_seq - f_seq;
% nonzero_index = find(diff_f_seq);
% last_nonzero_index_diff_f = nonzero_index(length(nonzero_index));
% diff_f_seq = diff_f_seq(1:last_nonzero_index_diff_f);
% n_f = length(diff_f_seq);
% regret_f_seq = zeros(max(n_f, n_t), 1);
% for i=1:n_f
%     regret_f_seq(i,:) = sum(diff_f_seq(1:i));
% end





end


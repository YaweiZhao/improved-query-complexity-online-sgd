function plot_lines(sum_x_seq, sum_squared_x_seq, sum_f_seq, T, model_opt, modular,dynamic_variation_base, n_dynamic)
    
    %var = 0.01
    figure(1);
    plot(1:T-1, sum_x_seq, '-or'); %our method
    hold on;
    plot(1:T-1, sum_squared_x_seq, '--+b');
    xlabel('Iterations');
    ylabel('Accumulate sum of variations' );
    %$$ \mathcal{P}_T^{\ast} $$
    legend('$$ \mathcal{P}_T^{\ast},\nu = 0.01$$', '$$ \mathcal{WS}_T^{\ast} $$,\nu=0.01');

end


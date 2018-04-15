function plot_lines(sum_x_seq, sum_squared_x_seq, sum_f_seq, T, ALGO)
    
    if strcmp(ALGO, 'MOGD')
        %var = 0.01
        figure(1);
        plot(1:T-1, sum_x_seq, '-or'); %our method
        hold on;
        plot(1:T-1, sum_squared_x_seq, '--+b');
        xlabel('Iterations');
        ylabel('Accumulate sum of variations' );
        %$$ \mathcal{P}_T^{\ast} $$
        legend('$$ \mathcal{P}_T^{\ast},\nu = 0.01$$', '$$ \mathcal{WS}_T^{\ast} $$,\nu=0.01');

        figure(2);
        plot(1:T, sum_f_seq, '-or'); %our method
        xlabel('Iterations');
        ylabel('Regret' );
        %$$ \mathcal{P}_T^{\ast} $$
        legend('regret');
    else
        % do nothing
    end
end


%% Elasticity of Substitution Sim with multiple sigma

close all; clear; clc;

% Simulation params
n = 50000;
cost_multiplier = linspace(0.5,1.5,n);
sigma_range = [0.5, 0.6, 0.7, 0.8, 0.9];
m = length(sigma_range);

% Exogenous params
c_1 = 100;
c_2 = 100;
alpha = [0.5, 0.5];
xi_1  = [0.95,   1];
xi_2  = [1, 0.95];
budget = 1;


figure('Renderer', 'painters', 'Position', [100 100 900 600])
hold on;

for j = 1:m
    
    sigma = sigma_range(j);
    results = zeros(n,2); 

    for i = 1:n


        phi   = (sigma - 1)/sigma;
        x_1_cost_param = c_1*cost_multiplier(i);
        x_2_cost_param = c_2;

        % Prices
        xi_mat   = [xi_1; xi_2];
        cost_mat = [x_1_cost_param; x_2_cost_param];
        prices   = xi_mat\cost_mat;

        if any(prices<0)
            continue
        end

        % Price Index
        P = ((1/2) * (prices'.^(1-sigma))*(alpha'.^sigma)).^(1/(1-sigma));
        if sigma == 1
            P = 1;
        end
        
        % Quantities
        Y = ((alpha'./prices).^(sigma)) * (budget/P);
           
        X = (xi_mat')\Y;

        results(i,:) = X';

    end    

    output = [];
    output(1,:) = c_1*cost_multiplier'./c_2;
    output(2,:) = results(:,1)./results(:,2);

    % subset to positive quantities
    ind = ~any(output <= 0);
    output = output(:,ind);

    % relationship between log prices and quantities
    subplot(2,1,1);
    hold on;
    
    plot(-log(output(1,:)), log(output(2,:)), 'LineWidth', 1, ...
         'Color', [1, 1, 1]*((sigma-0.5)*1.5))
    
    
    % relationship between log prices and quantities
    subplot(2,1,2);
    hold on;
    
    plot(-log(output(1,2:end)), ...
        diff(log(output(2,:)))./diff(-log(output(1,:))), ...
        'LineWidth', 1, 'Color', [1, 1, 1]*((sigma-0.5)*2));
    
end

%% Plot formatting

% Format subplot 1
subplot(2,1,1);
legend('0.5', '0.6', '0.7', '0.8', '0.9')
xlabel({'Negative Log Difference in Costs', 'log(c_2/c_1)'})
ylabel({'Log Difference in Quantities', 'log(X_1/X_2)'})
xlim([-2, 2]/500)
grid('on')

% Format legend
[hleg,att] = legend('show');
legend('Location', 'northwest')
title(hleg, '\sigma')

% Format subplot 2
subplot(2,1,2);
xlabel({'Negative Log Difference in Costs', 'log(c_2/c_1)'})
ylabel({'Elasticity of Substitution', ...
    'between Technologies', 'e_{1, 2}',})
xlim([-2, 2]/500)
ylim([0 5000])
grid('on')

% Add horizontal line at 1
%e_1_line = plot([-1.5, -0.2], [1,1], 'LineStyle', '--', 'Color', 'k');
%legend([e_1_line], ' e = 1');

% Save figure
print(gcf,'../../figures/fig_elasticity_range.png','-dpng','-r300')


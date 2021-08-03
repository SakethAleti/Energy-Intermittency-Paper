%% Adoption with Respect to Price of Solar Sim

close all; clear; clc;

% Simulation params
n = 500;
cost_multiplier = linspace(1, 2, n);
sigma_range = [0.8847 + 1.96*0.044, 0.8847, 0.8847 - 1.96*0.044];
m = length(sigma_range);

% Exogenous params
c_1 = 104.3;
c_2 = 60;
alpha = [0.6, 0.4];
xi_1  = [1,   1];
xi_2  = [1, 0.1];
budget = 1;


figure('Renderer', 'painters', 'Position', [100 100 900 400])
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
    output(1,:) = results(:,1);
    output(2,:) = results(:,2);
    output(3,:) = cost_multiplier-1;
    output(4,:) = c_1*cost_multiplier;
    
    % subset to positive quantities
    ind = ~any(output(1:2,:) <= 0);
    output = output(:,ind);

    % elasticity of coal versus price
    hold on;
    
    if sigma == 0.8847
        plot(output(3,2:end)*100, ...
            diff(log(output(1,:)))./diff(log(output(4,:))), ...
            'LineWidth', 1, 'Color', 'k');
    elseif sigma < 0.8846
        plot(output(3,2:end)*100, ...
            diff(log(output(1,:)))./diff(log(output(4,:))), ...
            'LineWidth', 1, 'LineStyle', '--', 'Color', [1 1 1]*0.2);
    else
        plot(output(3,2:end)*100, ...
            diff(log(output(1,:)))./diff(log(output(4,:))), ...
            'LineWidth', 1, 'LineStyle', '-.', 'Color', [1 1 0]*0.4);
    end
    
end

%% Plot formatting

% Format plot 1
legend('0.9709 (Upper 95% Confidence Limit)', '0.8847', ...
    '0.7985 (Lower 95% Confidence Limit)')
xlabel('Percent Change in the Cost of Coal')
ylabel({'The Price Elasticity of Demand for Coal'})
xtickformat('percentage')
ytickformat('percentage')
%xlim([-80, 40])
%ylim([0 100])
grid('on')

% Format legend
[hleg,att] = legend('show');
legend('Location', 'southwest')
title(hleg, '\sigma')

% Save figure
print(gcf,'../../figures/fig_coal_elas.png','-dpng','-r300')


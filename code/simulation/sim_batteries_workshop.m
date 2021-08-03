%% Elasticity of Substitution Sim with error bars on sigma estimate

close all; clear; clc;

% Simulation params
n = 500;
cost_multiplier = linspace(0.25,3,n);
xi_2_values = [1, 0.1; 0.95, 0.15; 0.9, 0.2];
m = 3;

% Exogenous params
c_1 = 104.3;
c_2 = 60;
alpha = [0.6, 0.4];
xi_1  = [1,   1];
xi_2  = [1, 0.1];
budget = 1;
sigma = 0.8847;

figure('Renderer', 'painters', 'Position', [100 100 900 600])
hold on;

for j = 1:m
    
    xi_2 = xi_2_values(j,:);
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

    if j == 3
        line_color = [207, 74, 48]/255;
    elseif j == 2
        line_color = mean([207, 74, 48; 35, 55, 59]/255, 1);
    else
        line_color = [35,55,59]/255;
    end

    hold on;
    
    plot(log(output(2,2:end)), ...
        diff(log(output(2,:)))./diff(-log(output(1,:))), ...
        'LineWidth', 1.5, 'Color', line_color);
    
    
end

%% Plot formatting

% Format subplot 1
% subplot(2,1,1);
lgnd = legend('(0%)', '(5%)', '(10%)');
% xlabel({'Negative Log Difference in Costs', 'log(c_2/c_1)'})
% ylabel({'Log Difference in Quantities', 'log(X_1/X_2)'})
% xlim([-1.3, -0.4])
% ylim([-10, 15])
% grid('on')

% Format legend
[hleg,att] = legend('show');
legend('Location', 'northwest')
set(lgnd, 'color', [250 250 250]/255)
title(hleg, {'% of Solar Output','shifted to Off-Peak'})

% Format subplot 2
%subplot(2,1,2);
xlabel({'Log Difference in Quantities', 'log(X_{coal}/X_{solar})'})
ylabel({'Elasticity of Substitution', ...
    'between Technologies', 'e_{solar, coal}',})
xlim([-2, 1.6])
ylim([0 25])
grid('on')

% Save figure

set(gca,'FontSize',14)
set(gcf,'units','points','position',[100,100,1600,700]/2)
set(gca,'color','none')
set(gcf, 'InvertHardcopy', 'off')
set(gcf,'color', [250 250 250]/255);
print(gcf,'../../figures/fig_batteries_workshop.png','-dpng','-r500')


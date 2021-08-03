%% Elasticity of Substitution Sim with error bars on sigma estimate

close all; clear; clc;

% Simulation params
n = 5000;
cost_multiplier = linspace(0.9,2,n);
sigma_range = [0.8847];
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
    output(1,:) = c_1*cost_multiplier'./c_2;
    output(2,:) = results(:,1)./results(:,2);

    % subset to positive quantities
    ind = ~any(output <= 0);
    output = output(:,ind);
    
    % relationship between e and the ratio of quantities
    hold on;
    
    plot(output(2,2:end), ...
        diff(log(output(2,:)))./diff(-log(output(1,:))), ...
        'LineWidth', 1.5, 'Color', 'k');
    
    % store data for average sigma assumption
    if sigma == 0.8847
        mean_output = output;
    end
    
    
end

%% Get linear approximation of CES (VES)

% Output from optimal equilibrium
output = mean_output;
Y = diff(log(output(2,:)))./diff(-log(output(1,:)));
X = output(2,2:end);

% Drop NaNs
output = [X;Y];
ind = ~any(isnan(output));
output = output(:,ind);
X = output(1,:);
Y = output(2,:);

% OLS 
beta = X'\(Y'-1);

X_range = linspace(0, 50, 100);
Y_hat = 1 + X_range.*beta;
plot(X_range, Y_hat, 'LineStyle', '-.', 'LineWidth', 2.5, ...
    'Color', [1, 1, 1]*0.3);


%% Plot formatting

annotation('textarrow', [0.45 .34], [.375 .375], ...
    'String', {['$\hat{e}_{1,2} \approx 1 + ', num2str(round(beta, 2)), ...
    '(X_1/X_2)$']}, ...
    'Interpreter', 'latex', 'fontsize', 14)

% Format plot
legend({'Elasticity of Substitution with \sigma = 0.8847'}, ...
    'VES Approximation')
xlabel({'Ratio of Quantities', 'X_1/X_2'})
ylabel({'Elasticity of Substitution', ...
    'between Technologies', 'e_{1, 2}',})
xlim([0, 5])
grid('on')

% Format legend
[hleg,att] = legend('show');
legend('Location', 'northwest')

% Save figure
print(gcf,'../../figures/fig_ves_approx.png','-dpng','-r300')


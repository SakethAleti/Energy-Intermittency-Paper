%% Adoption with Respect to Price of Solar Sim

close all; clear; clc;

% Simulation params
n = 500;
cost_multiplier = linspace(0.99, 1.01, n);
xi_2_values = [1, 0.1; 0.95, 0.15; 0.9, 0.2; 0.85, 0.25; 0.8, 0.30];
m = length(xi_2_values);
sigma = 0.8847;
 
% Exogenous params
c_1    = 104.3;
c_2    = 60;
alpha  = [0.6, 0.4];
xi_1   = [1,   1];
xi_2   = [1, 0.1];
budget = 1;

% Elasticities at each level of battery shift
elas_array = zeros(m, 2);

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
    output(1,:) = results(:,1);
    output(2,:) = results(:,2);
    output(3,:) = cost_multiplier-1;
    output(4,:) = c_1*cost_multiplier;
    
    % subset to positive quantities
    ind = ~any(output(1:2,:) <= 0);
    output = output(:,ind);

    % elasticity of coal versus price
    elas_coal_p = diff(log(output(1,:)))./diff(log(output(4,:)));
    
    % save elasticity around initial price
    elas_coal_p0  = elas_coal_p(round(n/2));
    
    % add to results
    elas_array(j, 1) = 1-xi_2(1);
    elas_array(j, 2) = elas_coal_p0;
    
end

%% Results
disp('Coal price elasticities')
elas_array

%% Adoption with Respect to Price of Solar Sim

clear; 

% Simulation params
n = 500;
cost_multiplier = linspace(0.99, 1.01, n);
xi_2_values = [1, 0.1; 0.95, 0.15; 0.9, 0.2; 0.85, 0.25; 0.8, 0.30];
m = length(xi_2_values);
sigma = 0.8847;
 
% Exogenous params
c_1    = 104.3;
c_2    = 60;
alpha  = [0.6, 0.4];
xi_1   = [1,   1];
xi_2   = [1, 0.1];
budget = 1;

% Elasticities at each level of battery shift
elas_array = zeros(m, 2);

for j = 1:m
    
    xi_2 = xi_2_values(j,:);
    results = zeros(n,2); 
    
    for i = 1:n


        phi   = (sigma - 1)/sigma;
        x_1_cost_param = c_1;
        x_2_cost_param = c_2*cost_multiplier(i);

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
    output(4,:) = c_2*cost_multiplier;
    
    % subset to positive quantities
    ind = ~any(output(1:2,:) <= 0);
    output = output(:,ind);

    % elasticity of coal versus price
    elas_solar_p = diff(log(output(2,:)))./diff(log(output(4,:)));
    
    % save elasticity around initial price
    elas_solar_p0  = elas_solar_p(round(n/2));
    
    % add to results
    elas_array(j, 1) = 1-xi_2(1);
    elas_array(j, 2) = elas_solar_p0;
    
end

%% Results
disp('Solar price elasticities')
elas_array








load Simulated_data

% Simulated_data contains a data matrix Z
% Z: 50,000 samples, 1,000 variables
% Z: each entry has zero mean and unit variance

B1 = [1.1241 0.3045 0.3806; 0.3902 -0.8169 -0.3114; -0.7166 -0.8630 1.0115];
B2 = [-0.2482 0.3676 0.0328; -0.4240 0.1101 0.0267; 0.6011 -0.5975 -0.3224];

M = 2;
m = 3;

[W,At,J] = principal_time_series(Z,M,m);

for i = 1:1000
    ar_coeff = [Z(2:end-1,i) Z(1:end-2,i)]\Z(3:end,i);
    ar_predict = [Z(2:end-1,i) Z(1:end-2,i)]*ar_coeff;
    ar_mse(i) = (Z(3:end,i)-ar_predict)'*(Z(3:end,i)-ar_predict)/size(ar_predict,1);
end

min_ar_mse = min(ar_mse);
max_ar_mse = max(ar_mse);

X = Z*W;
E = X(3:end,:) - [X(2:end-1,:) X(1:end-2,:)]*At;
mse_x = diag(E'*E)/size(E,1);

poles_true = eig([B1 B2;eye(3) zeros(3)]);
poles_x = eig([At';eye(3) zeros(3)]);


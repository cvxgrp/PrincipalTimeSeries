clear all
close all
clc

load GDP_quarterly_17

% GDP_quarterly_17 contains a data matrix x

% x: cotains the seasonally adjusted quarterly GDP growth of 17 countries
% from 1961-Q2 to 2017-Q3.
% 17 countries are: United States, Japan, United Kingdom, France, Italy, 
% Canada, South Korea, Australia, Spain, Mexico, Netherlands, Switzerland, 
% Germany, Sweden, Belgium, Austria, Norway.

% Dataset downloaded from https://stats.oecd.org/index. aspx?queryid=350#


% Training data: 135 samples from 1961-Q2 to 1994-Q4
ztrain = x(1:135,:);

% Shift and scale each entry to have zero mean and unit variance
Ztrain = (ztrain - mean(ztrain))./std(ztrain);

% Memory length
M = 1;

% Testing data: samples from 1994-Q4 to 2017-Q3
ztest = x(136-M:end,:);

% Shift and scale each entry using the mean and standard deviation of the
% training data
Ztest = (ztest - mean(ztrain))./std(ztrain);


%% Scenario 1: M = 1 and m = 1

% number of principal time series
m1 = 1;

[W1,At1,obj_val1] = principal_time_series(Ztrain,M,m1);

% Calculate principal time series and its prediction
[Xtrain1,Xtrain1_predict,Xtrain1_mse,~] = test_predict(Ztrain,M,m1,W1,At1);

% Testing
[Xtest1,Xtest1_predict,Xtest1_mse,mean1_test_mse] = test_predict(Ztest,M,m1,W1,At1);

%% Scenario 1: M = 1 and m = 2

% number of principal time series
m2 = 2;

[W2,At2,obj_val2] = principal_time_series(Ztrain,M,m2);

% Calculate principal time series and its prediction
[Xtrain2,Xtrain2_predict,Xtrain2_mse,~] = test_predict(Ztrain,M,m2,W2,At2);

% Testing
[Xtest2,Xtest2_predict,Xtest2_mse,mean2_test_mse] = test_predict(Ztest,M,m2,W2,At2);


%% Single time series AR fit 

for i = 1:17
    coeff(i) = Ztrain(1:end-1,i)\Ztrain(2:end,i);
end

Ztrain_ar_predict = Ztrain(1:end-1,:)*diag(coeff);
Ztrain_ar_error = Ztrain(2:end,:)-Ztrain_ar_predict;

ar_train_mse = diag(Ztrain_ar_error'*Ztrain_ar_error)/size(Ztrain_ar_error,1);

Ztest_ar_predict = Ztest(1:end-1,:)*diag(coeff);

Ztest_ar_error = Ztest(2:end,:)-Ztest_ar_predict;

ar_test_mse = diag(Ztest_ar_error'*Ztest_ar_error)/size(Ztest_ar_error,1);
mean_test_mse = diag(Ztest(2:end,:)'*Ztest(2:end,:))/size(Ztest(2:end,:),1);

%% 
% Mexico: 10, Belgium:15

% Mexico: scalar AR fitting training (un-)predictability and mean fitting (un-)predictability
[ar_train_mse(10) 1]
% Belgium: scalar AR fitting training (un-)predictability and mean fitting (un-)predictability
[ar_train_mse(15) 1]
% M=1 and m=1: training (un-)predictability and mean fitting (un-)predictability
[Xtrain1_mse 1]
% M=1 and m=2: training (un-)predictability and mean fitting (un-)predictability
[Xtrain2_mse 2]

% Mexico: scalar AR fitting testing (un-)predictability and mean fitting (un-)predictability
[ar_test_mse(10) mean_test_mse(10)]
% Belgium: scalar AR fitting testing (un-)predictability and mean fitting (un-)predictability
[ar_test_mse(15) mean_test_mse(15)]
% M=1 and m=1: testing (un-)predictability and mean fitting (un-)predictability
[Xtest1_mse mean1_test_mse]
% M=1 and m=2: testing (un-)predictability and mean fitting (un-)predictability
[Xtest2_mse mean2_test_mse]



%% Training Plot
% Mexico:10, Belgium:15

figure;
t_train = [1961.5:0.25:1994.75];
subplot(5,1,1)
plot(t_train,Ztrain(2:end,10))
hold on
plot(t_train,Ztrain_ar_predict(:,10),'--','LineWidth',2);
xlim([1961.5 1994.75])
ylim([-4 4])
title('Single variable AR fit to Mexico with lag 1')
ylabel('Pre-processed GDP')
subplot(5,1,2)
plot(t_train,Ztrain(2:end,15))
hold on
plot(t_train,Ztrain_ar_predict(:,15),'--','LineWidth',2);
xlim([1961.5 1994.75])
ylim([-4 4])
title('Single variable AR fit to Belgium with lag 1')
ylabel('Pre-processed GDP')
subplot(5,1,3)
plot(t_train,Xtrain1);
hold on
plot(t_train,Xtrain1_predict,'--','LineWidth',2)
xlim([1961.5 1994.75])
ylim([-4 4])
title('Reduced rank AR fit with 1 factor')
ylabel('Factor 1')
subplot(5,1,4)
plot(t_train,Xtrain2(:,1));
hold on
plot(t_train,Xtrain2_predict(:,1),'--','LineWidth',2)
xlim([1961.5 1994.75])
ylim([-4 4])
title('Reduced rank AR fit with 2 factors')
ylabel('Factor 1')
subplot(5,1,5)
plot(t_train,Xtrain2(:,2));
hold on
plot(t_train,Xtrain2_predict(:,2),'--','LineWidth',2)
xlim([1961.5 1994.75])
ylim([-4 4])
title('Reduced rank AR fit with 2 factors')
ylabel('Factor 2')

%% Prediction plot

figure;
t_test = [1995:0.25:2017.5];
subplot(5,1,1)
plot(t_test,Ztest(2:end,10))
hold on
plot(t_test,Ztest_ar_predict(:,10),'--','LineWidth',2);
xlim([1995 2017.5])
ylim([-6 2])
title('Single variable AR fit to Mexico with lag 1')
ylabel('Pre-processed GDP')
subplot(5,1,2)
plot(t_test,Ztest(2:end,15))
hold on
plot(t_test,Ztest_ar_predict(:,15),'--','LineWidth',2);
xlim([1995 2017.5])
ylim([-6 2])
title('Single variable AR fit to Belgium with lag 1')
ylabel('Pre-processed GDP')
subplot(5,1,3)
plot(t_test,Xtest1);
hold on
plot(t_test,Xtest1_predict,'--','LineWidth',2)
xlim([1995 2017.5])
ylim([-6 2])
title('Reduced rank AR fit with 1 factor')
ylabel('Factor 1')
subplot(5,1,4)
plot(t_test,Xtest2(:,1));
hold on
plot(t_test,Xtest2_predict(:,1),'--','LineWidth',2)
xlim([1995 2017.5])
ylim([-6 2])
title('Reduced rank AR fit with 2 factors')
ylabel('Factor 1')
subplot(5,1,5)
plot(t_test,Xtest2(:,2));
hold on
plot(t_test,Xtest2_predict(:,2),'--','LineWidth',2)
xlim([1995 2017.5])
ylim([-6 2])
title('Reduced rank AR fit with 2 factors')
ylabel('Factor 2')

%% bar plot of W1
figure;
vlbs = {'USA','JPN','GBR','FRA','ITA','CAN','KOR','AUS','ESP','MEX','NLD','CHE','DEU','SWE','BEL','AUT','NOR'};
bar(W1)
set(gca, 'XTick', [1:17])
set(gca,'XTickLabel',vlbs);
ylabel('Contribution')

%% bar plot of W2
figure;
bar(W2)
set(gca, 'XTick', [1:17])
set(gca,'XTickLabel',vlbs);
ylabel('Contribution')

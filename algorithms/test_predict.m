function [Xtest,Xtest_predict,Xtest_mse,mean_mse] = test_predict(Ztest,M,m,W,At)

    % For new data matrix Ztest (pre-shifted and scaled using mean and standard 
    % deviation of the training data), calculate the principal time series, the
    % prediction of the principal time series and its mse, and the mse
    % using zero predictor (mean predictor)
    
    Xtest = Ztest(M+1:end,:)*W;
    Xtest_predict = 0;
    for i = 1:M
        Xtest_predict = Xtest_predict + Ztest(M+1-i:end-i,:)*W*At((i-1)*m+1:i*m,:);
    end
    Xtest_error = Xtest-Xtest_predict;
    %Xtest_mse = trace(Xtest_error'*Xtest_error)/m/size(Xtest_error,1);
    %mean_mse = trace(Xtest'*Xtest)/m/size(Xtest,1);
    
    Xtest_mse = sum(trace(Xtest_error'*Xtest_error))/size(Xtest_error,1);
    mean_mse = sum(trace(Xtest'*Xtest))/size(Xtest,1);
end
function [W,At,obj_val] = principal_time_series(Z,M,m)
    
    % Z: each entry has zero mean and unit variance
    % Calculate sample covariance and autocovariance matrices
    for i = 1:M+1
        Sigmas(:,:,i) = Z(1:end-M,:)'*Z(i:end+i-M-1,:)/(size(Z(1:end-M,:),1)-1);
    end
    
    % Solve parameters W and At
    [W,At,obj_val] = solve_principal_time_series(Sigmas,M,m);
    
end
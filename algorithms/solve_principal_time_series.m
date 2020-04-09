function [W,At,obj_val] = solve_principal_time_series(Sigmas,M,m)
    
    % Input
    % M: memory length (VAR model order)
    % m: number of principal time series
    % Sigmas: store covariance and autocovariance matrices up to lag M 
    % Output
    % W: tranformation matrix to extract the principal time series
    % At: Stores VAR model coefficients
    % J: objective value
    
    nv = size(Sigmas,1);
    W = zeros(nv,1);
    
    for i = 1:m
        % initialize w
        [w,~] = eigs(sum(Sigmas(:,:,2:end),3)+sum(Sigmas(:,:,2:end),3)',Sigmas(:,:,1),1,'LM');

        w = (eye(nv)-Sigmas(:,:,1)*W*pinv(W'*Sigmas(:,:,1)*Sigmas(:,:,1)*W)*W'*Sigmas(:,:,1))*w;
        w = w/sqrt(w'*Sigmas(:,:,1)*w);
        W = [W w];      
        er = 1;
        while er > 0.001
            % update At
            [At,v] = At_update(W,Sigmas,M);
            % update W
            Wnew = W_update(W,Sigmas,At,M);
            er = subspace(W(:,end),Wnew(:,end));
            W = Wnew;
        end
        obj_val(i) = v;
    end
    
    W = W(:,2:end);
    [At,~] = At_update(W,Sigmas,M);
    

end
function [At,obj_val] = At_update(W,Sigmas,M)
    
    % Update At given W, Sigmas and M
    
    [~,m] = size(W);
    
    S = zeros(m,m,M+1);
    
    for i = 1:M+1
        S(:,:,i) = W'*Sigmas(:,:,i)*W;
    end
    
    temp = {};
    for i = -(M-1):-1
        temp{end+1} = S(:,:,-i+1)';
    end
    for i = 0:M-1
        temp{end+1} = S(:,:,i+1);
    end
    
    B = cell2mat(temp(toeplitz([M:2*M-1],[M:-1:1])));
    temp2 = [];
    for i = 1:M
        temp2 = [temp2;S(:,:,i+1)];
    end

    At = pinv(B)*temp2;
    
    obj_val = trace(S(:,:,1)) - trace(temp2'*At);
    
    
end
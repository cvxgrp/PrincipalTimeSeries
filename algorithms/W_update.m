function W = W_update(W,Sigmas,At,M)
    
    % Update the last column of the transformation matrix W given W, Sigmas, At and M
    
    [~,m] = size(W);
    Wfix = W(:,1:end-1);
    
    % w: the last column of W
    % update w as
    % min. w'B'w-2c'w
    % s.t. w'Sigmas(:,:,1)w = 1
    %      w'Sigmas(:,:,1)Wfix=0
    
    B = 0;
    for i = 1:M
        for j = i:M
            B = B + (At(i*m,1:end-1)*At(j*m,1:end-1)'+At(i*m,end)*At(j*m,end))*(Sigmas(:,:,j-i+1)+Sigmas(:,:,j-i+1)');
        end
        B = B-At(i*m,end)*(Sigmas(:,:,i+1)+Sigmas(:,:,i+1)');
    end
    B = B+Sigmas(:,:,1);
    
    c = 0;
    for i = 1:M
        for j = i+1:M
            c = c-Sigmas(:,:,j-i+1)'*Wfix*(At((j-1)*m+1:j*m-1,1:end-1)*At(i*m,1:end-1)'+At(i*m,end)*At((j-1)*m+1:j*m-1,end))-...
                Sigmas(:,:,j-i+1)*Wfix*(At((i-1)*m+1:i*m-1,1:end-1)*At(j*m,1:end-1)'+At(j*m,end)*At((i-1)*m+1:i*m-1,end));
        end
        c = c+Sigmas(:,:,i+1)*Wfix*At(i*m,1:end-1)'+Sigmas(:,:,i+1)'*Wfix*At((i-1)*m+1:i*m-1,end);
    end
    
    U = null(Wfix'*Sigmas(:,:,1));
    U = orth(U);
    D = U'*B*U;
    beta = U'*c;
    
    w = W_solve(D,-2*beta,U'*Sigmas(:,:,1)*U);
    
    w = U*w;
        
    W = [W(:,1:end-1) w];
    
end
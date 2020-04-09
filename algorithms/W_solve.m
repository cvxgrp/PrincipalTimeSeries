function w = W_solve(C1,C2,C3)
    
    % min. w'C1w+C2'w
    % s.t. w'C3w = 1.

    r = rank(C3);
    [~,d,v] = svds(C3,r);

    temp = v(:,1:r)*pinv(d(1:r,1:r)^0.5);

    % Problem transformed into
    % min. x'Hx-2g'x
    % s.t. x'x=1
    
    H = temp'*C1*temp;
    g = -1/2*temp'*C2;


    A2 = speye(size(H));
    A1 = -2*H;
    A0 = H*H - g*g';

    if isequal(g,zeros(size(g)))

        [x,~] = eigs(H,1,'SM');

    else

        [~,lambda] = eigs([H -eye(size(H));-g*g' H],1,'SR');
        if abs(imag(lambda))<0.001
            lambda = real(lambda);
        else
            error('Problems updating W');
        end

        x = (H-lambda*speye(size(H))) \ g;
        
    end

    w = temp*x;

end
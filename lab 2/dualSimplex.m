function [ x, Jb, B ] = dualSimplex( A, b, c, d )
%dualSimplex( A, b, c, d ) - Dual simplex method with bilateral limit
%Output:    x - optimal plan
%           Jb - base inxes
%           B - inverse base matrix
    J = 1:size(A, 2); 
    [ Jb, A, b ] = findBaseIndexes(A, b);
    Jnb = J(~ismember(J, Jb));
    Ab = A(:, Jb);
    B = inv(Ab);
    cb = c(Jb);
    JnbP = zeros(1, length(Jnb));
    JnbM = zeros(1, length(Jnb));
    
%     tic;
    
    y = cb/B;
    marks = y*A - c;
    
    JnbPLength = 0;
    JnbMLength = 0;
    for i = 1:length(Jnb)
        if marks(Jnb(i)) >= 0
            JnbPLength = JnbPLength + 1;
            JnbP(JnbPLength) = Jnb(i);
        else
            JnbMLength = JnbMLength + 1;
            JnbM(JnbMLength) = Jnb(i);
        end
    end
    JnbP = JnbP(1:JnbPLength);
    JnbM = JnbM(1:JnbMLength);
    
%     toc;
    
    ANew = A;
    NN = [1 1];
    while ~isempty(ANew) && ~isempty(NN)
        [ Jb, JnbP, JnbM, marks, B, ANew, NN ] = dualSimplexIter( Jb, JnbP, JnbM, marks, B, A, b, d );
    end
    x = NN;
end


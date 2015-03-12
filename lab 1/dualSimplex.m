function [ x ] = dualSimplex( A, b, c, d )
    J = 1:size(A, 2); 
    [ Jb, A, b ] = findBaseIndexes(A, b);
    Jnb = J(~ismember(J, Jb));
    Ab = A(:, Jb);
    B = inv(Ab);
    cb = c(Jb);
    JnbP = [];
    JnbM = [];
    
    y = cb/B;
    marks = y*A - c;
    for i = 1:length(Jnb)
        if marks(Jnb(i)) >= 0
            JnbP = [JnbP Jnb(i)];
        else
            JnbM = [JnbM Jnb(i)];
        end
    end
    
    ANew = A;
    NN = [1 1];
    while ~isempty(ANew) && ~isempty(NN)
        [ Jb, JnbP, JnbM, marks, B, ANew, NN ] = dualSimplexIter( Jb, JnbP, JnbM, marks, B, A, b, d );
    end
    x = NN;
end


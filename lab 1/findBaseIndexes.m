function [ Jb, A, b ] = findBaseIndexes( A, b )
%Find base plane of linear programming task
    [m, n] = size(A);
    J = 1:n;

    AA = zeros(m, n + 1);
    AA(1:m, 1:n) = A;
    AA(1:m, n + 1) = b;
    B = AA';
    [~,basiccol] = rref(B);
    B = B(:,basiccol)';
    A = B(:, 1:n);
    b = B(:, n + 1)';
    [m, n] = size(A);
    
    combinatons = combnk(J, m);
    for i = 1:size(combinatons, 1)
        Jbs = perms(combinatons(i, :));
        for ii = 1:size(Jbs, 1)
            Jb = Jbs(ii, :);
            Ab = A(:, Jb);
            if det(Ab) ~= 0
                return;
            end
        end
    end
end


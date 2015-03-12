function x = gamori( A, b, c, d )
% gamori( A, b, c, d ) - method for solving integral taks of linear
%programming
    EPS = 10^-8;
    INF = 10^8;
    Ji = [];
    JiRow = [];
    N = size(A, 2);
    while true
        [m, n] = size(A);
        [x, Jb, B] = dualSimplex( A, b, c, d );
        Jbi = setdiff(Jb, Ji);
        
        [ A, b, c, d, Ji, JiRow ] = tryExcludeCondition( A, b, c, d, Jb, Ji, JiRow, x );
        
        i0 = 0;
        for i = 1:length(Jbi)
            if abs(x(Jbi(i)) - round(x(Jbi(i)))) > EPS
               i0 = Jbi(i);
               break;
            end
        end
        if i0 == 0
            x = x(1:N); 
            return;
        end
        e = zeros(1, length(B));
        e(i0) = 1;
        y = e*B;

        alpha = y*A;
        betta = y*b';

        ANew = zeros(m + 1, n + 1);
        ANew(1:m, 1:n) = A;
        ANew(m + 1, 1:n) = floor(alpha) - alpha;
        ANew(m + 1, n + 1) = 1;

        bNew = zeros(1, m + 1);
        bNew(1:m) = b;
        bNew(m + 1) = floor(betta) - betta;

        cNew = zeros(1, n + 1);
        cNew(1:n) = c;
        
        dNew = zeros(n + 1, 2);
        dNew(1:n, 1:end) = d;
        dNew(n + 1, 1:2) = [0 INF];
        
        Ji = [Ji (n + 1)];
        JiRow = [JiRow (m + 1)];
        A = ANew;
        b = bNew;
        c = cNew;
        d = dNew;
    end
end


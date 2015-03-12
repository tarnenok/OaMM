function [ Jb, JnbP, JnbM, marks, B, A, NN ] = dualSimplexIter( Jb, JnbP, JnbM, marks, B, A, b, d )
%dualSimplexIter - iteration of dual simplex method with bilateral limit
%
%Jb - base inndexes
%JnbP - not base indexes and appropriate mark > 0
%JnbM - not base indexes and appropriate mark < 0
%
%return NN - emty when not solutions(AA is any)
%return NN - solution(AA is empty)

    [mm, n] = size(A);

    temp = 0;
    NN = zeros(1 , n);
    for i = 1:length(JnbP)
        NN(JnbP(i)) = d(JnbP(i), 1);
        temp = temp + NN(JnbP(i)).*A(:, JnbP(i)); 
    end
    for i = 1:length(JnbM)
        NN(JnbM(i)) = d(JnbM(i), 2);
        temp = temp + NN(JnbM(i)).*A(:, JnbM(i));
    end
    temp = B*(b' - temp);
    for i = 1:length(Jb)
       NN(Jb(i)) = temp(i); 
    end
    
    mjk = 0;
    k = 0;
    for i = 1:length(Jb)
        if d(Jb(i), 1) > NN(Jb(i))
            mjk = 1;
            k = i;
            break;
        end
        if d(Jb(i), 2) < NN(Jb(i))
            mjk = -1;
            k = i;
            break;
        end
    end
    
    if mjk == 0
        A = [];
        return;
    end
    
    m = zeros(1, n);
    m(Jb(k)) = mjk;
    ek = zeros(1, mm);
    ek(k) = 1;
    deltaY = mjk*ek*B;
    
    Jnb = [JnbP JnbM];
    
    for i = 1:length(Jnb)
        m(Jnb(i)) = deltaY*A(:, Jnb(i));
    end
    
    DELTA = zeros(1, n);
    for i = 1:length(JnbP)
        if m(JnbP(i)) < 0
            DELTA(JnbP(i)) = -marks(JnbP(i))/m(JnbP(i));
        else
            DELTA(JnbP(i)) = Inf;
        end
    end
    for i = 1:length(JnbM)
        if m(JnbM(i)) > 0
            DELTA(JnbM(i)) = -marks(JnbM(i))/m(JnbM(i));
        else
            DELTA(JnbM(i)) = Inf;
        end
    end
    
    DELTA0 = Inf;
    for i = 1:length(Jnb)
        if DELTA(Jnb(i)) < DELTA0
            DELTA0 = DELTA(Jnb(i));
            jj = Jnb(i);
        end
    end
    
    if DELTA0 == Inf
        NN = [];
        return;
    end
    
    jk = Jb(k);
    for i = 1:length(Jnb)
        marks(Jnb(i)) = marks(Jnb(i)) + DELTA0*m(Jnb(i));
    end
    marks(Jb) = 0;
    marks(jk) = marks(jk) + DELTA0*m(jk);
    
    Jb = Jb(Jb ~= jk);
    Jb = [Jb jj];
    B = inv(A(:, Jb));
    
    J = 1:n;
    Jnb = J(~ismember(J, Jb));
    if mjk == 1
        if ismember(jj, JnbP)
            JnbP = JnbP(JnbP ~= jj);
            JnbP = [JnbP jk];
        else
            JnbP = [JnbP jk];
        end
    else
        if ismember(jj, JnbP)
            JnbP = JnbP(JnbP ~= jj);
        end
    end
    JnbM = Jnb(~ismember(Jnb, JnbP));
end


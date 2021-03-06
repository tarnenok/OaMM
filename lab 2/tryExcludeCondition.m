function [ A, b, c, d, Ji, JiRow ] = tryExcludeCondition( A, b, c, d, Jb, Ji, JiRow, x )
%tryExcludeCondition - exclude condition gave rise synthetic variable in
%base plan
    EPS = 10^-8;
    [m, n] = size(A);
    i0 = 0;
    Jbi = setdiff(Jb, Ji);
    for i = 1:length(Jbi)
        if abs(x(Jbi(i)) - round(x(Jbi(i)))) > EPS
           i0 = Jbi(i);
           break;
        end
    end

    if i0 ~= 0
        Jib = intersect(Jb, Ji);
        if ~isempty(Jib)
            jj = Jib(1);
            index = find(Ji == jj);
            ARowTemp = A(JiRow(index), :)./A(JiRow(index), jj);
            bTemp = b(JiRow(index))/A(JiRow(index), jj);
            for i = 1:m
                tempRow = ARowTemp.*A(i, jj);
                tempb = bTemp.*A(i, jj);
                A(i, :) = A(i, :) - tempRow;
                b(i) = b(i) - tempb;
            end
            
            ANew = zeros(m - 1, n - 1);
            ANew(1:(JiRow(index) - 1), 1:(jj-1)) = A(1:(JiRow(index) - 1), 1:(jj-1));
            ANew(JiRow(index):end, 1:(jj-1)) = A((JiRow(index) + 1):end, 1:(jj-1));
            ANew(1:(JiRow(index) - 1), jj:end) = A(1:(JiRow(index) - 1), (jj + 1):end);
            ANew(JiRow(index):end, jj:end) = A((JiRow(index) + 1):end, (jj + 1):end);
            
            
            cNew = zeros(1, n - 1);
            cNew(1:jj - 1) = c(1, jj - 1);
            cNew(jj:end) = c((jj + 1):end);
            
            bNew = zeros(m - 1, 1);
            bNew(1, JiRow(index) - 1) = b(1, JiRow(index) - 1);
            bNew(JiRow(index):end) = b((JiRow(index) + 1):end);
            
            A = ANew;
            b = bNew;
            c = cNew;
            
            for i = (index + 1):length(Ji)
                Ji(i) = Ji(i) - 1;
                JiRow(i) = JiRow(i) - 1;
            end
            Ji = Ji(Ji ~= Ji(index));
            JiRow = JiRow(JiRow ~= JiRow(index));
        end
    end
end
function [ minWay, way ] = floid( D, R, i0, k0)
%Floid algorithm for finding the shortest way
    n = size(D, 1);
    changeIndex = 1:n;
    for j = 1:n
        rowJ = D(j, :);
        rowJ(j) = Inf;
        colJ = D(:, j);
        colJ(j) = Inf;
        rowChange = changeIndex(rowJ ~= Inf);
        colChange = changeIndex(colJ ~= Inf);
        for i = 1:length(colChange)
            for k = 1:length(rowChange)
                temp = D(colChange(i), j) + D(j, rowChange(k));
                if temp < D(colChange(i), rowChange(k))
                    D(colChange(i), rowChange(k)) = temp; 
                    R(colChange(i), rowChange(k)) = R(colChange(i), j); 
                end
            end
        end
    end
    
    minWay = D(i0, k0);
    
    way = zeros(1, n);
    way(1) = i0;
    intermediatePoint = way(1);
    pointCount = 2;
    while intermediatePoint ~= k0
        intermediatePoint = R(intermediatePoint, k0);
        way(pointCount) = intermediatePoint;
        pointCount = pointCount + 1;
    end
    way = way(1:pointCount - 1);
end


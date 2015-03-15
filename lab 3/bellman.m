function [ B, X ] = bellman( resArgs )
%bellman - 
%INPUT:
%   -resArgs - array of resource effectiveness
%OUTPUT:
%   -B - bellman function values
%   -X - value of resources for bellman function
    [m, n] = size(resArgs);
    B = zeros(m, n);
    X = zeros(m, n);
    B(1, 1:n) = resArgs(1, 1:n);
    for i = 2:m
        for j = 1:n
            tempMax = zeros(1, j);
            for k = 1:length(tempMax)
                tempMax(k) = resArgs(i, k) + B(i - 1, j - k + 1);
            end
            [B(i, j), X(i, j)] = max(tempMax);
            X(i, j) = X(i, j) - 1;
        end
    end
end


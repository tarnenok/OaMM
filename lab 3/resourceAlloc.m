function [ resAllocArgs, maxVal ] = resourceAlloc( resArgs )
%resourceAlloc -task of resource allocation
%INPUT:
%   -resArgs - array of resource effectiveness
%OUTPUT:
%   -resAllocArgs - array different type resouce allocation
%   -maxVal - max value with optimum resource allocation
    [m, c] = size(resArgs);
    [B, X] = bellman(resArgs);
    
    resAllocArgs = zeros(1, m);
    [maxVal, index] = max(B(m, :));
    resAllocArgs(m) = X(m, index);
    c = c - resAllocArgs(m);    
    for i = (m - 1):-1:1
        if c == 1
            break;
        else
            resAllocArgs(i) = X(i, c);
            c = c - resAllocArgs(i);
        end
    end
end


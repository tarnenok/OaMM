function prettyFloid( D, R , i0, k0)
    [minWay, way] = floid(D, R, i0, k0);
    fprintf('Floid method for finding the shortest way\n');
    fprintf('Min way: %d\n', minWay);
    fprintf('Way: %d', way(1))
    for i = 2:length(way)
        fprintf(' -> %d', way(i));
    end
    fprintf('\n');
end


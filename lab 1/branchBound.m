function [ x ] = branchBound( A, b, c, d )
%Integer number task
    tasks = Task(A, b, c, d);
    t = 1;
    r0 = -Inf;
    m0 = 0;
    m = 1:length(c);
    while ~isempty(tasks)
        task = tasks(1);
        x = dualSimplex(task.A, task.b, task.c, task.d);
        if isempty(x) || c*x' <= r0
            t = t + 1;
            tasks = tasks(tasks ~= task);
            continue;
        else
            j0 = -1; 
            for i = 1:length(x)
                if abs(x(i) - round(x(i))) > eps
                    j0 = i;
                    break;
                end
            end
            if j0 == -1
                m = x;
                m0 = 1;
                r0 = c*x';
                t = t + 1;
            else
%                 l = sign(x(j0))*ceil(abs(x(j0)));
                l = floor(x(j0));
                tasks = [tasks task.toNewTask(j0, [task.d(j0,1) l])];
                tasks = [tasks task.toNewTask(j0, [l + 1, task.d(j0,2)])];
                tasks = tasks(tasks ~= task);
                t = t + 1;
            end
        end
    end
    
    if m0 == 1
        x = m;
    else
        x = [];
    end
end


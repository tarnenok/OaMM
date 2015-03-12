classdef Task < handle
    properties
        A;
        b;
        c;
        d;
    end
    
    methods
        function this = Task(A, b, c, d)
            this.A = A;
            this.b = b;
            this.c = c;
            this.d = d;
        end
        
        function obj = toNewTask(this, j, d)
            obj = Task(this.A, this.b, this.c, this.d);
            obj.d(j, 1) = d(1);
            obj.d(j, 2) = d(2);
        end
    end
    
end


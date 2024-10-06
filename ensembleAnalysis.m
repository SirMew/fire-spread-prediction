function [P_o, P_f, P_b] = ensembleAnalysis(maps)

%initialise matrices
[M,N,I] = size(maps);

out = zeros(M,N);
fuel = zeros(M,N);
fire = zeros(M,N);



for i = 1:I %loop through datasets
   
    for m = 1:M
        for n = 1:N
            %index map where true, plus ones all at once, branchless
            if maps(m,n,i) == 1
                out(m,n) = out(m,n) + 1;
            elseif maps(m,n,i) == 2
                fuel(m,n) = fuel(m,n) + 1;
            elseif maps(m,n,i) == 3
                fire(m,n) = fire(m,n) + 1;
            else
                %for maps(m,n,i) == 0
            end
            
        end
    end
end

%probability of cell being in each state (matrix form)
P_o = out/I;
P_f = fuel/I;
P_b = fire/I;
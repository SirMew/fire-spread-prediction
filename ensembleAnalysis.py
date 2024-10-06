def ensembleAnalysis(maps):

#initialise matrices
M,N,I = maps.size()

out = np.zeros([M,N])
fuel = np.zeros([M,N])
fire = np.zeros([M,N])



for i in I: #loop through datasets
   
    for m  in M:
        for n = 1:N
            #index map where true, plus ones all at once, branchless
            if maps[m,n,i] == 1:
                out[m,n] = out[m,n] + 1
            elif maps[m,n,i] == 2:
                fuel[m,n] = fuel[m,n] + 1
            elif maps[m,n,i] == 3:
                fire[m,n] = fire[m,n] + 1
            else:
                #for maps(m,n,i) == 0
            
            
        
    


#probability of cell being in each state (matrix form)
P_o = out/I
P_f = fuel/I
P_b = fire/I

return P_o, P_f, P_b
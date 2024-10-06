def predictor(map_init, measurementTime, timeSteps):

[m,n] = size(map_init)
N = timeSteps
T_m = measurementTime
maps = zeros(m,n,N)
map_init = map_init

#Simulate N times
for sims = 1:N
    map_init = map_init
    #simulate model for T_m timesteps
    for T in T_m
        map_init = transitionRulesModel(map_init)
        
        #display map for debugging
#         colormap([.5,.5,.5;0,1,0;1,0,0]);
#         image(map); %display timestep graphically
#         pause(0.05);
    
    
    maps[:,:,sims] = map_init[:,:] #assign last model timestep of map for ensemble simulation
return maps


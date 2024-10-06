function maps = predictor(map, measurementTime, timeSteps)

[m,n] = size(map);
N = timeSteps;
T_m = measurementTime;
maps = zeros(m,n,N);
map_init = map;

%Simulate N times
for sims = 1:N
    map = map_init;
    %simulate model for T_m timesteps
    for T = 1:T_m
        map = transitionRulesModel(map);
        
        %display map for debugging
%         colormap([.5,.5,.5;0,1,0;1,0,0]);
%         image(map); %display timestep graphically
%         pause(0.05);
    
    end
    maps(:,:,sims) = map(:,:); %assign last model timestep of map for ensemble simulation
end


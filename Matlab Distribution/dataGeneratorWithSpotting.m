clc;
clear;
close all;


pic = 'ScenarioC.png';
writeFiles = 1;
laptop = 1;
videoWrite = 1;
display = 1;
colormap([.5,.5,.5;0,1,0;1,0,0]);

if laptop == 1
    path='C:\MCHA Workspace\firespreadfyp\Cellular Automata\CA Estimator with Spotting\data';
else 
    path='T:\MCHA Tool Chain 2.0\firespreadfyp\Cellular Automata\CA Estimator with Spotting\data';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%% Probability Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = 300;
J = I;
K = 100;
M = I;
N = J;
F = 2*ones(M,N); 
F(M/2:M/2+5,N/2:N/2+5) = 3; %Set ignition point
B = 0.3; %probability variable for ignition
windSpeed = 5; %ms (3.3 - 4.17 ms threshold)
spotRand = 0.0008;
% spotRand = 0;
mu_spotting = 50;
Pden = 0.3;
Pveg = -0.4; %lower number more moisture
c1 = 0.045; %wind constant defined empirically by Alexandridis
burn_rate = 0.15/(1 - c1*windSpeed); %lower number = longer burn time

timesteps = 250;
%% Run some error checks
if (burn_rate <= 0)
   error("Gosh darn it, you have an impossible burn rate that need to be greater than zero") 
end
O = 1 - exp(-burn_rate); % burning rate O = rate/time
windDirection = 'SE';

if ((windSpeed <= 0) && ~strcmp(windDirection,'O'))
    error("Captain, the windspeed must be greater than zero if a wind direction is given!");
end

% N = [(i-1,j-1), (i-1,j), (i-1, j+1)]
% NE = [(i-1,j), (i-1,j+1), (i, j+1)]
% E = [(i-1,j+1), (i,j+1), (i+1, j+1)]
% SE = [(i,j+1), (i+1,j+1), (i+1, j)]
% S = [(i+1,j+1), (i+1,j), (i+1, j-1)]
% SW = [(i+1,j), (i+1,j-1), (i, j-1)]
% W = [(i+1,j-1), (i,j-1), (i-1, j-1)]
% NW = [(i,j-1), (i-1,j-1), (i-1, j)]

%[1,2,3] - [out, fuel, fire]


tic
%Generate Map with empty border
    M = 300;
    N = 300;
    F = 2*ones(M,N); 
    F(15:25,20:35) = 3;
%     F(M/2:M/2+5,N/2:N/2+5) = 3; %Set ignition point
    F = imageToFireMap(pic);
    [M,N] = size(F);
    if(display == 1)
        figure(1);
        image(F);
        pause(0.05);
    end
    
for T = 1:timesteps
    FB = zeros(M,N);
    SF = zeros(M,N);
    % calculate one time step of map
    for i = 2:M-1
       for j = 2:N-1

           %if cell is fuel check to for burning neighbors
           if F(i,j) == 2

               Nb = 0; %initialise number of burning neighbors as 0;

               %check if neighbor is burning and enumerate if so

               if (strcmp(windDirection,'O'))
                   if F(i-1,j-1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i-1,j) == 3
                       Nb = Nb + 1;
                   end

                   if F(i,j-1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i-1,j+1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i+1,j-1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i+1,j) == 3
                       Nb = Nb + 1;
                   end

                   if F(i,j+1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i+1,j+1) == 3
                       Nb = Nb + 1;
                   end
               end
               %% South-east Wind
               if (strcmp(windDirection,'SE'))
                   if F(i,j-1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i-1,j-1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i-1,j) == 3
                       Nb = Nb + 1;
                   end
               end
               %% North Wind
               if (strcmp(windDirection,'N'))
                   if F(i+1,j+1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i+1,j) == 3
                       Nb = Nb + 1;
                   end

                   if F(i+1,j-1) == 3
                       Nb = Nb + 1;
                   end
               end

               %%West Wind
               if (strcmp(windDirection,'S'))
                   if F(i-1,j-1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i-1,j) == 3
                       Nb = Nb + 1;
                   end

                   if F(i-1,j+1) == 3
                       Nb = Nb + 1;
                   end
               end

               %% East Wind
               if (strcmp(windDirection,'E'))
                   if F(i+1,j-1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i,j-1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i-1,j-1) == 3
                       Nb = Nb + 1;
                   end
               end

               %% West Wind
               if (strcmp(windDirection,'W'))
                   if F(i-1,j+1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i,j+1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i+1,j+1) == 3
                       Nb = Nb + 1;
                   end
               end

               %% North-east Wind
               if (strcmp(windDirection,'NE'))
                   if F(i+1,j) == 3
                       Nb = Nb + 1;
                   end

                   if F(i+1,j-1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i,j-1) == 3
                       Nb = Nb + 1;
                   end
               end

               %% North-west Wind
               if (strcmp(windDirection,'NW'))
                   if F(i+1,j+1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i,j+1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i+1,j) == 3
                       Nb = Nb + 1;
                   end
               end

               %% South-west Wind
               if (strcmp(windDirection,'SW'))
                   if F(i-1,j) == 3
                       Nb = Nb + 1;
                   end

                   if F(i-1,j+1) == 3
                       Nb = Nb + 1;
                   end

                   if F(i,j+1) == 3
                       Nb = Nb + 1;
                   end
               end




               %%

               if Nb ~= 0
                    Pw = exp(c1*windSpeed);
%                         P0 = (1-(1-B)^Nb);
                    P0 = 0.58;
                    prob_ign = P0*Pw*(1 + Pveg)*(1 + Pden);
%                         prob_ign = P0*Pw;
                    % Pw = exp(c1*V)*exp(V*c2*(cos(theta) - 1))*3
                    % if theta = 0 then 
                    % Pw = exp(c1*V)
                   if rand < prob_ign %prob_ign %if random sample is within probability set cell to burning
                       FB(i,j) = 1; %set to future burning
                   end
               end



           end

           %%
               if (windSpeed > 0) %if wind speed is greater than zero include spotting and determine wind direction
                   if (rand < spotRand) %determine if spotting will be 'birthed' by cell in wind direction

                       %% North spotting
                       if (strcmp(windDirection,'N'))
                            dist = round(exprnd(mu_spotting)); %random distance sampled from an exponential distribution
                            if((i - dist) < 1) %if cell to ignite spot fire is outside simulation area
                                %do nothing
                            elseif(F(i,j)==3 && F(i-dist,j)==2) %check that cell is down wind of burning cell
                                    SF(i-dist,j) = 1; %set to future spot fire

                            end
                       end

                       %% North-East Spotting
                       if (strcmp(windDirection,'NE'))
                            dist = round(exprnd(mu_spotting)); %random distance sampled from an exponential distribution
                            idist = round(dist/sqrt(2));
                            jdist = round(dist/sqrt(2));

                            if(((i - idist) < 1) || ((j + jdist) > M)) %if cell to ignite spot fire is outside simulation area
                                %do nothing
                            elseif(F(i,j)==3 && F(i - idist,j + jdist)==2) %check that cell is down wind of burning cell
                                    SF(i-idist, j+jdist) = 1; %set to future spot fire
                            end
                       end

                       %% East Spotting
                       if (strcmp(windDirection,'E'))
                            dist = round(exprnd(mu_spotting)); %random distance sampled from an exponential distribution
                            if((dist + j) > M) %if cell to ignite spot fire is outside simulation area
                                %do nothing

                            elseif(F(i,j)==3 && F(i,dist + j)==2) %check that cell is down wind of burning cell and that it is fuel
                                    SF(i,dist + j) = 1; %set to future spot fire

                            end

                       end

                       %% South-East Spotting
                       if (strcmp(windDirection,'SE'))
                            dist = round(exprnd(mu_spotting)); %random distance sampled from an exponential distribution
                            idist = round(dist/sqrt(2));
                            jdist = round(dist/sqrt(2));

                            if(((i + idist) > N) || ((j + jdist) >M)) %if cell to ignite spot fire is outside simulation area
                                %do nothing
                            elseif(F(i,j)==3 && F(i+idist,j+jdist)==2) %check that cell is down wind of burning cell
                                    SF(i+idist, j+jdist) = 1; %set to future spot fire
                            end
                       end

                       %% South Spotting
                       if (strcmp(windDirection,'S'))
                            dist = round(exprnd(mu_spotting)); %random distance sampled from an exponential distribution
                            if((dist + i) > N) %if cell to ignite spot fire is outside simulation area
                                %do nothing
                            elseif(F(i,j)==3 && F(i+dist,j)==2) %check that cell is down wind of burning cell
                                    SF(dist + i, j) = 1; %set to future spot fire

                            end
                       end

                       %% South-West Spotting
                       if (strcmp(windDirection,'SW'))
                            dist = round(exprnd(mu_spotting)); %random distance sampled from an exponential distribution
                            idist = round(dist/sqrt(2));
                            jdist = round(dist/sqrt(2));

                            if(((i + idist) > N) || ((j - jdist) <1)) %if cell to ignite spot fire is outside simulation area
                                %do nothing
                            elseif(F(i,j)==3 && F(i+idist,j-jdist) ) %check that cell is down wind of burning cell
                                    SF(i+idist, j-jdist) = 1; %set to future spot fire
                            end
                       end

                       %% West Spotting
                       if (strcmp(windDirection,'W'))
                            dist = round(exprnd(mu_spotting)); %random distance sampled from an exponential distribution
                            if((j - dist) < 1) %if cell to ignite spot fire is outside simulation area
                                %do nothing
                            elseif(F(i,j)==3 && F(i,j-dist)) %check that cell is down wind of burning cell
                                    SF(i, j-dist) = 1; %set to future spot fire

                            end
                       end

                       %% North-West Spotting
                       if (strcmp(windDirection,'NW'))
                            dist = round(exprnd(mu_spotting)); %random distance sampled from an exponential distribution
                            idist = round(dist/sqrt(2));
                            jdist = round(dist/sqrt(2));

                            if(((i - idist) < 1) || ((j - jdist) < 1)) %if cell to ignite spot fire is outside simulation area
                                %do nothing
                            elseif(F(i,j)==3 && F(i-idist,j-jdist)) %check that cell is down wind of burning cell
                                    SF(i-idist, j-jdist) = 1; %set to future spot fire
                            end
                       end

                   end
               end
           %%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%%%%%%%%%%%%%%%%%%%%
           %%%%%%%%%%%%%%%%%%%%%%%%

       end
    end
    %set cell burning in last time step to out based on probability
    ff = (F==3);
    out_idx  = find(ff);

    for idx = out_idx'
        if rand < O
            F(idx) = 1;
        end
    end



    %set new burning cells to burning
    burn_idx = find(FB); %find non zero elements
    F(burn_idx) = 3;
    FB = 0;
    ff = 0;
    out_idx = 0;
    burn_idx = 0;

    %set spot fire cells to burning
    spot_idx = find(SF);
    F(spot_idx) = 3;
    SF = 0;
    spot_idx = 0;

    if(display == 1)
        image(F); %display timestep graphically
        title(['Wind direction: ' windDirection '  Timestep: ' num2str(T)])
        colorbar
        pause(0.01);
        gf(T) = getframe(gcf);
    end


    %%%%%% WRITE FILES %%%%%
    if (writeFiles == 1)
        textfilename = ['MsC' num2str(T) '.csv'];
        path_format = fullfile(path, textfilename);
        writematrix(F,path_format);
    else

    end

end

toc
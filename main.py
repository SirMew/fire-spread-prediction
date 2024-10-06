import numpy as np

videoWrite = 1;
laptop = 1;
savefigures = 1;
#%% Load sensor data (measurements)

if (laptop == 1)
   path='phoenix\Python\Cellular Automata\CA Estimator with Spotting\data'
else
   path='T:\MCHA Tool Chain 2.0\firespreadfyp\Cellular Automata\CA Estimator with Spotting\data';
end

timesteps = 250 #total timesteps of fire spread prediction
M = 1000
N = M

data = np.zeros([M,N,timesteps])

for i in timesteps:
    textfilename = ['MsC_t' num2str[i] '.csv']
    path_format = fullfile(path, textfilename)
    data[:,:,i] = readmatrix(path_format)




print('Data read from files')


#%%
# Load or initialise map
pic = 'Scenario.png'
# F = imageToFireMap(pic);
F = 2*np.ones([M,N])
# F(M/2:M/2+5,N/2:N/2+5) = 3; %Set ignition point
# F(15:25,20:35) = 3;
F = imageToFireMap(pic)
F_0 = F

Nsims = 100 #number of simulations for ensemble analysis
#[1,2,3] - [out, fuel, fire]

T_m = 10 #timesteps between measurement updates

for T in timesteps:
    
    #initialise some posterior variables
    e_dB_f_data = np.zeros([M,N])
    e_dB_b_data = np.zeros([M,N])
    e_dB_o_data = np.zeros([M,N])
    
    debug_f = np.zeros([M,N])
    debug_b = np.zeros([M,N])
    debug_o = np.zeros([M,N])
    
    # Measurement Update
    if mod(T,T_m) == 0 #multiple of T_m
        #Read in data from dataset
        pdata[:,:] = data[:,:,T]
        theta = getParameters()
        FF = np.zeros([M,N])
        
        # Predictor Step
        # Run N simulations for T_m timesteps from last timestep update map
        Fs = predictor(F_0,T_m,Nsims)
        
        #ensemble analysis loops through all the final data sets to determine
        #the mean of each cell being in each state (matrix form for each cell probability mean)
        [mu_data_o,  mu_data_f, mu_data_b] = ensembleAnalysis(Fs) #probabilities not means

        figure1 = figure(1)
        colormap([.5,.5,.5;0,1,0;1,0,0])
        subplot(2,2,1)
        imshow(mu_data_b)
        title(['Ensemble Analysis Average Probability - Burning. Timestep: ' num2str(T)])
        colorbar
        subplot(2,2,2)
        imshow(mu_data_o)
        title(['Ensemble Analysis Average Probability - Out. Timestep: ' num2str(T)])
        colorbar
        subplot(2,2,3)
        imshow(mu_data_f)
        title(['Ensemble Analysis Average Probability -  Fuel. Timestep: ' num2str(T)])
        colorbar
        pause(0.05)
        figure1filename = [path '\figures\EA Mean' num2str(T) '.fig']
        if savefigures ==1
            savefig(figure1, figure1filename)
        e
        
        #Assess each cell one at a time
        for i in M
            for j in N
                p.data = pdata[i,j]
                p.mu_data_f = mu_data_f[i,j]
                p.mu_data_b = mu_data_b[i,j]
                p.mu_data_o = mu_data_o[i,j]
                ~, o = cellStateClassifier(theta, p) #pass in one cell at a time
                
                e_dB_f_data[i,j] = o.e_dB_f_data;
                e_dB_b_data[i,j] = o.e_dB_b_data;
                e_dB_o_data[i,j] = o.e_dB_o_data;
                
                debug_f[i,j] = o.lik_dB_f;
                debug_b[i,j] = o.lik_dB_b;
                debug_o[i,j] = o.lik_dB_o;
                
                
                #determine the highest probability for each cell based
                #off the bayesian estimator
                if(max([e_dB_f_data(i,j), e_dB_b_data(i,j), e_dB_o_data(i,j)]) == e_dB_f_data(i,j))
                    FF(i,j) = 2;
                elseif(max([e_dB_f_data(i,j), e_dB_b_data(i,j), e_dB_o_data(i,j)]) == e_dB_b_data(i,j))
                    FF(i,j) = 3;
                elseif(max([e_dB_f_data(i,j), e_dB_b_data(i,j), e_dB_o_data(i,j)]) == e_dB_o_data(i,j))
                    FF(i,j) = 1;
                else %should never get here
                    error('Wuh oh Scoob. An unexpected error occurred. Looks like you have some impossible posterior values') 
                end
                
            end
        end
        F_0 = zeros(M,N); %clear F_0
        F_0 = FF; %save timestep update to initialise ensemble model
        
    else 
        
        %if not at a measurement update timestep assign prediction as next
        %step
        FF = predictor(F,1,1);
        
    end
    % Display map
    figure2 = figure(2);
    c = colorbar();
    colormap([.5,.5,.5;0,1,0;1,0,0]);
    set(get(c,'label'),'string','Out                         Fuel                      Fire');
    image(FF);
    title(['  Timestep: ' num2str(T)])
    colorbar
    fireframe(T) = getframe(gcf);
    figure2filename = [path '\figures\Map' num2str(T) '.fig'];
    if savefigures ==1
        savefig(figure2, figure2filename)
    end
    if mod(T,T_m) == 0 %multiple of T_m
        
        figure4 = figure(4);
        colormap gray
        subplot(2,2,1)
        imshow(e_dB_b_data);
        title(['Measurement Likelihood - Burning. Timestep: ' num2str(T)])
        colorbar
        subplot(2,2,2)
        imshow(e_dB_o_data);
        title(['Measurement Likelihood - Out. Timestep: ' num2str(T)])
        colorbar
        subplot(2,2,3)
        imshow(e_dB_f_data);
        title(['Measurement Likelihood - Fuel. Timestep: ' num2str(T)])
        colorbar
        figure4filename = [path '\figures\Measurement Likelihood' num2str(T) '.fig'];
        if savefigures == 1
            savefig(figure4, figure4filename)
        end
    end 
    pause(0.05)
    %Reinitialise F for predictor
    F = FF;
end

if (videoWrite == 1)
    writerObj = VideoWriter('main.avi');
    writerObj.FrameRate = 10; % sets the fps
    open(writerObj);

    for t = 1:length(fireframe)
        % convert the image to a frame
        frame = fireframe(t);
        writeVideo(writerObj, frame)
    end

    close(writerObj);

end

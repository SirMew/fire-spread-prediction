#Get standard deviations and prior probabilities
def getParameters():


# Standard deviation of measurement likelihood
sigma_f = 5 #NaN;  % stdev of cell fuel uncertainty
sigma_b = 5.5 #200;  % 216stdev of cell burning uncertainty
sigma_o = 5.5 #215;  %200 stdev of cell out uncertainty


# Prior hypothesis probabilities (common prior for each time step)

P_f	= 9858/10000 # %portion of world that is fuel at initial time step
P_b	= 101/10000 #portion of world that is burning at initial time step
P_o = 1 - (P_f + P_b) #portion of world that is out fuel at initial time step

if (P_f + P_b + P_o ~= 1):
   print("Ruh roh Raggy, prior probabilities must sum to 1") 


# uniformPlusExponetial distribution parameters
lowTemp = 25
upTemp = 35
lmda = 0.1

if (lowTemp == upTemp):
    print("Bing bong. Lower and upper temperature bounds for uniform distribution cannot be the same.")
elif(lowTemp > upTemp):
    print("Heck! Looks like you somehow managed to confuse lower and upper temperatures.")


# Pack parameters
theta = np.array([sigma_f;sigma_b;sigma_o;P_f;P_b;P_o;lowTemp;upTemp;lmda])
return theta
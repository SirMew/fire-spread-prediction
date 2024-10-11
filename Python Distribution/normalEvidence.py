# get the normal (guassian) evidence to create a likelihood model
import numpy as np

def normalEvidence(data, mu, sigma):

evidence = 10*((np.log(1/sigma/sqrt(2*np.pi)) -0.5*((data-mu)/sigma).^2 )/np.log(10));

return evidence
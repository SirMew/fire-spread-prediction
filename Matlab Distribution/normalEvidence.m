% get the normal (guassian) evidence to create a likelihood model
function evidence = normalEvidence(data, mu, sigma)

evidence = 10*((log(1/sigma/sqrt(2*pi)) -0.5*((data-mu)/sigma).^2 )/log(10));
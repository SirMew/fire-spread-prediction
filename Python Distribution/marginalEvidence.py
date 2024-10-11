# %
# % Helper function to compute 10*log10(sum(10.^(lik_dB/10) .* P, 2)) using
# % the log-sum-exp trick.
# % See also https://en.wikipedia.org/wiki/LogSumExp#log-sum-exp_trick_for_log-domain_calculations
# %
import numpy as np
def marginalEvidence(lik_dB, P):

x = lik_dB/10  + np.log10(P)
xstar = max(x,[],2)
evidence = 10*(xstar + np.log10(sum(10.^(x - xstar),2)))

return evidence
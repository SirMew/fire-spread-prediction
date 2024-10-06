%Bayesian estimator that classifies sensor measurements
function [surprisal, o] = cellStateClassifier(x, p)

% Standard deviation of measurement likelihood
sigma_f = x(1);
sigma_b = x(2);
sigma_o = x(3);

% Prior hypothesis probabilities (common prior for each time step)
P_f         = x(4);
P_b         = x(5);
P_o         = x(6);

% Parameters for normalPlusExponentEvidence
a = x(7);
b = x(8);
lambda = x(9);

%% Evaluate data likelihood functions

% Data likelihoods [dB]
% get mu from data? (ensemble mean per cell?)
% lik_dB_data_f   = uniformPlusExponentEvidence(p.data, a, b, lambda); %likelihood that cell/s is fuel
lik_dB_data_f   =  normalEvidence(p.data, p.mu_data_f, sigma_f); %likelihood that cell/s is burning
lik_dB_data_b   = normalEvidence(p.data, p.mu_data_b, sigma_b); %likelihood that cell/s is burning
lik_dB_data_o   = normalEvidence(p.data, p.mu_data_o, sigma_o); %likelihood that cell/s is out

%% Evaluate posterior evidence for each hypothesis

% Data likelihoods [dB] assuming each hypothesis is true, i.e., 10*log10(p(D|H))
o.lik_dB_f   = lik_dB_data_f; %likelihood that cell/s is fuel
o.lik_dB_b   = lik_dB_data_b; %likelihood that cell/s is burning
o.lik_dB_o   = lik_dB_data_o; %likelihood that cell/s is out

lik_dB_all    = [o.lik_dB_f, o.lik_dB_b, o.lik_dB_o];%#########
P_all         = [P_f, P_b, P_o];
idx_not_f = [2,3];
idx_not_b = [1,3];
idx_not_o = [1,2];


% Data likelihoods [dB] assuming each hypothesis is false, i.e., 10*log10(p(D|notH))
o.lik_dB_not_f   = marginalEvidence(lik_dB_all(:,idx_not_f),    P_all(idx_not_f)) - 10*log10(sum(P_all(idx_not_f)));
o.lik_dB_not_b   = marginalEvidence(lik_dB_all(:,idx_not_b),    P_all(idx_not_b)) - 10*log10(sum(P_all(idx_not_b))); %#########
o.lik_dB_not_o   = marginalEvidence(lik_dB_all(:,idx_not_o),    P_all(idx_not_o)) - 10*log10(sum(P_all(idx_not_o))); %#########

% o.lik_dB_not_f   = o.lik_dB_b + o.lik_dB_o;
% o.lik_dB_not_b   = o.lik_dB_f + o.lik_dB_o;
% o.lik_dB_not_o   = o.lik_dB_f + o.lik_dB_b;

% Evaluate prior evidence [dB]
o.e_dB_f         = 10*log10(P_f/(P_b+P_o));
o.e_dB_b         = 10*log10(P_b/(P_f+P_o));
o.e_dB_o         = 10*log10(P_o/(P_f+P_b));

%     % Evaluate posterior evidence [dB]
o.e_dB_f_data     = o.e_dB_f   + o.lik_dB_f   - o.lik_dB_not_f; %########
o.e_dB_b_data     = o.e_dB_b   + o.lik_dB_b   - o.lik_dB_not_b; %########2
o.e_dB_o_data     = o.e_dB_o   + o.lik_dB_o   - o.lik_dB_not_o; %########2


% Marginal likelihood [dB]
o.lik_dB = marginalEvidence(lik_dB_all, P_all);

% Total surprisal
surprisal = -sum(o.lik_dB);

if ~isfinite(surprisal) || ~isreal(surprisal) %if surprisal is infinite or not a real number
    error('SURPRISE: A surprising error was encountered while computing the surprisal.')
end
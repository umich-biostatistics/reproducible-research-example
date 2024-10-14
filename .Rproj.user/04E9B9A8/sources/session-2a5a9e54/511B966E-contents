# Load the rjags package
library(rjags)
library(yaml)

config = yaml.load_file("config-sim.yaml")

seed = config$seed
n.adapt = config$n.adapt
n.burn = config$n.burn
n.sampling = config$n.sampling

# Define the JAGS model as a string
model_string = "
model {
  for (i in 1:N) {
    # Logistic regression likelihood for binary classification
    y[i] ~ dbern(p[i])
    logit(p[i]) = beta_0 + inprod(beta[1:15], x[i,])
  }
  
  # Priors for the intercept and regression coefficients
  beta_0 ~ dnorm(0, 0.001)
  for (j in 1:15) {
    beta[j] ~ dnorm(0, 0.001)
  }
}
"

# Simulated data
set.seed(seed)
N = 1000  # Number of observations
x = matrix(rnorm(N * 15), nrow = N, ncol = 15)  # 15-dimensional input features
true_beta = c(1.5, -0.5, 0.8, -1.2, 0.3, 0.7, -0.8, 0.2, 1.1, -0.4, 0.9, 1.3, -1.1, 0.5, -0.7)
true_beta_0 = -0.2
logit_p = true_beta_0 + x %*% true_beta
p = 1 / (1 + exp(-logit_p))
y = rbinom(N, size = 1, prob = p)  # Binary outcome based on probabilities

# Bundle data for JAGS
data_list = list(
    x = x,
    y = y,
    N = N
)

# Initialize and sample from the model
model = jags.model(textConnection(model_string), data = data_list, n.chains = 3, n.adapt = n.adapt)
update(model, n.burn)  # Burn-in

# Sample from the posterior
samples = coda.samples(model, variable.names = c("beta_0", "beta"), n.iter = n.sampling)

# Posterior summaries
summary(samples)

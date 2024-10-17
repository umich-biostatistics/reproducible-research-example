# Load the rjags package
library(rjags)
library(yaml)
library(tidyverse)

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
true_beta_pars = read_csv("data/true_beta_pars.csv")
true_beta0 = true_beta_pars[["true_beta"]][1]
true_beta = true_beta_pars[["true_beta"]][-1]
logit_p = true_beta0 + x %*% true_beta
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

# Convert coda samples into a data frame
samples_df = 
    samples |> 
    as.matrix() |> 
    as.data.frame()
    

# Calculate summary statistics for each parameter
summary_df = 
    samples_df |>
    summarise(across(everything(), list(
        mean = ~ mean(.),
        sd = ~ sd(.),
        lower.ci = ~ quantile(., probs = 0.025),
        upper.ci = ~ quantile(., probs = 0.975)
    ), .names = "{.col}_{.fn}")) |>
    pivot_longer(
        cols = everything(),
        names_to = c("parameter", "stat"),
        names_pattern = "(.*)_(.*)"
    ) |>
    pivot_wider(
        names_from = stat,
        values_from = value
    ) |>
    mutate(
        parameter = 
            parameter |> 
            str_replace_all("\\[|\\]", "_") |> 
            str_remove("_$")
    ) |> 
    arrange(parameter) |> 
    left_join(
        true_beta_pars,
        by = "parameter"
    )

# Write the summary statistics to a CSV file
write_csv(summary_df, "results/posterior_summary.csv")


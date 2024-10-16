library(tidyverse)
library(ggplot2)

posterior_summary = 
    "results/posterior_summary.csv" |> 
    read_csv()


posterior_plot = 
    posterior_summary |> 
    ggplot() +
    aes(x = mean, y = parameter) +
    geom_point(
        color = "blue", size = 3
    ) +  # Plot simulated mean estimates
    geom_errorbar(
        aes(xmin = lower.ci, xmax = upper.ci), color = "blue", width = 0.2
    ) +  # Add 95% CI
    geom_point(
        aes(x = true_beta), 
        color = "red", shape = 17, size = 3
    ) +  # Plot true parameter values
    labs(
        title = "Simulated Estimate vs. True Parameter Value with 95% CIs",
        x = "Estimate",
        y = "Parameter"
    ) +
    theme_minimal(base_size = 14) +
    theme(
        plot.title = element_text(hjust = 0.5, size = 16, face = "bold"),
        axis.title.x = element_text(size = 14, margin = margin(t = 10)),
        axis.title.y = element_text(size = 14, margin = margin(r = 10)),
        axis.text.y = element_text(size = 12, color = "gray20"),
        axis.text.x = element_text(size = 12, color = "gray20"),
        panel.grid.major = element_line(color = "gray85", size = 0.5),
        panel.grid.minor = element_blank()
    )

save(posterior_plot, file = "results/posterior-samples.rda")

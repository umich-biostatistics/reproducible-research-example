library(targets)

tar_option_set(packages = c("rjags", "yaml", "tidyverse", "quarto"))

# Define the pipeline
list(
    tar_target(
        simulation,
        {
            system("Rscript R/sim-binomial-bayes.R")
            "results/posterior_summary.csv"
        },
        format = "file"
    ),
    
    tar_target(
        plot,
        {
            system("Rscript R/plot-binomial-bayes.R")
            "results/posterior-samples.rda"
        },
        format = "file"
    ),
    
    # Generate a report
    tar_target(
        report,
        {
            system("quarto render doc/report.qmd")
            "doc/report.qmd"
        },
        format = "file"
    )
)

library(targets)
library(tarchetypes)

tar_option_set(packages = c("rjags", "yaml", "tidyverse", "quarto", "tarchetypes"))

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
            simulation
            system("Rscript R/plot-binomial-bayes.R")
            "results/posterior-samples.rda"
        },
        format = "file"
    ),
    
    tar_target(
        copied_posterior_samples,
        {
            plot
            file.copy(from = "results/posterior-samples.rda", 
                      to = "posterior-samples.rda", 
                      overwrite = TRUE)
            "posterior-samples.rda"
        },
        format = "file"
    ),
    
    # Generate a report
    # tar_target(
    #     report,
    #     {
    #         copied_posterior_samples
    #         system("quarto render doc/report.qmd")
    #         "doc/report.qmd"
    #     },
    #     format = "file"
    # ),
    
    tar_quarto(
        report,
        "doc/report.qmd",
        execute_params = list(your_param = copied_posterior_samples)
    )
)

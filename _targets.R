library(targets)

tar_option_set(packages = c("rjags", "yaml", "tidyverse", "quarto"))

# Define the pipeline
list(
    # Load and prepare data
    # tar_target(data, read.csv("data.csv")),
    
    # Process data (e.g., filter or transform)
    # tar_target(processed_data, dplyr::filter(data, value > 10)),
    
    # Run a simulation or analysis
    # tar_target(simulation_results, simulate_function(processed_data)),
    
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
    # tar_target(report, {
    #     quarto::quarto_render("report.qmd")
    #     "report.html"  # Return the output filename for tracking
    # })
)

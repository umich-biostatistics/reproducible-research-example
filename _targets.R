library(targets)

tar_option_set(packages = c("rjags", "yaml", "tidyverse"))

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
            system("Rscript sim-binomial-bayes.R")
            "posterior_summary.csv"
        },
        format = "file"
    )
    
    # Generate a report
    # tar_target(report, {
    #     quarto::quarto_render("report.qmd")
    #     "report.html"  # Return the output filename for tracking
    # })
)

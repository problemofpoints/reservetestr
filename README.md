
<!-- README.md is generated from README.Rmd. Please edit that file -->

# reservetestr

The goal of reservetestr is to provide a framework for testing loss
reserve methods. Specifically, an interface to test methods against the
[Casualty Actuarial Society (CAS) Loss Reserve
Database](http://www.casact.org/research/index.cfm?fa=loss_reserves_data)
is provided.

## Installation

You can install reservetestr from GitHub with:

``` r
# install.packages("devtools")
devtools::install_github("problemofpoints/reservetestr")
```

## Example Useage

Insert example here…

## Future Enhancements

  - \[ \] write function to apply reserving methods
      - start with deterministic? then stochastic?
          - different functions or argument?
      - make resulting object an S3 class?
      - use CL/Mack as test (use as vignette)
      - add more error handling
  - \[ \] write wrappers around methods to work with above function
      - do for as many methods as possible included in `ChainLadder`
        package
      - for deterministic, do average of methods example?
      - add more error handling
  - \[ \] write functions to create exhibits

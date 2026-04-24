# polynomialregr

MLR3 Learner for Polynomial Regression.

## Installation

```r
devtools::install_github("imanechadli2003/polynomialregr")
```

## Usage

```r
library(mlr3)
library(polynomialregr)

task = tsk("mtcars")
learner = LearnerRegrPolynomial$new()
learner$param_set$values$degree = 2L
learner$train(task)
pred = learner$predict(task)
```

## Related work

- [Course wiki](https://github.com/tdhock/2026-01-aa-grande-echelle/wiki/projets)
- [mlr3 package](https://mlr3.mlr-org.com/)

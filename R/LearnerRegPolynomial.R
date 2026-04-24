#' @title Polynomial Regression Learner
#' @description MLR3 Learner for polynomial regression using stats::lm() with poly().
#' @import mlr3
#' @import mlr3misc
#' @import paradox
#' @import R6
#' @export
LearnerRegrPolynomial = R6::R6Class(
  "LearnerRegrPolynomial",
  inherit = mlr3::LearnerRegr,
  public = list(
    #' @description Creates a new instance of this learner.
    initialize = function() {
      super$initialize(
        id = "regr.polynomial",
        packages = character(0),
        feature_types = c("numeric", "integer"),
        predict_types = "response",
        param_set = paradox::ps(
          degree = paradox::p_int(lower = 1L, upper = 10L, default = 2L,
                                  tags = "train")
        ),
        label = "Polynomial Regression",
        man = "polynomialregr::LearnerRegrPolynomial"
      )
    }
  ),
  private = list(
    .train = function(task) {
      degree = self$param_set$get_values()$degree
      if (is.null(degree)) degree = 2L
      data = task$data()
      target = task$target_names
      features = task$feature_names
      poly_terms = paste(
        sprintf("poly(%s, degree = %d, raw = TRUE)", features, degree),
        collapse = " + "
      )
      formula = as.formula(paste(target, "~", poly_terms))
      mlr3misc::invoke(stats::lm, formula = formula, data = data)
    },
    .predict = function(task) {
      newdata = task$data(cols = task$feature_names)
      response = predict(self$model, newdata = newdata)
      list(response = response)
    }
  )
)

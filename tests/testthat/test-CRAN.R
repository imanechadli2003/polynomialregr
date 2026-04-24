test_that("train et predict fonctionnent", {
  task = mlr3::tsk("mtcars")
  learner = LearnerRegrPolynomial$new()
  learner$param_set$values$degree = 2L
  learner$train(task)
  expect_true(!is.null(learner$model))
  pred = learner$predict(task)
  expect_equal(length(pred$response), task$nrow)
})

test_that("degree hyperparameter change le modele", {
  task = mlr3::tsk("mtcars")
  lrn1 = LearnerRegrPolynomial$new()
  lrn1$param_set$values$degree = 1L
  lrn1$train(task)
  lrn2 = LearnerRegrPolynomial$new()
  lrn2$param_set$values$degree = 3L
  lrn2$train(task)
  pred1 = lrn1$predict(task)$response
  pred2 = lrn2$predict(task)$response
  expect_false(all(pred1 == pred2))
})

library(mlr3)
library(mlr3learners)
library(mlr3tuning)
library(polynomialregr)
library(ggplot2)

# Installer les packages manquants si nécessaire
# install.packages(c("mlr3learners", "mlr3tuning", "ggplot2"))

# Jeux de données de régression
library(mlr3data)
tasks = list(
  tsk("mtcars"),
  as_task_regr(airquality[complete.cases(airquality),],
               target = "Ozone",
               id = "airquality")
)

# 1. Ton nouveau Learner
lrn_poly = LearnerRegrPolynomial$new()
lrn_poly$param_set$values$degree = 2L
lrn_poly$id = "poly_regr"

# 2. Featureless
lrn_featureless = lrn("regr.featureless")

# 3. Modèle linéaire CV Glmnet
lrn_glmnet = lrn("regr.cv_glmnet")

# 4. Plus proches voisins avec auto_tuner
lrn_knn = auto_tuner(
  tuner = tnr("grid_search", resolution = 10),
  learner = lrn("regr.kknn", k = to_tune(1L, 10L)),
  resampling = rsmp("cv", folds = 3),
  measure = msr("regr.mse")
)
lrn_knn$id = "kknn_tuned"

# Benchmark design
design = benchmark_grid(
  tasks = tasks,
  learners = list(lrn_poly, lrn_featureless, lrn_glmnet, lrn_knn),
  resamplings = rsmp("cv", folds = 5)
)

bmr = benchmark(design)

# Résultats
results = bmr$score(msr("regr.mse"))

# Graphique
ggplot(results, aes(x = regr.mse, y = learner_id)) +
  geom_point() +
  facet_grid(task_id ~ ., scales = "free_x") +
  labs(x = "MSE", y = "learner_id",
       title = "Benchmark — Polynomial Regression vs autres Learners")

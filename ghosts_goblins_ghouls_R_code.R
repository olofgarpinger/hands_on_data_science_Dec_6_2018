# Hands on Data Science meetup at Foo Café, 20181206
# Code by Olof Rännbäck-Garpinger, Knightec AB
#
# Make sure you have R and RStudio on your computer,
# and all libraries below installed in RStudio
# (Packages tab => Install => Type in name of library)

### Import libraries ###
library(tidyverse) # General data science tools
library(GGally) # For exploring data
library(caret) # Streamline the process for creating predictive models
library(rpart) # Decision trees
library(randomForest) # Random forest
library(gbm) # Gradient boosting



### Read data ###

# Training set
boo_train <- read_csv("train.csv") %>% 
  mutate(type = as.factor(type),
         color = as.factor(color)) %>% 
  select(-id)
boo_train

# Test set, for which the type needs to be predicted
boo_test <- read_csv("test.csv") %>% 
  mutate(color = as.factor(color))
test_id <- boo_test %>% pull(id) # Save for Kaggle submission
boo_test <- boo_test %>% select(-id)
boo_test



### Exploratory data analysis ###

# Explore the data with GGally::ggpairs
boo_train %>% 
  ggpairs(aes(col = type))



### Classification ###

## Prepare for 10-fold cross validation with 3 repeats
ctrl <- trainControl(
  method = "repeatedcv", 
  number = 10,
  repeats = 3
)


## Decision tree model

# Create an unpruned decision tree by setting cp = 0
complexity <-  expand.grid(cp = 0)

# Build the model on training data
tree_model <- train(type ~ .,
                    data = boo_train,
                    method = "rpart",
                    tuneGrid = complexity)

# Plot tree
plot(tree_model$finalModel) 
text(tree_model$finalModel)

# Predict test data classes
tree_pred <- predict(tree_model,
                     newdata = boo_test,
                     type = "raw")

# Create csv for submission on Kaggle
single_tree_submit <- tibble(id = test_id, 
                             type = tree_pred)
write_csv(single_tree_submit, "single_tree_submit.csv")


## Bagging and Random forest 

# Use m (number of random variables chosen at each tree split) between 2 and 9
# Nine because the color variable is transformed into 5 different dummy variables
bagging <- expand.grid(mtry = 9) # Bagging when all 9 variables are used at each split
rf_m_rule_of_thumb <- expand.grid(mtry = 3) # Random forest with m = square root of variable count
rf_all_m <- expand.grid(mtry = 2:9) # Random forest over all possible m, to find optimal m

# Bagging on training data, 500 trees are used by default
set.seed(1)
bagging_model <- train(type ~ .,
                       data = boo_train,
                       method = "rf",
                       control = ctrl,
                       tuneGrid = bagging)
bagging_model

# Random Forest with m = 3 on training data
set.seed(1)
rf_model_rule_of_thumb <- train(type ~ .,
                                data = boo_train,
                                method = "rf",
                                control = ctrl,
                                tuneGrid = rf_m_rule_of_thumb)
rf_model_rule_of_thumb

# Random Forest models with m = 2, 3, ..., 9, on training data
set.seed(1)
rf_model_all_m <- train(type ~ .,
                       data = boo_train,
                       method = "rf",
                       control = ctrl,
                       tuneGrid = rf_all_m)
rf_model_all_m
plot(rf_model_all_m) # Mean accuracy of all models
varImpPlot(rf_model_all_m$finalModel) # Variable importance plot of final model,
                                      # showing which variables are most important
# Predict test data classes
bagging_pred <- predict(bagging_model,
                        newdata = boo_test,
                        type = "raw")
rf_m3_pred <- predict(rf_model_rule_of_thumb,
                      newdata = boo_test,
                      type = "raw")
rf_all_m_pred <- predict(rf_model_all_m,
                         newdata = boo_test,
                         type = "raw")

# Create csv:s for submission on Kaggle
bagging_submit <- tibble(id = test_id, 
                         type = bagging_pred)
write_csv(bagging_submit, "bagging_submit.csv")

rf_m3_submit <- tibble(id = test_id, 
                       type = rf_m3_pred)
write_csv(rf_m3_submit, "rf_m3_submit.csv")

rf_all_m_submit <- tibble(id = test_id, 
                          type = rf_all_m_pred)
write_csv(rf_all_m_submit, "rf_all_m_submit.csv")



## Gradient Boosting 
# Grid search over shrinkage factor, number of trees, and tree depth
# Used to find optimal parameters
boost_grid1 <- expand.grid(interaction.depth = c(1, 2, 3, 4, 5),
                           n.trees = (1:20)*50,
                           shrinkage = 0.01,
                           n.minobsinnode = 10)
boost_grid2 <- expand.grid(interaction.depth = c(1, 2, 3), 
                           n.trees = (10:30)*350, 
                           shrinkage = 0.001,
                           n.minobsinnode = 10)

set.seed(1)
boost_model1 <- train(type ~ ., 
                    data = boo_train,
                    method = "gbm",
                    trControl = ctrl,
                    verbose = FALSE,
                    tuneGrid = boost_grid1)
boost_model1
summary(boost_model1) # Variable importance, relative influence
View(boost_model1$results %>% 
       arrange(desc(Accuracy))
     )

set.seed(1)
boost_model2 <- train(type ~ ., 
                    data = boo_train,
                    method = "gbm",
                    trControl = ctrl,
                    verbose = FALSE,
                    tuneGrid = boost_grid2)
boost_model2
summary(boost_model2) # Variable importance, relative influence
View(boost_model2$results %>% 
       arrange(desc(Accuracy))
     )

# Predict test data classes
boost1_pred <- predict(boost_model1,
                       newdata = boo_test,
                       type = "raw")
boost2_pred <- predict(boost_model2,
                       newdata = boo_test,
                       type = "raw")

# Create csv:s for submission on Kaggle
boost1_submit <- tibble(id = test_id, 
                        type = boost1_pred)
write_csv(boost1_submit, "boost1_submit.csv")

boost2_submit <- tibble(id = test_id, 
                        type = boost2_pred)
write_csv(boost2_submit, "boost2_submit.csv")


### Compare all models ###
# Model lists
models1 <- list(bagging = bagging_model, 
               rf1 = rf_model_rule_of_thumb, 
               rf2 = rf_model_all_m)

models2 <- list(boost1 = boost_model1,
                boost2 = boost_model2)

# Resample models
resampled1 <- resamples(models1)
resampled2 <- resamples(models2)

# Model accuracies
model_accuracies1 <- tibble("Bagging" = resampled1$values$"bagging~Accuracy",
                            "Random forest 1" = resampled1$values$"rf1~Accuracy",
                            "Random forest 2" = resampled1$values$"rf2~Accuracy")
model_accuracies2 <- tibble("Boosting 1" = resampled2$values$"boost1~Accuracy",
                            "Boosting 2" = resampled2$values$"boost2~Accuracy")

# Create one data frame for all accuracies
model_accuracies <- model_accuracies1 %>% 
  gather("Bagging", "Random forest 1", "Random forest 2", key = "model", value = "accuracy") %>% 
  bind_rows(model_accuracies2 %>%
              gather("Boosting 1", "Boosting 2", key = "model", value = "accuracy"))

# Boxplot over model accuracies (cross validation folds)
model_accuracies %>% 
  ggplot(aes(x = reorder(model, accuracy, FUN = mean), y = accuracy)) +
  geom_boxplot() +
  labs(x = "Model",
       y = "Model accuracy")




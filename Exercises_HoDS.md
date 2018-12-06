Hands on Data Science exercises
================
by Olof Rännbäck-Garpinger and Jonas Dürango, Knightec AB
Thursday, December 6, 2018

These are tonight's Hands-on exercises of varying difficulty, ranging from beginner to advanced. Note that the beginner exercises are at the bottom. We suggest that you choose exercise(s) depending on your own level of Data Science understanding. You can retrieve the data either from a USB-stick or <https://www.kaggle.com/c/ghouls-goblins-and-ghosts-boo/>. *Note that you need a Kaggle account to download data on their website and also to make late submissions for obtaining test accuracy.*

If you have any questions during the exercise session you are welcome to ask Jonas or Olof.

### 1. Data manipulation (easy)

1.  Import the training data and create a data frame.
2.  Remove the id column from the data frame.
3.  Filter out rows such that bone\_length &gt; 0.5.
4.  Sort rows after hair\_length in a descending order.
5.  Add a new feature called hair\_soul = hair\_length\*has\_soul.
6.  Calculate the mean, minimum, and maximum hair\_length for each monster type.

### 2. Exploratory Data Analysis (easy to medium)

1.  Import the training data and create a data frame.
2.  Make a summary over you data frame, calculating for example min, max, and median over numerical features and counts over categorical features.
3.  Plot variable distributions (using for example histograms) over one or several features for each monster type. What can you say about these?
4.  Are there any strong relationships between features? Calculate correlations and make scatterplots to show your point. Give each monster type a different color in the plots.
5.  Which two features do you think are best for separating the monster types? Why?

### 3. Machine Learning - Classification (easy to advanced)

#### 3.1. Go through Olof's R or Jonas' Python script

1.  The scripts are available on <https://github.com/olofgarpinger/hands_on_data_science_Dec_6_2018>.

#### 3.2. Check out Kaggle Kernels at <https://www.kaggle.com/c/ghouls-goblins-and-ghosts-boo/kernels>

1.  For example by first checking which Kernels have the most votes and which Kernels use your preferred language.

#### 3.3. Build your own models

1.  Import data
    1.  Read in the training and test data.
2.  Cross validation (choose one the following exercises)
    1.  Randomly select 20% of your data into a cross validation set, or...
    2.  Make sure your models will be run through 10-fold cross validation.
3.  Model training (choose one or several exercises)
    1.  Train a Decision tree.
        1.  Calculate model accuracy using your selected cross validation method.
    2.  Use Bagging to train a model.
        1.  Use cross validation to select a proper amount of trees.
        2.  Is it possible to use too many trees (that is overfit the model)?
    3.  Train a Random Forest classifier.
        1.  Use cross validation to select a proper amount of trees, *B*, and predictors, *m*, to consider at each split.
        2.  Plot feature importance.
    4.  Train a Gradient Boosting model.
        1.  Pick any three parameters for your model and use cross validation to calculate model accuracy.
        2.  Use grid search and cross validation to select all three tuning parameters.
        3.  Plot feature importance.
    5.  Repeat the training of a Gradient Boosting classifier using the following implementations:
        1.  Extreme Gradient Boosting
        2.  Light Gradient Boosting
        3.  What are the advantages of these methods compared to more traditional implementations of Gradient Boosting?

### 4. Getting started with R and Python (beginner)

#### 4.1. R introduction

1.  Download and install R and RStudio on your laptop if you haven't already.
2.  Run RStudio.
3.  From <https://www-bcf.usc.edu/~gareth/ISL/> and download the book pdf.
4.  Go to page 42 and do the *Introduction to R* lab

#### 4.2. Python introduction

1.  Download and install [Anaconda](https://www.anaconda.com/).
2.  Start Anaconda Navigator and open up a Jupyter Notebook.
3.  Do the 10 minutes to pandas introduction: <https://pandas.pydata.org/pandas-docs/stable/10min.html>

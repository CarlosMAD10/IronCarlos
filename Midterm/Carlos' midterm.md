# 1.- Goal

The goal is to create a model for prediting the price of houses based on several variables like square feet, number of rooms, location, etc. We are given a dataset with information about around 21600 houses which were sold, and we know the price that was paid. Our model should be as accurate as possible.

# 2.- Plan

1. Data import and first cleaning: eliminating clear outliers.
2. Exploratory Data Analysis (EDA): visualization in order to see what factors seem more relevant/interesting.
3. Modeling - regression: create first models based in know regressors and asses the precision of this models, without fine parameter tuning.
4. Modeling - clustering: analyse whether a non-supervised learning system could help simplify the location data (coordinates and zipcode) so the regression model benefits.
5. Modeling - fine tuning: if possible, check whether the selected models can be fined-tuned in order to increase accuracy.
6. Visualization - selection of the most interesting analyses in appropriate graphs for the presentation.

# 3.- Progress

Data import and cleaning done.
EDA - done/in progress. Visualization and selection of the most interesting variables.
Selected models: so far the most promising ones are the Generalised Linear Regression and the Random Forest.
Clustering for location data: in progress.
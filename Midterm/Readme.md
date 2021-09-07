# 1.- Goal

The goal is to create a model for prediting the price of houses based on several variables like square feet, number of rooms, location, etc. We are given a dataset with information about around 21600 houses which were sold, and we know the price that was paid. Our model should be as accurate as possible.

# 2.- Plan

1. Data import and first cleaning: eliminating clear outliers.
2. Exploratory Data Analysis (EDA): visualization in order to see what factors seem more relevant/interesting.
3. Modeling - regression: create first models based in know regressors and asses the precision of this models, without fine parameter tuning.
4. Modeling - clustering: analyse whether a non-supervised learning system could help simplify the location data (coordinates and zipcode) so the regression model benefits.
5. Modeling - fine tuning: if possible, check whether the selected models can be fined-tuned in order to increase accuracy.
6. Visualization - selection of the most interesting analyses in appropriate graphs for the presentation.

# 3.- Modeling

Data import and cleaning - done.
EDA - done. Visualization and selection of the most interesting variables.
Selected models - done. After analysing the Generalised Linear Regression and the Random Forest, we will keep the random forest model.
Clustering for location data - done. We have created a model for clustering the geolocation data and prices for the training set. We create clusters that have several centers that have an "average price". Then, for the predictions we calculate the closest cluster center to the apartment which price we are predicting. Then, we can introduce a new variable in the dataset: the location_price. We have started optimising the number of clusters and their respective centers that increase the accuracy of the model.
Fine tuning of the random forest model - done. We have applied a fine tuning of the hyper parameters of the random forest model. We select the best parameters for the next stage. The results were cross valued in order to avoid overfitting.
New elimination of outliers - in progress. In order to increase the accuracy of the model, we will try to detect an eliminate the outliers, because they introduce noise in the model and thus reduce its accuracy. It will be the final fase of the modeling process.

# 4.- Visualization

We have started gathering interesting plots with seaborn and geolocation data. We will experiment with tableau visualizations.
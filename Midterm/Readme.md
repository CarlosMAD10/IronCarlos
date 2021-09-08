# 1. Business case

The goal is to predict the price of houses of a certain area in Northwest USA. In order to do so, we will apply a machine learning model on historic data of house sales in said area. We have information on about 21600 previous sales, and the data includes the area of the houses/apartments, the lot sizes, the number of rooms and bathrooms, and the coordinates of the house.

The data provided should allow us to obtain sufficient precision on the prediction of a price houses if we have similar information to the one with which we will be training the model.

# 2. Data import and Exploratory Data Analysis (EDA)

We will be working mostly with two data science packages that work together very effectively in a Python programming environment: Pandas, for convenient dataset manipulation, and Scikit-Learn, for quick implementation of machine learning algorithms. We will code the results in a Jupyter Notebook, which allows for interactive coding and facilitates the presentation of the results.

The **data import** procedure is automatic, since we are provided with an Excel file that we can incorporate directly in our environment with Pandas.

The **Exploratory Data Analysis** that we first undertake reveals that the data is clean and well organised. We have 21 columns:
- id: an identifier for each sale.
- date: the date, in 2013 or 2014, when the house was sold.
- bedrooms and bathrooms: two columns for these numbers. The number of bathrooms ranges from 0.5 to 8, with intervals of 0.25. The bedrooms are integers between 1 and 33. 
- sqft_living and sqft_lot: the surfaces of the living area and the lot of the house, respectively. 
- sqft_living15 and sqft_lot15: from the information we have gathered, this corresponds to the avreage areas of the 15 nearest neighbors to the houses. But the information is not very clear. In the distribution there are clear outliers, with houses that are very big compared to the average ones. 
- floors: the number of floors, between 1 and 3.5.
- waterfront: a boolean variable, 0 correspond to no waterfront, 1 is a house with waterfront. The city of Seattle and it's surrounding areas are full of lakes, bays, and water bodies in general, so it makes sense to record this information. However, only 163 of the initial houses have a waterfront.
- view: the great majority has 0. The rest have between 2 and 4, but there are only 2000 of them.
- condition: 200 houses have 1 or 2, the rest between 3 and 5.
- grade: between 1 and 13, but very densely distributed around 7, the average.
- sqft_basement: the surface of the living space that corresponds to basement.
- sqft_above: it's the sqft_living variable minus the sqft_basement. So it is, in a sense, redundant information.




















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


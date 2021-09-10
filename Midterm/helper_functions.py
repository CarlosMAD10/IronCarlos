"""This module is intended to provide some helper functions for:
- Importing dataset
- Cleaning the dataset: eliminating outliers
- Evaluate models
"""
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score, mean_squared_log_error
from scipy.spatial import KDTree


#Importing data function:
def import_dataset(path=r".\Data_Midterm.xls"):
    """
    Input: optionally, the path to the file with the dataset
    Output: returns the dataset with the cleaning functions applied (mostly eliminating outliers)
    """

    df = pd.read_excel(path, engine="xlrd")
    df = df.drop(columns=['id', "date", 'sqft_above'])
    df = df[df["bedrooms"] <= 6]
    df = df[(df["bathrooms"] < 6) & (df["bathrooms"] >= 1)]
    df = df[df["sqft_living"] <= 5000]
    df = df[df["sqft_living15"] <= 5000]
    df = df[df["sqft_lot"] <= 15000]
    df = df[df["sqft_lot15"] <= 15000]
    df.loc[df["view"] != 0, "view"] = 1
    df = df[df["condition"] > 2]
    df.loc[df["sqft_basement"] != 0, "sqft_basement"] = 1
    df.loc[(df["yr_renovated"]!=0)&(df["yr_renovated"]<2000), "yr_renovated"] = 1
    df.loc[df["yr_renovated"]>=2000, "yr_renovated"] = 2
    
  
    return df

def rf_model(df, cols=[]):
    """
    Function for creating and running a random forest model with the optimised parameters.
    Input: the dataframe; optionally, a list of columns' names to drop before running the model.
    Output: returns a tuple with the trained regressor, the X_train, y_train, X_test and y_test sets.
    """

    #Dropping necessary columns. By default, we drop yr_built and condition
    #df = df.drop(["yr_built", "condition"] + cols, axis=1)
    if cols != []:
        df = df.drop(cols, axis=1)

    #Splitting the dataset in train and test
    X_train, X_test, y_train, y_test = train_test_split(df.drop("price",axis=1), df["price"], random_state=1)

    #Creating the regressor with the optimal parameters
    optimal_params = {'bootstrap': False, 'max_depth': 70, 'max_features': 'sqrt',
     'min_samples_leaf': 1, 'min_samples_split': 4, 'n_estimators': 300}
    

    reg = RandomForestRegressor(bootstrap=False, max_depth=100, max_features="sqrt", min_samples_leaf=1,
        min_samples_split=2, n_estimators=300)

    #Fitting the estimator and returning the output
    reg.fit(X_train, y_train)

    return reg, X_train, y_train, X_test, y_test

def rf_clustering(df, cols=[], centers = 125):
    """
    Function for creating a random forest model, but introducing a new variable: location_price. It is estimated through a clustering process. 
    The model uses the training set to create a function that maps the location of a house to an "average price" calculated for houses sold nearby.
    Input: the dataframe, optionally the columns that we will eliminate from the model (by default, year built and condition) and the number of centers
    that the clustering model will have.
    Output: a tuple with the random forest regressor, the dataframe with the cluster centers and their prices, and the X_train, y_train, X_test and y_test
    datasets.
    """

    #Dropping necessary columns. By default, we drop yr_built and condition
    #df = df.drop(["yr_built", "condition"] + cols, axis=1)
    if cols:
        df = df.drop(cols, axis=1)

    #Splitting the dataset in train and test
    X_train, X_test, y_train, y_test = train_test_split(df.drop("price",axis=1), df["price"], random_state=1)

    #We create the location dataframe with the lat, longitude and price data of the training set.
    location = X_train[["lat", "long"]]
    location.loc[:,"price"] = y_train

    #We create and fit the clustering estimator, KMeans
    estimator = KMeans(n_clusters=centers)
    estimator.fit(location)

    #We prepare the data about the clusters that we obtained. We have three lists with lat, long and price data of the clusters,
    #and a dataframe with the same values.
    long = []
    lat = []
    price = []
    for index, center in enumerate(estimator.cluster_centers_):
        lat.append(center[0])
        long.append(center[1])
        price.append(center[2])

    centers_df = pd.DataFrame(data={"lat": lat, "long":long, "price":price})

    #Now we use the centers_df to create the new column that will be added to the train and test sets, location_price.

    #1. We create the tree that will allow us to quickly calculate which center is the nearest neighbor
    tree = KDTree(centers_df[["lat", "long"]])

    #2. We get the distances (not really needed) and the index of the centers that correspond to each point
    distance_train, index_train = tree.query(X_train[["lat", "long"]])
    distance_test, index_test = tree.query(X_test[["lat", "long"]])

    X_train["index_centers"] = index_train
    X_test["index_centers"] = index_test

    #3. Finally, we add the column with the location price that corresponds to each center
    price_column_train = []
    price_column_test = []

    for row in X_train.itertuples():
        price_column_train.append(centers_df.loc[row.index_centers, "price"])

    for row in X_test.itertuples():
        price_column_test.append(centers_df.loc[row.index_centers, "price"])

    X_train["location_price"] = price_column_train
    X_test["location_price"] = price_column_test

    X_train = X_train.drop("index_centers", axis=1)
    X_test = X_test.drop("index_centers", axis=1)

    #Now we run the random forest model

    #Creating the regressor with the optimal parameters
    optimal_params = {'bootstrap': False, 'max_depth': 100, 'max_features': 'sqrt',
     'min_samples_leaf': 1, 'min_samples_split': 6, 'n_estimators': 250}
    
    reg = RandomForestRegressor(bootstrap=False, max_depth=100, max_features="sqrt", min_samples_leaf=1,
        min_samples_split=2, n_estimators=300)

    #Fitting the estimator and returning the output
    reg.fit(X_train, y_train)

    return reg, centers_df, X_train, y_train, X_test, y_test


#Function for evaluating a Random Forest Model:
def evaluate(model, X_test, y_test, silent=False):
    """
    Input: a regressor, the matrix with test features, the vector with test labels.
    Output: a list with the accuracy, the R2 coefficient of determination, and the average error (absolute)
    """
    
    y_predict = model.predict(X_test)
    errors = abs(y_predict - y_test)
    mape = 100 * np.mean(errors / y_test)
    avg_error = np.mean(errors)
    accuracy = 100 - mape
    r2 = r2_score(y_test, y_predict)
    if not silent:
        print('---Model Performance---')
        print(model)
        #print(X_test.columns)
        print('\nAverage Absolute Error: {:0.1f} dollars.'.format(np.mean(errors)))
        print('Mean squared error: %.2f' % mean_squared_error(y_test, y_predict, squared=False))
        print('Accuracy = {:0.2f}%.'.format(accuracy))
        # The coefficient of determination: 1 is perfect prediction
        print('Coefficient of determination: %.2f\n' % r2)
    
    return [accuracy, r2, avg_error]




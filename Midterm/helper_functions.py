"""This module is intended to provide some helper functions for:
- Importing dataset
- Cleaning the dataset: eliminating outliers
- Evaluate models
"""

#Importing data function:
def import_dataset(path=r".\Data_Midterm.xls"):
	df = pd.read_excel(path, engine="xlrd")
    df=df.drop(columns=['id', 'date'])
    df = df[df["bedrooms"] <= 8]
    df = df[(df["bathrooms"] < 6) & (df["bathrooms"] >= 1)]
    df = df[df["sqft_living"] <= 6000]
    df = df[df["sqft_lot"] <= 30000]
    df = df[df["sqft_lot15"] <= 30000]
    df.loc[df["view"] != 0, "view"] = 1
    df = df[df["condition"] > 2]
    df.loc[df["sqft_basement"] != 0, "sqft_basement"] = 1
    df.loc[(df["yr_renovated"]!=0)&(df["yr_renovated"]<2000), "yr_renovated"] = 1
    df.loc[df["yr_renovated"]>=2000, "yr_renovated"] = 2
    
  
    return df

#Function for evaluating a Random Forest Model:
def evaluate(model, test_features, test_labels):
    y_predict = model.predict(test_features)
    errors = abs(y_predict - test_labels)
    mape = 100 * np.mean(errors / test_labels)
    avg_error = np.mean(errors)
    accuracy = 100 - mape
    r2 = r2_score(y_test, y_predict)
    print('Model Performance')
    print('Average Abosulute Error: {:0.4f} dollars.'.format(np.mean(errors)))
    print('Mean squared error: %.2f' % mean_squared_error(y_test, y_predict, squared=False))
    print('Accuracy = {:0.2f}%.'.format(accuracy))
    # The coefficient of determination: 1 is perfect prediction
    print('Coefficient of determination: %.2f\n' % r2)
    
    return [accuracy, r2, avg_error]
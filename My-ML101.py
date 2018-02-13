import pandas as pd

main_file_path = '../input/train.csv'
data = pd.read_csv(main_file_path)
# print a summary of the data in Melbourne data
print(data.describe())
print(data.SalePrice.head())
y = data.SalePrice
data.head()
predictors = ['LotArea','YearBuilt','1stFlrSF','2ndFlrSF','FullBath','BedroomAbvGr','TotRmsAbvGrd']
X = data[predictors]

from sklearn.model_selection import train_test_split

# split data into training and validation data, for both predictors and target
# The split is based on a random number generator. Supplying a numeric value to
# the random_state argument guarantees we get the same split every time we
# run this script.
train_X, val_X, train_y, val_y = train_test_split(X, y,random_state = 0)

from sklearn.tree import DecisionTreeRegressor

# Define model
file_model = DecisionTreeRegressor()

# Fit model
file_model.fit(train_X, train_y)

from sklearn.metrics import mean_absolute_error

val_predictions = file_model.predict(val_X)
print("val", mean_absolute_error(val_y, val_predictions))

from sklearn.metrics import mean_absolute_error

train_predictions = file_model.predict(train_X)
print("train", mean_absolute_error(train_y, train_predictions))

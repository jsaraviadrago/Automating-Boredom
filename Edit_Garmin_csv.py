import pandas as pd

data_garmin = pd.read_csv("C:\\Users\\JuanCarlosSaraviaDra\\Dropbox\\Activities_garmin.csv")

#print(data_garmin.head())

data_garmin = data_garmin[['Activity Type', 'Date',	'Distance',	'Calories',	'Time',	'Avg HR','Max HR',
'Avg Run Cadence','Max Run Cadence','Avg Pace','Best Pace','Total Ascent','Total Descent','Avg Stride Length',
                       'Best Lap Time','Number of Laps','Moving Time','Elapsed Time','Min Elevation','Max Elevation']]

data_garmin = data_garmin.loc[data_garmin['Activity Type'] == 'Running']

# create an intermediate column that we won't store on the DataFrame
checkout_as_datetime = pd.to_datetime(data_garmin['Date'])

# Add the desired columns to the dataframe
data_garmin['run_date'] = checkout_as_datetime.dt.date
data_garmin['run_time'] = checkout_as_datetime.dt.time
data_garmin['run_year'] = checkout_as_datetime.dt.year

data_garmin = data_garmin.drop(['Activity Type', 'Date'], axis=1)

print(data_garmin.head())
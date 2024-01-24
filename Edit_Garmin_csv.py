import pandas as pd
import numpy as np

data_garmin = pd.read_csv("C:\\Users\\JuanCarlosSaraviaDra\\Dropbox\\Activities_garmin.csv")


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

# Drop unnecesary columns
data_garmin = data_garmin.drop(['Activity Type', 'Date'], axis=1)

#Format to deltatime
data_garmin['Avg Pace'] = pd.to_datetime(data_garmin['Avg Pace'], format = '%M:%S') - pd.to_datetime(data_garmin['Avg Pace'], format = '%M:%S').dt.normalize()
data_garmin['Best Pace'] = pd.to_datetime(data_garmin['Best Pace'], format = '%M:%S') - pd.to_datetime(data_garmin['Best Pace'], format = '%M:%S').dt.normalize()
data_garmin['run_time'] = pd.to_datetime(data_garmin['run_time'], format = '%H:%M:%S') - pd.to_datetime(data_garmin['run_time'], format = '%H:%M:%S').dt.normalize()

# Create column for morning, mid day and night

values = ['Mañana', 'Tarde', 'Noche']

condition_results = [(data_garmin['run_time'] >= '00:00:00') & (data_garmin['run_time'] < '12:00:00'),
                     (data_garmin['run_time'] >= '12:00:00') & (data_garmin['run_time'] < '18:00:00'),
                     (data_garmin['run_time'] >= '18:00:00')]

data_garmin['Day_time'] = np.select(condition_results,
                                    values)



data_garmin.to_csv('C:\\Users\\JuanCarlosSaraviaDra\\Dropbox\\Activities_garmin_VF.csv', index=False)

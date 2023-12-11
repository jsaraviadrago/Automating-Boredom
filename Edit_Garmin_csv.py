import pandas as pd

data_garmin = pd.read_csv("C:\\Users\\JuanCarlosSaraviaDra\\Dropbox\\Activities_garmin.csv")

#print(data_garmin.head())

data_garmin = data_garmin[['Activity Type', 'Date',	'Distance',	'Calories',	'Time',	'Avg HR','Max HR',
'Avg Run Cadence','Max Run Cadence','Avg Pace','Best Pace','Total Ascent','Total Descent','Avg Stride Length',
                       'Best Lap Time','Number of Laps','Moving Time','Elapsed Time','Min Elevation','Max Elevation']]

data_garmin = data_garmin.loc[data_garmin['Activity Type'] == 'Running']


print(data_garmin)
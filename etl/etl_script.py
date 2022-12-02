import os
import pandas as pd
# import dask.dataframe as dd
from sqlalchemy import create_engine
from warnings import filterwarnings 
filterwarnings('ignore')


def extract(device_name, database):
    # set to your own desktop name
    pc_name = device_name

    # connect to MS-SQL
    server = f"{pc_name}\SQLEXPRESS" # SQL Server Name
    database = database # database name
    con_string = f'mssql+pyodbc://{server}/{database}?driver=SQL Server'
    engine = create_engine(con_string)

    # retrieve data
    connection = engine.connect()

    # driver data
    drivers = connection.execute('SELECT * FROM drivers')
    driver_data = pd.DataFrame(data=drivers.fetchall(), columns=drivers.keys())

    # trip data
    trips = connection.execute('SELECT * FROM trips')
    trip_data = pd.DataFrame(data=trips.fetchall(), columns=trips.keys())

    connection.close() # close connection explicitly


    # get sensor data by chunksize
    sensor_data_generator = pd.read_sql_query('SELECT * FROM sensor_data', con_string, chunksize=100000)
    sensor_data = pd.concat([chunk for chunk in sensor_data_generator])
    print("Retrived all data")

    return driver_data, trip_data, sensor_data


def transform(driver_data, trip_data, sensor_data):
    # remove duplicated data from all 3 dataframes
    driver_data = driver_data.drop_duplicates()
    trip_data = trip_data.drop_duplicates()
    sensor_data = sensor_data.drop_duplicates()

    # merge driver and trip data
    driver_trips = trip_data.merge(driver_data, on='driver_id', how='left')

    # merge driver_trips and sensor data
    driver_trips_sensor = sensor_data.merge(driver_trips, on='booking_id', how='left')

    taxi_data = driver_trips_sensor[['booking_id', 'driver_id', 'name', 'date_of_birth', 'gender', 'car_model', 'car_make_year', 'accuracy', 'bearing', 'acceleration_x', 'acceleration_y', 'acceleration_z', 'gyro_x', 'gyro_y', 'gyro_z', 'second', 'speed', 'rating', 'safety_label']]

    return taxi_data


def load(final_data):
    # if directory does not exist, create it
    print("Finding/Creating directory...")
    if not os.path.exists('../data/cleaned/'):
        os.makedirs('../data/cleaned/')

    # save data to csv
    print("Saving data to csv...")
    final_data.to_csv('../data/cleaned/taxi_data.csv', index=False)

    print("ETL script completed")


device_name = os.environ['COMPUTERNAME']
driver_data, trip_data, sensor_data = extract(device_name=device_name, database='JustTaxi')
final_data = transform(driver_data, trip_data, sensor_data)
load(final_data)
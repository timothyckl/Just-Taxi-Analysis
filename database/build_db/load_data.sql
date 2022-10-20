USE JustTaxi
GO

-- Load driver data
BULK INSERT drivers
FROM 'C:\pai_data\driver_data.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')
GO

-- Load trip data
BULK INSERT trips
FROM 'C:\pai_data\safety_labels.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')
GO

-- Load sensor data
-- BULK INSERT sensor_data
-- FROM 'C:\pai_data\sensor_data\sensor_data_part-1.csv'
-- WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n')
-- GO


-- Script to load sensor data

-- create temporary table to store all numbers as varchar
CREATE TABLE #tempTable (
    [booking_id] VARCHAR(100) NOT NULL,
    [accuracy] VARCHAR(100) NULL,
    [bearing] VARCHAR(100) NULL,
    [acceleration_x] VARCHAR(100) NULL,
    [acceleration_y] VARCHAR(100) NULL,
    [acceleration_z] VARCHAR(100) NULL,
    [gyro_x] VARCHAR(100) NULL,
    [gyro_y] VARCHAR(100) NULL,
    [gyro_z] VARCHAR(100) NULL,
    [second] VARCHAR(100) NOT NULL,
    [speed] VARCHAR(100) NULL
)
GO

-- load sensor data to temporary table
BULK INSERT #tempTable 
FROM 'C:\pai_data\sensor_data\sensor_data_part-1.csv' 
WITH (ROWTERMINATOR='\n', FIELDTERMINATOR=',', FIRSTROW = 2);
GO

-- insert sensor data to actual sensor_data table
INSERT INTO sensor_data 
    (booking_id, accuracy, bearing, acceleration_x, acceleration_y, acceleration_z, gyro_x, gyro_y, gyro_z, second, speed)
SELECT 
    booking_id,
    -- this is to convert the string to floating precision, then to decimal number
    -- this is required as MSSQL does not automatically convert exponential expression to decimal
    CONVERT(DECIMAL(38,25), CAST(accuracy AS FLOAT)),
    CONVERT(DECIMAL(38,25), CAST(bearing AS FLOAT)),
    CONVERT(DECIMAL(38,25), CAST(acceleration_x AS FLOAT)),
    CONVERT(DECIMAL(38,25), CAST(acceleration_y AS FLOAT)),
    CONVERT(DECIMAL(38,25), CAST(acceleration_z AS FLOAT)),
    CONVERT(DECIMAL(38,25), CAST(gyro_x AS FLOAT)),
    CONVERT(DECIMAL(38,25), CAST(gyro_y AS FLOAT)),
    CONVERT(DECIMAL(38,25), CAST(gyro_z AS FLOAT)),
    CONVERT(DECIMAL(38,25), CAST([second] AS FLOAT)),
    CONVERT(DECIMAL(38,25), CAST(speed AS FLOAT))
FROM #tempTable
GO

DROP TABLE #tempTable
GO
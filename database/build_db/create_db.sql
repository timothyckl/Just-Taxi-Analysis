-- Command to drop database
/**
USE master
ALTER DATABASE JustTaxi
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE
DROP DATABASE JustTaxi
**/

CREATE DATABASE JustTaxi
GO

USE JustTaxi
GO

-- Store driver information
CREATE TABLE [drivers] (
    [driver_id] VARCHAR(100) PRIMARY KEY, -- Primary Key
    [name] VARCHAR(50) NOT NULL,
    [date_of_birth] DATE NOT NULL,
    [gender] VARCHAR(6) NOT NULL,
    [car_model] VARCHAR(50) NOT NULL,
    [car_make_year] DATE NOT NULL,
    [rating] DECIMAL(2, 1) NOT NULL
);
GO

-- Store trip information and safety label
CREATE TABLE [trips] (
    [booking_id] VARCHAR(100) PRIMARY KEY, -- Primary Key
    [driver_id] VARCHAR(100) NOT NULL, -- Foreign Key
    [safety_label] CHAR(1) NOT NULL,

    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) 
    -- When a driver is deleted, all trips associated with that driver are deleted
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
GO

CREATE TABLE [sensor_data] (
    [booking_id] VARCHAR(100) NOT NULL, -- Primary Key 1, Foreign Key
    [accuracy] DECIMAL(38, 25) NULL,
    [bearing] DECIMAL(38, 25) NULL,
    [acceleration_x] DECIMAL(38, 25) NULL,
    [acceleration_y] DECIMAL(38, 25) NULL,
    [acceleration_z] DECIMAL(38, 25) NULL,
    [gyro_x] DECIMAL(38, 25) NULL,
    [gyro_y] DECIMAL(38, 25) NULL,
    [gyro_z] DECIMAL(38, 25) NULL,
    [second] DECIMAL(38, 25) NOT NULL, -- Primary Key 2
    [speed] DECIMAL(38, 25) NULL

    PRIMARY KEY (booking_id, second), -- Composite Primary Key

    FOREIGN KEY (booking_id) REFERENCES trips(booking_id)
    -- When a trip is deleted, all sensor data associated with that trip is deleted
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
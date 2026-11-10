USE master;
GO

IF DB_ID('CompanyDB') IS NOT NULL
BEGIN
    ALTER DATABASE CompanyDB
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE CompanyDB;
END;
GO

CREATE DATABASE CompanyDB;
GO

USE CompanyDB;
GO


CREATE TABLE Department (
    DNUM INT PRIMARY KEY,
    DName VARCHAR(100) NOT NULL,

    ManagerSSN VARCHAR(20) NULL,
    Manager_Hiring_Date DATE
);
GO



CREATE TABLE Employee (
    SSN VARCHAR(20) PRIMARY KEY,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    Birth_Date DATE,
    Gender VARCHAR(10),

    DNUM INT NOT NULL,
    SupervisorSSN VARCHAR(20) NULL,

    CONSTRAINT FK_Employee_Department
    FOREIGN KEY (DNUM)
    REFERENCES Department(DNUM),

    CONSTRAINT FK_Employee_Supervisor
    FOREIGN KEY (SupervisorSSN)
    REFERENCES Employee(SSN)
);
GO


CREATE TABLE Department_Location (
    DNUM INT,
    Location VARCHAR(100),

    PRIMARY KEY (DNUM, Location),

    FOREIGN KEY (DNUM)
    REFERENCES Department(DNUM)
    ON DELETE CASCADE
);
GO


CREATE TABLE Project (
    PNumber INT PRIMARY KEY,
    Pname VARCHAR(100) NOT NULL,
    Location VARCHAR(100),
    City VARCHAR(100),

    DNUM INT NOT NULL,

    CONSTRAINT FK_Project_Department
    FOREIGN KEY (DNUM)
    REFERENCES Department(DNUM)
);
GO


CREATE TABLE Dependent (
    Employee_SSN VARCHAR(20),
    Dependent_Name VARCHAR(100),
    Gender VARCHAR(10),
    Birth_Date DATE,

    PRIMARY KEY (Employee_SSN, Dependent_Name),

    CONSTRAINT FK_Dependent_Employee
    FOREIGN KEY (Employee_SSN)
    REFERENCES Employee(SSN)
    ON DELETE CASCADE
);
GO


CREATE TABLE Employee_Project (
    Employee_SSN VARCHAR(20),
    PNumber INT,
    Working_Hours DECIMAL(6,2),

    PRIMARY KEY (Employee_SSN, PNumber),

    CONSTRAINT FK_EP_Employee
    FOREIGN KEY (Employee_SSN)
    REFERENCES Employee(SSN)
    ON DELETE CASCADE,

    CONSTRAINT FK_EP_Project
    FOREIGN KEY (PNumber)
    REFERENCES Project(PNumber)
    ON DELETE CASCADE,

    CONSTRAINT CK_Working_Hours
    CHECK (Working_Hours >= 0)
);
GO

ALTER TABLE Department
ADD CONSTRAINT FK_Department_Manager
FOREIGN KEY (ManagerSSN)
REFERENCES Employee(SSN);
GO

CREATE UNIQUE INDEX UQ_Department_Manager
ON Department(ManagerSSN)
WHERE ManagerSSN IS NOT NULL;
GO


SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
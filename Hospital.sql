
USE HospitalDB;
GO

/* =========================================
   1. WARD TABLE
========================================= */

CREATE TABLE Ward (
    Ward_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,

    Supervisor_Nurse_Number INT NULL
);
GO


/* =========================================
   2. CONSULTANT TABLE
========================================= */

CREATE TABLE Consultant (
    Consultant_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);
GO


/* =========================================
   3. NURSE TABLE
========================================= */

CREATE TABLE Nurse (
    Nurse_Number INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200),

    Ward_ID INT NOT NULL,

    CONSTRAINT FK_Nurse_Ward
    FOREIGN KEY (Ward_ID)
    REFERENCES Ward(Ward_ID),

    CONSTRAINT UQ_Nurse_Number_Ward
    UNIQUE (Nurse_Number, Ward_ID)
);
GO


/* =========================================
   4. WARD SUPERVISOR RELATIONSHIP
========================================= */

ALTER TABLE Ward
ADD CONSTRAINT FK_Ward_Supervisor
FOREIGN KEY (Supervisor_Nurse_Number, Ward_ID)
REFERENCES Nurse(Nurse_Number, Ward_ID);
GO

CREATE UNIQUE INDEX UQ_Ward_Supervisor
ON Ward(Supervisor_Nurse_Number)
WHERE Supervisor_Nurse_Number IS NOT NULL;
GO


/* =========================================
   5. PATIENT TABLE
========================================= */

CREATE TABLE Patient (
    Patient_ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Date_Of_Birth DATE,

    Ward_ID INT NOT NULL,
    Leading_Consultant_ID INT NOT NULL,

    CONSTRAINT FK_Patient_Ward
    FOREIGN KEY (Ward_ID)
    REFERENCES Ward(Ward_ID),

    CONSTRAINT FK_Patient_Leading_Consultant
    FOREIGN KEY (Leading_Consultant_ID)
    REFERENCES Consultant(Consultant_ID)
);
GO


/* =========================================
   6. PATIENT_CONSULTANT TABLE
========================================= */

CREATE TABLE Patient_Consultant (
    Patient_ID INT,
    Consultant_ID INT,

    PRIMARY KEY (Patient_ID, Consultant_ID),

    CONSTRAINT FK_PC_Patient
    FOREIGN KEY (Patient_ID)
    REFERENCES Patient(Patient_ID)
    ON DELETE CASCADE,

    CONSTRAINT FK_PC_Consultant
    FOREIGN KEY (Consultant_ID)
    REFERENCES Consultant(Consultant_ID)
);
GO


/* =========================================
   7. DRUG TABLE
========================================= */

CREATE TABLE Drug (
    Drug_Code INT PRIMARY KEY,
    Recommended_Dosage VARCHAR(100)
);
GO


/* =========================================
   8. DRUG_BRAND TABLE
========================================= */

CREATE TABLE Drug_Brand (
    Drug_Code INT,
    Brand_Name VARCHAR(100),

    PRIMARY KEY (Drug_Code, Brand_Name),

    CONSTRAINT FK_DrugBrand_Drug
    FOREIGN KEY (Drug_Code)
    REFERENCES Drug(Drug_Code)
    ON DELETE CASCADE
);
GO


/* =========================================
   9. DRUG_ADMINISTRATION TABLE
========================================= */

CREATE TABLE Drug_Administration (
    Administration_ID INT IDENTITY(1,1) PRIMARY KEY,

    Nurse_Number INT NOT NULL,
    Patient_ID INT NOT NULL,
    Drug_Code INT NOT NULL,

    Dosage VARCHAR(100) NOT NULL,
    Administration_DateTime DATETIME2 NOT NULL,

    CONSTRAINT FK_DA_Nurse
    FOREIGN KEY (Nurse_Number)
    REFERENCES Nurse(Nurse_Number),

    CONSTRAINT FK_DA_Patient
    FOREIGN KEY (Patient_ID)
    REFERENCES Patient(Patient_ID),

    CONSTRAINT FK_DA_Drug
    FOREIGN KEY (Drug_Code)
    REFERENCES Drug(Drug_Code)
);
GO


/* =========================================
   10. DISPLAY ALL TABLES
========================================= */

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

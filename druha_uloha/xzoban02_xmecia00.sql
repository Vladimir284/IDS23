DROP TABLE T_Medic CASCADE CONSTRAINTS;
DROP TABLE T_Doctor CASCADE CONSTRAINTS;
DROP TABLE T_Nurse CASCADE CONSTRAINTS;
DROP TABLE T_Patient CASCADE CONSTRAINTS;
DROP TABLE T_Examination CASCADE CONSTRAINTS;
DROP TABLE T_Surgery CASCADE CONSTRAINTS;
DROP TABLE T_Location CASCADE CONSTRAINTS;
DROP TABLE T_Prescribed_Drug CASCADE CONSTRAINTS;
DROP TABLE T_Hospitalization CASCADE CONSTRAINTS;
DROP TABLE T_Clinic CASCADE CONSTRAINTS;
DROP TABLE T_Medical_equipment CASCADE CONSTRAINTS;

CREATE TABLE T_Medic
(
    Medic_ID    INTEGER NOT NULL PRIMARY KEY,
    First_name  VARCHAR(11),
    Last_name   VARCHAR(11),
    Clinic_name VARCHAR(30),
    Duty        VARCHAR(20),
    Status      VARCHAR(20)
);

CREATE TABLE T_Doctor
(
    Medic_ID    INTEGER NOT NULL PRIMARY KEY,
    Attestation varchar(20)
);

CREATE TABLE T_Nurse
(
    Medic_ID INTEGER NOT NULL PRIMARY KEY
);

CREATE TABLE T_Patient
(
    Personal_ID INTEGER NOT NULL PRIMARY KEY,
    First_name  VARCHAR(11),
    Last_name   VARCHAR(11)
);

CREATE TABLE T_Examination
(
    Exam_ID     INTEGER NOT NULL PRIMARY KEY,
    Medic_ID    INTEGER,
    Personal_ID INTEGER,
    Exam_Date   VARCHAR(10),
    Exam_Time   VARCHAR(5),
    Location_ID INTEGER
);

CREATE TABLE T_Surgery
(
    Surgery_ID   INTEGER NOT NULL PRIMARY KEY,
    Medic_ID     INTEGER,
    Personal_ID  INTEGER,
    Surgery_date VARCHAR(10),
    Surgery_Time VARCHAR(5),
    Location_ID  INTEGER
);

-- Identifies location, makes code cleaner
CREATE TABLE T_Location
(
    Location_ID INTEGER NOT NULL PRIMARY KEY,
    Clinic_name VARCHAR(30),
    Pavilion    VARCHAR(30),
    Room        VARCHAR(30)
);

CREATE TABLE T_Prescribed_Drug
(
    Drug_ID           INTEGER NOT NULL PRIMARY KEY,
    Medic_ID          INTEGER,
    Personal_ID       INTEGER,
    Prescription_date VARCHAR(10),
    Prescription_time VARCHAR(5),
    Cure              VARCHAR(20)
);

CREATE TABLE T_Hospitalization
(
    Hospitalization_ID INTEGER NOT NULL PRIMARY KEY,
    Medic_ID           INTEGER,
    Personal_ID        INTEGER,
    Date_from          varchar(10),
    Date_till          varchar(10)
);

CREATE TABLE T_Clinic
(
    Clinic_name          INTEGER NOT NULL PRIMARY KEY,
    Telephone            INTEGER,
    Medical_equipment_ID INTEGER
);

CREATE TABLE T_Medical_equipment
(
    Medical_equipment_ID INTEGER NOT NULL PRIMARY KEY,
    Equipment            VARCHAR(30),
    Amount               INTEGER
);


-- Add Primary keys
-- ALTER TABLE T_Medic
--     ADD CONSTRAINT PK_Medic PRIMARY KEY (Medic_ID);
-- ALTER TABLE T_Doctor
--     ADD CONSTRAINT PK_Doctor PRIMARY KEY (Medic_ID);
-- ALTER TABLE T_Nurse
--     ADD CONSTRAINT PK_Nurse PRIMARY KEY (Medic_ID);
-- ALTER TABLE T_Patient
--     ADD CONSTRAINT PK_Patient PRIMARY KEY (Personal_ID);
-- ALTER TABLE T_Examination
--     ADD CONSTRAINT PK_PRIMARY KEY (Exam_ID);
-- ALTER TABLE T_Surgery
--     ADD CONSTRAINT PRIMARY KEY (Surgery_ID);
-- ALTER TABLE T_Location
--     ADD CONSTRAINT PRIMARY KEY (Location_ID);
-- ALTER TABLE T_Prescribed_Drug
--     ADD CONSTRAINT PRIMARY KEY (Drug_ID);
-- ALTER TABLE T_Hospitalization
--     ADD CONSTRAINT PRIMARY KEY (Hospitalization_ID);
-- ALTER TABLE T_Clinic
--     ADD CONSTRAINT PRIMARY KEY (Clinic_name);
-- ALTER TABLE T_Medical_equipment
--     ADD CONSTRAINT PRIMARY KEY (Medical_equipment_ID);

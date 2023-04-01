--SQL script for creating a hospital database and extracting data
--Authors: Radek Zobaník (xzoban02) and Vladimír Mečiar (xmecia00)

DROP TABLE T_Medic CASCADE CONSTRAINTS;
DROP TABLE T_Doctor CASCADE CONSTRAINTS;
DROP TABLE T_Nurse CASCADE CONSTRAINTS;
DROP TABLE T_Patient CASCADE CONSTRAINTS;
DROP TABLE T_Examination CASCADE CONSTRAINTS;
DROP TABLE T_Surgery CASCADE CONSTRAINTS;
DROP TABLE T_Surgery_participants CASCADE CONSTRAINTS;
DROP TABLE T_Location CASCADE CONSTRAINTS;
DROP TABLE T_Prescribed_Drug CASCADE CONSTRAINTS;
DROP TABLE T_Hospitalization CASCADE CONSTRAINTS;
DROP TABLE T_Clinic CASCADE CONSTRAINTS;
DROP TABLE T_Medical_equipment CASCADE CONSTRAINTS;

CREATE TABLE T_Clinic
(
    Clinic_name VARCHAR(30) NOT NULL PRIMARY KEY,
    Telephone   INTEGER
);

--Nurse and medic reffer to medic using their primary key
CREATE TABLE T_Medic
(
    Medic_ID         INTEGER NOT NULL PRIMARY KEY,
    Medic_first_name VARCHAR(20),
    Medic_last_name  VARCHAR(20),
    Clinic_name      VARCHAR(30),
    Duty             VARCHAR(20),
    Status           VARCHAR(20),
    FOREIGN KEY (Clinic_name) REFERENCES T_Clinic (Clinic_name)
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
    Personal_ID        VARCHAR(10) NOT NULL PRIMARY KEY,
    Patient_first_name VARCHAR(20),
    Patient_last_name  VARCHAR(20),
    CHECK ( (regexp_like(Personal_ID, '^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$')
        AND (MOD(CAST(Personal_ID AS INTEGER), 11) = 0))
        OR (regexp_like(Personal_ID, '^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$')
            AND NOT regexp_like(Personal_ID, '000$')) )
);

CREATE TABLE T_Examination
(
    Exam_ID     INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    Medic_ID    INTEGER,
    Personal_ID VARCHAR(10),
    Exam_Date   VARCHAR(10),
    Exam_Time   VARCHAR(5),
    Location_ID INTEGER,
    FOREIGN KEY (Medic_ID) REFERENCES T_Medic (Medic_ID),
    FOREIGN KEY (Personal_ID) REFERENCES T_Patient (Personal_ID)
);

--They are two different entities but with the same data
CREATE TABLE T_Surgery
(
    Surgery_ID   INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    Personal_ID  VARCHAR(10),
    Surgery_date VARCHAR(10),
    Surgery_Time VARCHAR(5),
    Location_ID  INTEGER,
    FOREIGN KEY (Personal_ID) REFERENCES T_Patient (Personal_ID)
);

CREATE TABLE T_Surgery_participants -- Added, when we want to add multiple medics into operation
(
    Surgery_ID INTEGER,
    Medic_ID   INTEGER,
    FOREIGN KEY (Surgery_ID) REFERENCES T_Surgery (Surgery_ID),
    FOREIGN KEY (Medic_ID) REFERENCES T_Medic (Medic_ID)
);

-- Identifies location, makes code cleaner
CREATE TABLE T_Location
(
    Location_ID INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    Clinic_name VARCHAR(30),
    Pavilion    VARCHAR(30),
    Room        VARCHAR(30),
    FOREIGN KEY (Clinic_name) REFERENCES T_Clinic (Clinic_name) ON DELETE CASCADE
);

CREATE TABLE T_Prescribed_Drug
(
    Drug_ID           INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    Medic_ID          INTEGER,
    Personal_ID       VARCHAR(10),
    Prescription_date VARCHAR(10),
    Prescription_time VARCHAR(5),
    Cure              VARCHAR(20),
    FOREIGN KEY (Medic_ID) REFERENCES T_Medic (Medic_ID),
    FOREIGN KEY (Personal_ID) REFERENCES T_Patient (Personal_ID)
);

CREATE TABLE T_Hospitalization
(
    Hospitalization_ID INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    Medic_ID           INTEGER,
    Personal_ID        VARCHAR(10),
    Date_from          varchar(10),
    Date_till          varchar(10),
    FOREIGN KEY (Medic_ID) REFERENCES T_Medic (Medic_ID),
    FOREIGN KEY (Personal_ID) REFERENCES T_Patient (Personal_ID)
);

CREATE TABLE T_Medical_equipment
(
    Medical_equipment_ID INTEGER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
    Clinic_name          VARCHAR(30),
    Equipment            VARCHAR(30),
    Amount               INTEGER,
    FOREIGN KEY (Clinic_name) REFERENCES T_Clinic (Clinic_name) ON DELETE CASCADE
);

INSERT INTO T_Clinic
VALUES ('Dětské', '222333444');
INSERT INTO T_Clinic
VALUES ('Ambulance', '528625362');
INSERT INTO T_Clinic
VALUES ('Neurologie', '777777777');

INSERT INTO T_Medic
VALUES ('1', 'Alena', 'Chytrá', 'Ambulance', 'plný', 'všeobecný');
INSERT INTO T_Medic
VALUES ('2', 'Anton', 'Stašek', 'Ambulance', 'plný', 'všeobecný');
INSERT INTO T_Medic
VALUES ('3', 'Michal', 'Novotný', 'Neurologie', 'plný', 'primář');
INSERT INTO T_Medic
VALUES ('4', 'Anna', 'Černá', 'Neurologie', 'plný', 'všeobecný');
INSERT INTO T_Medic
VALUES ('5', 'Peter', 'Kasčák', 'Neurologie', 'plný', 'všeobecný');
INSERT INTO T_Medic
VALUES ('6', 'Dana', 'Loučková', 'Dětské', 'plný', 'všeobecný');
INSERT INTO T_Medic
VALUES ('7', 'David', 'Novák', 'Dětské', 'směny', 'pratik');
INSERT INTO T_Medic
VALUES ('8', 'David', 'Wentl', 'Neurologie', 'směny', 'všeobecný');
INSERT INTO T_Medic
VALUES ('9', 'Alena', 'Wentl', 'Neurologie', 'plný', 'všeobecný');

INSERT INTO T_Doctor
VALUES ('1', 'ambulantní');
INSERT INTO T_Doctor
VALUES ('2', 'ambulantní');
INSERT INTO T_Doctor
VALUES ('3', 'Dětská neurologie');
INSERT INTO T_Doctor
VALUES ('6', '');
INSERT INTO T_Doctor
VALUES ('7', '');

INSERT INTO T_Nurse
VALUES ('4');
INSERT INTO T_Nurse
VALUES ('5');
INSERT INTO T_Nurse
VALUES ('8');
INSERT INTO T_Nurse
VALUES ('9');

INSERT INTO T_Patient
VALUES ('9502146005', 'Evžen', 'Bezděk');
INSERT INTO T_Patient
VALUES ('9301049593', 'Dominik', 'Nevřela');
INSERT INTO T_Patient
VALUES ('7062012562', 'Eliška', 'Hoffmannová');
INSERT INTO T_Patient
VALUES ('100328001', 'Petr', 'Novák');
--Wrong values
--INSERT INTO T_Patient
--VALUES ('7062012555','Amálie','Hoffmannová');
--INSERT INTO T_Patient
--VALUES ('706201256','Eliška','Hoffmannová');
--INSERT INTO T_Patient
--VALUES ('706201000','Eliška','Hoffmannová');

INSERT INTO T_Medical_equipment
VALUES ('42', 'Dětské', 'Váha', '10');
INSERT INTO T_Medical_equipment
VALUES ('43', 'Ambulance', 'Postel', '76');
INSERT INTO T_Medical_equipment
VALUES ('44', 'Neurologie', 'Rentgen', '2');
INSERT INTO T_Medical_equipment
VALUES ('45', 'Dětské', 'Zraková_tabule', '10');
INSERT INTO T_Medical_equipment
VALUES ('46', 'Ambulance', 'Povlečení', '336');
INSERT INTO T_Medical_equipment
VALUES ('47', 'Neurologie', 'Magnetická_rezonance', '1');

INSERT INTO T_Location
VALUES ('2413', 'Dětské', 'A', 'E21');
INSERT INTO T_Location
VALUES ('521', 'Ambulance', 'C', '127');
INSERT INTO T_Location
VALUES ('15', 'Neurologie', 'A', '11');
INSERT INTO T_Location
VALUES ('221', 'Neurologie', 'B', 'A12');

INSERT INTO T_Prescribed_Drug
VALUES ('222', '1', '9502146005', '2022-06-22', '15:01', 'diazepam');
INSERT INTO T_Prescribed_Drug
VALUES ('521', '1', '7062012562', '2022-07-09', '12:41', 'inzulin');
INSERT INTO T_Prescribed_Drug
VALUES ('634', '2', '7062012562', '2022-08-13', '21:35', 'diazepam');
INSERT INTO T_Prescribed_Drug
VALUES ('991', '2', '7062012562', '2022-05-21', '11:22', 'diazepam');
INSERT INTO T_Prescribed_Drug
VALUES ('943', '1', '100328001', '2022-08-02', '14:33', 'penicilin');
INSERT INTO T_Prescribed_Drug
VALUES ('944', '6', '100328001', '2022-09-04', '18:06', 'penicilin');
INSERT INTO T_Prescribed_Drug
VALUES ('945', '7', '100328001', '2022-10-06', '10:15', 'tyrotricin');

INSERT INTO T_Examination
VALUES ('', '6', '9502146005', '2022-08-25', '12:24', '2431');
INSERT INTO T_Examination
VALUES ('', '2', '9301049593', '2022-06-04', '07:15', '521');
INSERT INTO T_Examination
VALUES ('', '6', '9502146005', '2022-08-25', '12:24', '2431');
INSERT INTO T_Examination
VALUES ('100', '2', '9301049593', '2022-06-04', '07:15', '521');

INSERT INTO T_Surgery
VALUES ('1', '9502146005', '2022-03-01', '15:01', '2431');
INSERT INTO T_Surgery_participants
VALUES ('1', '6');
INSERT INTO T_Surgery
VALUES ('2', '9301049593', '2022-12-23', '8:00', '521');
INSERT INTO T_Surgery_participants
VALUES ('2', '3');
INSERT INTO T_Surgery_participants
VALUES ('2', '2');
INSERT INTO T_Surgery
VALUES ('3', '100328001', '2023-01-12', '9:30', '15');
INSERT INTO T_Surgery_participants
VALUES ('3', '3');
INSERT INTO T_Surgery_participants
VALUES ('3', '8');
INSERT INTO T_Surgery_participants
VALUES ('3', '9');

INSERT INTO T_Hospitalization
VALUES ('99921', '6', '9502146005', '2022-03-01', '2022-03-09');
INSERT INTO T_Hospitalization
VALUES ('99922', '2', '9301049593', '2022-12-23', '2023-01-01');

---- Select queries, all queries will create view so we can see the result

--- Select queries using JOIN two tables
-- First, we want to see all Doctors on available on neurology
DROP VIEW V_Neurology_doctors;

CREATE VIEW V_Neurology_doctors AS
SELECT *
FROM T_Medic
         NATURAL LEFT JOIN T_Doctor
WHERE Clinic_name = 'Neurologie';

-- Now, we want to view all medical equipment available on neurology
DROP VIEW V_Medical_equipment_on_neurology;

CREATE VIEW V_Medical_equipment_on_neurology AS
SELECT Clinic_name, Medical_equipment_ID, Equipment, Amount
FROM T_Clinic
         NATURAL LEFT JOIN T_Medical_equipment
WHERE Clinic_name = 'Neurologie';

--- Select queries using JOIN with three tables

-- We want to view all medics who operated certain patient

DROP VIEW V_Operation_patient_details;

CREATE VIEW V_Operation_patient_details AS
SELECT T_Medic.Medic_ID,
       T_Medic.Medic_first_name,
       T_Medic.Medic_last_name,
       T_Surgery.Surgery_ID,
       Surgery_date,
       Surgery_Time,
       T_Patient.Patient_first_name,
       T_Patient.Patient_last_name
FROM T_Surgery
         LEFT JOIN T_Surgery_participants ON T_Surgery.Surgery_ID = T_Surgery_participants.Surgery_ID
         LEFT JOIN T_Medic ON T_Medic.Medic_ID = T_Surgery_participants.Medic_ID
         LEFT JOIN T_Patient ON T_Patient.Personal_ID = T_Surgery.Personal_ID
WHERE T_Patient.Personal_ID = '100328001';


--- Select queries using GROUP BY and aggregate functions

-- We want to see amount of medic stuff on Neurological clinic
DROP VIEW V_Neurological_stuff;

CREATE VIEW V_Neurological_stuff AS
SELECT COUNT(T_Medic.Medic_ID) AS "Number of medics", T_Medic.Clinic_name
FROM T_Medic
GROUP BY T_Medic.Clinic_name;

-- Which medic had the least operations
DROP VIEW V_Operations_count;

CREATE VIEW V_Operations_count AS
SELECT T_Medic.Medic_ID,
       COUNT(T_Surgery_participants.Surgery_ID) AS "Amount of surgeries"
FROM T_Surgery_participants
         LEFT JOIN T_Medic ON T_Medic.Medic_ID = T_Surgery_participants.Medic_ID
GROUP BY T_Medic.Medic_ID
ORDER BY "Amount of surgeries";

-- How many
--- Select query using EXISTS
-- We want to see names of all medicine prescribed by certain doctor

DROP VIEW V_Prescribed_drugs;

CREATE VIEW V_Prescribed_drugs AS
SELECT T_Medic.Medic_first_name,
       T_Medic.Medic_last_name,
       T_Prescribed_Drug.Prescription_date,
       T_Prescribed_Drug.Cure
FROM T_Doctor
         LEFT JOIN T_Medic ON T_Medic.Medic_ID = T_Doctor.Medic_ID
         LEFT JOIN T_Prescribed_Drug ON T_Medic.Medic_ID = T_Prescribed_Drug.Medic_ID
WHERE EXISTS(
        SELECT Cure
        FROM T_Doctor
                 LEFT JOIN T_Prescribed_Drug ON T_Doctor.Medic_ID = T_Prescribed_Drug.Medic_ID
    )
  AND Cure IS NOT NULL;

--- Select queries using IN
-- Now we want to see only who prescribed diazepam or insulin

DROP VIEW V_Prescribed_insulin_diazepam;

CREATE VIEW V_Prescribed_insulin_diazepam AS
SELECT T_Medic.Medic_first_name,
       T_Medic.Medic_last_name,
       T_Prescribed_Drug.Prescription_date,
       T_Prescribed_Drug.Cure
FROM T_Doctor
         LEFT JOIN T_Medic ON T_Medic.Medic_ID = T_Doctor.Medic_ID
         LEFT JOIN T_Prescribed_Drug ON T_Medic.Medic_ID = T_Prescribed_Drug.Medic_ID
WHERE EXISTS(
        SELECT Cure
        FROM T_Doctor
                 LEFT JOIN T_Prescribed_Drug ON T_Doctor.Medic_ID = T_Prescribed_Drug.Medic_ID
    )
  AND Cure IS NOT NULL
  AND Cure IN ('diazepam', 'inzulin');


COMMIT;

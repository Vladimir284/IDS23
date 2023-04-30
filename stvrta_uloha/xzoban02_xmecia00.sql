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
INSERT INTO T_Medical_equipment
VALUES ('48', 'Neurologie', 'Postel', '20');

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

--- CREATE TRIGGERS

-- Check date trigger
CREATE OR REPLACE TRIGGER check_date
    BEFORE UPDATE OR INSERT
    ON T_Hospitalization
    FOR EACH ROW
DECLARE
    current_date VARCHAR(10);
BEGIN
    current_date := TO_CHAR(SYSDATE, 'YYYY-MM-DD');
    if :NEW.Date_from < current_date THEN
        :NEW.Date_from := current_date;
    else
        :NEW.Date_from := :NEW.Date_from;
    end if;
END;
/

INSERT INTO T_Hospitalization
VALUES ('', '2', '9301049593', '2021-12-23', '2023-01-01');
INSERT INTO T_Hospitalization
VALUES ('', '2', '9301049593', '2024-12-23', '2023-01-01');

-- Check presribed drug trigger
CREATE OR REPLACE TRIGGER check_prescribed_drug
    BEFORE INSERT
    ON T_Prescribed_Drug
    FOR EACH ROW
DECLARE
    prescribtor_id INTEGER;
BEGIN
    select null
    into prescribtor_id
    from T_Doctor
    where T_Doctor.Medic_ID = :NEW.Medic_ID
      and rownum = 1;

exception
    when no_data_found then
        -- do things here when record doesn't exists
        raise_application_error(-20000, 'Zaměstnanec není oprávňen předepisovat léky');
END;

INSERT INTO T_Prescribed_Drug
VALUES (778, '3', '100328001', '2023-04-26', '08:58', 'Paracetamol');
INSERT INTO T_Prescribed_Drug
VALUES (779, '9', '100328001', '2023-04-27', '08:58', 'Placebo');


--- END TRIGGERS

--- CREATE PROCEDURES

-- Used items in whole hospital procedure
CREATE OR REPLACE PROCEDURE ITEM_USED(item_name IN VARCHAR)
AS
    name            T_Medical_equipment.Equipment%type;
    amount_of_items T_Medical_equipment.Amount%type;
    "count"         NUMBER;
    name_to_find    T_Medical_equipment.Equipment%type;
    CURSOR Items IS SELECT Equipment, Amount
                    FROM T_Medical_equipment;
BEGIN
    "count" := 0;
    name_to_find := item_name;
    OPEN Items;
    LOOP
        FETCH Items INTO name,amount_of_items;
        EXIT WHEN Items%NOTFOUND;
        IF name = item_name THEN
            "count" := "count" + amount_of_items;
        END IF;
    END LOOP;
    CLOSE Items;
    DBMS_OUTPUT.put_line('Počet položek ' || name_to_find || ' je ' || "count");
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        BEGIN
            DBMS_OUTPUT.put_line('Položka' || name_to_find || 'nenalezena.');
        END;

END;
/
BEGIN
    ITEM_USED('Postel');
END;
--- END PROCEDURES

-- CREATE EXPLAIN PLAN
-- CREATE INDEX
DROP INDEX person;
EXPLAIN PLAN FOR
SELECT T_Patient.Personal_ID,
       COUNT(T_Examination.Personal_ID) AS "Amount of examinations"
FROM T_Patient
         LEFT JOIN T_Examination ON T_Examination.Personal_ID = T_Patient.Personal_ID
WHERE NOT EXISTS(
        SELECT *
        FROM T_Nurse
        WHERE T_Examination.Medic_ID = T_Nurse.Medic_ID
    )
GROUP BY T_Patient.Personal_ID
ORDER BY "Amount of examinations";
SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);

CREATE INDEX person ON T_Examination (Personal_ID);

EXPLAIN PLAN FOR
SELECT T_Patient.Personal_ID,
       COUNT(T_Examination.Personal_ID) AS "Amount of examinations"
FROM T_Patient
         LEFT JOIN T_Examination ON T_Examination.Personal_ID = T_Patient.Personal_ID
WHERE NOT EXISTS(
        SELECT *
        FROM T_Nurse
        WHERE T_Examination.Medic_ID = T_Nurse.Medic_ID
    )
GROUP BY T_Patient.Personal_ID
ORDER BY "Amount of examinations";
SELECT *
FROM TABLE (DBMS_XPLAN.DISPLAY);
-- END EXPLAIN PLAN
-- END INDEX
/
BEGIN
    ITEM_USED('Postel');
END;

CREATE OR REPLACE PROCEDURE GET_PATIENT_OPERATIONS(patients_id in VARCHAR)
AS
    CURSOR Operations IS SELECT T_Patient.Patient_first_name,
                                T_Patient.Patient_last_name,
                                T_Surgery.Surgery_ID,
                                T_Surgery.Surgery_date,
                                T_Surgery.Surgery_Time
                         FROM T_Patient
                                  JOIN T_Surgery ON T_Patient.Personal_ID = T_Surgery.Personal_ID
                         WHERE T_Surgery.Personal_ID = patients_id;
    r_row Operations%ROWTYPE;
BEGIN
    OPEN Operations;
    LOOP
        FETCH Operations INTO r_row;
        EXIT WHEN Operations%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(r_row.Patient_first_name || ' ' || r_row.Patient_last_name || ' ' || r_row.Surgery_ID ||
                             ' ' ||
                             r_row.Surgery_date || ' ' || r_row.Surgery_Time);
    END LOOP;
    CLOSE Operations;
END GET_PATIENT_OPERATIONS;

INSERT INTO T_Surgery
VALUES ('4', '100328001', '2022-04-28', '10:00', '15');
INSERT INTO T_Surgery_participants
VALUES ('1', '6');

BEGIN
    GET_PATIENT_OPERATIONS('100328001');
END;

--- END PROCEDURES

--- GRANT ACCES
GRANT SELECT ON T_Clinic TO XMECIA00;
GRANT SELECT ON T_Doctor TO XMECIA00;
GRANT SELECT ON T_Examination TO XMECIA00;
GRANT SELECT ON T_Hospitalization TO XMECIA00;
GRANT SELECT ON T_Location TO XMECIA00;
GRANT SELECT ON T_Medic TO XMECIA00;
GRANT SELECT ON T_Medical_equipment TO XMECIA00;
GRANT SELECT ON T_Nurse TO XMECIA00;
GRANT SELECT ON T_Patient TO XMECIA00;
GRANT SELECT ON T_Prescribed_Drug TO XMECIA00;
GRANT SELECT ON T_Surgery TO XMECIA00;
GRANT SELECT ON T_Surgery_participants TO XMECIA00;

--- END GRANT ACCES

--- CREATE MATERIALISED VIEW
DROP MATERIALIZED VIEW V_Operation_patient_details;

CREATE MATERIALIZED VIEW V_Operation_patient_details AS
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

GRANT SELECT ON V_Operation_patient_details TO XZOBAN02;

--- END VIEW


--- CREATE COMPLEX SELECT QUERY

-- New clinic with insufficient capacity

INSERT INTO T_Clinic
VALUES ('Gastroenterologie', 9876543210);
INSERT INTO T_Location
VALUES (143, 'Gastroenterologie', 'Pavilon A', 'A 336');
INSERT INTO T_Medical_equipment
VALUES (123, 'Gastroenterologie', 'Postel', 3);
INSERT INTO T_Medic
VALUES (10, 'Alan', 'Dvetl', 'Gastroenterologie', 'plný', 'extérní');
INSERT INTO T_Medic
VALUES (11, 'Michal', 'Dveran', 'Gastroenterologie', 'směny', 'všeobecný');
INSERT INTO T_Medic
VALUES (12, 'Radim', 'Kurchus', 'Gastroenterologie', 'plný', 'primář');

-- Insertion of Clinic name with warning
INSERT INTO T_Medical_equipment
VALUES (178, 'Dětské', 'Postel', 13);

SELECT T_CLINIC.CLINIC_NAME,
       CASE
           WHEN AMOUNT < (SELECT count(*)
                          FROM T_Nurse
                                   JOIN T_Medic ON T_Nurse.Medic_ID = T_Medic.Medic_ID
                                   JOIN T_Clinic ON T_Medic.Clinic_name = T_Clinic.Clinic_name) * 2 + (SELECT count(*)
                                                                                                       FROM T_Doctor
                                                                                                                JOIN T_Medic ON T_Doctor.Medic_ID = T_Medic.Medic_ID
                                                                                                                JOIN T_Clinic ON T_Medic.Clinic_name = T_Clinic.Clinic_name)
               THEN 'CHYBA:     Nedostatečná kapacita lůžek'
           WHEN AMOUNT = (SELECT count(*)
                          FROM T_Nurse
                                   JOIN T_Medic ON T_Nurse.Medic_ID = T_Medic.Medic_ID
                                   JOIN T_Clinic ON T_Medic.Clinic_name = T_Clinic.Clinic_name) * 2 + (SELECT count(*)
                                                                                                       FROM T_Doctor
                                                                                                                JOIN T_Medic ON T_Doctor.Medic_ID = T_Medic.Medic_ID
                                                                                                                JOIN T_Clinic ON T_Medic.Clinic_name = T_Clinic.Clinic_name)
               THEN 'Varování:  Žádná další rezerva lůžek'
           WHEN AMOUNT > (SELECT count(*)
                          FROM T_Nurse
                                   JOIN T_Medic ON T_Nurse.Medic_ID = T_Medic.Medic_ID
                                   JOIN T_Clinic ON T_Medic.Clinic_name = T_Clinic.Clinic_name) * 2 + (SELECT count(*)
                                                                                                       FROM T_Doctor
                                                                                                                JOIN T_Medic ON T_Doctor.Medic_ID = T_Medic.Medic_ID
                                                                                                                JOIN T_Clinic ON T_Medic.Clinic_name = T_Clinic.Clinic_name)
               THEN 'OK:        Dostatečná rezerva lůžek'
           END AS STATE
FROM T_CLINIC
         RIGHT JOIN T_MEDICAL_EQUIPMENT ON (T_CLINIC.CLINIC_NAME = T_MEDICAL_EQUIPMENT.CLINIC_NAME)
WHERE EQUIPMENT = 'Postel';

--- END
COMMIT;

-- Debug for view errors
-- DROP VIEW errors;
-- CREATE VIEW errors AS
-- SELECT *
-- FROM user_errors
-- WHERE type = 'TRIGGER' -- Podla typu errorru
--   and name = 'CHECK_PRESCRIBED_DRUG'; -- Nazov erroru

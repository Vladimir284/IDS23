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

CREATE TABLE T_Clinic
(
    Clinic_name         VARCHAR(30) NOT NULL PRIMARY KEY,
    Telephone           INTEGER
);

CREATE TABLE T_Medic
(
    Medic_ID    INTEGER NOT NULL PRIMARY KEY,
    First_name  VARCHAR(20),
    Last_name   VARCHAR(20),
    Clinic_name VARCHAR(30),
    Duty        VARCHAR(20),
    Status      VARCHAR(20),
    FOREIGN KEY (Clinic_name) REFERENCES T_Clinic(Clinic_name)
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
    First_name  VARCHAR(20),
    Last_name   VARCHAR(20)
);

CREATE TABLE T_Examination
(
    Exam_ID     INTEGER NOT NULL PRIMARY KEY,
    Medic_ID    INTEGER,
    Personal_ID INTEGER,
    Exam_Date   VARCHAR(10),
    Exam_Time   VARCHAR(5),
    Location_ID INTEGER,
    FOREIGN KEY (Medic_ID) REFERENCES T_Medic(Medic_ID) ,
    FOREIGN KEY (Personal_ID) REFERENCES T_Patient(Personal_ID)
);

CREATE TABLE T_Surgery
(
    Surgery_ID   INTEGER NOT NULL PRIMARY KEY,
    Medic_ID     INTEGER,
    Personal_ID  INTEGER,
    Surgery_date VARCHAR(10),
    Surgery_Time VARCHAR(5),
    Location_ID  INTEGER,
    FOREIGN KEY (Medic_ID) REFERENCES T_Medic(Medic_ID) ,
    FOREIGN KEY (Personal_ID) REFERENCES T_Patient(Personal_ID)
);

-- Identifies location, makes code cleaner
CREATE TABLE T_Location
(
    Location_ID INTEGER NOT NULL PRIMARY KEY,
    Clinic_name VARCHAR(30),
    Pavilion    VARCHAR(30),
    Room        VARCHAR(30),
    FOREIGN KEY (Clinic_name) REFERENCES T_Clinic(Clinic_name) ON DELETE CASCADE
);

CREATE TABLE T_Prescribed_Drug
(
    Drug_ID           INTEGER NOT NULL PRIMARY KEY,
    Medic_ID          INTEGER,
    Personal_ID       INTEGER,
    Prescription_date VARCHAR(10),
    Prescription_time VARCHAR(5),
    Cure              VARCHAR(20),
    FOREIGN KEY (Medic_ID) REFERENCES T_Medic(Medic_ID) ,
    FOREIGN KEY (Personal_ID) REFERENCES T_Patient(Personal_ID)
);

CREATE TABLE T_Hospitalization
(
    Hospitalization_ID INTEGER NOT NULL PRIMARY KEY,
    Medic_ID           INTEGER,
    Personal_ID        INTEGER,
    Date_from          varchar(10),
    Date_till          varchar(10),
    FOREIGN KEY (Medic_ID) REFERENCES T_Medic(Medic_ID) ,
    FOREIGN KEY (Personal_ID) REFERENCES T_Patient(Personal_ID)
);

CREATE TABLE T_Medical_equipment
(
    Medical_equipment_ID INTEGER NOT NULL PRIMARY KEY,
    Clinic_name          VARCHAR(30),
    Equipment            VARCHAR(30),
    Amount               INTEGER,
    FOREIGN KEY (Clinic_name) REFERENCES T_Clinic(Clinic_name) ON DELETE CASCADE
);

INSERT INTO T_Clinic
VALUES ('Dětské','222333444');
INSERT INTO T_Clinic
VALUES ('Ambulance','528625362');
INSERT INTO T_Clinic
VALUES ('Neurologie','777777777');

INSERT INTO T_Medic
VALUES ('1','Alena','Chytrá','Ambulance','plný','všeobecný');
INSERT INTO T_Medic
VALUES ('2','Anton','Stašek','Ambulance','plný','všeobecný');
INSERT INTO T_Medic
VALUES ('3','Michal','Novotný','Neurologie','plný','primář');
INSERT INTO T_Medic
VALUES ('4','Anna','Černá','Neurologie','plný','všeobecný');
INSERT INTO T_Medic
VALUES ('5','Dana','Loučková','Dětské','plný','všeobecný');
INSERT INTO T_Medic
VALUES ('6','David','Novák','Dětské','směny','pratik');

INSERT INTO T_Doctor
VALUES ('1','ambulantní');
INSERT INTO T_Doctor
VALUES ('2','ambulantní');

INSERT INTO T_Nurse
VALUES ('4');
INSERT INTO T_Nurse
VALUES ('5');

INSERT INTO T_Patient
VALUES ('9502146005','Evžen','Bezděk');
INSERT INTO T_Patient
VALUES ('9301049593','Dominik','Nevřela');
INSERT INTO T_Patient
VALUES ('7062012562','Eliška','Hoffmannová');

INSERT INTO T_Medical_equipment
VALUES ('42','Dětské','Váha','10');
INSERT INTO T_Medical_equipment
VALUES ('43','Ambulance','Postel','76');
INSERT INTO T_Medical_equipment
VALUES ('44','Neurologie','Rentgen','2');
INSERT INTO T_Medical_equipment
VALUES ('45','Dětské','Zraková_tabule','10');
INSERT INTO T_Medical_equipment
VALUES ('46','Ambulance','Povlečení','336');
INSERT INTO T_Medical_equipment
VALUES ('47','Neurologie','Magnetická_rezonance','1');

INSERT INTO T_Location
VALUES ('2413','Dětské','A','E21');
INSERT INTO T_Location
VALUES ('521','Ambulance','C','127');
INSERT INTO T_Location
VALUES ('15','Neurologie','A','11');
INSERT INTO T_Location
VALUES ('221','Neurologie','B','A12');

INSERT INTO T_Prescribed_Drug
VALUES ('222','1','9502146005','2022-06-22','15:01','diazepam');
INSERT INTO T_Prescribed_Drug
VALUES ('521','1','7062012562','2022-07-09','12:41','inzulin');
INSERT INTO T_Prescribed_Drug
VALUES ('634','2','7062012562','2022-08-13','21:35','diazepam');
INSERT INTO T_Prescribed_Drug
VALUES ('991','2','7062012562','2022-05-21','11:22','diazepam');



INSERT INTO T_Examination
VALUES ('11111','6','9502146005','2022-08-25','12:24','2431');
INSERT INTO T_Examination
VALUES ('12222','2','9301049593','2022-06-04','07:15','521');

INSERT INTO T_Examination
VALUES ('1','6','9502146005','2022-08-25','12:24','2431');
INSERT INTO T_Examination
VALUES ('2','2','9301049593','2022-06-04','07:15','521');

INSERT INTO T_Surgery
VALUES ('1','6','9502146005','2022-03-01','15:01','2431');
INSERT INTO T_Surgery
VALUES ('2','2','9301049593','2022-12-23','8:00','521');

INSERT INTO T_Hospitalization
VALUES ('99921','6','9502146005','2022-03-01','2022-03-09');
INSERT INTO T_Hospitalization
VALUES ('99922','2','9301049593','2022-12-23','2023-01-01');

commit ;


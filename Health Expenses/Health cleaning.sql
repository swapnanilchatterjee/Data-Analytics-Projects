DROP TABLE IF EXISTS diabetic_data;

CREATE TABLE diabetic_data (
    patient_nbr BIGINT,
    race TEXT,
    gender TEXT,
    age TEXT,
    admission_type_id INT,
    discharge_disposition_id INT,
    admission_source_id INT,
    time_in_hospital INT,
    payer_code TEXT,
    medical_specialty TEXT,
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    diag_1 TEXT,
    diag_2 TEXT,
    diag_3 TEXT,
    number_diagnoses INT,
    max_glu_serum TEXT,
    a1cresult TEXT,
    metformin TEXT,
    repaglinide TEXT,
    nateglinide TEXT,
    chlorpropamide TEXT,
    glimepiride TEXT,
    acetohexamide TEXT,
    glipizide TEXT,
    glyburide TEXT,
    tolbutamide TEXT,
    pioglitazone TEXT,
    rosiglitazone TEXT,
    acarbose TEXT,
    miglitol TEXT,
    troglitazone TEXT,
    tolazamide TEXT,
    examide TEXT,
    citoglipton TEXT,
    insulin TEXT,
    glyburide_metformin TEXT,
    glipizide_metformin TEXT,
    glimepiride_pioglitazone TEXT,
    metformin_rosiglitazone TEXT,
    metformin_pioglitazone TEXT,
    change TEXT,
    diabetesmed TEXT,
    readmitted TEXT
);
select * FROM diabetic_data limit 10;
ALTER TABLE diabetic_data ADD COLUMN readmitted_binary INT;

UPDATE diabetic_data
SET readmitted_binary = CASE
    WHEN readmitted = '<30' THEN 1
    WHEN readmitted = '>30' THEN 1
    WHEN readmitted = 'NO'  THEN 0
    ELSE NULL
END;

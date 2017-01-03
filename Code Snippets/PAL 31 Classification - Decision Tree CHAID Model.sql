SET SCHEMA PAL;

-- PAL setup

CREATE TYPE PAL_T_DT_DATA AS TABLE (POLICY VARCHAR(10), AGE INTEGER, AMOUNT INTEGER, OCCUPATION VARCHAR(10), FRAUD VARCHAR(10));
CREATE TYPE PAL_T_DT_PARAMS AS TABLE (NAME VARCHAR(60), INTARGS INTEGER, DOUBLEARGS DOUBLE, STRINGARGS VARCHAR (100));
CREATE TYPE PAL_T_DT_MODEL_JSON AS TABLE (ID INTEGER, JSONMODEL VARCHAR(5000));
CREATE TYPE PAL_T_DT_MODEL_PMML AS TABLE (ID INTEGER, PMMLMODEL VARCHAR(5000));

CREATE COLUMN TABLE PAL_DT_SIGNATURE (ID INTEGER, TYPENAME VARCHAR(100), DIRECTION VARCHAR(100));
INSERT INTO PAL_DT_SIGNATURE VALUES (1, 'PAL.PAL_T_DT_DATA', 'in');
INSERT INTO PAL_DT_SIGNATURE VALUES (2, 'PAL.PAL_T_DT_PARAMS', 'in');
INSERT INTO PAL_DT_SIGNATURE VALUES (3, 'PAL.PAL_T_DT_MODEL_JSON', 'out');
INSERT INTO PAL_DT_SIGNATURE VALUES (4, 'PAL.PAL_T_DT_MODEL_PMML', 'out');

CALL SYSTEM.AFL_WRAPPER_GENERATOR ('PAL_DT', 'AFLPAL', 'CREATEDTWITHCHAID', PAL_DT_SIGNATURE);

-- app setup

CREATE VIEW V_DT_DATA AS
 SELECT POLICY, AGE, AMOUNT, OCCUPATION, FRAUD 
  FROM CLAIMS
  ;
CREATE COLUMN TABLE DT_PARAMS LIKE PAL_T_DT_PARAMS;
CREATE COLUMN TABLE DT_MODEL_JSON LIKE PAL_T_DT_MODEL_JSON;
CREATE COLUMN TABLE DT_MODEL_PMML LIKE PAL_T_DT_MODEL_PMML;

INSERT INTO DT_PARAMS VALUES ('THREAD_NUMBER', 2, null, null);
INSERT INTO DT_PARAMS VALUES ('PERCENTAGE', null, 1.0, null);
INSERT INTO DT_PARAMS VALUES ('MIN_NUMS_RECORDS', 1, null, null);
INSERT INTO DT_PARAMS VALUES ('IS_SPLIT_MODEL', 0, null, null);
INSERT INTO DT_PARAMS VALUES ('PMML_EXPORT', 1, null, null);
INSERT INTO DT_PARAMS VALUES ('CONTINUOUS_COL', 1, null, null); -- specify column # as continuous (default for integer columns is categorical)
INSERT INTO DT_PARAMS VALUES ('CONTINUOUS_COL', 2, null, null); -- specify column # as continuous (default for integer columns is categorical)

-- app runtime

TRUNCATE TABLE DT_MODEL_JSON;
TRUNCATE TABLE DT_MODEL_PMML;

CALL _SYS_AFL.PAL_DT (V_DT_DATA, DT_PARAMS, DT_MODEL_JSON, DT_MODEL_PMML) WITH OVERVIEW;

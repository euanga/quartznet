-- These are taken from Quartz (Java) version 1.6.0

--
-- Thanks to Leonardo Alves
--


DROP TABLE QRTZ_JOB_LISTENERS;
DROP TABLE QRTZ_TRIGGER_LISTENERS;
DROP TABLE QRTZ_FIRED_TRIGGERS;
DROP TABLE QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE QRTZ_SCHEDULER_STATE;
DROP TABLE QRTZ_LOCKS;
DROP TABLE QRTZ_SIMPLE_TRIGGERS;
DROP TABLE QRTZ_CRON_TRIGGERS;
DROP TABLE QRTZ_BLOB_TRIGGERS;
DROP TABLE QRTZ_TRIGGERS;
DROP TABLE QRTZ_JOB_DETAILS;
DROP TABLE QRTZ_CALENDARS;


CREATE TABLE QRTZ_JOB_DETAILS (
    JOB_NAME  VARCHAR(60) NOT NULL,
    JOB_GROUP VARCHAR(60) NOT NULL,
    DESCRIPTION VARCHAR(120),
    JOB_CLASS_NAME   VARCHAR(128) NOT NULL, 
    IS_DURABLE VARCHAR(1) NOT NULL,
    IS_VOLATILE VARCHAR(1) NOT NULL,
    IS_STATEFUL VARCHAR(1) NOT NULL,
    REQUESTS_RECOVERY VARCHAR(1) NOT NULL,
    JOB_DATA BLOB,
    CONSTRAINT PK_QRTZ_JOB_DETAILS PRIMARY KEY (JOB_NAME,JOB_GROUP)
);

CREATE TABLE QRTZ_JOB_LISTENERS (
    JOB_NAME  VARCHAR(60) NOT NULL, 
    JOB_GROUP VARCHAR(60) NOT NULL,
    JOB_LISTENER VARCHAR(60) NOT NULL,
    CONSTRAINT PK_QRTZ_JOB_LST PRIMARY KEY (JOB_NAME,JOB_GROUP,JOB_LISTENER),
    CONSTRAINT FK_QRTZ_JOB_LST_1 FOREIGN KEY (JOB_NAME,JOB_GROUP)
    REFERENCES QRTZ_JOB_DETAILS(JOB_NAME,JOB_GROUP) 
);

CREATE TABLE QRTZ_TRIGGERS (
    TRIGGER_NAME VARCHAR(60) NOT NULL,
    TRIGGER_GROUP VARCHAR(60) NOT NULL,
    JOB_NAME  VARCHAR(60) NOT NULL, 
    JOB_GROUP VARCHAR(60) NOT NULL,
    IS_VOLATILE VARCHAR(1) NOT NULL,
    DESCRIPTION VARCHAR(120),
    NEXT_FIRE_TIME BIGINT,
    PREV_FIRE_TIME BIGINT,
    PRIORITY INTEGER,
    TRIGGER_STATE VARCHAR(16) NOT NULL,
    TRIGGER_TYPE VARCHAR(8) NOT NULL,
    START_TIME BIGINT NOT NULL,
    END_TIME BIGINT,
    CALENDAR_NAME VARCHAR(60),
    MISFIRE_INSTR SMALLINT,
    JOB_DATA BLOB,
    CONSTRAINT PK_QRTZ_TRIGGERS PRIMARY KEY (TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT FK_QRTZ_TRIGGERS_1 FOREIGN KEY (JOB_NAME,JOB_GROUP) 
    REFERENCES QRTZ_JOB_DETAILS(JOB_NAME,JOB_GROUP) 
);

CREATE TABLE QRTZ_SIMPLE_TRIGGERS (
    TRIGGER_NAME VARCHAR(60) NOT NULL,
    TRIGGER_GROUP VARCHAR(60) NOT NULL,
    REPEAT_COUNT BIGINT NOT NULL,
    REPEAT_INTERVAL BIGINT NOT NULL,
    TIMES_TRIGGERED BIGINT NOT NULL,
    CONSTRAINT PK_QRTZ_SIMPLE_TRIGGERS PRIMARY KEY (TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT FK_QRTZ_SIMPLE_TRIGGERS_1 FOREIGN KEY (TRIGGER_NAME,TRIGGER_GROUP) 
    REFERENCES QRTZ_TRIGGERS(TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_CRON_TRIGGERS (
    TRIGGER_NAME VARCHAR(60) NOT NULL,
    TRIGGER_GROUP VARCHAR(60) NOT NULL,
    CRON_EXPRESSION VARCHAR(60) NOT NULL,
    TIME_ZONE_ID VARCHAR(60),
    CONSTRAINT PK_QRTZ_SIMPLE_TRG PRIMARY KEY (TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT FK_QRTZ_SIMPLE_TRG_1 FOREIGN KEY (TRIGGER_NAME,TRIGGER_GROUP)
    REFERENCES QRTZ_TRIGGERS(TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_BLOB_TRIGGERS (
    TRIGGER_NAME VARCHAR(60) NOT NULL,
    TRIGGER_GROUP VARCHAR(60) NOT NULL,
    BLOB_DATA BLOB,
    CONSTRAINT PK_QRTZ_BLOB_TRIGGERS PRIMARY KEY (TRIGGER_NAME,TRIGGER_GROUP),
    CONSTRAINT FK_QRTZ_BLOB_TRIGGERS_1 FOREIGN KEY (TRIGGER_NAME,TRIGGER_GROUP) 
        REFERENCES QRTZ_TRIGGERS(TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_TRIGGER_LISTENERS (
    TRIGGER_NAME  VARCHAR(60) NOT NULL, 
    TRIGGER_GROUP VARCHAR(60) NOT NULL,
    TRIGGER_LISTENER VARCHAR(60) NOT NULL,
    CONSTRAINT PK_QRTZ_TRIGGER_LST PRIMARY KEY (TRIGGER_NAME,TRIGGER_GROUP,TRIGGER_LISTENER),
    CONSTRAINT FK_QRTZ_TRIGGER_LST_1 FOREIGN KEY (TRIGGER_NAME,TRIGGER_GROUP)
    REFERENCES QRTZ_TRIGGERS(TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_CALENDARS (
    CALENDAR_NAME  VARCHAR(60) NOT NULL, 
    CALENDAR BLOB NOT NULL,
    CONSTRAINT PK_QRTZ_CALENDARS PRIMARY KEY (CALENDAR_NAME)
);

CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS (
    TRIGGER_GROUP  VARCHAR(60) NOT NULL, 
    CONSTRAINT PK_QRTZ_PAUSED_TRIGGER_GRPS PRIMARY KEY (TRIGGER_GROUP)
);

CREATE TABLE QRTZ_FIRED_TRIGGERS (
    ENTRY_ID VARCHAR(95) NOT NULL,
    TRIGGER_NAME VARCHAR(60) NOT NULL,
    TRIGGER_GROUP VARCHAR(60) NOT NULL,
    IS_VOLATILE VARCHAR(1) NOT NULL,
    INSTANCE_NAME VARCHAR(80) NOT NULL,
    FIRED_TIME BIGINT NOT NULL,
    PRIORITY INTEGER NOT NULL,
    STATE VARCHAR(16) NOT NULL,
    JOB_NAME VARCHAR(60),
    JOB_GROUP VARCHAR(60),
    IS_STATEFUL VARCHAR(1),
    REQUESTS_RECOVERY VARCHAR(1),
    CONSTRAINT PK_QRTZ_FIRED_TRIGGERS PRIMARY KEY (ENTRY_ID)
);

CREATE TABLE QRTZ_SCHEDULER_STATE (
    INSTANCE_NAME VARCHAR(80) NOT NULL,
    LAST_CHECKIN_TIME BIGINT NOT NULL,
    CHECKIN_INTERVAL BIGINT NOT NULL,
    CONSTRAINT PK_QRTZ_SCHEDULER_STATE PRIMARY KEY (INSTANCE_NAME)
);

CREATE TABLE QRTZ_LOCKS (
    LOCK_NAME  VARCHAR(40) NOT NULL, 
    CONSTRAINT PK_QRTZ_LOCKS PRIMARY KEY (LOCK_NAME)
);

INSERT INTO QRTZ_LOCKS VALUES('TRIGGER_ACCESS');
INSERT INTO QRTZ_LOCKS VALUES('JOB_ACCESS');
INSERT INTO QRTZ_LOCKS VALUES('CALENDAR_ACCESS');
INSERT INTO QRTZ_LOCKS VALUES('STATE_ACCESS');
INSERT INTO QRTZ_LOCKS VALUES('MISFIRE_ACCESS');

COMMIT;

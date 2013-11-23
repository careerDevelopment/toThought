CREATE TABLE TAG(
	TAG_ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	NAME VARCHAR(100)
);

CREATE TABLE POST_PART(
  POST_PART_ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  BODY text
);

CREATE TABLE POST(
  POST_ID INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
  TITLE VARCHAR(200) DEFAULT NULL,
  AUTHOR VARCHAR(45) DEFAULT NULL,
  POST_PART_ID INT DEFAULT NULL,
  POSTED_DT DATE DEFAULT NULL,
  SOURCE_CODE MEDIUMTEXT,
  FOREIGN KEY(POST_PART_ID) REFERENCES POST_PART(POST_PART_ID)
);

CREATE TABLE POST_TAG(
	POST_ID INT NOT NULL,
	TAG_ID INT NOT NULL,
	FOREIGN KEY(POST_ID) REFERENCES POST(POST_ID),
    FOREIGN KEY(TAG_ID) REFERENCES TAG(TAG_ID),
    PRIMARY KEY(POST_ID,TAG_ID)
);

CREATE VIEW V_POST AS 
select POST_ID,AUTHOR,POSTED_DT,SOURCE_CODE,TITLE, POST.POST_PART_ID, BODY,
substr(BODY,1,300) AS TEASER 
from POST 
join POST_PART 
on POST.POST_PART_ID = POST_PART.POST_PART_ID;

CREATE VIEW V_TAG as
select POST_TAG.TAG_ID, count(POST_TAG.TAG_ID) as COUNT, NAME
from POST_TAG
join TAG
on POST_TAG.TAG_ID = TAG.TAG_ID
group by POST_TAG.TAG_ID;

CREATE  TABLE IF NOT EXISTS IMAGE (
  IMAGE_ID INT NOT NULL AUTO_INCREMENT,
  NAME VARCHAR(100) NULL ,
  TYPE VARCHAR(100) NULL ,
  FILE BLOB NULL ,
  PRIMARY KEY (IMAGE_ID)
);
  
CREATE TABLE skill_category (
  SKILL_CATEGORY_ID int(11) NOT NULL AUTO_INCREMENT,
  NAME varchar(100) DEFAULT NULL,
  PRIMARY KEY (SKILL_CATEGORY_ID)
);

CREATE TABLE skill (
  SKILL_ID int(11) NOT NULL AUTO_INCREMENT,
  NAME varchar(45) NOT NULL,
  RATING int(11) DEFAULT NULL,
  DESCRIPTION longtext,
  PROVIDER varchar(100) DEFAULT NULL,
  URL varchar(150) DEFAULT NULL,
  TAG_ID int(11) DEFAULT NULL,
  SKILL_CATEGORY_ID int(11) DEFAULT NULL,
  IMAGE_ID int(11) DEFAULT NULL,
  PRIMARY KEY (SKILL_ID)
);

CREATE TABLE experience(
	EXPERIENCE_ID INT(11) NOT NULL AUTO_INCREMENT ,
	START_DATE DATE NOT NULL ,
	END_DATE DATE NOT NULL ,
  	DESCRIPTION LONGTEXT NOT NULL ,
    POSITION VARCHAR(100) NOT NULL ,
    ORGANIZATION LONGTEXT NOT NULL ,
    IS_PRESENT TINYINT NULL,
    PRIMARY KEY(EXPERIENCE_ID)
);

CREATE TABLE experience_detail(
   EXPERIENCE_DETAIL_ID INT(11) NOT NULL AUTO_INCREMENT,
   DESCRIPTION LONGTEXT NULL ,
   EXPERIENCE_ID INT(11) NULL,
   PRIMARY KEY(EXPERIENCE_DETAIL_ID)
);

CREATE TABLE experience_tag(
	EXPERIENCE_TAG_ID INT(11) NOT NULL AUTO_INCREMENT,
	EXPERIENCE_ID INT(11) NOT NULL ,
    TAG_ID INT(11) NOT NULL ,
  FOREIGN KEY(EXPERIENCE_ID) REFERENCES EXPERIENCE(EXPERIENCE_ID),
  FOREIGN KEY(TAG_ID) REFERENCES TAG(TAG_ID),
  PRIMARY KEY (EXPERIENCE_TAG_ID)
);

CREATE TABLE DEGREE (
  DEGREE_ID INT NOT NULL AUTO_INCREMENT,
  INSTITUTION VARCHAR(100) NULL ,
  PROGRAM VARCHAR(125) NULL ,
  EMPHASIS VARCHAR(125) NULL ,
  DEGREE_TYPE VARCHAR(45) NULL ,
  GPA VARCHAR(45) NULL ,
  START_DATE DATE NULL ,
  END_DATE DATE NULL ,
  IS_PRESENT TINYINT,
  PRIMARY KEY (DEGREE_ID) 
);

CREATE  TABLE DEGREE_DETAIL (
  DEGREE_DETAIL_ID INT NOT NULL AUTO_INCREMENT ,
  DESCRIPTION LONGTEXT NOT NULL ,
  DEGREE_ID INT NULL ,
  PRIMARY KEY (DEGREE_DETAIL_ID)
);

CREATE  TABLE IF NOT EXISTS COMMENT (
  COMMENT_ID INT NOT NULL AUTO_INCREMENT ,
  AUTHOR VARCHAR(100) NOT NULL ,
  EMAIL VARCHAR(100) NULL ,
  SITE VARCHAR(100) NULL ,
  BODY MEDIUMTEXT NULL ,
  RATING INT NULL ,
  POSTED_DT DATETIME NULL ,
  POST_ID INT,
  IP_ADDRESS VARCHAR(50),
  PRIMARY KEY (COMMENT_ID) ,
  FOREIGN KEY (POST_ID ) REFERENCES POST (POST_ID ));
  
CREATE TABLE COMMIT (
  COMMIT_ID int(11) NOT NULL AUTO_INCREMENT,
  TITLE varchar(150) DEFAULT NULL,
  API_URL varchar(250) DEFAULT NULL,
  HTML_URL varchar(250) DEFAULT NULL,
  SHA varchar(250) DEFAULT NULL,
  COMMIT_DT datetime null,
  MESSAGE VARCHAR(250) null,
  PRIMARY KEY (COMMIT_ID)
);

CREATE TABLE DATA_LOAD_LOG_ENTRY (
  DATA_LOAD_LOG_ENTRY_ID int(11) NOT NULL AUTO_INCREMENT,
  LOAD_NAME varchar(100) DEFAULT NULL,
  RECORDS_ADDED int(11) DEFAULT NULL,
  DATA_CURRENT_DT date DEFAULT NULL,
  RUN_DT date DEFAULT NULL,
  PRIMARY KEY (DATA_LOAD_LOG_ENTRY_ID)
);

CREATE TABLE commit_tag (
  COMMIT_ID int(11) NOT NULL,
  TAG_ID int(11) DEFAULT NULL,
  PRIMARY KEY (COMMIT_ID),
);

CREATE TABLE STACK_OVERFLOW_ANSWER (
  STACK_OVERFLOW_ANSWER_ID int(11) NOT NULL AUTO_INCREMENT,
  TITLE varchar(200) DEFAULT NULL,
  URL varchar(300) DEFAULT NULL,
  CREATED_DT date DEFAULT NULL,
  PRIMARY KEY (STACK_OVERFLOW_ANSWER_ID)
);

CREATE VIEW v_data_load_log_entry AS 
(select
    data_load_log_entry_id,
	data_load_log_entry.LOAD_NAME AS load_name,
	max(data_load_log_entry.DATA_CURRENT_DT) AS DATA_CURRENT_DT,
	data_load_log_entry.RUN_DT AS run_dt 
from data_load_log_entry group by data_load_log_entry.LOAD_NAME, data_load_log_entry_id);

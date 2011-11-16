WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool FND_ATM_ATTACHMENT.log

prompt
prompt Creating table FND_ATM_ATTACHMENT
prompt ============================
prompt
whenever sqlerror continue
drop table FND_ATM_ATTACHMENT;
whenever sqlerror exit failure rollback

-- Create table
create table FND_ATM_ATTACHMENT
(
  ATTACHMENT_ID    NUMBER not null,
  SOURCE_TYPE_CODE VARCHAR2(100),
  SOURCE_PK_VALUE  VARCHAR2(100),
  CONTENT          BLOB,
  FILE_TYPE_CODE   VARCHAR2(100),
  MIME_TYPE        VARCHAR2(200),
  FILE_NAME        VARCHAR2(1000),
  FILE_SIZE        NUMBER,
  FILE_PATH        VARCHAR2(2000),
  CREATION_DATE    DATE not null,
  CREATED_BY       NUMBER not null,
  LAST_UPDATE_DATE DATE not null,
  LAST_UPDATED_BY  NUMBER not null
);

-- Create/Recreate primary, unique and foreign key constraints 
alter table FND_ATM_ATTACHMENT
  add constraint FND_ATM_ATTACHMENT_PK primary key (ATTACHMENT_ID);
-- Create/Recreate indexes 
create index FND_ATM_ATTACHMENT_N1 on FND_ATM_ATTACHMENT (SOURCE_TYPE_CODE, SOURCE_PK_VALUE);

  
spool off
exit

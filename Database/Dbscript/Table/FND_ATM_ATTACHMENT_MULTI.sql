WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool FND_ATM_ATTACHMENT_MULTI.log

prompt
prompt Creating table FND_ATM_ATTACHMENT_MULTI
prompt ============================
prompt
whenever sqlerror continue
drop table FND_ATM_ATTACHMENT_MULTI;
whenever sqlerror exit failure rollback

-- Create table
create table FND_ATM_ATTACHMENT_MULTI
(
  RECORD_ID        NUMBER not null,
  TABLE_NAME       VARCHAR2(100) not null,
  TABLE_PK_VALUE   VARCHAR2(100) not null,
  ATTACHMENT_ID    NUMBER,
  CREATION_DATE    DATE not null,
  CREATED_BY       NUMBER not null,
  LAST_UPDATE_DATE DATE not null,
  LAST_UPDATED_BY  NUMBER not null
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table FND_ATM_ATTACHMENT_MULTI
  add constraint FND_ATM_ATTACHMENT_MULTI_PK primary key (RECORD_ID);
-- Create/Recreate indexes 
create index FND_ATM_ATTACHMENT_MULTI_N1 on FND_ATM_ATTACHMENT_MULTI (TABLE_NAME, TABLE_PK_VALUE);
create index FND_ATM_ATTACHMENT_MULTI_N2 on FND_ATM_ATTACHMENT_MULTI (ATTACHMENT_ID);


spool off
exit

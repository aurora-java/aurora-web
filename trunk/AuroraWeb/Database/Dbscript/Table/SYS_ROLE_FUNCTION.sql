WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool SYS_ROLE_FUNCTION.log

prompt
prompt Creating table SYS_ROLE_FUNCTION
prompt ====================================
prompt
whenever sqlerror continue
drop table SYS_ROLE_FUNCTION;
whenever sqlerror exit failure rollback
-- Create table
create table SYS_ROLE_FUNCTION
(
  ROLE_ID          NUMBER not null,
  FUNCTION_ID      NUMBER not null,
  SEQUENCE         NUMBER,
  EXPANDED         VARCHAR2(1) not null,
  START_DATE       DATE not null,
  END_DATE         DATE,
  CREATED_BY       NUMBER not null,
  CREATION_DATE    DATE not null,
  LAST_UPDATED_BY  NUMBER not null,
  LAST_UPDATE_DATE DATE not null
);
create unique index SYS_ROLE_FUNCTION_U1 on SYS_ROLE_FUNCTION (ROLE_ID,FUNCTION_ID);
spool off
exit
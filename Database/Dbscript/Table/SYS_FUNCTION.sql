WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool SYS_FUNCTION.log

prompt
prompt Creating table SYS_FUNCTION
prompt ====================================
prompt
whenever sqlerror continue
drop table SYS_FUNCTION;
whenever sqlerror exit failure rollback
-- Create table
-- Create table
create table SYS_FUNCTION
(
  FUNCTION_ID        NUMBER not null,
  FUNCTION_CODE      VARCHAR2(100) not null,
  FUNCTION_NAME_ID   NUMBER not null,
  FUNCTION_TYPE      VARCHAR2(1) not null,
  PARENT_FUNCTION_ID NUMBER,
  MODULE_ID          NUMBER,
  DESCRIPTION_ID     NUMBER,
  ICON               VARCHAR2(100),
  SEQUENCE           NUMBER,
  SERVICE_ID         NUMBER,
  CREATION_DATE      DATE not null,
  CREATED_BY         NUMBER not null,
  LAST_UPDATE_DATE   DATE not null,
  LAST_UPDATED_BY    NUMBER not null
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_FUNCTION
  add constraint SYS_FUNCTION_PK primary key (FUNCTION_ID);
-- Create/Recreate indexes 
create unique index SYS_FUNCTION_U1 on SYS_FUNCTION (FUNCTION_CODE);
create index SYS_FUNCTION_N1 on SYS_FUNCTION (SERVICE_ID);


spool off
exit
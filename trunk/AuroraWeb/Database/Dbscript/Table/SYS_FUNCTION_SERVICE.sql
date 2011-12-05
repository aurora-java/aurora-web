WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool SYS_FUNCTION_SERVICE.log

prompt
prompt Creating table SYS_FUNCTION_SERVICE
prompt ====================================
prompt
whenever sqlerror continue
drop table SYS_FUNCTION_SERVICE;
whenever sqlerror exit failure rollback
-- Create table
-- Create table
create table SYS_FUNCTION_SERVICE
(
  function_id      NUMBER not null,
  service_id       NUMBER not null,
  creation_date    DATE not null,
  created_by       NUMBER not null,
  last_update_date DATE not null,
  last_updated_by  NUMBER not null
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_FUNCTION_SERVICE
  add constraint NSYS_FUNCTION_SERVICE_PK primary key (FUNCTION_ID, SERVICE_ID);
  

spool off
exit
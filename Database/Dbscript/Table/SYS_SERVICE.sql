WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool SYS_SERVICE.log

prompt
prompt Creating table SYS_SERVICE
prompt ====================================
prompt
whenever sqlerror continue
drop table SYS_SERVICE;
whenever sqlerror exit failure rollback
-- Create table
-- Create table
create table SYS_SERVICE
(
  service_id        NUMBER not null,
  service_name      VARCHAR2(100) not null,
  is_entry_page     NUMBER not null,
  is_access_checked NUMBER not null,
  is_login_required NUMBER not null,
  title             VARCHAR2(200),
  is_system_access  NUMBER not null,
  creation_date     DATE not null,
  last_update_date  DATE not null,
  created_by        NUMBER not null,
  last_updated_by   NUMBER not null
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_SERVICE
  add constraint SYS_SERVICE_PK primary key (SERVICE_ID);
-- Create/Recreate indexes 
create unique index SYS_SERVICE_U1 on SYS_SERVICE (SERVICE_NAME);


spool off
exit
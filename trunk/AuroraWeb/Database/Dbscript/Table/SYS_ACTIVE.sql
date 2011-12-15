spool SYS_ACTIVE.log

prompt
prompt Creating table SYS_ACTIVE
prompt ==========================
prompt

-- Create table
create table SYS_ACTIVE
(
  key_code VARCHAR2(100) not null,
  user_id  NUMBER not null
)
tablespace AURORA
  pctfree 10
  initrans 1
  maxtrans 255;
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_ACTIVE
  add constraint SYS_ACTIVE_PK primary key (KEY_CODE)
  using index 
  tablespace AURORA
  pctfree 10
  initrans 2
  maxtrans 255;
  
spool off

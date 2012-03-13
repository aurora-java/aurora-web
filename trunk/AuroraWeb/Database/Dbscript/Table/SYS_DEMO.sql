spool SYS_DEMO.log

prompt
prompt Creating table SYS_DEMO
prompt ==========================
prompt


-- Create table
create table SYS_DEMO
(
  demo_id          NUMBER not null,
  account_name     VARCHAR2(200),
  description      VARCHAR2(200),
  start_date       DATE,
  end_date         DATE,
  is_frozen        CHAR(1),
  created_by       NUMBER not null,
  creation_date    DATE not null,
  last_updated_by  NUMBER not null,
  last_update_date DATE not null,
  parent_id        NUMBER
)
tablespace AURORA
  pctfree 10
  initrans 1
  maxtrans 255;
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_DEMO
  add constraint SYS_DEMO_PK primary key (DEMO_ID)
  using index 
  tablespace AURORA
  pctfree 10
  initrans 2
  maxtrans 255;

  spool off
spool SYS_USER.log

prompt
prompt Creating table SYS_USER
prompt ==========================
prompt

-- Create table
create table SYS_USER
(
  user_id          NUMBER not null,
  user_name        VARCHAR2(100) not null,
  password         VARCHAR2(100) not null,
  last_update_date DATE not null,
  last_updated_by  NUMBER not null,
  creation_date    DATE not null,
  created_by       NUMBER not null,
  nick_name        VARCHAR2(100),
  authority        CHAR(1) not null
)
tablespace AURORA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the columns 
comment on column SYS_USER.authority
  is '权限';
-- Create/Recreate indexes 
create unique index SYS_USER_U1 on SYS_USER (USER_NAME)
  tablespace AURORA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Create/Recreate primary, unique and foreign key constraints 
alter table SYS_USER
  add constraint SYS_USER_PK primary key (USER_ID)
  using index 
  tablespace AURORA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
  
 spool off

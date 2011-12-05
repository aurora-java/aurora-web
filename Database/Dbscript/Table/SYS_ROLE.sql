WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool SYS811.log

prompt
prompt Creating table SYS_ROLE
prompt ============================
prompt
whenever sqlerror continue
drop table SYS_ROLE;
whenever sqlerror exit failure rollback

create table SYS_ROLE
(
  ROLE_ID          NUMBER not null,
  ROLE_CODE        VARCHAR2(30) not null,
  ROLE_NAME_ID     NUMBER,
  DESCRIPTION_ID   NUMBER,
  START_DATE       DATE not null,
  END_DATE         DATE,
  LAST_UPDATE_DATE DATE not null,
  LAST_UPDATED_BY  NUMBER not null,
  CREATION_DATE    DATE not null,
  CREATED_BY       NUMBER not null
);

alter table SYS_ROLE
  add constraint SYS_ROLE_PK primary key (ROLE_ID);

create unique index SYS_ROLE_U1 on SYS_ROLE (ROLE_CODE);



spool off

exit

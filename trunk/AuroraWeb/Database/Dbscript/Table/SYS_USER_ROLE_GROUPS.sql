WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool SYS_USER_ROLE_GROUPS.log

prompt
prompt Creating table SYS_USER_ROLE_GROUPS
prompt ===================================
prompt
whenever sqlerror continue
drop table SYS_USER_ROLE_GROUPS;
whenever sqlerror exit failure rollback

create table SYS_USER_ROLE_GROUPS
( 
  USER_ROLE_GROUP_ID NUMBER not null,
  USER_ID            NUMBER not null,
  ROLE_ID            NUMBER not null,
  COMPANY_ID         NUMBER ,
  START_DATE         DATE not null,
  END_DATE           DATE,
  CREATED_BY         NUMBER not null,
  CREATION_DATE      DATE not null,
  LAST_UPDATED_BY    NUMBER not null,
  LAST_UPDATE_DATE   DATE not null
);
alter table SYS_USER_ROLE_GROUPS add constraint SYS_USER_ROLE_GROUPS_PK primary key (USER_ROLE_GROUP_ID);
create unique index SYS_USER_ROLE_GROUPS_U1 on SYS_USER_ROLE_GROUPS (USER_ID,ROLE_ID,COMPANY_ID);

spool off

exit

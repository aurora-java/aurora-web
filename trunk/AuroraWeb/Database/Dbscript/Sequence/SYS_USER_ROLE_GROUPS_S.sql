WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;


spool SYS_USER_ROLE_GROUPS_S.log


prompt
prompt Creating sequence SYS_USER_ROLE_GROUPS_S
prompt ====================================
prompt
whenever sqlerror continue
drop sequence SYS_USER_ROLE_GROUPS_S;
whenever sqlerror exit failure rollback

create sequence SYS_USER_ROLE_GROUPS_S;


spool off

exit

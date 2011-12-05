WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool SYS_ROLE_S.log

prompt
prompt Creating sequence SYS_ROLE_S
prompt ============================
prompt
whenever sqlerror continue
drop sequence SYS_ROLE_S;
whenever sqlerror exit failure rollback

create sequence SYS_ROLE_S;

spool off

exit

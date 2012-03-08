WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool SYS_DEMO_S.log

prompt
prompt Creating sequence SYS_DEMO_S
prompt ============================
prompt
whenever sqlerror continue
drop sequence sys_demo_s;
whenever sqlerror exit failure rollback

create sequence sys_demo_s;

spool off

exit

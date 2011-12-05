WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;


spool sys_service_s.log

prompt
prompt Creating sequence sys_service_s
prompt =================================
prompt
whenever sqlerror continue
  drop sequence sys_service_s;
whenever sqlerror exit failure rollback
  create sequence sys_service_s;
  
spool off


exit
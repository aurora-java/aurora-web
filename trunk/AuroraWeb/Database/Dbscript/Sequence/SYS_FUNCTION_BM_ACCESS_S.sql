WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;


spool SYS_FUNCTION_BM_ACCESS_S.log

prompt
prompt Creating sequence SYS_FUNCTION_BM_ACCESS_S
prompt ================================
prompt

whenever sqlerror continue
drop sequence SYS_FUNCTION_BM_ACCESS_S;
whenever sqlerror exit failure rollback

create sequence SYS_FUNCTION_BM_ACCESS_S;


spool off


exit


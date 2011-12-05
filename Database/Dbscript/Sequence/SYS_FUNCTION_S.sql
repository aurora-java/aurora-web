WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool SYS_FUNCTION_S.log

prompt
prompt Creating sequence SYS_FUNCTION_S
prompt ============================
prompt
---create exp sequence 
whenever sqlerror continue
drop sequence SYS_FUNCTION_S;
whenever sqlerror exit failure rollback
-- Create sequence 
create sequence SYS_FUNCTION_S;
                             
spool off

exit


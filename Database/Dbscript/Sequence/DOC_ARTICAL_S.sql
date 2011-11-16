--------------------------------------------
-- Export file for user AURORA            --
-- Created by IBM on 2011-11-16, 16:05:55 --
--------------------------------------------

spool DOC_ARTICAL_S.log

prompt
prompt Creating sequence DOC_ARTICAL_S
prompt ===============================
prompt
create sequence DOC_ARTICAL_S
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;


spool off

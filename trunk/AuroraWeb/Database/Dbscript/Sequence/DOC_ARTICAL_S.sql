-------------------------------------------
-- Export file for user AURORA           --
-- Created by IBM on 2011-11-18, 9:52:26 --
-------------------------------------------

spool DOC_ARTICAL_S.log

prompt
prompt Creating sequence DOC_ARTICAL_S
prompt ===============================
prompt
create sequence DOC_ARTICAL_S
minvalue 1
maxvalue 9999999999999999999999999999
start with 61
increment by 1
cache 20;


spool off

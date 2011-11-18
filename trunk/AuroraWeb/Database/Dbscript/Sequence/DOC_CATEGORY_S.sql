-------------------------------------------
-- Export file for user AURORA           --
-- Created by IBM on 2011-11-18, 9:53:16 --
-------------------------------------------

spool DOC_CATEGORY_S.log

prompt
prompt Creating sequence DOC_CATEGORY_S
prompt ================================
prompt
create sequence DOC_CATEGORY_S
minvalue 1
maxvalue 9999999999999999999999999999
start with 21
increment by 1
cache 20;


spool off

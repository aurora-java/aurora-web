spool DOC_TAGS_S.log

prompt
prompt Creating sequence DOC_TAGS_S
prompt ===============================
prompt

-- Create sequence 
create sequence DOC_TAGS_S
minvalue 1
maxvalue 9999999999999999999999999999
start with 21
increment by 1
cache 20;


spool off
spool SYS_USER_S.log

prompt
prompt Creating sequence SYS_USER_S
prompt ===============================
prompt

create sequence SYS_USER_S
minvalue 1
maxvalue 9999999999999999999999999999
start with 41
increment by 1
cache 20;

spool off

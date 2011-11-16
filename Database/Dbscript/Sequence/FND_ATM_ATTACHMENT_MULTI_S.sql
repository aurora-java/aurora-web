WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;

spool FND_ATM_ATTACHMENT_MULTI_S.log

prompt
prompt Creating sequence FND_ATM_ATTACHMENT_MULTI_S
prompt ============================
prompt
whenever sqlerror continue
drop sequence FND_ATM_ATTACHMENT_MULTI_S;
whenever sqlerror exit failure rollback

create sequence FND_ATM_ATTACHMENT_MULTI_S;

spool off

exit

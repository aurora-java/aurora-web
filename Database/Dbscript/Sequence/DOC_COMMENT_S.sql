WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;


spool DOC_COMMENT_S.log

prompt
prompt Creating sequence DOC_COMMENT_S
prompt =================================
prompt
whenever sqlerror continue
  drop sequence DOC_COMMENT_S;
whenever sqlerror exit failure rollback
  create sequence DOC_COMMENT_S;
  

spool off


exit




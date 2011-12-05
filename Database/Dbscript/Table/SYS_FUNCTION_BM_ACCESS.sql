WHENEVER SQLERROR EXIT FAILURE ROLLBACK;
WHENEVER OSERROR  EXIT FAILURE ROLLBACK;


spool CSH_BANKS.log

prompt
prompt Creating table SYS_FUNCTION_BM_ACCESS
prompt ========================
prompt
whenever sqlerror continue
drop table SYS_FUNCTION_BM_ACCESS;
whenever sqlerror exit failure rollback

-- Create table
create table SYS_FUNCTION_BM_ACCESS
(
  ACCESS_ID        NUMBER,
  FUNCTION_ID      NUMBER not null,
  BM_NAME          VARCHAR2(100) not null,
  INSERT_OPTION    VARCHAR2(1),
  UPDATE_OPTION    VARCHAR2(1),
  QUERY_OPTION     VARCHAR2(1),
  DELETE_OPTION    VARCHAR2(1),
  EXECUTE_OPTION   VARCHAR2(1),
  CREATED_BY       NUMBER not null,
  CREATION_DATE    DATE not null,
  LAST_UPDATED_BY  NUMBER not null,
  LAST_UPDATE_DATE DATE not null
);
--CREATE INDEX
create index SYS_FUNCTION_BM_ACCESS_N1  ON SYS_FUNCTION_BM_ACCESS(FUNCTION_ID);
--CREATE INDEX
create index SYS_FUNCTION_BM_ACCESS_N2  ON SYS_FUNCTION_BM_ACCESS(BM_NAME);

--create unique index
create unique index SYS_FUNCTION_BM_ACCESS_U1 ON SYS_FUNCTION_BM_ACCESS(FUNCTION_ID,BM_NAME);

spool off

exit

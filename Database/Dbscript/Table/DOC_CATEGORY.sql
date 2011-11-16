--------------------------------------------
-- Export file for user AURORA            --
-- Created by IBM on 2011-11-16, 16:03:59 --
--------------------------------------------

spool test.log

prompt
prompt Creating table DOC_CATEGORY
prompt ===========================
prompt
create table DOC_CATEGORY
(
  CATEGORY_ID   NUMBER not null,
  CATEGORY_NAME VARCHAR2(200) not null,
  PARENT_ID     NUMBER default -1 not null,
  SEQUENCE      NUMBER default 0 not null
)
;
comment on column DOC_CATEGORY.CATEGORY_ID
  is 'ID';
comment on column DOC_CATEGORY.CATEGORY_NAME
  is '����';
comment on column DOC_CATEGORY.PARENT_ID
  is '���ڵ�';
comment on column DOC_CATEGORY.SEQUENCE
  is '˳���';


spool off

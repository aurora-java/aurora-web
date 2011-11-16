--------------------------------------------
-- Export file for user AURORA            --
-- Created by IBM on 2011-11-16, 16:03:19 --
--------------------------------------------

spool test.log

prompt
prompt Creating table DOC_ARTICAL
prompt ==========================
prompt
create table DOC_ARTICAL
(
  ARTICAL_ID       NUMBER not null,
  ARTICAL_PATH     VARCHAR2(100) not null,
  CREATED_BY       NUMBER,
  CREATION_DATE    DATE,
  LAST_UPDATED_BY  NUMBER,
  LAST_UPDATE_DATE DATE,
  ARTICAL_TITLE    VARCHAR2(100),
  CATEGORY_ID      NUMBER
)
;
comment on table DOC_ARTICAL
  is '���±�';
comment on column DOC_ARTICAL.ARTICAL_ID
  is '����ID';
comment on column DOC_ARTICAL.ARTICAL_PATH
  is '����·��';
comment on column DOC_ARTICAL.CREATED_BY
  is '������ID';
comment on column DOC_ARTICAL.CREATION_DATE
  is '��������';
comment on column DOC_ARTICAL.LAST_UPDATED_BY
  is '���������ID';
comment on column DOC_ARTICAL.LAST_UPDATE_DATE
  is '�����������';
comment on column DOC_ARTICAL.ARTICAL_TITLE
  is '���±���';
comment on column DOC_ARTICAL.CATEGORY_ID
  is '����ID';
alter table DOC_ARTICAL
  add constraint DOC_ARTICAL_PK primary key (ARTICAL_ID);
create index DOC_ARTICAL_N1 on DOC_ARTICAL (LAST_UPDATE_DATE);


spool off

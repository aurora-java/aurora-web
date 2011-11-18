-------------------------------------------
-- Export file for user HECDEV           --
-- Created by IBM on 2010/8/23, 17:32:03 --
-------------------------------------------

spool DOC_COMMENT.log

prompt
prompt Creating table DOC_COMMENT
prompt =======================
prompt
create table DOC_COMMENT
(
	COMMENT_ID					NUMBER not null,
	CONTENT						CLOB,
	TABLE_ID					NUMBER not null,
	TABLE_NAME					VARCHAR(50) not null,
	CREATED_BY					NUMBER,
	CREATION_DATE				DATE,
	LAST_UPDATED_BY				NUMBER,
	LAST_UPDATE_DATE			DATE
)
;
comment on table DOC_COMMENT
  is '���۱�';
comment on column DOC_COMMENT.COMMENT_ID
  is '����ID';
comment on column DOC_COMMENT.CONTENT
  is '��������';
comment on column DOC_COMMENT.TABLE_ID
  is '���۶����ID';
comment on column DOC_COMMENT.TABLE_NAME
  is '���۶���ı�'; 
comment on column DOC_COMMENT.CREATED_BY
  is '������ID';
comment on column DOC_COMMENT.CREATION_DATE
  is '��������';
comment on column DOC_COMMENT.LAST_UPDATED_BY
  is '��������ID';
comment on column DOC_COMMENT.LAST_UPDATE_DATE
  is '����������';

alter table DOC_COMMENT
  add constraint DOC_COMMENT_PK primary key (COMMENT_ID);

spool off
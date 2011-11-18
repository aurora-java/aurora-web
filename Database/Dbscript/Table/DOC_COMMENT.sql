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
	TABLE_NAME					VARCHAR(50),
	CREATED_BY					NUMBER,
	CREATION_DATE				DATE,
	LAST_UPDATED_BY				NUMBER,
	LAST_UPDATE_DATE			DATE
)
;
comment on table DOC_COMMENT
  is '评论表';
comment on column DOC_COMMENT.COMMENT_ID
  is '评论ID';
comment on column DOC_COMMENT.CONTENT
  is '评论内容';
comment on column DOC_COMMENT.TABLE_ID
  is '评论对象的ID';
comment on column DOC_COMMENT.TABLE_NAME
  is '评论对象的表'; 
comment on column DOC_COMMENT.CREATED_BY
  is '创建者ID';
comment on column DOC_COMMENT.CREATION_DATE
  is '创建日期';
comment on column DOC_COMMENT.LAST_UPDATED_BY
  is '最近更新者ID';
comment on column DOC_COMMENT.LAST_UPDATE_DATE
  is '最近更新日期';

alter table DOC_COMMENT
  add constraint DOC_COMMENT_PK primary key (COMMENT_ID);

spool off
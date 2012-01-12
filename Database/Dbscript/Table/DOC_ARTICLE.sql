--------------------------------------------
-- Export file for user AURORA            --
-- Created by IBM on 2011-11-18, 11:12:22 --
--------------------------------------------

spool DOC_ARTICLE.log

prompt
prompt Creating table DOC_ARTICLE
prompt ==========================
prompt
-- Create table
create table DOC_ARTICLE
(
  article_id       NUMBER not null,
  article_path     VARCHAR2(100) not null,
  created_by       NUMBER,
  creation_date    DATE,
  last_updated_by  NUMBER,
  last_update_date DATE,
  article_title    VARCHAR2(100),
  category_id      NUMBER,
  content          CLOB  
)
tablespace AURORA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
-- Add comments to the table 
comment on table DOC_ARTICLE
  is '文章表';
-- Add comments to the columns 
comment on column DOC_ARTICLE.article_id
  is '文章ID';
comment on column DOC_ARTICLE.article_path
  is '文章路径';
comment on column DOC_ARTICLE.created_by
  is '创建者ID';
comment on column DOC_ARTICLE.creation_date
  is '创建日期';
comment on column DOC_ARTICLE.last_updated_by
  is '最近更新者ID';
comment on column DOC_ARTICLE.last_update_date
  is '最近更新日期';
comment on column DOC_ARTICLE.article_title
  is '文章标题';
comment on column DOC_ARTICLE.category_id
  is '分类ID';
comment on column DOC_ARTICLE.content
  is '内容';
-- Create/Recreate indexes 
create index DOC_ARTICAL_N1 on DOC_ARTICLE (LAST_UPDATE_DATE);
-- Create/Recreate primary, unique and foreign key constraints 
alter table DOC_ARTICLE
  add constraint DOC_ARTICAL_PK primary key (ARTICLE_ID)
  using index ;



spool off

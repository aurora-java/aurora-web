--------------------------------------------
-- Export file for user AURORA            --
-- Created by IBM on 2011-11-18, 11:12:22 --
--------------------------------------------

spool DOC_ARTICLE.log

prompt
prompt Creating table DOC_ARTICLE
prompt ==========================
prompt
create table DOC_ARTICLE
(
  ARTICLE_ID       NUMBER not null,
  ARTICLE_PATH     VARCHAR2(100) not null,
  CREATED_BY       NUMBER,
  CREATION_DATE    DATE,
  LAST_UPDATED_BY  NUMBER,
  LAST_UPDATE_DATE DATE,
  ARTICLE_TITLE    VARCHAR2(100),
  CATEGORY_ID      NUMBER,
  CONTENT          CLOB
)
;
comment on table DOC_ARTICLE
  is '文章表';
comment on column DOC_ARTICLE.ARTICLE_ID
  is '文章ID';
comment on column DOC_ARTICLE.ARTICLE_PATH
  is '文章路径';
comment on column DOC_ARTICLE.CREATED_BY
  is '创建者ID';
comment on column DOC_ARTICLE.CREATION_DATE
  is '创建日期';
comment on column DOC_ARTICLE.LAST_UPDATED_BY
  is '最近更新者ID';
comment on column DOC_ARTICLE.LAST_UPDATE_DATE
  is '最近更新日期';
comment on column DOC_ARTICLE.ARTICLE_TITLE
  is '文章标题';
comment on column DOC_ARTICLE.CATEGORY_ID
  is '分类ID';
comment on column DOC_ARTICLE.CONTENT
  is '内容';
alter table DOC_ARTICLE
  add constraint DOC_ARTICAL_PK primary key (ARTICLE_ID);
create index DOC_ARTICAL_N1 on DOC_ARTICLE (LAST_UPDATE_DATE);


spool off

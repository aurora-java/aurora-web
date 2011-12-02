spool DOC_ARTICLE.log

prompt
prompt Creating table DOC_ARTICLE
prompt ==========================
prompt

-- Create table
create table DOC_NEWS
(
  news_id          NUMBER not null,
  path             VARCHAR2(200),
  title            VARCHAR2(100) not null,
  summary          CLOB,
  content          CLOB,
  created_by       NUMBER not null,
  creation_date    DATE not null,
  last_updated_by  NUMBER not null,
  last_update_date DATE not null,
  is_recommend     CHAR(1)
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
-- Create/Recreate primary, unique and foreign key constraints 
alter table DOC_NEWS
  add constraint DOC_NEWS_PK1 primary key (NEWS_ID)
  using index 
  tablespace AURORA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

spool off
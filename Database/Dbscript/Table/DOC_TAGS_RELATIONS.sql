
spool DOC_TAGS_RELATIONS.log

prompt
prompt Creating table DOC_TAGS_RELATIONS
prompt ==========================
prompt

-- Create table
create table DOC_TAGS_RELATIONS
(
  relation_id NUMBER not null,
  article_id  NUMBER not null,
  tag_id      NUMBER not null
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table DOC_TAGS_RELATIONS
  add constraint DOC_TAGS_RELATIONS_PK primary key (RELATION_ID)
  using index;
alter table DOC_TAGS_RELATIONS
  add constraint DOC_TAGS_RELATIONS_U1 unique (ARTICLE_ID, TAG_ID)
  using index;
 
spool off


spool DOC_TAGS.log

prompt
prompt Creating table DOC_TAGS
prompt ==========================
prompt

-- Create table
create table DOC_TAGS
(
  tag_id   NUMBER not null,
  tag_name VARCHAR2(100)
);
-- Create/Recreate primary, unique and foreign key constraints 
alter table DOC_TAGS
  add constraint DOC_TAGS_PK primary key (TAG_ID)
  using index;
alter table DOC_TAGS
  add constraint DOC_TAGS_U1 unique (TAG_NAME)
  using index;


spool off
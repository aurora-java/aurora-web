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
  is '标题';
comment on column DOC_CATEGORY.PARENT_ID
  is '父节点';
comment on column DOC_CATEGORY.SEQUENCE
  is '顺序号';


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
  is '文章表';
comment on column DOC_ARTICAL.ARTICAL_ID
  is '文章ID';
comment on column DOC_ARTICAL.ARTICAL_PATH
  is '文章路径';
comment on column DOC_ARTICAL.CREATED_BY
  is '创建者ID';
comment on column DOC_ARTICAL.CREATION_DATE
  is '创建日期';
comment on column DOC_ARTICAL.LAST_UPDATED_BY
  is '最近更新者ID';
comment on column DOC_ARTICAL.LAST_UPDATE_DATE
  is '最近更新日期';
comment on column DOC_ARTICAL.ARTICAL_TITLE
  is '文章标题';
comment on column DOC_ARTICAL.CATEGORY_ID
  is '分类ID';
alter table DOC_ARTICAL
  add constraint DOC_ARTICAL_PK primary key (ARTICAL_ID);
create index DOC_ARTICAL_N1 on DOC_ARTICAL (LAST_UPDATE_DATE);


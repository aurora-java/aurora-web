create or replace package article_pkg is

  -- Author  : huangshengbo
  -- Created : 2011-12-1 16:30
  -- Purpose : 对文章增删改

  --删除
  procedure delete_article(p_article_id number);

  --新建
  procedure create_article(p_article_path  varchar,
                           p_article_title varchar,
                           p_category_id   number,
                           p_content       varchar,
                           p_user_id       number,
                           p_tag_name      varchar);

  --更新
  procedure update_article(p_article_id    number,
                           p_article_title varchar,
                           p_category_id   number,
                           p_content       varchar,
                           p_user_id       number,
                           p_tag_name      varchar);

end article_pkg;
/
create or replace package body article_pkg is

  --************************************************************
  --新建
  -- parameter :
  -- p_article_path  文章路径
  -- p_article_title 文章标题
  -- p_category_id   文章目录
  -- p_content       文章内容
  -- p_user_id       用户id
  -- p_tag_name      文章标签
  --************************************************************
  procedure create_article(p_article_path  varchar,
                           p_article_title varchar,
                           p_category_id   number,
                           p_content       varchar,
                           p_user_id       number,
                           p_tag_name      varchar) is
    v_tag_id     number;
    v_article_id number;
    v_tag_name   varchar2(100);
    v_index      number;
    v_str        varchar2(500) := p_tag_name;
  begin
    v_article_id := doc_article_s.nextval;
    insert into doc_article
      (article_id,
       article_path,
       article_title,
       category_id,
       content,
       created_by,
       creation_date,
       last_updated_by,
       last_update_date)
    values
      (v_article_id,
       p_article_path,
       p_article_title,
       p_category_id,
       p_content,
       p_user_id,
       sysdate,
       p_user_id,
       sysdate);
    if v_str is not null then
      while instr(v_str, ',', 1, 1) > 0 loop
        v_index    := instr(v_str, ',', 1, 1);
        v_tag_name := substr(v_str, 1, v_index - 1);
        v_str      := substr(v_str, v_index + 1, length(v_str) - v_index);
        begin
          select t.tag_id
            into v_tag_id
            from doc_tags t
           where t.tag_name = LOWER(v_tag_name);
        exception
          when no_data_found then
            v_tag_id := doc_tags_s.nextval;
            insert into doc_tags
              (tag_id, tag_name)
            values
              (v_tag_id, LOWER(v_tag_name));
        end;
        insert into doc_tags_relations
          (relation_id, article_id, tag_id)
        values
          (doc_tags_relations_s.nextval, v_article_id, v_tag_id);
      end loop;
    end if;
  exception
    when others then
      rollback;
  end;

  --************************************************************
  --更新
  -- parameter :
  -- p_article_id    文章id
  -- p_article_title 文章标题
  -- p_category_id   文章目录
  -- p_content       文章内容
  -- p_user_id       用户id
  -- p_tag_name      文章标签
  --************************************************************
  procedure update_article(p_article_id    number,
                           p_article_title varchar,
                           p_category_id   number,
                           p_content       varchar,
                           p_user_id       number,
                           p_tag_name      varchar) is
    v_tag_id   number;
    v_tag_name varchar2(100);
    v_index    number;
    v_str      varchar2(500) := p_tag_name;
  begin
    update doc_article t
       set t.article_title    = p_article_title,
           t.category_id      = p_category_id,
           t.content          = p_content,
           t.last_updated_by  = p_user_id,
           t.last_update_date = sysdate
     where t.article_id = p_article_id;
    delete from doc_tags_relations t where t.article_id = p_article_id;
    if v_str is not null then
      while instr(v_str, ',', 1, 1) > 0 loop
        v_index    := instr(v_str, ',', 1, 1);
        v_tag_name := substr(v_str, 1, v_index - 1);
        v_str      := substr(v_str, v_index + 1, length(v_str) - v_index);
        begin
          select t.tag_id
            into v_tag_id
            from doc_tags t
           where t.tag_name = LOWER(v_tag_name);
        exception
          when no_data_found then
            v_tag_id := doc_tags_s.nextval;
            insert into doc_tags
              (tag_id, tag_name)
            values
              (v_tag_id, LOWER(v_tag_name));
        end;
        insert into doc_tags_relations
          (relation_id, article_id, tag_id)
        values
          (doc_tags_relations_s.nextval, p_article_id, v_tag_id);
      end loop;
    end if;
  exception
    when others then
      rollback;
  end;

  --************************************************************
  --删除
  -- parameter :
  -- p_article_id  文章id  
  --************************************************************
  procedure delete_article(p_article_id number) is
  begin
    for att in (select atm.attachment_id
                  from fnd_atm_attachment_multi atm
                 where atm.table_pk_value = p_article_id) loop
      delete from fnd_atm_attachment at
       where at.attachment_id = att.attachment_id;
    end loop;
    delete from fnd_atm_attachment_multi atm
     where atm.table_pk_value = p_article_id;
    delete from doc_comment c where c.table_id = p_article_id;
    delete from doc_article a where a.article_id = p_article_id;
    delete from doc_tags_relations d where d.article_id = p_article_id;
  end;

end article_pkg;
/

create or replace package article_pkg is

  -- Author  : huangshengbo
  -- Created : 2011-12-1 16:30
  -- Purpose : 系统登录

  --删除
  procedure delete_article(p_article_id number);

end article_pkg;
/
create or replace package body article_pkg is

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
  end;
end article_pkg;
/

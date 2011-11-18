--------------------------------------------
-- Export file for user AURORA            --
-- Created by IBM on 2011-11-18, 11:16:27 --
--------------------------------------------

spool DOC_ARTICLE_V.log

prompt
prompt Creating view DOC_ARTICLE_V
prompt ===========================
prompt
create or replace view doc_article_v as
select a.article_id,
       a.article_title,
       a.category_id,
       a.creation_date,
       a.last_update_date,
       u.user_id,
       nvl(u.nick_name,u.user_name) nick_name
  from doc_article a, sys_user u
 where a.created_by = u.user_id(+) order by a.last_update_date desc;


spool off

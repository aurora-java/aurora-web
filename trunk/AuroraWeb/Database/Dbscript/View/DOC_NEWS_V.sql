spool DOC_ARTICLE_V.log

prompt
prompt Creating view DOC_ARTICLE_V
prompt ===========================
prompt

create or replace view doc_news_v as
select a.news_id,
       a.title,
       a.summary,
       a.content,
       a.creation_date,
       a.is_recommend,
       u.user_id,
       nvl(u.nick_name,u.user_name) nick_name
  from doc_news a, sys_user u
 where a.created_by = u.user_id(+) order by a.last_update_date desc;

spool off
spool SYS_USER_V.log

prompt
prompt Creating view SYS_USER_V
prompt ===========================
prompt

create or replace view sys_user_v as
select u.user_id, u.user_name, u.nick_name, decode(r.role_code,'ADMIN','Y','N') as role_code
  from sys_user u, sys_user_role_groups g, sys_role r
 where u.user_id = g.user_id(+)
   and g.role_id = r.role_id(+)
 order by u.creation_date desc;
 
 spool off

create or replace package sys_login_pkg is

  -- Author  : huangshengbo
  -- Created : 2011-11-18 14:30
  -- Purpose : 系统登录

  --md5加密
  function md5(p_password in varchar2) return varchar2;

  --用户注册
  procedure register(p_user_name varchar,
                     p_password  varchar,
                     p_nick_name varchar,
                     p_user_id   out number,
                     p_success   out number);

  --用户登录
  procedure login(p_user_name varchar,
                  p_password  varchar,
                  p_user_id   out number,
                  p_nick_name out varchar,
                  p_role_id   out number,
                  p_role_code out varchar,
                  p_success   out number);

  --修改密码
  procedure changePassword(p_password_old varchar,
                           p_password_new varchar,
                           p_user_id      number,
                           p_success      out number);

  --修改权限
  procedure changeAuthority(p_role_code varchar,
                            p_user_id   number,
                            p_success   out number);

end sys_login_pkg;
/
create or replace package body sys_login_pkg is

  --************************************************************
  --MD5密码转换
  -- parameter :
  -- p_password  原密码
  -- return    :
  -- md5后的密码
  --************************************************************

  function md5(p_password in varchar2) return varchar2 is
    retval varchar2(32);
  begin
    retval := utl_raw.cast_to_raw(dbms_obfuscation_toolkit.md5(input_string => p_password));
    return retval;
  end md5;

  --************************************************************
  --用户注册
  -- parameter :
  -- p_user_name  用户名
  -- p_password   密码
  -- p_nick_name  昵称
  -- p_success    是否成功
  --************************************************************
  procedure register(p_user_name varchar,
                     p_password  varchar,
                     p_nick_name varchar,
                     p_user_id   out number,
                     p_success   out number) is
    v_count number;
  begin
    select count(*)
      into v_count
      from sys_user u
     where u.user_name = p_user_name;
    if (v_count > 0) then
      p_success := 0;
      return;
    end if;
    p_user_id := sys_user_s.nextval;
    insert into sys_user
      (user_id,
       user_name,
       password,
       last_update_date,
       last_updated_by,
       creation_date,
       created_by,
       nick_name)
    values
      (p_user_id,
       p_user_name,
       md5(p_password => p_password),
       sysdate,
       p_user_id,
       sysdate,
       p_user_id,
       p_nick_name);
    p_success := 1;
  end;

  --************************************************************
  -- 用户登录
  -- parameter :
  -- p_user_name  用户名
  -- p_password   密码
  -- p_user_id    用户编号
  -- p_nick_name  昵称
  -- p_success    是否成功
  --************************************************************
  procedure login(p_user_name varchar,
                  p_password  varchar,
                  p_user_id   out number,
                  p_nick_name out varchar,
                  p_role_id   out number,
                  p_role_code out varchar,
                  p_success   out number) is
  begin
    p_success := -1;
    p_role_id := -1;
    select u.user_id, u.nick_name
      into p_user_id, p_nick_name
      from sys_user u
     where u.user_name = p_user_name
       and u.password = md5(p_password => p_password);
    p_success := 1;
    select g.role_id, r.role_code
      into p_role_id, p_role_code
      from sys_user_role_groups g, sys_role r
     where g.role_id = r.role_id
       and g.user_id = p_user_id
       and rownum = 1;
  exception
    when no_data_found then
      null;
  end;

  --************************************************************
  -- 修改密码
  -- parameter :
  -- p_password_old  原密码
  -- p_password_new  新密码
  -- p_user_id    用户编号  
  -- p_success    是否成功
  --************************************************************
  procedure changePassword(p_password_old varchar,
                           p_password_new varchar,
                           p_user_id      number,
                           p_success      out number) is
    v_count number;
  begin
    select count(*)
      into v_count
      from sys_user u
     where u.user_id = p_user_id
       and u.password = md5(p_password => p_password_old);
    if (v_count = 0) then
      p_success := 0;
      return;
    end if;
    update sys_user u
       set u.password = md5(p_password => p_password_new)
     where u.user_id = p_user_id;
    p_success := 1;
  exception
    when no_data_found then
      p_success := 0;
  end;

  --************************************************************
  -- 修改权限
  -- parameter :
  -- p_role_code  角色 
  -- p_user_id    用户编号  
  -- p_success    是否成功
  --************************************************************
  procedure changeAuthority(p_role_code varchar,
                            p_user_id   number,
                            p_success   out number) is
    v_role_id number;
  begin
    select r.role_id
      into v_role_id
      from sys_role r
     where r.role_code = 'ADMIN';
    if (p_role_code = 'Y') then
      insert into sys_user_role_groups
        (user_role_group_id,
         user_id,
         role_id,
         company_id,
         start_date,
         end_date,
         created_by,
         creation_date,
         last_updated_by,
         last_update_date)
      values
        (sys_user_role_groups_s.nextval,
         p_user_id,
         v_role_id,
         1,
         sysdate,
         null,
         p_user_id,
         sysdate,
         p_user_id,
         sysdate);
    else
      delete from sys_user_role_groups g where g.user_id = p_user_id;
    end if;
    p_success := 1;
  exception
    when no_data_found then
      p_success := 0;
  end;

end sys_login_pkg;
/

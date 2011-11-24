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
                  p_authority out varchar,
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
       nick_name,
       is_admin)
    values
      (p_user_id,
       p_user_name,
       md5(p_password => p_password),
       sysdate,
       p_user_id,
       sysdate,
       p_user_id,
       p_nick_name,
       'N');
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
                  p_authority out varchar,
                  p_success   out number) is
  begin
    select u.user_id, u.nick_name, u.is_admin
      into p_user_id, p_nick_name, p_authority
      from sys_user u
     where u.user_name = p_user_name
       and u.password = md5(p_password => p_password);
    p_success := 1;
  exception
    when no_data_found then
      p_success := 0;
  end;

end sys_login_pkg;
/

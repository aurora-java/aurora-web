create or replace package sys_login_pkg is

  -- Author  : huangshengbo
  -- Created : 2011-11-18 14:30
  -- Purpose : ϵͳ��¼

  --md5����
  function md5(p_password in varchar2) return varchar2;

  --�û�ע��
  procedure register(p_user_name varchar,
                     p_password  varchar,
                     p_nick_name varchar,
                     p_success   out number);

end sys_login_pkg;
/
create or replace package body sys_login_pkg is

  --************************************************************
  --MD5����ת��
  -- parameter :
  -- p_password  ԭ����
  -- return    :
  -- md5�������
  --************************************************************

  function md5(p_password in varchar2) return varchar2 is
    retval varchar2(32);
  begin
    retval := utl_raw.cast_to_raw(dbms_obfuscation_toolkit.md5(input_string => p_password));
    return retval;
  end md5;

  --************************************************************
  --�û�ע��
  -- parameter :
  -- p_user_name  �û���
  -- p_password   ����
  -- p_nick_name  �ǳ�
  --************************************************************
  procedure register(p_user_name varchar,
                     p_password  varchar,
                     p_nick_name varchar,
                     p_success   out number) is
    v_user_id number;
    v_count   number;
  begin
    select count(*)
      into v_count
      from sys_user u
     where u.user_name = p_user_name;
    if (v_count > 0) then
      p_success := 0;
      return;
    end if;
    v_user_id := sys_user_s.nextval;
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
      (v_user_id,
       p_user_name,
       md5(p_password => p_password),
       sysdate,
       v_user_id,
       sysdate,
       v_user_id,
       p_nick_name);
    p_success := 1;
  end;

end sys_login_pkg;
/

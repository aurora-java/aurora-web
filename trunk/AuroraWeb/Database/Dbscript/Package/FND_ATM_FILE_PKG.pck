create or replace package fnd_fileupload is


  function get_attachment_id(p_source_type varchar2,
                             p_pkvalue     varchar2,
                             p_user_id     number) return number;

  procedure set_attachment_file(p_record_id number,
                                p_file_name varchar2,
                                p_type_code out varchar2);


  /* 多附件上传版本 根据源表类型、PK值，获取fnd_atm_attachment_multi.record_id */
  function get_multi_attachment_id(p_source_type      varchar2,
                                   p_source_record_id varchar2,
                                   p_user_id          number) return number;


end fnd_fileupload;
/
create or replace package body fnd_fileupload is

  function get_attachment_id(p_source_type varchar2,
                             p_pkvalue     varchar2,
                             p_user_id     number) return number is
    v_attachment_id number;
  begin
    select a.attachment_id
      into v_attachment_id
      from fnd_atm_attachment a
     where a.source_pk_value = p_pkvalue
       and a.source_type_code = p_source_type;
    update fnd_atm_attachment a
       set a.content = empty_blob()
     where a.attachment_id = v_attachment_id;
    return v_attachment_id;
  exception
    when no_data_found then
      insert into fnd_atm_attachment
        (attachment_id,
         source_type_code,
         source_pk_value,
         creation_date,
         created_by,
         last_update_date,
         last_updated_by)
      values
        (fnd_atm_attachment_s.nextval,
         p_source_type,
         p_pkvalue,
         sysdate,
         p_user_id,
         sysdate,
         p_user_id)
      returning attachment_id into v_attachment_id;
      return v_attachment_id;
  end;

  procedure set_attachment_file(p_record_id number,
                                p_file_name varchar2,
                                p_type_code out varchar2) is
    v_ext varchar2(300);
  begin
    v_ext := substr(lower(p_file_name), instr(p_file_name, '.', -1) + 1);
    begin
      update fnd_atm_attachment a
         set a.last_update_date = sysdate,
             a.file_name        = p_file_name,
             (                 a.file_type_code, a.mime_type) = (select t.file_type_code,
                                                                        t.mine_type
                                                                   from fnd_atm_file_type t
                                                                  where t.file_extension =
                                                                        v_ext)
       where a.attachment_id = p_record_id
      returning file_type_code into p_type_code;
    exception
      when no_data_found then
        return;
    end;
  end;

  

  /* 多附件上传版本 根据源表类型、PK值，获取fnd_atm_attachment_multi.record_id */
  function get_multi_attachment_id(p_source_type      varchar2,
                                   p_source_record_id varchar2,
                                   p_user_id          number) return number is
    v_id number;
  begin
    delete from fnd_atm_attachment_multi m
     where m.table_name = p_source_type
       and m.table_pk_value = p_source_record_id
       and m.attachment_id is null
        or m.attachment_id = 0;

    insert into fnd_atm_attachment_multi
      (record_id,
       table_name,
       table_pk_value,
       creation_date,
       created_by,
       last_update_date,
       last_updated_by)
    values
      (fnd_atm_attachment_multi_s.nextval,
       p_source_type,
       p_source_record_id,
       sysdate,
       p_user_id,
       sysdate,
       p_user_id)
    returning record_id into v_id;

    return v_id;
  end;


end fnd_fileupload;
/

PL/SQL Developer Test script 3.0
42
declare
  pCnt integer;
begin
  -- удаление таблиц system.balance_log, system.balance, system.payment, system.expense, system.client и пакета system.pkgclient
  begin
    select count(*) into pCnt from dba_procedures where object_type = 'PACKAGE' and object_name = 'PKGCLIENT' and subprogram_id = 0;
    if pCnt = 1 then
      execute immediate 'drop package system.pkgclient';
      dbms_output.put_line('Пакет system.pkgclient удален.');
    end if;

    select count(*) into pCnt from all_tables where table_name = 'BALANCE_LOG' and owner = 'SYSTEM';
    if pCnt = 1 then
      execute immediate 'drop table system.balance_log';
      dbms_output.put_line('Таблица system.balance_log удалена.');
    end if;

    select count(*) into pCnt from all_tables where table_name = 'BALANCE' and owner = 'SYSTEM';
    if pCnt = 1 then
      execute immediate 'drop table system.balance';
      dbms_output.put_line('Таблица system.balance удалена.');
    end if;

    select count(*) into pCnt from all_tables where table_name = 'PAYMENT' and owner = 'SYSTEM';
    if pCnt = 1 then
      execute immediate 'drop table system.payment';
      dbms_output.put_line('Таблица system.payment удалена.');
    end if;

    select count(*) into pCnt from all_tables where table_name = 'EXPENSE' and owner = 'SYSTEM';
    if pCnt = 1 then
      execute immediate 'drop table system.expense';
      dbms_output.put_line('Таблица system.expense удалена.');
    end if;

    select count(*) into pCnt from all_tables where table_name = 'CLIENT' and owner = 'SYSTEM';
    if pCnt = 1 then
      execute immediate 'drop table system.client';
      dbms_output.put_line('Таблица system.client удалена.');
    end if;
  end;
end;
0
0

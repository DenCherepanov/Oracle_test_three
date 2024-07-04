PL/SQL Developer Test script 3.0
122
declare
  -- объявление необходимых для тестирования переменных
  vClient       system.client%rowtype;
  vBalance_Log  system.balance_log%rowtype;
  vBalance      system.balance%rowtype;
  vPayment      system.payment%rowtype;
  vExpense      system.expense%rowtype;
  vCntRow       number;
  vCountOper    number := 20;
  i             number := 1;
  vTypeOper     number;
  vKindOper     number;
  vSumOper      number;
  vRef          sys_refcursor;
  type tHistory is record (
    kind_oper   varchar2(50),
    type_oper   varchar2(50),
    sum_oper    number,
    date_oper   date);
  vRowHist      tHistory;
begin
  dbms_output.put_line('Добавление нового клиента: ' || vClient.first_name || ' ' || vClient.last_name);

  -- Добавление клиента
  vClient.first_name := 'Денис';
  vClient.last_name  := 'Черепанов';

  -- Посмотрим, может такой клиент уже есть в БД
  select count(1)
    into vCntRow
    from system.client t
   where t.first_name = vClient.first_name
     and t.last_name  = vClient.last_name;

  -- Если такого клиента нет, добавим его и проведем инициализацию баланса
  if vCntRow = 0 then
    vClient.id := seq_id.nextval;
    system.pkgclient.add_client(vClient);

    dbms_output.put_line('Клиент "' || vClient.first_name || ' ' || vClient.last_name || '" успешно добавлен в БД.');

    -- Заполнение данных
    vBalance.id          := seq_id.nextval;
    vBalance.id_client   := vClient.id;
    vBalance.balance_sum := 200;
    vBalance.update_date := sysdate;

    -- Инициализация баланса
    pkgclient.init_balance(vBalance);
  else
    -- Найдем ИД клиента
    select t.id
      into vClient.id
      from system.client t
     where t.first_name = vClient.first_name
       and t.last_name = vClient.last_name;
     -- Найдем баланс
    select t.*
      into vBalance
      from system.balance t
     where t.id_client = vClient.id;

    dbms_output.put_line('Клиент "' || vClient.first_name || ' ' || vClient.last_name || '" уже есть в БД.');
  end if;

  -- Эмуляция операций
  while i <= vCountOper
  loop
    dbms_lock.sleep(1);
    -- Каждую 5ую операцию будем обновлять баланс
    if mod(i, 5) = 0 then
      -- Обновим баланс
      system.pkgclient.upd_balance(vBalance.id);
      -- Получим баланс
      dbms_output.put_line('Текущий баланс: ' || system.pkgclient.get_balance(vClient.id));
    -- Добавление операции
    else
      -- Вид операции, 1 - платеж, 2 - расход
      select round(dbms_random.value(1, 2))
        into vKindOper
        from dual;
      -- Тип операции (в зависимости от вида операции)
      select round(dbms_random.value(1, 3))
        into vTypeOper
        from dual;
      -- Сумма операции
      select round(dbms_random.value(1, 100))
        into vSumOper
        from dual;

      if vKindOper = 1 then
        vPayment.id           := seq_id.nextval;
        vPayment.id_client    := vClient.id;
        vPayment.payment_type := vTypeOper;
        vPayment.payment_sum  := vSumOper;
        vPayment.payment_date := sysdate;

        system.pkgclient.add_payment(vPayment, vBalance.id);
      else
        vExpense.id           := seq_id.nextval;
        vExpense.id_client    := vClient.id;
        vExpense.expense_type := vTypeOper;
        vExpense.expense_sum  := vSumOper;
        vExpense.expense_date := sysdate;

        system.pkgclient.add_expense(vExpense, vBalance.id);
      end if;
    end if;
    i := i + 1;
  end loop;

  -- Выведем историю изменения баланса
  dbms_output.put_line('История изменения баланса:');
  vRef := system.pkgclient.get_history_balance(vBalance.id);
    loop
    fetch vRef into vRowHist;
    exit when vRef%notfound;
    dbms_output.put_line(lpad(to_char(vRowHist.kind_oper), 15) || lpad(to_char(vRowHist.type_oper), 15) ||
                         lpad(to_char(vRowHist.sum_oper), 15) || lpad(to_char(vRowHist.date_oper, 'DD/MM/YYYY HH24:MI:SS'), 25));
  end loop;
  close vRef;
end;
0
2
vRowHist.kind_oper

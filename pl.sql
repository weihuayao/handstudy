declare
  message varchar2(20) := 'hello world!';
begin
  dbms_output.put_line(message);
  -- dbms_output.put(message);
end;
---------------------------
declare 
  subtype name is char(20);           --
  subtype message is varchar2(100);
  salutation name;   
  getting message;
begin 
  salutation := 'reader';
  getting :='welcome to hand!'   ;
  dbms_output.put_line(salutation||getting);
end;      
--NULL值表示缺少或未知的数据，它不是一个整数，字符，或任何其他特定的数据类型。
--需要注意的是NULL不是一样的空数据串或空字符值''。
--NULL可以被分配，但它不能与任何东西等同，包括其本身
  DECLARE
   -- Global variables 
   num1 number := 95; 
   num2 number := 85; 
BEGIN 
   dbms_output.put_line('Outer Variable num1: ' || num1);
   dbms_output.put_line('Outer Variable num2: ' || num2);
   DECLARE 
      -- Local variables
      num1 number := 195; 
      num2 number := 185; 
   BEGIN 
      dbms_output.put_line('Inner Variable num1: ' || num1);
      dbms_output.put_line('Inner Variable num2: ' || num2);
   END; 
END;

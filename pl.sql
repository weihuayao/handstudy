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
--NULLֵ��ʾȱ�ٻ�δ֪�����ݣ�������һ���������ַ������κ������ض����������͡�
--��Ҫע�����NULL����һ���Ŀ����ݴ�����ַ�ֵ''��
--NULL���Ա����䣬�����������κζ�����ͬ�������䱾��
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

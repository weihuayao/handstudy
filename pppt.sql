
-----13. Create a PL/SQL block to promote clerks who earn more than 3,000 to the job title SR CLERK 
--and increase their salary by 10%. Use the EMP table for this practice. 
--Verify the results by querying on the EMP table. Hint: Use a cursor with FOR UPDATE and CURRENT OF syntax

select * from employees
declare 
  cursor emp_cur is
         select empno,job,sal
         from emp
         where sal > 3000 ;
  v_empno number;
  v_job varchar2(20);
  v_sal number;
begin
  open emp_cur;
  loop
    fetch emp_cur into v_empno,v_job,v_sal;
    exit when emp_cur%notfound;
    update emp set job = 'SRCLERK',sal = sal*1.1 where empno = v_empno;
  end loop;
  close emp_cur;
end;

---14 a. For the exercise below, you will require a table to store the results. You can create the 
--ANALYSIS table yourself or run the labAp_14a.sql script that creates the table for you. 
--Create a table called ANALYSIS with the following three columns:

--Create a PL/SQL block to populate the ANALYSIS table with the information from the EMPLOYEES table. 
--Use an iSQL*Plus substitution variable to store an employee��s last name. 

--Query the EMPLOYEES table to find if the number of years that the employee has been 
--with the organization is greater than five, and if the salary is less than 3,500, raise an exception. 
--Handle the exception with an appropriate exception handler that inserts the following values 
--into the ANALYSIS table: employee last name, number of years of service, and the current salary. 
--Otherwise display Not due for a raise in the window. Verify the results by querying the ANALYSIS table.
-- Use the following test cases to test the PL/SQL block:
select  *  from analysis
create table Analysis(
       ename varchar2(20),
       years number(2),
       sal  number(8,2)
       )
declare
  exc_1 exception;
  v_name  varchar2(20) := '&name';
  v_years number;
  v_sal   number;
--select * from  employees
begin
  select last_name,trunc(months_between(sysdate, hire_date)/12), salary
    into v_name, v_years, v_sal
    from employees
   where last_name = v_name;

  if v_years > 5 and v_sal < 3500 then
    RAISE exc_1;
  else
    dbms_output.put_line('not due for a raise');
  end if;
 
  exception
    when exc_1 then 
      insert into ANALYSIS(ename,year,sal)
      values (v_name, v_years, v_sal);
      dbms_output.put_line('due for a raise');
end;

---.15   In this practice, create a program to add a new job into the JOBS table.
--a.	Create a stored procedure called ADD_JOBS to enter a new order into the JOBS table. 
--	The procedure should accept three parameters. The first and second parameters supplies a job ID and a job title. The third parameter supplies the minimum salary. Use the maximum salary for the new job as twice the minimum salary supplied for the job ID. 
--b.	Disable the trigger SECURE_EMPLOYEES before invoking the procedure. Invoke the procedure to add a new job with job ID SY_ANAL, job title System Analyst, and minimum salary of 6,000.
--c.	Verify that a row was added and remember the new job ID for use in the next exercise.
--     Commit the changes.
--15 ���������ϰ�У�����һ�����������µĹ�����JOBS����
--a.����һ��ADD_JOBS�洢�����������µ����JOBS���
-- �������Ӧ�ý��������������ֱ���JOB_ID�� JOB_TITLE��min_salary��ÿ�����Ϊ��С���ʵ�������
--b.�ڵ��ù���ǰ��SECURE_EMPLOYEES������ʧЧ�����ù�������������Ϣ
--SY_ANAL   System Analyst   6,000   12000
--c.�˶���һ�����ӵ����ݽ����Ϊ����һ����ϰ��סjob_id���ύ���̡�
CREATE PROCEDURE ADD_JOBS(P_JOB_ID VARCHAR2,
                          P_JOB_TITLE VARCHAR2,
                          P_MIN_SALARY NUMBER) IS
BEGIN
  INSERT INTO JOBS VALUES(P_JOB_ID,P_JOB_TITLE,P_MIN_SALARY,P_MIN_SALARY*2);
  DBMS_OUTPUT.put_line('INSERT SUCCESS!');
  END ADD_JOBS;

DECLARE
V_JOB_ID JOBS.JOB_ID%TYPE:=&P_JOB_ID;
V_JOB_TITLE JOBS.JOB_TITLE%TYPE:=&P_JOB_TITLE;
V_MIN_SALARY JOBS.MIN_SALARY%TYPE:=&P_MIN_SALARY;


BEGIN
  ADD_JOBS(V_JOB_ID,V_JOB_TITLE,V_MIN_SALARY);
  END;

create table jobs_temp(
       job_id varchar2(20),
       job_title varchar2(20),
       minsal number,
       maxsal number
)

create or replace  


--16
/*ע��:�ڵ��õ�b�����еĹ���֮ǰ������employee��JOBS��JOB_HISTORY���ϵ����д�������
a.����һ����ΪADD_JOB_HIST�Ĵ洢���̣��Ա�Ϊ����ҵ����Ϊ��������15b
�д���������ҵID��Ա����JOB_HISTORY�����������С�
ʹ�����ڸ�����ҵ��Ա����Ա��ID�͸�Ա�����¹���ID��Ϊ������
��EMPLOYEES���л�ȡ���Ա��ID��Ӧ���У����������JOB_HISTORY����
����Ա���Ĺ�Ӷ������ΪJOB_HISTORY������һ�еĿ�ʼ���ںͽ����������Ϊ�������ڡ�
��EMPLOYEES���и�Ա���Ĺ�Ӷ���ڸ���Ϊ���졣
����Ա���Ĺ���ID����Ϊ��Ϊ�������ݵĹ���ID(ʹ������15b�д����Ĺ����Ĺ���ID)��
���ʵ��ڸù���ID + 500����͹��ʡ�
�����쳣�������������벻���ڵĹ�Ա�ĳ��ԡ�
b.���ô�����(��������⿪ͷ��˵��)��
��Ա��ID 106����ҵID SY_ANAL��Ϊ����ִ�й��̡�
���������õĴ�������
c.��ѯ���Բ鿴���ģ�Ȼ���ύ����*/

--teacher
create or replace procedure add_job_hist(p_empno      employees.employee_id%type,
                                         p_new_job_no employees.job_id%type) as
  v_hire_date employees.hire_date%type;
  v_oldjobid  employees.job_id%type;
  v_olddept   employees.department_id%type;
  v_salary    employees.salary%type;
  v_emp_id    employees.employee_id%type;
  --cursor for update ����
  --if(�жϲ���Ϊ��)
  --open cursor
begin
  select emp.employee_id, emp.hire_date, emp.job_id, emp.department_id
    into v_emp_id, v_hire_date, v_oldjobid, v_olddept
    from employees emp
   where emp.employee_id = p_empno
     for update nowait;
exception
  when others then
    v_hire_date := null;
    v_oldjobid  := null;
    v_olddept   := null;
    v_emp_id    := null;
    dbms_output.put_line(sqlerrm);
end;

savepoint begin_trxn;

if v_emp_id is
not null then

select min_salary + 500 into v_salary from jobs where job_id = p_newjobno;

insert into job_history values(p_empno, v_hire_date, sysdate, v_oldjobid, v_olddept);

update employees set hire_date = sysdate, job_id = p_newjobno, salary = v_salary where employee_id = p_empno; dbms_output.put_line('success');

commit;
end if;
exception
when others then rollback all; dbms_output.put_line(sqlerrm); dbms_output.put_line('fail');
end add_job_hist;
  --17 ����һ�����򣬸���JOBS������С�������
  --a.����һ���洢����UPD_SAL������JOBS��һ���ض�job_id����С���ʺ�����ʣ�    
  --�����������������̣�������ţ�����С���ʣ�������ʡ��������⴦����Ч�ĵĹ�����š�
  --��Ȼ���������С����С���ʣ��׳�һ�����⡣���jobs�������ݱ��������޷��ı����ڴ�������ʾ���ʵ���Ϣ��
  create or replace procedure upd_sal(p_job_id  varchar2,
                                      p_min_sal number,
                                      p_max_sal number) is
  vexception;_ex 
  v_is_jobid jobs.job_id%type;
  cursor job_cur is
    select job_id from jobs where job_id = p_job_id for update nowait;
begin
  --�����п�
  open job_cur;
  fetch job_cur
    into v_is_jobid;
  if v_is_jobid is not null then
    if p_min_sal > p_max_sal then
      raise v_ex;
    end if;
    update jobs
       set min_salary = p_min_sal, max_salary = p_max_sal
     where job_id = p_job_id;
    commit;
    dbms_output.put_line('SUCCESS');
  else
    raise no_data_found;
  end if;
  close job_cur;
exception
  when no_data_found then
    if job_cur%isopen then
      close job_cur;
    end if;
    rollback;
    dbms_output.put_line('SORRY,NO DATA FOUND');
  when v_ex then
    if job_cur%isopen then
      close job_cur;
    end if;
    rollback;
    dbms_output.put_line('SORRY,THE MIN SALARY SHOULD LOWER THAN MAX SALARY');
  when others then
    if job_cur%isopen then
      close job_cur;
    end if;
    rollback;
    --DO SOMETHING...
end upd_sal;

declare
  v_job_id     jobs.job_id%type := &p_job_id;
  v_min_salary number := &p_min_salary;
  v_max_salary number := &p_max_salary;
begin
  upd_sal(v_job_id, v_min_salary, v_max_salary);
end;
18
/*
a.ͨ��ִ������������EMPLOYEES������һ��:(labaddA_18.sql)
дһ����ΪCHECK_AVG_SAL�Ĵ洢���̡��⽫���JOBS����ÿ��Ա��
��ƽ������������EMPLOYEES���и�Ա���Ĺ��ʣ����ڸ�Ա��������ƽ����������ʱ����EMPLOYEES���е�sal_limit_suggest�С�
����һ�����������Ա��id�����ʺ����ǵ�ƽ���������ơ�
��JOBS�����ҵ�һ����Ա������ƽ���������ơ���ÿ��Ա�����ܵ�ƽ������������ʵ�ʹ��ʽ��бȽϣ�
������ʳ���ƽ���������ƣ��򽫸�Ա����sal_limit_describe������ΪYES;���򣬽�������ΪNO��
Ϊ�������ļ�¼�����쳣������
c.ִ�г���Ȼ����Խ����
��ѯEMPLOYEES���Բ鿴�����޸ģ�Ȼ���ύ����
*/
Procedure CHECK_AVG_SAL() Is
  v_count Number(3) := 0;
  e_locked Exception;
  v_yes_no varchar2(3) := 'yes';
  Cursor cur_sal Is
    Select e.employee_id, e.salary, j.min_salary, j.Max_salary
      From employees e, jobs j
     Where e.job_id = j.job_id
       For Update Nowait;
Begin
  For sal_cur In cur_sal Loop
    v_count := 1;
    
    begin
      SAVEPOINT rec_loop;
      --If sal_cur.salary <= sal_cur.max_salary And
      --   sal_cur.salary >= sal_cur.min_salary Then
      If sal_cur.salary between sal_cur.min_salary And sal_cur.max_salary Then
        v_yes_no := 'yes'
      Else
        v_yes_no := 'NO'
      End If;
      
      Update employees
         Set sal_limit_indicate = v_yes_no
       Where employee_id = sal_cur.employee_id;
       
      COMMIT;
    exception
      when others then
        rollback to rec_loop;
    end;
  End Loop;
  If v_count = 0 Then
    Raise e_locked;
  End If;
Exception
  When e_locked Then
    Rollback all;
    dbms_output.put_line('���ݱ������޷�����');
  When Others Then
    Rollback all;
    dbms_output.put_line(Sqlerrm);
End;
--19
/*
����һ����ΪGET_SERVICE_YRS�Ĵ洢�����������ض�Ա���ķ������ޡ�
�ú���Ӧ�ý���Ա��ID��Ϊ�����������ط������ޡ�Ϊ��Ч��Ա��ID���Ӵ�������
b.���ú�����������ʹ����������:
ִ��DBMS_OUTPUT.PUT_LINE (get_service_yrs (999))
��ʾ:��������Ӧ�û����һ��������Ϣ����Ϊû��Ա��ID 999��
DBMS_OUTPUTִ�С�PUT_LINE('��Լ....|| get_service_yrs(106) || ' years')
��ʾ:�������Ӧ���ǳɹ��ģ�������Ա��IDΪ106�ķ������ޡ�
c.��ѯָ��Ա����JOB_HISTORY��EMPLOYEES��������֤�޸��Ƿ���ȷ��
*/select * from job_history

create or replace function GET_SERVICE_YRS 
 (p_empid in employees.employee_id%type)
  return number 
 is 
     cursor emp_yrs_cur is  
     select (end_date - start_date)/365  service
     from  job_history 
     where employee_id = p_empid;
     v_seryr  number(2) :=0;
     v_yrs    number(2) :=0;
 begin 
    for r_yrs in  emp_yrs_cur loop 
      exit when emp_yrs_cur%not found;
      v_seryr := v_seryr+ r_yrs.service;
    end loop;
     
        select  (sysdate -hire_date)
    into v_yrs  
    from employees 
    where employee_id = p_empid;
    v_seryr := v_seryr+ v_yrs;
    
    return v_seryr
      exception not_date_found then 
        dbms_output.put_line('Ա��δ�ҵ�');
    end GET_SERVICE_YRS;
    
 begin   
 dbms_output.put_line(sys.GET_SERVICE_YRS(999));
 end;         
  20 /*
����һ����ΪGET_JOB_COUNT�Ĵ洢����������Ա�������Ĳ�ͬ��ҵ��������
�ú���Ӧ�ý���һ������������Ա��ID���ú���������Ա����ĿǰΪֹ���µĲ�ͬ������������
��Ҳ����Ŀǰ�Ĺ�����Ϊ��Ч��Ա��ID�����쳣������
��ʾ:��֤��ͬ��JOB_HISTORY������ҵid����֤��ǰ��ҵID�Ƿ��Ǹ�Ա����������ҵID֮һ��
b.���ú�����������ʹ����������:
*/

 create and replace function GET_JOB_COUNT(p_empid in employees.employee_id%type)
  return number 
  is 
     v_currjob employees.job%type;
     v_numjob number :=0;
     n  number ;
   begin 
     select   count (distinct  job_id)
     into v_numjob 
     from job_history
     where employee_id = p_empid ;
     
     select count(job_id)
     into n 
     from employees
     where employee_id = p_empid;
     and job_id in  (select distinct job_id 
                    from   job_history
                    where employee_id = p_empid);
     if (n=0) then 
       v_numjob  =  v_numjob +1;
       end if ;
       return v_numjob ;
       exception 
          when   no_data_found then 
            dbms_output.put_line('���޴���');
            
        end GET_JOB_COUNT;
                      
                   
                                                                            
                                       
                                       
                                  
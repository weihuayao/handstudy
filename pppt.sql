
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
--Use an iSQL*Plus substitution variable to store an employee’s last name. 

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
--15 在下面的练习中，创建一个程序增加新的工作到JOBS表里
--a.创建一个ADD_JOBS存储过程来输入新的命令到JOBS表里。
-- 这个过程应该接受三个变量，分别是JOB_ID， JOB_TITLE，min_salary，每最大工资为最小工资的两倍；
--b.在调用过程前让SECURE_EMPLOYEES触发器失效。调用过程增加下列信息
--SY_ANAL   System Analyst   6,000   12000
--c.核对这一行增加的数据结果，为了下一个练习记住job_id，提交过程。
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
/*注意:在调用第b部分中的过程之前，禁用employee、JOBS和JOB_HISTORY表上的所有触发器。
a.创建一个名为ADD_JOB_HIST的存储过程，以便为将作业更改为您在问题15b
中创建的新作业ID的员工在JOB_HISTORY表中输入新行。
使用正在更改作业的员工的员工ID和该员工的新工作ID作为参数。
从EMPLOYEES表中获取与此员工ID对应的行，并将其插入JOB_HISTORY表。
将该员工的雇佣日期作为JOB_HISTORY表中这一行的开始日期和今天的日期作为结束日期。
将EMPLOYEES表中该员工的雇佣日期更改为今天。
将该员工的工作ID更新为作为参数传递的工作ID(使用问题15b中创建的工作的工作ID)，
工资等于该工作ID + 500的最低工资。
包含异常处理来处理插入不存在的雇员的尝试。
b.禁用触发器(请参阅问题开头的说明)。
以员工ID 106和作业ID SY_ANAL作为参数执行过程。
启用您禁用的触发器。
c.查询表以查看更改，然后提交更改*/

--teacher
create or replace procedure add_job_hist(p_empno      employees.employee_id%type,
                                         p_new_job_no employees.job_id%type) as
  v_hire_date employees.hire_date%type;
  v_oldjobid  employees.job_id%type;
  v_olddept   employees.department_id%type;
  v_salary    employees.salary%type;
  v_emp_id    employees.employee_id%type;
  --cursor for update 锁表
  --if(判断参数为空)
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
  --17 创建一个程序，更改JOBS表内最小和最大工资
  --a.创建一个存储过程UPD_SAL来更新JOBS表一个特定job_id的最小工资和最大工资，    
  --传递三个参数给过程：工作编号，新最小工资，新最大工资。增加例外处理无效的的工作编号。
  --当然，当最大工资小于最小工资，抛出一个例外。如果jobs表中数据被锁或者无法改变则在窗口中显示合适的消息；
  create or replace procedure upd_sal(p_job_id  varchar2,
                                      p_min_sal number,
                                      p_max_sal number) is
  vexception;_ex 
  v_is_jobid jobs.job_id%type;
  cursor job_cur is
    select job_id from jobs where job_id = p_job_id for update nowait;
begin
  --参数判空
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
a.通过执行以下命令向EMPLOYEES表添加一列:(labaddA_18.sql)
写一个名为CHECK_AVG_SAL的存储过程。这将检查JOBS表中每个员工
的平均工资限制与EMPLOYEES表中该员工的工资，并在该员工超过其平均工资限制时更新EMPLOYEES表中的sal_limit_suggest列。
创建一个光标来保存员工id、工资和他们的平均工资限制。
从JOBS表中找到一个雇员工作的平均工资限制。将每个员工可能的平均工资限制与实际工资进行比较，
如果工资超过平均工资限制，则将该员工的sal_limit_describe列设置为YES;否则，将其设置为NO。
为被锁定的记录添加异常处理。
c.执行程序，然后测试结果。
查询EMPLOYEES表以查看您的修改，然后提交更改
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
    dbms_output.put_line('数据被锁，无法更改');
  When Others Then
    Rollback all;
    dbms_output.put_line(Sqlerrm);
End;
--19
/*
创建一个名为GET_SERVICE_YRS的存储函数来检索特定员工的服务年限。
该函数应该接受员工ID作为参数，并返回服务年限。为无效的员工ID添加错误处理。
b.调用函数。您可以使用以下数据:
执行DBMS_OUTPUT.PUT_LINE (get_service_yrs (999))
提示:上面的语句应该会产生一条错误消息，因为没有员工ID 999。
DBMS_OUTPUT执行。PUT_LINE('大约....|| get_service_yrs(106) || ' years')
提示:上述语句应该是成功的，并返回员工ID为106的服务年限。
c.查询指定员工的JOB_HISTORY和EMPLOYEES表，以验证修改是否正确。
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
        dbms_output.put_line('员工未找到');
    end GET_SERVICE_YRS;
    
 begin   
 dbms_output.put_line(sys.GET_SERVICE_YRS(999));
 end;         
  20 /*
创建一个名为GET_JOB_COUNT的存储函数，检索员工工作的不同作业的总数。
该函数应该接受一个参数来保存员工ID。该函数将返回员工到目前为止从事的不同工作的数量。
这也包括目前的工作。为无效的员工ID添加异常处理。
提示:验证不同于JOB_HISTORY表的作业id。验证当前作业ID是否是该员工工作的作业ID之一。
b.调用函数。您可以使用以下数据:
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
            dbms_output.put_line('查无此人');
            
        end GET_JOB_COUNT;
                      
                   
                                                                            
                                       
                                       
                                  

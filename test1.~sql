--使用pl/sql块编程实现，注意必要的异常处理。

--1 输入一个员工号，输出该员工的姓名、薪金和工作时间（按年月日显示）。
declare
  emp_name     scott.emp.ename%type;
  emp_sal      scott.emp.sal%type;
  emp_hiredate scott.emp.hiredate%type;
begin
  select ename, sal, hiredate
    into emp_name, emp_sal, emp_hiredate
    from emp
   where empno = &empno;
  dbms_output.put_line('姓名：' || emp_name || ' 工资：' || emp_sal || ' 入职时间：' ||
                       to_char(emp_hiredate, 'yyyy-mm-dd'));
exception
  when others then
    dbms_output.put_line('发生异常！');
end;
--2 接收一个员工号，输出该员工所在部门的名称。
declare
  dept_dname dept.dname%type;
begin
  select dname
    into dept_dname
    from emp e, dept d
   where e.deptno = d.deptno
     and empno = &empno;
  dbms_output.put_line('部门名称：' || dept_dname);
exception
  when others then
    dbms_output.put_line('发生异常！');
end;
--3 接收一个员工号，如果该员工职位是MANAGER，并且在DALLAS工作，那么就给他薪金加15%；如果该员工职位是CLERK，并且在NEW YORK工作，那么就给他薪金扣除5%；其他情况不作处理。
declare
  emp_job  emp.job%type;
  dept_loc dept.loc%type;
  emp_sal  emp.sal%type;
  emp_no   emp.empno%type;
begin
  select job, loc, sal, e.empno
    into emp_job, dept_loc, emp_sal, emp_no
    from emp e, dept d
   where d.deptno = e.deptno
     and empno = &empno;
  if emp_job = 'MANAGER' and dept_loc = 'DALLAS' then
    emp_sal := emp_sal * 1.15;
  elsif emp_job = 'CLERK' and dept_loc = 'NEW YORK' then
    emp_sal := emp_sal * 0.95;
  end if;
  dbms_output.put_line('职位：' || emp_job || ' 工作地点：' || dept_loc || ' 工资：' ||
                       emp_sal);
  update emp set sal = emp_sal where empno = emp_no;
exception
  when others then
    dbms_output.put_line('发生异常！');
end;

--4 接收一个员工号，输出这个员工所在部门的平均工资。
declare
  dept_avgsal emp.sal%type;
begin
  select avg(sal)
    into dept_avgsal
    from emp e, dept d
   where e.deptno = d.deptno
     and e.deptno = (select deptno from emp where empno = &empno)
   group by e.deptno;
  dbms_output.put_line('该部门平均工资：' || dept_avgsal);
exception
  when others then
    dbms_output.put_line('发生异常！');
end;
--5 要求输入一个雇员编号，为此雇员增长工资，增长工作按照以下的原则进行：
--  · 10部门人员工资上涨10% · 20部门人员工资上涨20% · 30部门人员工资上涨30% 
--但是所有的工资最高不超过5000。
declare
  emp_sal emp.sal%type;
  dept_no emp.deptno%type;
  emp_no  emp.empno%type;
begin
  select empno, deptno, sal
    into emp_no, dept_no, emp_sal
    from emp
   where empno = &empno;
  if dept_no = 10 then
    emp_sal := emp_sal * 1.1;
  elsif dept_no = 20 then
    emp_sal := emp_sal * 1.2;
  elsif dept_no = 30 then
    emp_sal := emp_sal * 1.3;
  elsif emp_sal > 5000 then
    emp_sal := 5000;
  end if;
  dbms_output.put_line('部门编号：' || dept_no || ' 工资：' || emp_sal);
  update emp set sal = emp_sal where empno = emp_no;
exception
  when others then
    dbms_output.put_line('发生异常！');
end;
--球队
select max(nn.team) team, min(nn.y) beginy, max(nn.y) + 1 endy
  from (select n2.team, n2.y, rownum, n2.y - rownum
          from (select * from nba) n1
         inner join (select * from nba) n2
            on n1.team = n2.team
         where          n1.y = n2.y + 1) nn
 group by (nn.y - rownum)
 order by beginy

--查询80,81,82,87年员工入职人数
set serveroutput on
declare
  cursor cemp is select to_char(hiredate,'yyyy') from emp; 
  count80 number :=0;
  count81 number :=0;
  count82 number  :=0;
  count87 number  :=0;
  phiredate varchar2(4) := '';
  
begin
  open cemp;
  
  loop
    fetch cemp into phiredate ;
    exit when cemp%notfound;
    
    if phiredate = '1980' then  count80 := count80 +1;
    elsif phiredate = '1981' then  count81 := count81 +1;
    elsif phiredate = '1982' then  count82 := count82 +1;
    elsif phiredate = '1987' then  count87 := count87 +1;
    end if;
    
  end loop;
  close cemp;
  
  dbms_output.put_line('total:'||(count80+count81+count82+count87));
  dbms_output.put_line('1980:'||(count80 ));
  dbms_output.put_line('1981:'||(count81));
  dbms_output.put_line('1982:'||(count82));
  dbms_output.put_line('1987:'||(count87));
  
end;
--实现按部门分段(6000以上、(6000，3000)、3000元以下)统计各个工资段的职工人数、
--以及各部门的工资总额



declare 

    cursor cdept is select deptno from dept;
    pdeptno dept.deptno%type;
  
    cursor cemp(dno number )  is select deptno,sal from emp where deptno = dno;
    pdno emp.deptno%type;
    psal emp.sal%type; 
  
    count1 number := 0;
    count2 number := 0;
    count3 number := 0;
    saltotal number := 0;

begin

    open cdept;
    
    loop
        fetch cdept into pdeptno ;
        exit when cdept%notfound;
    
        open cemp(pdeptno);
         saltotal := 0;
         count1 := 0;
         count2 := 0;
         count3 :=0;
        loop
            fetch cemp into pdno,psal;
            exit when cemp%notfound;
           
            if psal < 3000 then count1 :=count1+1;
            elsif psal <= 6000 then count2:=count2+1;
            elsif psal > 6000 then count3 := count3 +1;
            end if;
            saltotal := saltotal +psal;
        end loop;
        close cemp;
        insert into msg values(pdno,count1,count2,count3,saltotal);
  end loop;


  close cdept;
  
  commit;
end;

--员工涨工资。从最低工资涨起每人涨10%，
--但是所有员工的工资总额不能超过5万元，请计算涨工资的人数和涨工资后的所有员工的工资总额


set serveroutput on

declare

--定义光标:查询所有员工的员工号和工资
  cursor cemp is select empno,sal from emp order by sal;
  pempno emp.empno%type;
  psal emp.sal%type;
  
  countEmp number := 0;
  salTotal emp.sal%type;
  
  begin
  --查询所有员工涨前的工资总额
    select sum(sal)  into salTotal from emp;
  
  open cemp;
  loop
  --涨前工资综合大于5000则退出循环
    exit when salTotal > 50000 ;
    
    fetch cemp into pempno,psal;
    
    --若未从光标中取到值退出循环
    exit when cemp%notfound;
    
    --若当前的工资总额加上 当前员工涨后的工资大于5万则退出循环
    exit when salTotal +psal*0.1 >50000;
    
    update emp set sal = sal*1.1 where empno = pempno;
  
    countEmp := countEmp +1;
    salTotal :=salTotal +psal*0.1;
  
  end loop;
  close cemp;
  commit;
  
  dbms_output.put_line('涨工资的人数是:'||countEmp);
  dbms_output.put_line('涨后的工资总额是:'||salTotal);
  
  
  end;
  /
--实例1:统计每年入职的员工个数

declare
  cursor cemp is select to_char(hiredate,'yyyy') from emp;
  phiredate varchar2(4);
  --计数器(2010-2016的入职人数统计)
  count10 number := 0;
  count11 number := 0;
  count12 number := 0;
  count13 number := 0;
  count14 number := 0;
  count15 number := 0;
  count16 number := 0;
begin
  open cemp;
  loop
    --取一个数据
    fetch cemp into phiredate;
    exit when cemp%notfound;
    --判断
    if phiredate = '2010' then count10:=count10+1;
      elsif phiredate = '2011' then count11:=count11+1;
      elsif phiredate = '2012' then count12:=count12+1;
      elsif phiredate = '2013' then count13:=count13+1;
      elsif phiredate = '2014' then count14:=count14+1;
      elsif phiredate = '2015' then count15:=count15+1;
      else count16:=count16+1;
    end if;
  end loop;
  close cemp;
  --输出
  dbms_output.put_line('total:'||(count10+count11+count12+count13+count14+count15+count16));
  dbms_output.put_line('2010:'||count10);
  dbms_output.put_line('2011:'||count11);
  dbms_output.put_line('2012:'||count12);
  dbms_output.put_line('2013:'||count13);
  dbms_output.put_line('2014:'||count14);
  dbms_output.put_line('2015:'||count15);
  dbms_output.put_line('2016:'||count16);
end;

--为员工涨工资，从最低工资调起，每人涨10%，但工资总额不能超过5万元，
--请计算涨工资的人数和涨工资后的工资总额，并输出涨工资人数和工资总额。


declare
  psal emp.sal%type;
  pempno emp.empno%type;
  s_sal emp.sal%type; --总工资数
  counts number := 0;  --涨工资的人数
  cursor cemp is select empno,sal from emp order by sal;
begin
  select sum(sal) into s_sal from emp;
  open cemp;
  loop
   exit when s_sal+psal*0.1>50000;
   fetch cemp into pempno,psal;
   exit when cemp%notfound;
   update emp set sal=sal+sal*0.1 where empno=pempno;
   counts := counts+1;
   s_sal:=s_sal+psal*0.1;
  end loop;
  close cemp;
  dbms_output.put_line('涨工资人数:'||counts);
  dbms_output.put_line('工资总额:'||s_sal);
end;
--:统计工资段


declare
  --部门
  dbms_output.put_line('部门 小于3000数 3000-6000 大于6000 工资总额');  
  cursor cdept is select deptno from dept;
  pdno dept.deptno%type;
 
  --部门中的员工
  cursor cemp(dno number) is select sal from emp where deptno=dno;
  psal emp.sal%type;
 
  --各个段的人数
  count1 number;count2 number;count3 number;
  --部门的工资总额
  salTotal number;
begin
  open cdept;
  loop
    --取部门
    fetch cdept into pdno;
    exit when cdept%notfound;
    
    --初始化
    count1 :=0;count2:=0;count3:=0;
    select sum(sal) into salTotal  from emp where deptno=pdno;
    
    --取部门中的员工
    open cemp(pdno);
    loop
      fetch cemp into psal;
      exit when cemp%notfound;
      
      --判断
      if psal<3000 then count1:=count1+1;
        elsif psal>=3000 and psal<6000 then count2:=count2+1;
        else count3:=count3+1;
      end if;        
    end loop;
    close cemp;
    
    --输出
    dbms_output.put_line(pdno||'    '||count1||'    '||count2||'    '||count3||'    '||nvl(salTotal,0));
    
  end loop;
  close cdept;
end;

--
declare
  psal emp.sal%type;
  pdeptno emp.deptno%type;
  cursor cemp is select sal,deptno from emp order by deptno;
  counts201 number := 0;counts202 number := 0;counts203 number := 0;
  s20_sal number := 0;
  counts301 number := 0;counts302 number := 0;counts303 number := 0;
  s30_sal number := 0;
  counts401 number := 0;counts402 number := 0;counts403 number := 0;
  s40_sal number := 0;
  counts501 number := 0;counts502 number := 0;counts503 number := 0;
  s50_sal number := 0;
begin
  open cemp;
     loop
       fetch cemp into psal,pdeptno;
       exit when cemp%notfound;
       if pdeptno='20'
         then
           s20_sal:=s20_sal+psal;
           if psal<3000 then
             counts201:=counts201+1;
           elsif psal>=3000 and psal<=6000 then
             counts202:=counts202+1;
           else
             counts203:=counts203+1;
           end if;
       elsif pdeptno='30'
         then
           s30_sal:=s30_sal+psal;
           if psal<3000 then
             counts301:=counts301+1;
           elsif psal>=3000 and psal<=6000 then
             counts302:=counts302+1;
           else
             counts303:=counts303+1;
           end if;
       elsif pdeptno='40'
         then
           s40_sal:=s40_sal+psal;
           if psal<3000 then
             counts401:=counts401+1;
           elsif psal>=3000 and psal<=6000 then
             counts402:=counts402+1;
           else
             counts403:=counts403+1;
           end if;
       elsif pdeptno='50'
         then
           s50_sal:=s50_sal+psal;
           if psal<3000 then
             counts501:=counts501+1;
           elsif psal>=3000 and psal<=6000 then
             counts502:=counts502+1;
           else
             counts503:=counts503+1;
           end if;
       end if;
     end loop;
  close cemp;
  dbms_output.put_line('部门 小于3000数 3000-6000 大于6000 工资总额');
  dbms_output.put_line('20    '||counts201||'    '||counts202||'    '||counts203||'    '||s20_sal);
  dbms_output.put_line('30    '||counts301||'    '||counts302||'    '||counts303||'    '||s30_sal);
  dbms_output.put_line('40    '||counts401||'    '||counts402||'    '||counts403||'    '||s40_sal);
  dbms_output.put_line('50    '||counts501||'    '||counts502||'    '||counts503||'    '||s50_sal);
end;

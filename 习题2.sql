--1.  Show all data of the clerks who have been hired after the year 1997.
select * from employees where to_number(to_char(hire_date,'yyyy')) - 1997 < 0;
--2.  Show the last name,  job, salary, and commission of those employees 
--who earn commission. Sort the data by the salary in descending order. 
--显示这些员工的姓氏、工作、薪水和佣金谁赚佣金。按工资降序排列数据\
select last_name, job_id, salary, commission_pct
  from employees
 where commission_pct is not null
 order by salary desc;
--3.  Show the employees that have no commission 
--with a 10% raise in their salary (round off the salaries).
select employee_id,  salary ,1.1 * salary  new_salary
  from employees
 where commission_pct is null;
--4.  Show the last names of all employees together with the number of 
--years and the number of completed months that they have been employed.
--请列出所有雇员的姓名，以及他们受雇的年数和完成工作的月数。
select last_name,
       to_number(to_char(sysdate, 'yyyy')) -
       to_number(to_char(hire_date, 'yyyy')) year1,
       (to_number(to_char(sysdate, 'yyyy')) -
       to_number(to_char(hire_date, 'yyyy'))) * 12 + (to_number(to_char(sysdate, 'mm')) -
       to_number(to_char(hire_date, 'mm')) ) month1
  from employees
--5.  Show those employees that have a name starting with J, K, L, or M.
select first_name
  from employees
 where last_name like 'J%'
    or last_name like 'K%'
    or last_name like 'L%'
    or last_name like 'M%';
--6.  Show all employees, and indicate with “Yes” or “No” whether they receive a commission.
select last_name ,salary, nvl2(commission_pct, 'YES', 'NO') from employees;
--7.  Show the department names, locations, names, job titles, and salaries of employees
--who work in location 1800.
select d.department_name,
       j.job_title,
       d.location_id,
       e.first_name,
       e.salary
  from departments d, jobs j, employees e, locations l
 where d.department_id = e.department_id
   and d.location_id = l.location_id
   and e.job_id = j.job_id
--8.  How many employees have a name that ends with an n? Create two possible solutions.
 select * from employees where  Last_name like '%n' ;
 select * from employees where substr(last_name, -1) = 'n';
--9.  Show the names and locations for all departments, and the number of employees working 
--in each department. Make sure that departments without employees are included as well
-- 显示所有部门的名称和位置，以及工作的员工数量在每个部门。确保没有员工的部门也包括在内.

select * from departmentS

select d.department_name, d.location_id, count(*)
  from departments d, employees e
  where d.department_id = e.department_id
 group by d.department_name, d.location_id
--10. Which jobs are found in departments 10 and 20?
select j.job_title 
  from employees e, jobs j
 where e.job_id = j.job_id
   and e.department_id = 10
   or e.department_id = 20;
  --11. Which jobs are found in the Administration and Executive departments, 
  --and how many employees do these jobs? Show the job with the highest frequency first.
select e.job_id, count(e.job_id)
  from employees e, departments d, jobs j
 where e.department_id = d.department_id
   and department_name = 'Administration'
    or department_name = 'Executive'
 group by (e.job_id) 
 order by count(e.job_id) desc
--12. Show all employees who were hired in the first half of the month (before the 16th of the month).
 --显示所有在上半月(16号之前)被雇佣的员工。
 select *
   from employees e
  where to_number(to_char(e.hire_date, 'dd')) < 16;
--13. Show the names, salaries, and the number of dollars (in thousands) 
--that all employees earn.
select last_name ,salary ,trunc(salary,-3)/1000 thousands from employees;
--14. Show all employees who have managers with a salary 
--higher than $15,000. Show the following data: employee name, manager name, 
--manager salary, and salary grade of the manager.
select e.last_name, m.last_name manager, m.salary, j.grade_level
  from employees e, employees m, job_grades j
 where e.manager_id = m.employee_id
   and m.salary between j.lowest_sal and j.highest_sal
   and m.salary > 15000;
--15. Show the department number, name, number of employees, and average salary of all departments
--, together with the names, salaries, and jobs of the employees working in each department
select d.department_id,
       d.department_name,
       count(e1.employee_id) employees,
       nvl(to_char(avg(e1.salary), '99999.99'), 'No average') avg_sal,
       e2.last_name,
       e2.salary,
       e2.job_id
  from departments d, employees e1, employees e2
 where d.department_id = e1.department_id(+)
   and d.department_id = e2.department_id(+)
 group by d.department_id,
          d.department_name,
          e2.last_name,
          e2.salary,
          e2.job_id
 order by d.department_id, employees;

--16. Show the department number and the lowest salary of the 
--department with the highest average salary.
select department_id, min(salary)
  from employees
 group by department_id
having avg(salary) = (select max(avg(salary))
                        from employees
                       group by department_id);

--17. Show the department numbers, names, and locations of the departments
-- where no sales representatives work.显示部门编号、名称和部门的位置 没有销售代表的地方。
select *
  from departments
 where department_id not in
       (select department_id
          from employees
         where job_id = 'sa_rep'
           and department_id is not null);
--18. Show the department number, department name, 
--and the number of employees working in each department that:显示部门编号、部门名称、各部门员工人数:
select d.department_id, d.department_name, count(*)
  from employees e, departments d
 where d.department_id = e.department_id
 group by d.department_id, d.department_name

--19. Show the employee number, last name, salary, department number,
-- and the average salary in their department for all employees.
select e.employee_id, e.last_name, e.department_id, avg(s.salary)
  from employees e, employees s
 where e.department_id = s.department_id
 group by e.employee_id, e.last_name, e.department_id;
--20. Show all employees who were hired on the day of the week 
--on which the highest number of employees were hired.
--显示所有在周几那一天被雇佣的员工。 
select to_char(hire_date, 'day') from employees  --星期几
select last_name, to_char(hire_date, 'day') day   
  from employees
 where to_char(hire_date, 'day') =
       (select to_char(hire_date ,'day')
          from employees
         group by to_char(hire_date, 'day')
        having count(*) = (select max(count(*))
                            from employees
                           group by to_char(hire_date, 'day'))); 
--21.根据员工的雇佣日期创建周年回顾。把周年纪念日按升序排列。
select last_name, to_char(hire_date, 'mm-dd') birthday
  from employees
 order by to_char(hire_date, 'mm-dd');
--22. Find the job that was filled in the first half of 1990 and the same job that was filled during the same period in 1991.
 --找到1990年上半年的工作和1991年同期的工作。

select job_id 
  from employees
 where hire_date between to_date('1990/1/1','yyyy-mm-dd' ) and to_date('1990/6/30','yyyy-mm-dd' )
intersect
select job_id
  from employees
 where hire_date between to_date('1991/1/1','yyyy-mm-dd' ) and to_date('1991/6/30','yyyy-mm-dd' );
--23. Write a compound query to produce a list of employees showing raise percentages, employee     IDs, and old salary and new salary increase. Employees in departments 10, 50, and 110 are     given a 5% raise, employees in department 60 are given a 10% raise, employees in    departments 20 and 80 are given a  15% raise, and employees in department 90 are not given    a raise.  
--编写一个复合查询，以生成显示加薪百分比、员工id、旧工资和新工资增长的员工列表。
--10、50、110部门的员工加薪5%，60部门的员工加薪10%，20、80部门的员工加薪15%，
--90部门的员工不加薪。\
select '5% raise ' raise, employee_id, salary, salary * 0.05 new_salary
  from employees
 where department_id in (10, 50, 110)
union
select '10% raise ', employee_id, salary, salary * 0.10
  from employees
 where department_id = 60
union
select '15% raise', employee_id, salary, salary * 0.15
  from employees
 where department_id in (20, 80)
union
select 'no raise ', employee_id, salary, salary
  from employees
 where department_id = 90;
--
SELECT hs.student_no,hs.course_no,/*hs.rn,*/hs.core
  FROM (SELECT rownum rn,
               hsc.student_no,
               hsc.course_no,
               hsc.core,
               row_number() OVER(ORDER BY hsc.core DESC) ranks
          FROM hand_student_core hsc
          ) hs
 ORDER BY CASE
            WHEN ranks <= 3 THEN
             -ranks
            ELSE
             null
          END,
          rn;

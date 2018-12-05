select * from hand_Student;
select * from hand_teacher;
select * from HAND_COURSE;
select * from HAND_STUDENT_CORE;


-- 1. 查询没学过“谌燕”老师课的同学，显示（学号、姓名）
with s_t as
 (select sc.student_no stu_no , t.teacher_name t_name
    from HAND_STUDENT_CORE sc, HAND_COURSE c, hand_teacher t
   where sc.course_no = c.course_no
     and c.teacher_no = t.teacher_no)

select s.student_no 学号, s.student_name 姓名
  from hand_student s
 where s.student_no not in (select s.student_no
                              from hand_student s, s_t
                             where s.student_no = s_t.stu_no
                               and s_t.t_name = '谌燕'
                             group by s.student_no);
-- 2. 查询没有学全所有课的同学，显示（学号、姓名）
select s.student_no 学号 , s.student_name 姓名
  from hand_student s, HAND_STUDENT_CORE sc
 where s.student_no = sc.student_no
 group by s.student_no, s.student_name
having count(sc.course_no) < (select count(*) from hand_course);

-- 3. 查询“c001”课程比“c002”课程成绩高的所有学生，显示（学号、姓名）
 select s.student_no 学号, s.student_name 姓名
             from hand_student s,
                  (select sc.student_no
                     from hand_student_core sc
                    where sc.course_no = 'c001'
                      and sc.core >
                          (select sc1.core
                             from hand_student_core sc1
                            where sc1.course_no = 'c002'
                              and sc.student_no = sc1.student_no)) tb1
            where s.student_no = tb1.student_no
    
-- 4. 按各科平均成绩和及格率的百分数，按及格率高到低的顺序排序，显示（课程号、平均分、及格率）
   select sc.course_no 课程号,
          round(AVG(core),1)平均分 ,
          (SUM(case
                 when core between 60 and 100 then
                  1
                 else
                  0
               end) / count(*))*100 || '%' 及格率
     from hand_student_core sc
    group by sc.course_no
-- 5. 1992年之后出生的学生名单找出年龄最大和最小的同学，显示（学号、姓名、年龄）
 select s.student_no, s.student_name, s.student_age
   from hand_student s,
        (select max(s.student_age) max_age, min(s.student_age) min_age
           from hand_student s
          where to_number(to_char(SYSDATE, 'yyyy')) - s.student_age > 1992) tb
  where s.student_age = tb.max_age
     or s.student_age = tb.min_age;
-- 6. 统计列出矩阵类型各分数段人数，横轴为分数段[100-85]、[85-70]、[70-60]、[<60]，
--纵轴为课程号、课程名称（提示使用case when句式）
select sc.course_no,
       c.course_name,
       sum(case
             when sc.core between 85 and 100 then
              1
             else
              0
           end) as " [ 100 - 85 ] ",
       sum(case
             when sc.core between 70 and 85 then
              1
             else
              0
           end) as " [ 85 - 70 ]",
       sum(case
             when sc.core between 70 and 60 then
              1
             else
              0
           end) as " [ 70 - 60 ]",
       sum(case
             when sc.core < 60 then
              1
             else
              0
           end) AS " [ < 60 ]"
  from hand_student_core sc, hand_course c
 where sc.course_no = c.course_no
 group by sc.course_no, c.course_name;

-- 7. 查询各科成绩前三名的记录:(不考虑成绩并列情况)，显示（学号、课程号、分数）
 select student_no, course_no, core
   from (select sc.student_no,
                sc.course_no,
                sc.core,
                dense_rank() over(partition by sc.course_no order by sc.core desc) ranks
           from hand_student_core sc)
  where ranks < =3
-- 8. 查询选修“谌燕”老师所授课程的学生中每科成绩最高的学生，显示（学号、姓名、课程名称、成绩）
select s.student_no, s.student_name, c.course_name, sc.core
  from hand_student_core sc, hand_Student s, hand_teacher t, HAND_COURSE c
 where s.student_no = sc.student_no
   and sc.course_no = c.course_no
   and c.teacher_no = t.teacher_no
   and t.teacher_name = '谌燕'
   and sc.core = (select max(sc1.core)
                    from hand_student_core sc1
                   where sc1.course_no = c.course_no)
-- 9. 查询两门以上不及格课程的同学及平均成绩，显示（学号、姓名、平均成绩（保留两位小数））
select s.student_name, sc.student_no, round(avg(sc.core), 2) avg_core
  from hand_student_core sc, hand_student s
 where exists (select sc1.student_no
          from hand_student_core sc1
         where sc1.core < 60     
           and sc1.student_no = sc.student_no
         group by sc1.student_no
       having count(sc1.student_no) > x)
   and sc.student_no = s.student_no
  group by sc.student_no,s.student_name;
-- 10. 查询姓氏数量最多的学生名单，显示（学号、姓名、人数）
ct s1.student_no, s1.student_name, tb.num1
  from (select substr(s.student_name, 1, 1) xing,
               count(1) num1,
               dense_rank() over(order by count(1) desc) ranks
          from hand_student s
         group by substr(s.student_name, 1, 1)) tb,
       hand_student s1
 where substr(s1.student_name, 1, 1) = tb.xing
   and tb.ranks = 1


-- 11. 查询课程名称为“J2SE”的学生成绩信息，90以上为“优秀”、
--80-90为“良好”、60-80为“及格”、60分以下为“不及格”，显示（学号、姓名、课程名称、成绩、等级）
select sc.student_no,
       s.student_name,
       c.course_name,
       sc.core,
       case
         when sc.core >= 90 then
          '优秀'
         when  sc.core >= 80 then
          '良好'
         when  sc.core >= 60 then
          '及格'
         when sc.core < 60 then   
          '不及格'
         end   core_level
   from hand_student_core sc,
        hand_course c,
        hand_student s
   where sc.course_no = c.course_no
     and sc.student_no = s.student_no
     and c.course_name = 'J2SE';
-- 12. 这是一个树结构，查询教师“胡明星”的所有主管及姓名:
--（无主管的教师也需要显示），显示（教师编号、教师名称、主管编号、主管名称）
select * from hand_teacher;
select t1.teacher_no,
       t1.teacher_name,
       t1.manager_no,
       t2.teacher_name manager
  from hand_teacher t1
  left join hand_teacher t2
    on t1.manager_no = t2.teacher_no
 start with t1.teacher_name = '胡明星'
connect by prior t1.manager_no = t1.teacher_no
-- 13. 查询分数高于课程“J2SE”中所有学生成绩的学生课程信息，显示（学号，姓名，课程名称、分数）
select sc1.student_no, 
       s.student_name,
       c1.course_name, 
       sc1.core
  from  hand_student_core sc1,
       hand_course c1,
       hand_student s
 where sc1.course_no = c1.course_no
   and sc1.student_no = s.student_no
   and sc1.core > ALL (select sc.core 
                         from hand_student_core sc,
                              hand_course c
                        where sc.course_no = c.course_no
                          and c.course_name = 'J2SE')
  and c1.course_name != 'J2SE';
-- 14. 分别根据教师、课程、教师和课程三个条件统计选课的学生数量：
--（使用rollup),显示（教师名称、课程名称、选课数量）
select  t.teacher_name,
       c.course_name,
       count(1) nums
  from  hand_student_core sc,
       hand_teacher t,
       hand_course c
 where sc.course_no = c.course_no
   and c.teacher_no = t.teacher_no
 group by rollup(t.teacher_name,c.course_name);
 
-- 15. 查询所有课程成绩前三名的按照升序排在最开头，
--其余数据排序保持默认（7分）,显示（学号、成绩）

select s.student_no,
       s.core
  from  (select  rownum rn,
               sc.student_no,
               sc.core,
               row_number()over(order by sc.core desc) ranks
          from hand_student_core sc) s
order by case when  ranks <= 3 then -ranks else null end,rn;


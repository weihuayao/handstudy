1.  没有使用子查询的理由； 

查询老师：谌燕 ，所教授的课程；
--不需要使用子查询
SELECT hc.COURSE_NO, hc.COURSE_NAME
  FROM HAND_COURSE hc
 WHERE TEACHER_NO =
       (SELECT TEACHER_NO FROM HAND_TEACHER WHERE TEACHER_NAME = '谌燕');--here
     
--
2.  自定义更新语句，没有判断版本号，没有更新版本号+who字段
更新学生s001对应的课程 c002 成绩为 82.8

UPDATE HAND_STUDENT_CORE 
   SET CORE = 82.8
 WHERE STUDENT_NO = 'S001'
   AND COURSE_NO = 'c002';
   
UPDATE HAND_STUDENT_CORE 
   SET CORE = 82.8,
   OBJECT_VERSION_NUMBER =OBJECT_VERSION_NUMBER+1,
   LAST_UPDATED_BY = LAST_UPDATED_BY +1,
   LAST_UPDATE_DATE = sysdate,
   LAST_UPDATE_LOGIN = session
 WHERE STUDENT_NO = 'S001'
   AND COURSE_NO = 'c002';


3.  子查询滥用，重复的子查询请简化；
查询学生s001 对应的成绩+教师编号+课程名称+课程编号

SELECT hsc.COURSE_NO,
       (select COURSE_NAME
          from HAND_COURSE i
         where i.COURSE_NO = hsc.COURSE_NO) COURSE_NAME,
       (select TEACHER_NO
          from HAND_COURSE j
         where j.COURSE_NO = hsc.COURSE_NO) TEACHER_NO,
       hsc.CORE
  FROM HAND_STUDENT_CORE hsc
  where hsc.STUDENT_NO = 's001';
  


4.  条件语句中直接使用 case when，性能差，建议子查询封装
core 分数等级在 70分以下，差； 70-80分，良； 80分以上，优；
查询出所有成绩等级为"差"的学生及对应课程分数；

SELECT hs.STUDENT_NAME,
       hsc.COURSE_NO,
       (CASE
         WHEN hsc.CORE > 80 THEN
          '优'
         WHEN hsc.CORE > 70 THEN
          '良'
         ELSE
          '差'
       END) type,
       hsc.CORE
  FROM HAND_STUDENT_CORE hsc, hand_student hs
 where hsc.STUDENT_NO = hs.STUDENT_NO
   and (CASE
         WHEN hsc.CORE > 80 THEN
          '优'
         WHEN hsc.CORE > 70 THEN
          '良'
         ELSE
          '差'
       END) = 'xxxx' ;

     
     
5.  列名的函数运算，将不走索引
查询出所有加10分后，分数还低于80分的学生成绩；

SELECT hs.STUDENT_NAME, 
       hsc.STUDENT_NO, 
       hsc.COURSE_NO, 
       hsc.CORE
  FROM HAND_STUDENT_CORE hsc, hand_student hs
 WHERE hsc.STUDENT_NO = hs.STUDENT_NO
   and hsc.core + 10 < 80
 order by hs.STUDENT_NAME;  

SELECT hs.STUDENT_NAME, 
       hsc.STUDENT_NO, 
       hsc.COURSE_NO, 
       hsc.CORE
  FROM HAND_STUDENT_CORE hsc, hand_student hs
 WHERE hsc.STUDENT_NO = hs.STUDENT_NO
   and hsc.core  < 80 - 10
 order by hs.STUDENT_NAME; 



6.  重复的SQL建议使用子查询整个进行封装 or 合适的方式进行改写；

查询老师：刘阳，所教授的课程；

SELECT hc.COURSE_NO,
       hc.COURSE_NAME,
       hc.TEACHER_NO,
       (SELECT TEACHER_NAME
          FROM HAND_TEACHER ht
         where hc.TEACHER_NO = ht.TEACHER_NO) TEACHER_NAME
  FROM HAND_COURSE hc
 WHERE 1 = 1
   and (SELECT TEACHER_NAME
          FROM HAND_TEACHER ht
         where hc.TEACHER_NO = ht.TEACHER_NO) = '刘阳';
         

/*
select teacher_name, c.course_no, course_name, t.teacher_no
  from hand_teacher t, hand_course c
 where t.teacher_no = c.teacher_no
   and t.teacher_name = '刘阳';
   */


7.  Group by 与 distinct 混用    一个即可

SELECT DISTINCT STUDENT_NO, COURSE_NO
  FROM HAND_STUDENT_CORE
 GROUP BY STUDENT_NO, COURSE_NO;
 

7 SELECT  STUDENT_NO, COURSE_NO
  FROM HAND_STUDENT_CORE
 GROUP BY STUDENT_NO, COURSE_NO;
 
8.  内层的Group by 没有任何的限制条件，只能走全表扫描，建议改成子查询
计算学生的成绩总分；  
大数据量，比如50万左右的数据可以明显看出执行计划上的差别，小数据量比如10几行可能错误的写法还更快，全表扫描比走索引快；

select hs.STUDENT_NO, hs.STUDENT_NAME, hc.cores
  from hand_student hs
  left join (SELECT STUDENT_NO, sum(CORE) cores
               FROM HAND_STUDENT_CORE
              GROUP BY STUDENT_NO) hc
    on hs.STUDENT_NO = hc.STUDENT_NO;
 --- 
  select hs.STUDENT_NO,
         hs.STUDENT_NAME,
         (select sum(core)
            from hand_student_core sc
           where sc.student_no = hs.student_no)
    from hand_student hs
9.--  内层子查询的Group by 没有限制条件走全表扫描，
--外层where条件可作为限制，建议移到内层，走索引查询；
--内层多余的查询字段请去除，只使用有用的字段

 
select COURSE_NO, sum(core)
  from (select STUDENT_NO, COURSE_NO, core
          from HAND_STUDENT_CORE
        union ALL
        select STUDENT_NO, COURSE_NO, core
          from HAND_STUDENT_CORE) a
 where 1 = 1
   and a.student_no = 's001'
 group by COURSE_NO;


--------9 
 select COURSE_NO, sum(core)
   from (select STUDENT_NO, COURSE_NO, core
           from HAND_STUDENT_CORE s
           where s.student_no = 's001'
         union ALL
         select STUDENT_NO, COURSE_NO, core
           from HAND_STUDENT_CORE s
          where  s.student_no = 's001') 
  group by COURSE_NO;
 
10. 存在全表扫描，可以如何提速；
 --应尽量避免在where 子句中对字段进行null 值判断
 -- 应尽量避免在where 子句中使用!=或<>操作符，否则将引擎放弃使用索引而进行全表扫描。
 --应尽量避免在where 子句中使用or 来连接条件
 --in 和not in 也要慎用，否则会导致全表扫描
 --如果在where 子句中使用参数，也会导致全表扫描
 --应尽量避免在where子句中对字段进行函数操作
--不要在where 子句中的“=”左边进行函数、
--算术运算或其他表达式运算，否则系统将可能无法正确使用索引。
--.很多时候用exists 代替in 是一个好的选择


SELECT hsc.COURSE_NO, hc.COURSE_NAME, hc.TEACHER_NO, hsc.CORE
  FROM HAND_STUDENT_CORE hsc, HAND_COURSE hc
 where hsc.COURSE_NO = 'c001'
   and hc.COURSE_NO = hsc.COURSE_NO; 



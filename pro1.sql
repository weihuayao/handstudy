--请在Oracle数据库中新建一个包，在Pacakge中，自定义一个存储过程，该存储过程可以输出一个HTML的报表，
--打印所有参加过考试的学生的考试记录。
--需要打印的列：学生姓名、性别、年龄、考试课程、考试得分（四舍五入取整）、授课老师，该科考试排名
--要求：1.支持按学号查询和打印报表。
--      2.调用存储过程后必须返回程序是否运行成功
--      3.程序必须结构清晰，逻辑完整
select * from hand_student;

create or replace package body mypackage as

  v_name   hand_student.student_name%type; --声明
  v_sex    hand_student.student_gender%type;
  v_age    hand_student.student_age%type;
  v_course hand_course.course_name%type;
  v_core   hand_student_core.core%type;
  v_tname  hand_teacher.teacher_name%type;
  v_sno    hand_student.student_no%type;
  v_rank   int;
  --num varchar2(20) := &student_no;
  cursor cur1 is; --游标
end mypackage;

--cursor cur_1 is  --游标 
--select * from(select hs.student_no,hs.student_name,hs.student_gender,hs.student_age,hc.course_name,sc.core,ht.teacher_name，
--rank() over(partition by hc.course_name order by sc.core desc) rank
--from hand_student hs,hand_student_core sc,hand_course hc,hand_teacher ht
-- where hs.student_no=sc.student_no and ht.teacher_no=hc.teacher_no and hc.course_no=sc.course_no)
--  end;


create or replace package body mypackage is
declare num varchar2(20) := &student_no;
begin
cursor cur_1 is --游标 
select * from(select hs.student_no, hs.student_name, hs.student_gender, hs.student_age, hc.course_name, sc.core, ht.teacher_name， rank() over(partition by hc.course_name order by sc.core desc) rank from hand_student hs, hand_student_core sc, hand_course hc, hand_teacher ht where hs.student_no = sc.student_no and ht.teacher_no = hc.teacher_no and hc.course_no = sc.course_no) where student_no = num;

end mypackage;
declare
  v_student_name hand_student.student_name%type;
  v_student_gender hand_student.student_gender%type;
  v_student_age hand_student.student_age%type;
  v_course_name hand_course.course_name%type;
  v_student_core hand_student_core.core%type;
  v_teacher_name hand_teacher.teacher_name%type;
  v_student_no hand_student.student_no%type;
  v_rank int;
  
  
  
  num varchar2(20) := &student_no;
  cursor v_record is
  select * from(select hs.student_no,hs.student_name,hs.student_gender,hs.student_age,hc.course_name,sc.core,ht.teacher_name，
  rank() over(partition by hc.course_name order by sc.core desc) rank
  from hand_student hs,hand_student_core sc,hand_course hc,hand_teacher ht
  where hs.student_no=sc.student_no and ht.teacher_no=hc.teacher_no and hc.course_no=sc.course_no) where student_no=num;
begin
  open v_record;
  loop
    fetch v_record into v_student_no,v_student_name,v_student_gender,v_student_age,v_course_name,v_student_core,v_teacher_name,v_rank;
    exit when v_record%notfound;
    dbms_output.put_line('姓名：'||v_student_name||',性别：'||v_student_gender||',年龄：'||v_student_age||',课程名称：'||v_course_name||',成绩：'||v_student_core||',老师：'||v_teacher_name||',排名：'||v_rank);
  end loop;
  close v_record;
end;

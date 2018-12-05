--����Oracle���ݿ����½�һ��������Pacakge�У��Զ���һ���洢���̣��ô洢���̿������һ��HTML�ı���
--��ӡ���вμӹ����Ե�ѧ���Ŀ��Լ�¼��
--��Ҫ��ӡ���У�ѧ���������Ա����䡢���Կγ̡����Ե÷֣���������ȡ�������ڿ���ʦ���ÿƿ�������
--Ҫ��1.֧�ְ�ѧ�Ų�ѯ�ʹ�ӡ����
--      2.���ô洢���̺���뷵�س����Ƿ����гɹ�
--      3.�������ṹ�������߼�����
select * from hand_student;

create or replace package body mypackage as

  v_name   hand_student.student_name%type; --����
  v_sex    hand_student.student_gender%type;
  v_age    hand_student.student_age%type;
  v_course hand_course.course_name%type;
  v_core   hand_student_core.core%type;
  v_tname  hand_teacher.teacher_name%type;
  v_sno    hand_student.student_no%type;
  v_rank   int;
  --num varchar2(20) := &student_no;
  cursor cur1 is; --�α�
end mypackage;

--cursor cur_1 is  --�α� 
--select * from(select hs.student_no,hs.student_name,hs.student_gender,hs.student_age,hc.course_name,sc.core,ht.teacher_name��
--rank() over(partition by hc.course_name order by sc.core desc) rank
--from hand_student hs,hand_student_core sc,hand_course hc,hand_teacher ht
-- where hs.student_no=sc.student_no and ht.teacher_no=hc.teacher_no and hc.course_no=sc.course_no)
--  end;


create or replace package body mypackage is
declare num varchar2(20) := &student_no;
begin
cursor cur_1 is --�α� 
select * from(select hs.student_no, hs.student_name, hs.student_gender, hs.student_age, hc.course_name, sc.core, ht.teacher_name�� rank() over(partition by hc.course_name order by sc.core desc) rank from hand_student hs, hand_student_core sc, hand_course hc, hand_teacher ht where hs.student_no = sc.student_no and ht.teacher_no = hc.teacher_no and hc.course_no = sc.course_no) where student_no = num;

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
  select * from(select hs.student_no,hs.student_name,hs.student_gender,hs.student_age,hc.course_name,sc.core,ht.teacher_name��
  rank() over(partition by hc.course_name order by sc.core desc) rank
  from hand_student hs,hand_student_core sc,hand_course hc,hand_teacher ht
  where hs.student_no=sc.student_no and ht.teacher_no=hc.teacher_no and hc.course_no=sc.course_no) where student_no=num;
begin
  open v_record;
  loop
    fetch v_record into v_student_no,v_student_name,v_student_gender,v_student_age,v_course_name,v_student_core,v_teacher_name,v_rank;
    exit when v_record%notfound;
    dbms_output.put_line('������'||v_student_name||',�Ա�'||v_student_gender||',���䣺'||v_student_age||',�γ����ƣ�'||v_course_name||',�ɼ���'||v_student_core||',��ʦ��'||v_teacher_name||',������'||v_rank);
  end loop;
  close v_record;
end;

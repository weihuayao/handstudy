select * from hap_dev.HR_EMPLOYEE

--����
create synonym HR_EMPLOYEE1 for  hap_dev.HR_EMPLOYEE
select * from HR_EMPLOYEE1

--�˵�Ŀ¼�ṹ��
create table tb_menu(
 id number(10) not null, --����id
 title varchar2(50), --����
 parent number(10) --parent id
)
 
--���˵�
insert into tb_menu(id, title, parent) values(1, '���˵�1',null);
insert into tb_menu(id, title, parent) values(2, '���˵�2',null);
insert into tb_menu(id, title, parent) values(3, '���˵�3',null);
insert into tb_menu(id, title, parent) values(4, '���˵�4',null);
insert into tb_menu(id, title, parent) values(5, '���˵�5',null);
--һ���˵�
insert into tb_menu(id, title, parent) values(6, 'һ���˵�6',1);
insert into tb_menu(id, title, parent) values(7, 'һ���˵�7',1);
insert into tb_menu(id, title, parent) values(8, 'һ���˵�8',1);
insert into tb_menu(id, title, parent) values(9, 'һ���˵�9',2);
insert into tb_menu(id, title, parent) values(10, 'һ���˵�10',2);
insert into tb_menu(id, title, parent) values(11, 'һ���˵�11',2);
insert into tb_menu(id, title, parent) values(12, 'һ���˵�12',3);
insert into tb_menu(id, title, parent) values(13, 'һ���˵�13',3);
insert into tb_menu(id, title, parent) values(14, 'һ���˵�14',3);
insert into tb_menu(id, title, parent) values(15, 'һ���˵�15',4);
insert into tb_menu(id, title, parent) values(16, 'һ���˵�16',4);
insert into tb_menu(id, title, parent) values(17, 'һ���˵�17',4);
insert into tb_menu(id, title, parent) values(18, 'һ���˵�18',5);
insert into tb_menu(id, title, parent) values(19, 'һ���˵�19',5);
insert into tb_menu(id, title, parent) values(20, 'һ���˵�20',5);
--�����˵�
insert into tb_menu(id, title, parent) values(21, '�����˵�21',6);
insert into tb_menu(id, title, parent) values(22, '�����˵�22',6);
insert into tb_menu(id, title, parent) values(23, '�����˵�23',7);
insert into tb_menu(id, title, parent) values(24, '�����˵�24',7);
insert into tb_menu(id, title, parent) values(25, '�����˵�25',8);
insert into tb_menu(id, title, parent) values(26, '�����˵�26',9);
insert into tb_menu(id, title, parent) values(27, '�����˵�27',10);
insert into tb_menu(id, title, parent) values(28, '�����˵�28',11);
insert into tb_menu(id, title, parent) values(29, '�����˵�29',12);
insert into tb_menu(id, title, parent) values(30, '�����˵�30',13);
insert into tb_menu(id, title, parent) values(31, '�����˵�31',14);
insert into tb_menu(id, title, parent) values(32, '�����˵�32',15);
insert into tb_menu(id, title, parent) values(33, '�����˵�33',16);
insert into tb_menu(id, title, parent) values(34, '�����˵�34',17);
insert into tb_menu(id, title, parent) values(35, '�����˵�35',18);
insert into tb_menu(id, title, parent) values(36, '�����˵�36',19);
insert into tb_menu(id, title, parent) values(37, '�����˵�37',20);
--�����˵�
insert into tb_menu(id, title, parent) values(38, '�����˵�38',21);
insert into tb_menu(id, title, parent) values(39, '�����˵�39',22);
insert into tb_menu(id, title, parent) values(40, '�����˵�40',23);
insert into tb_menu(id, title, parent) values(41, '�����˵�41',24);
insert into tb_menu(id, title, parent) values(42, '�����˵�42',25);
insert into tb_menu(id, title, parent) values(43, '�����˵�43',26);
insert into tb_menu(id, title, parent) values(44, '�����˵�44',27);
insert into tb_menu(id, title, parent) values(45, '�����˵�45',28);
insert into tb_menu(id, title, parent) values(46, '�����˵�46',28);
insert into tb_menu(id, title, parent) values(47, '�����˵�47',29);
insert into tb_menu(id, title, parent) values(48, '�����˵�48',30);
insert into tb_menu(id, title, parent) values(49, '�����˵�49',31);
insert into tb_menu(id, title, parent) values(50, '�����˵�50',31);
commit;

select * from tb_menu
delete  from tb_menu;
-- PRIOR������CONNECT BY�Ӿ��еȺŵ�ǰ��ʱ����ǿ�ƴӸ��ڵ㵽Ҷ�ڵ��˳�������
--���ɸ��ڵ����ӽڵ㷽��ͨ�����ṹ�����ǳ�֮Ϊ�Զ����µķ�ʽ���磺
-- CONNECT BY PRIOR EMPNO=MGR
--PIROR�����������CONNECT BY �Ӿ��еȺŵĺ���ʱ����ǿ�ƴ�Ҷ�ڵ㵽���ڵ��˳������������ӽڵ��򸸽ڵ㷽��ͨ�����ṹ�����ǳ�֮Ϊ�Ե����ϵķ�ʽ��

-- CONNECT BY EMPNO=PRIOR MGR

---����һ���ڵ������ֱ���ӽڵ㣨���к������
select * from tb_menu m 
start with m.id=1
connect by prior m.id=  m.parent  -- ����ĸ��ڵ��������� �ӽڵ�

--��ѯһ���ڵ���������ڵ� 
select * from tb_menu m 
start with m.id=50
connect by m.id  = prior m.parent  --���ڵ�parent����ǰ��һ���ڵ��id

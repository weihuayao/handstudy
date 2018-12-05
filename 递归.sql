select * from hap_dev.HR_EMPLOYEE

--别名
create synonym HR_EMPLOYEE1 for  hap_dev.HR_EMPLOYEE
select * from HR_EMPLOYEE1

--菜单目录结构表
create table tb_menu(
 id number(10) not null, --主键id
 title varchar2(50), --标题
 parent number(10) --parent id
)
 
--父菜单
insert into tb_menu(id, title, parent) values(1, '父菜单1',null);
insert into tb_menu(id, title, parent) values(2, '父菜单2',null);
insert into tb_menu(id, title, parent) values(3, '父菜单3',null);
insert into tb_menu(id, title, parent) values(4, '父菜单4',null);
insert into tb_menu(id, title, parent) values(5, '父菜单5',null);
--一级菜单
insert into tb_menu(id, title, parent) values(6, '一级菜单6',1);
insert into tb_menu(id, title, parent) values(7, '一级菜单7',1);
insert into tb_menu(id, title, parent) values(8, '一级菜单8',1);
insert into tb_menu(id, title, parent) values(9, '一级菜单9',2);
insert into tb_menu(id, title, parent) values(10, '一级菜单10',2);
insert into tb_menu(id, title, parent) values(11, '一级菜单11',2);
insert into tb_menu(id, title, parent) values(12, '一级菜单12',3);
insert into tb_menu(id, title, parent) values(13, '一级菜单13',3);
insert into tb_menu(id, title, parent) values(14, '一级菜单14',3);
insert into tb_menu(id, title, parent) values(15, '一级菜单15',4);
insert into tb_menu(id, title, parent) values(16, '一级菜单16',4);
insert into tb_menu(id, title, parent) values(17, '一级菜单17',4);
insert into tb_menu(id, title, parent) values(18, '一级菜单18',5);
insert into tb_menu(id, title, parent) values(19, '一级菜单19',5);
insert into tb_menu(id, title, parent) values(20, '一级菜单20',5);
--二级菜单
insert into tb_menu(id, title, parent) values(21, '二级菜单21',6);
insert into tb_menu(id, title, parent) values(22, '二级菜单22',6);
insert into tb_menu(id, title, parent) values(23, '二级菜单23',7);
insert into tb_menu(id, title, parent) values(24, '二级菜单24',7);
insert into tb_menu(id, title, parent) values(25, '二级菜单25',8);
insert into tb_menu(id, title, parent) values(26, '二级菜单26',9);
insert into tb_menu(id, title, parent) values(27, '二级菜单27',10);
insert into tb_menu(id, title, parent) values(28, '二级菜单28',11);
insert into tb_menu(id, title, parent) values(29, '二级菜单29',12);
insert into tb_menu(id, title, parent) values(30, '二级菜单30',13);
insert into tb_menu(id, title, parent) values(31, '二级菜单31',14);
insert into tb_menu(id, title, parent) values(32, '二级菜单32',15);
insert into tb_menu(id, title, parent) values(33, '二级菜单33',16);
insert into tb_menu(id, title, parent) values(34, '二级菜单34',17);
insert into tb_menu(id, title, parent) values(35, '二级菜单35',18);
insert into tb_menu(id, title, parent) values(36, '二级菜单36',19);
insert into tb_menu(id, title, parent) values(37, '二级菜单37',20);
--三级菜单
insert into tb_menu(id, title, parent) values(38, '三级菜单38',21);
insert into tb_menu(id, title, parent) values(39, '三级菜单39',22);
insert into tb_menu(id, title, parent) values(40, '三级菜单40',23);
insert into tb_menu(id, title, parent) values(41, '三级菜单41',24);
insert into tb_menu(id, title, parent) values(42, '三级菜单42',25);
insert into tb_menu(id, title, parent) values(43, '三级菜单43',26);
insert into tb_menu(id, title, parent) values(44, '三级菜单44',27);
insert into tb_menu(id, title, parent) values(45, '三级菜单45',28);
insert into tb_menu(id, title, parent) values(46, '三级菜单46',28);
insert into tb_menu(id, title, parent) values(47, '三级菜单47',29);
insert into tb_menu(id, title, parent) values(48, '三级菜单48',30);
insert into tb_menu(id, title, parent) values(49, '三级菜单49',31);
insert into tb_menu(id, title, parent) values(50, '三级菜单50',31);
commit;

select * from tb_menu
delete  from tb_menu;
-- PRIOR被置于CONNECT BY子句中等号的前面时，则强制从根节点到叶节点的顺序检索，
--即由父节点向子节点方向通过树结构，我们称之为自顶向下的方式。如：
-- CONNECT BY PRIOR EMPNO=MGR
--PIROR运算符被置于CONNECT BY 子句中等号的后面时，则强制从叶节点到根节点的顺序检索，即由子节点向父节点方向通过树结构，我们称之为自底向上的方式。

-- CONNECT BY EMPNO=PRIOR MGR

---查找一个节点的所有直属子节点（所有后代）。
select * from tb_menu m 
start with m.id=1
connect by prior m.id=  m.parent  -- 后面的父节点等于这里的 子节点

--查询一个节点的所属父节点 
select * from tb_menu m 
start with m.id=50
connect by m.id  = prior m.parent  --父节点parent等于前面一个节点的id

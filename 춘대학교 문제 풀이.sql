-------------------------------
------BASIC
--1
select department_name, category from tb_department;

--2
select department_name||'의 정원은 '|| capacity||' 명 입니다.' from tb_department;

--3
select student_name
from tb_student
where student_no in('A513079',
    'A513090',
    'A513091',
    'A513110',
    'A513119') 
order by student_name desc;

--4
select department_name, category
from tb_department
where capacity between 20 and 30;

--5
select professor_name
from tb_professor
where department_no is null;

--6
select *
from tb_student
where department_no is null;

--7
select class_no
from tb_class
where preattending_class_no IS NOT NULL;

--8
SELECT DISTINCT(CATEGORY)
FROM tb_department;

--9
SELECT STUDENT_NO, STUDENT_NAME, STUDENT_SSN,ENTRANCE_DATE
FROM tb_student
WHERE EXTRACT(YEAR FROM ENTRANCE_DATE)='2002'
    AND student_address LIKE '%전주시%'
    AND ABSENCE_YN ='N';

-------------------------------
------FUNCTION
--1
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, ENTRANCE_DATE 입학년도
FROM tb_student
WHERE department_no=002
ORDER BY 입학년도;

--2
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM tb_professor
WHERE professor_name NOT LIKE ('___');

--3

SELECT PROFESSOR_NAME "교수이름", add_months(TO_DATE(SUBSTR(professor_ssn,1,6),'yyMMDD'),-1200),
TO_DATE(SUBSTR(professor_ssn,1,6),'rrMMDD'),
case when floor(months_between(sysdate,TO_DATE(SUBSTR(professor_ssn,1,6),'rrMMDD'))/12)<0
     then abs(floor(months_between(sysdate,TO_DATE(SUBSTR(professor_ssn,1,6),'rrMMDD'))/12))+50
     else floor(months_between(sysdate,TO_DATE(SUBSTR(professor_ssn,1,6),'rrMMDD'))/12)
     end"나이"
FROM tb_professor
where substr(professor_ssn,8,1)=1
ORDER BY 3 desc;

--4

select substr(PROFESSOR_NAME,2,2) 이름
from TB_PROFESSOR;

--5
select STUDENT_NO,student_name a,
--extract(year from entrance_date)-extract(year from TO_DATE(SUBSTR(student_ssn,1,6),'rrMMDD'))+1 f
--floor(months_between(entrance_date,TO_DATE(SUBSTR(student_ssn,1,6),'rrMMDD'))/12) "나이"
from tb_student
where extract(year from entrance_date)-extract(year from TO_DATE(SUBSTR(student_ssn,1,6),'rrMMDD'))+1 >20
order by 1;

--6
select to_char(to_date('20201225'),'day') from dual;

--7
--2049년 10월 11일

--8
select STUDENT_NO, STUDENT_NAME
from tb_student
where entrance_date<'2000/01/01';

--9
select to_char(avg(point),'9.9')"평점"
from tb_grade
where student_no='A517178';

select round(avg(point),1)"평점"
from tb_grade
where student_no='A517178';

--10
select DEPARTMENT_NO 학과번호,
count(*)"학생수(명)"
from tb_student
group by department_no
order by 1;

--11
select count(*)
from tb_student
where COACH_PROFESSOR_NO is null;

--12
select substr(term_no,1,4) 년도,round(avg(POINT),1)"년도 별 평점"
from tb_grade
where STUDENT_NO='A112113'
group by substr(term_no,1,4) 
order by 1;

--13
select DEPARTMENT_NO, count(decode(ABSENCE_YN,'Y','1','N',null))
from tb_student
group by  DEPARTMENT_NO
order by DEPARTMENT_NO;

--14
select STUDENT_NAME, count(STUDENT_NAME)
from tb_student
group by STUDENT_NAME
having count(STUDENT_NAME)>1
order by STUDENT_NAME;

--15
select substr(term_no,1,4),substr(term_no,5,6), round(avg(point),1)
from tb_grade
where STUDENT_NO='A112113'
group by rollup(substr(term_no,1,4),substr(term_no,5,6))
order by substr(term_no,1,4),substr(term_no,5,6);

--------------------------------------------------------------------------------
--option
--1.
select student_name 학생이름, student_address 주소지
from tb_student
order by student_name;

--2.
select student_name, student_ssn
from tb_student
where absence_yn = 'Y'
order by student_ssn desc;

--3.
select student_name, student_no, student_address
from tb_student
where (student_address like'%경기도%' or student_address like'%강원도%') and student_no like'9%'
order by student_name;

--4.
select professor_name, professor_ssn
from tb_professor
where department_no='005'
order by professor_ssn;

--5.
select student_no, point
from tb_grade
where class_no='C3118100'and term_no='200402'
order by point desc, student_no;

--6
select student_no, student_name, department_name
from tb_student S,tb_department d
where s.department_no=d.department_no
order by student_name;

--7
select class_name, department_name
from tb_class
left join tb_department using(department_no);

--8
select class_name, professor_name
from tb_class
join tb_class_professor using(class_no)
join tb_professor using(professor_no);

--9
select class_name, professor_name
from tb_class c
join tb_class_professor using(class_no)
join tb_professor using(professor_no)
join tb_department d on(c.department_no=d.department_no)
where category ='인문사회';

--10
select s.STUDENT_NO,STUDENT_NAME,avg(point)
from tb_grade g, tb_student s
where DEPARTMENT_NO=(select DEPARTMENT_NO
                        from tb_department
                        where DEPARTMENT_NAME='음악학과')
group by s.STUDENT_NO,STUDENT_NAME;

--    and d.DEPARTMENT_NO(+)=s.DEPARTMENT_NO 
--    and g.STUDENT_NO(+)=s.STUDENT_NO
--group by s.STUDENT_NO;

select g.STUDENT_NO,STUDENT_NAME,round(avg(point),1)
from  tb_student s, tb_department d,tb_grade g
where  d.DEPARTMENT_NO(+)=s.DEPARTMENT_NO 
    and s.STUDENT_NO=g.STUDENT_NO 
    and DEPARTMENT_NAME='음악학과'
group by g.STUDENT_NO,STUDENT_NAME;

--11
select DEPARTMENT_NAME  "학과이름", STUDENT_NAME  "학생이름",PROFESSOR_NAME  "지도교수이름"
from tb_student s, tb_department d, tb_professor p
where STUDENT_NO='A313047'and s.DEPARTMENT_NO=d.DEPARTMENT_NO and COACH_PROFESSOR_NO=PROFESSOR_NO;

--12
select s.STUDENT_NAME, g.TERM_NO
from tb_student s,tb_grade g
where s.STUDENT_NO=g.STUDENT_NO 
and term_no like '2007%'
and g.CLASS_NO=(select CLASS_NO 
                from tb_class 
                where CLASS_NAME='인간관계론');
                
--13             
with nonprof as(select CLASS_NO from tb_class
                minus
                select class_no from tb_class_professor)
select class_name,department_name
from nonprof n,tb_department d, tb_class c
where n.class_no=c.class_no 
and d.DEPARTMENT_NO=c.DEPARTMENT_NO
and category = '예체능';

--14
select STUDENT_NAME,nvl(PROFESSOR_NAME,'지도교수 미지정')
from tb_student s,tb_professor p
where s.DEPARTMENT_NO=(
                     select DEPARTMENT_NO 
                     from tb_department 
                     where department_name='서반아어학과')
and COACH_PROFESSOR_NO=PROFESSOR_NO(+);

--15
select g.STUDENT_NO,STUDENT_NAME,DEPARTMENT_NAME,avg(POINT)
from tb_student s,tb_grade g,tb_department d
where ABSENCE_YN='N'  
and d.DEPARTMENT_NO=s.DEPARTMENT_NO 
and g.STUDENT_NO=s.STUDENT_NO
group by g.STUDENT_NO,STUDENT_NAME,DEPARTMENT_NAME
having avg(POINT)>=4;

--16
select g.CLASS_NO,c. CLASS_NAME,avg(point)
from tb_class c, tb_grade g
where DEPARTMENT_NO=(select DEPARTMENT_NO from tb_department where department_name = '환경조경학과')
and c.class_no=g.class_no
AND CLASS_TYPE LIKE '%전공%'
group by g.class_no, class_name;
                
--17
SELECT STUDENT_NAME,STUDENT_ADDRESS
FROM TB_STUDENT
WHERE DEPARTMENT_NO=(SELECT DEPARTMENT_NO FROM TB_STUDENT WHERE STUDENT_NAME='최경희');

--18
WITH SMART AS (SELECT STUDENT_NAME, RANK()OVER(ORDER BY AVG(POINT) DESC) 성적
               FROM TB_STUDENT S, TB_DEPARTMENT D, TB_GRADE G
               WHERE S.DEPARTMENT_NO = D.DEPARTMENT_NO
               AND DEPARTMENT_NAME = '국어국문학과'
               AND S.STUDENT_NO=G.STUDENT_NO
               GROUP BY STUDENT_NAME)
SELECT STUDENT_NO,S.STUDENT_NAME
FROM TB_STUDENT ST,SMART S
WHERE ST.STUDENT_NAME =S.STUDENT_NAME
AND 성적=1;

--19
                
SELECT DEPARTMENT_NAME "계열 학과명",ROUND(AVG(POINT),1)"전공평점"
FROM TB_DEPARTMENT D, TB_GRADE G, TB_STUDENT S
WHERE CATEGORY=(SELECT CATEGORY 
                FROM TB_DEPARTMENT 
                WHERE DEPARTMENT_NAME='환경조경학과')
AND S.DEPARTMENT_NO=D.DEPARTMENT_NO
AND S.STUDENT_NO=G.STUDENT_NO
GROUP BY DEPARTMENT_NAME;

----------------------------------------------------------------------------------------------------------------
--DDL
--1.
create table tb_category(
name varchar2(10),
use_yn char(1) default 'Y'
);

--2
create table tb_class_type(
no varchar2(5) primary key,
name varchar2(10)
);

--3
alter table tb_category add constraint cat_pk primary key(name);

--4
alter table tb_class_type modify name not null;

--5
alter table tb_class_type modify no varchar2(10)
                          modify name varchar2(20);
alter table tb_category modify name varchar2(20);
rollback;

--6-------***
alter table tb_class_type rename column no to class_type_no;
alter table tb_category rename column name to category_name;

--7
alter table tb_class_type rename constraint SYS_C008056 to pk_class_type_no;
alter table tb_category rename constraint CAT_PK to pk_category_name;

--8
insert into tb_category values('공학','Y');
insert into tb_category values('자연과학','Y');
insert into tb_category values('의학','Y');
insert into tb_category values('예체능','Y');
insert into tb_category values('인문사회','Y');

--9
alter table tb_department
add constraint fk_department_category 
foreign key(category) 
references tb_category(category_name); 
-- forrign key : alter talbe 테이블명 add foreign key(나의 컬럼명) reference 참조할 테이블명[(참조할 컬럼명)]



SELECT * FROM USER_TABLES;

SELECT* FROM USER_TAB_COLUMNS;











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
select STUDENT_NO,student_name a
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


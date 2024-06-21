/*
        *view(view를 쓰면 마치 테이블을 만든것 마냥 쓸 수 있다.)
         select문을 저장해둘수 있는 객체(엄청 복잡한 select문을 계속 여러번 사용해야할때 사용한다.)
         (자주 쓰이는 긴 select문을 저장해두었다가 호출하여 사용할 수 있다.)
         임시테이블 같은 존재(실제 데이터가 담겨있는거는 아님 -> 논리적 테이블)

*/

--한국에서 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명
select emp_id, emp_name, dept_title, salary, national_name
from employee e
join department d on(dept_code=dept_id)
join location l on(local_code=location_id)
join national n using(national_code)
where national_name = '한국';

--러시아에서 근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명

--일본근무하는 사원의 사번, 사원명, 부서명, 급여, 근무국가명

---------------------------------------------------------------------------------------------------------
/*
        *1. view 생성
        [표현법]
        create view 뷰명
        as 서브쿼리;

*/
--view를 만들기 전에 만들수 있는 권한을 먼저 관리자 계정으로 줘야한다.
grant create view to tjoeun;

create view vm_employee
as select emp_id, emp_name, dept_title, salary, national_name
   from employee e
    join department d on(dept_code=dept_id)
    join location l on(local_code=location_id)
    join national n using(national_code);

--view에 있는 모든 값 조회
select * 
from vm_employee;

--한국에서 근무하는 사원 검색
select *
from vm_employee
where national_name= '한국';

--러시아에서 근무하는 사원 검색
select *
from vm_employee
where national_name= '러시아';

--일본에서 근무하는 사원 검색
select *
from vm_employee
where national_name= '일본';
--------------------------------------------------------------------------------------------------------
/*
        *뷰 컬럼에 별칠 부여
         서브쿼리의 서브쿼리에 함수식, 산술식이 기술되면 반드시 별칭 부여해줘야함
*/
--전 사원의 사번, 사원명, 직급명, 성별(남/여),근무년수를 조회할 수 있는 view(vm_emp_job)를 생성하시오
--create or replace view : 이미 같은 이름의 뷰가 있으면 덮어쓰기함. 없으면 생성해주는 옵션 쿼리임
create or replace view vm_emp_job
as select emp_id, emp_name, 
    job_name,
    decode(substr(emp_no,8,1),1,'남',2,'여') 성별, 
    floor(months_between( sysdate,hire_date)/12) 근무년수
from employee
join job using(job_code);

--별칭을 다른 방식으로도 부여 가능
--view이름볖에 괄호를 써서 컬럼별 별칭을 순서대로 써주면 컬럼 뒤에 하나씩 입력하지 않아도 한번에 컬럼 별칭을 정해줄 수 있다.
create or replace view vm_emp_job(사번, 사원명, 직급명, 성별, 근무년수)
as select emp_id, emp_name, 
    job_name,
    decode(substr(emp_no,8,1),1,'남',2,'여') 성별, 
    floor(months_between( sysdate,hire_date)/12) 근무년수
from employee
join job using(job_code);

select emp_id, emp_name, decode(substr(emp_no,8,1),1,'남',2,'여') 성별, floor(months_between( sysdate,hire_date)/12) 근무년수
from employee;

select 사원명, 근무년수 
  from vm_emp_job
  where 성별 = '여';

--근무년수가 30년 이상인 사람의 사원명, 직급명 조회 
select 사원명, 직급명
from vm_emp_job
where 근무년수>=30;


------------------------------------------------------------------------------------
/*
        *뷰 삭제
         drop view 뷰명;
*/
drop view vm_emp_job;

------------------------------------------------------------------------------------
/*
        *생성된 view를 통해 DML 사용 가능(데이터 변경 가능)
         view에서 insert, update, delete를 실행하면 실제 데이터베이스에 반영됨
*/
--뷰(vm_job) job테이블의 모든 컬럼을 서브쿼리를 이용해 생성
create or replace view vm_job(직급코드,직급명)
as select * from job;

--뷰에 한 행 추가를 하면 원본에도 추가가 된다.
insert into vm_job values('J8','인턴');

select *from job;
select * from vm_job;

--뷰에서 업데이트
update vm_job set 직급명='알바'
where 직급코드='J8';

--뷰에서 삭제
delete from vm_job
where 직급코드='J8';

/*
         * 데이터 변경은 가능하나  
        *단, dml명령어로 조작이 불가능한 경우가 더 많음
         1) 뷰에 정의되지 않은 컬럼을 조작하고자 하는경우
         2) 뷰에 정의되어있는 컬럼 중에 원본 테이블 상에 not null제약 조건이 지정되어있는 경우
         3) 산술식, 함수식으로 정의되어 있는 경우(view에 성별이 남과 여로 표현 되어있는데 원본에는 그런 컬럼이 없어서 변경할 수 없다)
         4) 그룹함수(sum, avg, count)나 group by절이 포함되어 있는 경우
         5) distinct 구문이 포함된 경우(중복된 값은 뺴는 distinct를 쓴 경우 view에서 변경할 행이 원본의 어떤 컬럼인지 알 수 없다.)
         6) join을 이용하여 여러 테이블을 연결시켜놓은 경우
            (employee 테이블에서 한국에서 근무하는사람만 변경하는 경우 원본 테이블에는 한국에서 일하는 사람을 알 수 없기 때문에 불가능)
*/      

--1) 뷰에 정의되어 있지 않은 컬럼을 조작하고자 하는 경우
create or replace view vm_job
as select job_code
   from job;

select *from job;
select *from vm_job;

--insert
insert into vm_job (job_code,job_name)values('J8','인턴');
--job_name이 view에 없어서 오류

--update
update vm_job
set job_name='인턴'
where job_code='J7';
--job_name이 view에 없어서 오류

--delete
delete
  from vm_job
  where job_name='사원';
--job_name이 view에 없어서 오류


--         2) 뷰에 정의되어있는 컬럼 중에 원본 테이블 상에 not null제약 조건이 지정되어있는 경우

create or replace view vm_job
as select job_name
   from job;


select *from job;
select *from vm_job;
--insert
insert into vm_job values('인턴');
--원본테이블에서 job_code가 primary key인데 job_name만 넣으면 기본키가 널값이 되어서 오류가 난다
--실제 원본 테이블에는 (null,'인턴');이라는 뜻이 되는데 job_code는 널겂을 허용하지 않아서 오류ㅜ가 난다.

--update
update vm_job 
 set job_name='인턴'
 where job_name= '사원';
--오류가 나지 않음

--외래키가 걸려있는걸 view로 가져온다면 삭제가 안된다.

--delete할 떄 부모테이블을 view 로 만들었다면 외래키 제약조건도 따져야 한다.
--자식테이블에서 쓰고 있는 제이터라면 삭제가 안된다.

--         3) 산술식, 함수식으로 정의되어 있는 경우(view에 성별이 남과 여로 표현 되어있는데 원본에는 그런 컬럼이 없어서 변경할 수 없다)
create or replace view vm_emp_sal
as select emp_id,emp_name, salary,salary*12 연봉
    from employee;
    
--insert
insert into vm_emp_sal values(301,'김상진',3000000,36000000);
--오류인데 두 가지 오류가 있다. 
--1. not null제약조건인 컬럼의 데이터를 입력하지 않았고, 
--2. 연봉은 원본테이블에는 없는 컬럼이다.

--update(오류) 
update vm_emp_sal
  set 연봉 = 20000000
  where emp_id=214;
--가상 열 오류로 연봉이라는 컬럼이 원본 테이블에 존재하지 않아서 발생

--update (성공)
update vm_emp_dal 
  set salary=2000000
  where emp_id=214;

rollback;

--         4) 그룹함수(sum, avg, count)나 group by절이 포함되어 있는 경우
create or replace view vm_group_dept
as select dept_code, sum(salary) 합계 ,ceil(avg(salary)) 평균 
    from employee
    group by dept_code;

--insert
insert into vm_group_dept values('D3',80000000,4000000);
--view에 insert하면 view에만 insert되는게 아니라 원본 테이블에도 insert가 되기 때문에 입력한 값의 컬럼이 원본테이블에도 존재해야하고 제약조건도 맞아야 한다.

--update
update vm_group_dept
  set 합계=9000000
  where dept_code='D1';
--오류

--delete
delete from vm_group_dept
  where dept_code='D1';

--         5) distinct 구문이 포함된 경우(중복된 값은 뺴는 distinct를 쓴 경우 view에서 변경할 행이 원본의 어떤 컬럼인지 알 수 없다.)

create or replace view vm_job
as select distinct job_code
    from employee;

--insert
insert into vm_job values('J8');
--오류  job테이블에서 가져왔으면 오류가 나지 않는다.

---update
update vm_job
  set job_code='J8'
  where job_code='J7';
  --원본 임플로이 테이블의 직급코드가j7인 사람은 3명인데 그 3명중 누구의 값을 바꿔줄지 정해주지 않아 불가능
  
--delete
delete from vm_job
 where job_code='J7';
 --마찬가지로 원본테이블의 값 중 j2ㅇ인 사람중 누구를 지울지 기준을 정해주지 않아 불가능


--         6) join을 이용하여 여러 테이블을 연결시켜놓은 경우
create or replace view vm_join
as select emp_id, emp_name,dept_title
    from employee
    join department on dept_id=dept_code;

--insert
insert into vm_join values(600,'황미연','회계관리');
--join한 두 테이블 모두 입력이 들어가기 때문에 안되는듯..?

--update(성공)
update vm_join
  set emp_name='김새로'
  where emp_id=201;
  --이거는 또 수정이 된다...??
  
--update(오류)  
update vm_join
  set dept_title='인사관리부'
  where emp_id=200;
--이건 오류가 난다, 아마 바꾸려는 값과 조건이 서로 다른 테이블에 존재해서 그런듯


--delete(성공)
delete vm_join
where emp_id=200;
--이거는 된다...?
rollback;

---------------------------------------------------------------------------------------------------------------------------------------
/*
        *view 옵션
        
        [표현식]
         create[or replace] [force|no force] view 뷰명
         as 서브쿼리
         [with check option]
         [with read only]
         
         1) or replace : 기존에 동일한 뷰가 있다면 덮어쓰기, 없다면 새로 생성
         2) force|noforce
            > force : 서브쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성된다.
            > noforce : 서브쿼리에 기술된 테이블이 실제 존재해야만 뷰가 생성된다.(default)
         3) with check option : dml(update,insert,delete)시 서브쿼리에 기술된 조건에 부합한 값으로만 dml을 가능하도록 함
         4) with read only : 뷰를 조회만 가능(dml문 수행 불가)
*/

--         2) force|noforce(default)
--                noforce
create or replace noforce view vm_emp
as select tcode,tname, tcontent
    from it;
--오류가 난다. // it라는 테이블이 존재하지 않아서 그럼

--force
create or replace force view vm_emp
as select tcode,tname, tcontent
    from it;
-- 경고문: 컴파일 오류와 함꼐 뷰가 생성되었습니다.
--만들수는 있지만 사용할 수는 없다,

insert into vm_emp values(1,'name','content');
--insert 하려는 값의 원본테이블의 컬럼이 존재하지 않아 오류가 난다.
--실제 뷰를 사용하려면 it라는 실존테입르이 있어야 사용가능
create table it(
tcode number,
tname varchar2(20),
tcontent varchar2(100));


--3) with check option
--ex) 임플로이에서 급여가 300만원 이상인 사람을 가져왔을때 급여를 수정하려면 300만원 이상으로만 수정해야한다.
create or replace view vm_emp
as select*
    from employee
    where salary>=3000000;

--update
update vm_emp
  set salary=2000000
  where emp_id=204;
--300만원 이상인 사람만 있는 뷰에서 한 사람의 급요를 200만원으로 하면 뷰에서 행이 하나 줄어든다.
rollback;


--4)with check option을 사용
create or replace view vm_emp
as select *
    from employee
    where salary>=3000000
with check option;

--update
update vm_emp
  set salary=4000000
  where emp_id=204;
--with check option을 쓴 뷰에서 업데이트를 하려면 뷰 생성시 서브쿼리의 조건문에 맞도록 수정해야한다.

--5) with read only : 뷰를 조회만 가능(dml문 수행 불가)
create or replace view vm_emp
as select emp_id,emp_name,bonus
    from employee
    where bonus is not null
    with read only;

delete from vm_emp where emp_id = 204;
--오류 //dml실행 불가
select * from vm_emp;

































































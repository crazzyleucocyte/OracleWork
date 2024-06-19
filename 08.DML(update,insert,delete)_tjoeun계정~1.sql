/*
        *DML(data manipulation language) :데이터 조작 언어
          : 테이블에 값을 삽입(insert)하거나, 수정(update),삭제(delete)하는 구문
          
*/
--=================================================================================================
/*
        *insert
         : 테이블에 새로운 행을 추가하는 구문
         
         [표현식]
         1) insert into 테이블명 values(값1, 값2, 값3.....)
            테이블의 모든 컬럼에 대한 값을 넣고자 할때(한행 추가)
            컬럼의 순서를 지켜서 값을 넣어야함
            
            값의 갯수가 부족하면 => not enough value 오류
            값의 갯수가 많으면 => too many falues 오류

*/
select * from employee;
insert into employee values(300,'강민석','980123-1234567','alstjr7696@tjoeun.or.kr','01057897696','D7','J5'
                            ,4200000,0.2,200,'2015/05/10',null,'N');
--------------------------------------------------------------------------------------------------------------------------------------------
/*
        2) insert into 테이블명(컬럼명, 컬럼명,....)values(값1, 값2,.....);
           : 테이블에 내가 선택한 컬럼에만 값을 삽입할때 사용
             -> 내가 선택한 컬럼값 이외의 값들은 null이 들어가고 default 값이 설정되어있으면 default값이 들어감
             
         **주의
           - 컬럼이 nut null제약조건이 있으면 반드시 값을 넣어야함
             => default값이 설정되어 있으면 안넣어도 됨
*/

insert into employee_copy(emp_id, emp_name, emp_no, job_code, hire_date,phone) 
values('301','박민서','031206-4556789','j5',sysdate,'01033549391');

insert into employee_copy(emp_id, emp_name, emp_no,  hire_date,phone) 
values('302','강서석','031119-3556789',sysdate,'01033547696');

insert into employee_copy(emp_id, emp_name,  hire_date,phone) 
values('304','설현수',sysdate,'01045975186');
--null값 오류
--가독성을 위해 아래처럼 쓸 수도 있다.
insert 
    into employee_copy
        (
            emp_id
            , emp_name
            , emp_no
            , job_code
            , hire_date
            ,phone
            ) 
    values
        (
            '301'
            ,'박민서'
            ,'031206-4556789'
            ,'j5'
            ,sysdate
            ,'01033549391'
        );

--------------------------------------------------------------------------------------------------------------------------------------------
/*
        3)insert into 테이블명(서브쿼리);
          values로 값을 직접 넣는 대신 서브쿼리로 조회된 결과를 모두 insert가능하다.
*/
create table emp_01(
    emp_id varchar2(3),
    emp_name varchar2(20),
    dept_name varchar2(35)
);


--전체 사원들의 사번, 사원명, 부서명 조회
select emp_id, emp_name, dept_title
from employee_copy, department
where dept_code=dept_id(+);

insert into emp_01(select emp_id, emp_name, dept_title
                   from employee_copy, department
                   where dept_code=dept_id(+));

--------------------------------------------------------------------------------------------------------------------------------------------
/*
        *insert all
        2개 이상의 테이블에 각각 insert할때
        사용하는 서브쿼리가 동일한 경우

        [표현식]
        insert all
        into 테이블명1 values(컬럼명, 컬럼명,...)
        into 테이블명2 values(컬럼명, 컬럼명,...)
             서브쿼리;
*/
--테스트할 테이블 2개 생성
 create table emp_dept
 as select emp_id, emp_name,dept_code,hire_date
    from employee
    where 1=0;

 create table emp_manager
 as select emp_id, emp_name,manager_id
    from employee
    where 1=0;

--부서코드가 D1인 사원들의 사번, 이름, 부서코드, 입사일, 사수사번 조회
select emp_id, emp_name, dept_code, hire_date,manager_id
from employee
where dept_code ='D1';

--서브쿼리의 원하는 컬럼만 골라서 insert할 수 있다.
insert all
into emp_dept values(emp_id, emp_name, dept_code, hire_date)
into emp_manager values(emp_id, emp_name, manager_id)
        select emp_id, emp_name, dept_code, hire_date,manager_id
        from employee
        where dept_code ='D1';

--------------------------------------------------------------------------------------------------------------------------------------------
/*
        * 조건을 사용하는 insert all
        
        [표현식]
        insert all
        when 조건1 then
             into 테이블명1 values(컬럼명, 컬럼명,.....)
        when 조건2 then
             into 테이블명2 values(컬럼명, 컬럼명,.....)
        서브쿼리;
*/
-- 2000년도 이전에 입사한 사원들을 저장할 테이블 생성
create table emp_old
as select emp_id, emp_name,hire_date,salary
   from employee
   where 1=0;

-- 2000년도 이후에 입사한 사원들을 저장할 테이블 생성
create table emp_new
as select emp_id, emp_name,hire_date,salary
   from employee
   where 1=0;

insert all
when hire_date<'2000/01/01' then
        into emp_old values(emp_id,emp_name,hire_date,salary)
when hire_date>='2000/01/01' then
        into emp_new values(emp_id,emp_name,hire_date,salary)
select emp_id,emp_name,hire_date,salary
from employee;

--=======================================================================================================================
/*
        *update
         테이블의 데이터를 수정하는 구문
         
         [표현식]
         update 테이블명
         set 컬럼명 = 바꿀값,
             컬럼명 = 바꿀값,
             .....
        [where 조건];    ->**주의: 조건을 생략하면 모든행의 데이터가 변경됨


*/
--department 복사본 테이블 생성
create table dept_copy
as select * from department;

--D9 부서명을 전략기획부로 변경
update dept_copy
set dept_title='전략기획부'
where dept_id='D9';

--employee_cody테이블에서 왕정보의 급여를 1,500,000으로 인상
update employee_copy
set salary=1500000
where emp_name='왕정보';

--employee_copy테이블에서 구정하의 급여를 1,800,000으로 인상하고 보너스는 10
update employee_copy
set salary=1800000,
    bonus = 0.1
where emp_name='구정하';

--전체 사원의 급여를 기존 급여에 10% 인상한 금액 변경
update employee_copy
set bonus= bonus+0.1;

--------------------------------------------------------------------------------------
/*
        *서브쿼리를 사용한 update
        [표현식]
        update 테이블명
        set 컬럼명 = (서브쿼리)
        [where 조건];
*/
--박민서 사원의 급여와 보너스를 전정보 사원의 급여와 보너스값으로 변경
--단일행 서브쿼리
update employee_copy
set salary=(select salary 
            from employee 
            where emp_name='전정보'),
    bonus=(select bonus 
           from employee 
           where emp_name='전정보')
where emp_name = '박민서';

--다중열 서브쿼리
update employee_copy
set (salary,bonus)=(select salary,bonus from employee where emp_name='전정보')
where emp_name = '박민서';

--오정보의 급여와 보너스를 왕정보, 구정하, 선정보,전지연, 장정보
update employee_copy
set (salary,bonus)= (select salary, bonus from employee where emp_name ='오정보')
where emp_name in ('왕정보','구정하','선정보','전지연','장정보');

--아시아 지역에서 근무하는 사원들의 보너스값을 0.3으로 변경
update employee_copy
set bonus=0.3
where local_name in(select local_name 
                    from employee, location, department
                    where dept_code=dept_id
                    and location_id=local_code
                    and local_name like'ASIA%');

update (select *
        from employee_copy)
set bonus=0.4
where emp_name in(select emp_name 
                    from employee_copy, location, department
                    where dept_code=dept_id
                    and location_id=local_code
                    and local_name in('ASIA1','ASIA2','ASIA3'));

update (select *
        from employee_copy, location, department
        where dept_code=dept_id
        and location_id=local_code)
set bonus=0.3
where local_name like'ASIA%';
rollback;

--update시에도 제약조건에 위배되면 안됨
--왕정보의 dept_code를 d10으로 변경
--부모테이블에 D0이 없어서 제약조건에 위배
update employee_copy
set dept_code = 'D0'
where emp_name = '왕정보';
--오류ㅜ

update employee_copy
set dept_code = null
where emp_name = '왕정보';
--오류
-------------------------------------------------------------------------------------------------------------------
/*
        *delete
          :테이블의 데이터를 삭제하는 구문(한 행 단위로 삭제)
          
          [표현식]
          delete from 테이블명
          [where]조건        -->**주의 : 조건이 없으면 모든 데이터 삭제
*/

delete from employee_copy;
rollback;

delete from employee_copy
where emp_name = '왕정보';

delete from emplpyee_copy
where dept_code is null;

/*
        *truncate : 테이블의 전체 행을 삭제할 때 사용하는 구문으로 delete보다 수행 속도가 빠르다

          [표현식]
          truncate table 테이블명;
*/
truncate table employee_copy4;
--   ****주의 롤백이 되지 않으니 신중히 사용할 것.








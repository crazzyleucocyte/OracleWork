/*
        *서브쿼리
          : 하나의 sql문안에 포함된 또 다른 select문
            - 메인 sql문을 위해 보조 역할을 하는 쿼리문

*/

--김정보와 같은 부서의 사원 조회
--1. 김정보의 부서 조회
select emp_name, dept_code
from employee
where emp_name = '김정보' ;

--2. 부서가 d9인 사원 조회
select emp_name
from employee
where dept_code='D9';

--3.위의 단계를 하나의 쿼리문으로 합침
select emp_name
from employee
where dept_code=( select  dept_code
                   from employee
                   where emp_name = '김정보');

--전 직원의 평균급여보다 더 많은 급여를 받는 사원의 사번, 사우너명, 직급코드, 급여 조회
--1. 전 직원의 평균 급여


--2. 평균급여보다 많이 받는 사원들 조회

select emp_id, emp_name, job_code, salary
from employee
where salary >(select round(avg(salary))
                from employee);

------------------------------------------------------------------------------------------------------------
/*
        * 서브쿼리의 구분
          서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라 구분한다.
          
          - 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개 일때(1행 1열)
          - 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러개의 행 일때(다중행 1열)
          - 다중열 서브쿼리 : 서브쿼리의 조회 결과값이 여러열 일때(1행 다중열)
          - 다중행 다중열 서브쿼리 : 서브쿼리의 조회결과값이 여러행, 여러열일때(다중행, 다중열)
          
          >>서브쿼리의 종류가 뭐냐에 따라 서브쿼리 앞에 붙는 연산자가 달라짐
*/
------------------------------------------------------------------------------------------------------------
/*
        1. 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개 일때(1행 1열)
            일반 비교 연산자 사용 가능
            (>,<,>=,<=,=,!=)
*/
--1) 전 직원의 평균 급여보다 더 적게 받는 직원의 사원명, 직급코드,급여를 조회하시오
select emp_name, job_code, salary
from employee
where salary<(
        select avg(salary)
        from employee);

--2) 최저급여를 받는 사원의 사번, 사원명, 급여, 입사일 조회
select emp_id, emp_name, salary, hire_date
from employee
where salary=(select min(salary) from employee);

--3)박정보사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서코드, 급여를 조회
select emp_id, emp_name, dept_code, salary
from employee
where salary>(select salary from employee where emp_name = '박정보');

--4)박정보사원의 급여보다 더 많이 받는 사원들의 사번, 사원명, 부서명, 급여를 조회
-->>오라클
select emp_id, emp_name, dept_title, salary
from employee, department
where dept_id(+)=dept_code and salary>(select salary from employee where emp_name='박정보');

-->>ansi
select emp_id, emp_name, dept_title, salary
from employee
left join department on (dept_id=dept_code)
where salary>(select salary from employee where emp_name = '박정보');

--5) 왕정보 사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회
-->>oracle
select emp_id, emp_name, phone, hire_date,dept_title
from employee, department
where dept_id = dept_code and dept_code = (
select dept_code
from employee
where emp_name = '왕정보');

--> ansi
select emp_id, emp_name, phone, hire_date, dept_title
from employee
left join department on (dept_id=dept_code)
where dept_code=(
select dept_code
from employee
where emp_name = '왕정보');

--5-1) 왕정보 사원과 같은 부서원들의 사번, 사원명, 전화번호, 입사일, 부서명 조회(왕정보 제외)
-->>oracle
select emp_id, emp_name, phone, hire_date,dept_title
from employee, department
where dept_id = dept_code 
and dept_code = (
    select dept_code
    from employee
    where emp_name = '왕정보')
and emp_name !='왕정보';

--> ansi
select emp_id, emp_name, phone, hire_date, dept_title
from employee
left join department on (dept_id=dept_code)
where dept_code=(
    select dept_code
    from employee
    where emp_name = '왕정보')
and emp_name <>'왕정보';

--group by
--6) 부서별 급여합이 가장 큰 부서의 부서코두,급여합 조회
--6.1 부서별 급여합 중 가장 큰 값 하나만 조회
select max(sum(salary))
from employee
group by dept_code;

--6.2 부서별 급여합이 17700000인 부서를 조회
select dept_code, sum(salary)
from employee
group by dept_code
having sum(salary)=(17700000);

-- 합체
select dept_code, to_char(sum(salary),'fml999,999,999')
from employee
group by dept_code
having sum(salary)=(
            select max(sum(salary))
            from employee
            group by dept_code);
            
------------------------------------------------------------------------------------------------------------
/*
        1. 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러개의 행 일때(다중행 1열)
            -  in 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면
                >(비교연산자)any 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클경우
                                        (여러개의 결과값 중에서 가장 작은 값보다 클 경우)
                <(비교연산자)any 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작을 경우
                                        (여러개의 결과값 중에서 가장 큰값보다 작을 경우)
                                        
                비교대상 > any(값1, 값2, 값3) : 3개의 값에서 가장 작은 값보다 비교대상이 더 크냐
                  -- 비교대상>값1 or 비교대상>값2 or 비교대상>값3
                비교대상 < any(값1, 값2, 값3) : 3개의 값에서 가장 큰 값보다 비교대상이 더 작냐
            
*/

--1)조정연 또는 전지연 사원과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여를 조회하시오
select emp_id, emp_name, job_code, salary
from employee
where job_code in (
select job_code
from employee
where emp_name in('전지연','조정연'));

--사원->대리->과장
--2)대리 직급임에도 불구하고 과장직급 급여들 중 최소급여보다 많이 받는 직원의 사번, 사원명, 직급, 급여 조히
--다중쿼리
select emp_id, emp_name, job_name,salary
from employee join job using (job_code)
where job_name = '대리'
and salary>any(
                select salary
                from employee
                where job_code ='J5')
order by 1;

--단일쿼리
select emp_id, emp_name, job_name,salary
from employee join job using (job_code)
where job_name = '대리'
and salary>(
                select min(salary)
                from employee
                where job_code ='J5')
order by 1;



select salary,job_code
from employee
where job_code ='J5';




















































































































/*
        *group by절
        그룹기준을 제시할 수 있는 구문(해당 그룹별로 여러 그룹으로 묶을 수 있음)
        여러개의 값들을 하나의 그룹으로 묶어서 처리하 ㄹ목적으로 사용
*/
select sum(salary)
from employee;--전체 사원을 하나의 그룹으로 묶어서 총합을 구한 결과

--각 부서별 급여의 합계
select dept_code,sum(salary)
from employee
group by dept_code;

--부서별 사원수
select dept_code,count(*)
from employee
group by dept_code;

select dept_code,count(*),sum(salary),round(avg(salary))
from employee
group by dept_code
order by 4;

--각 직급별 직원의 수와 급여의 합계 조회
select count(*),job_code,sum(salary)
from employee
group by job_code;

--각 직급별 직원의 수, 보너스를 받는 사원 수, 급여 합, 평균 급여, 최저급여, 최고급여
select job_code, count(*),sum(decode((bonus),null,0,'1'))"보너스를 받는 사원 수",sum(salary),min(salary),max(salary)
--select job_code, count(*),count(bonus)"보너스를 받는 사원 수",sum(salary),min(salary),max(salary)
from employee
group by job_code;

--group by에 함수식 사용가능
SELECT decode(substr(emp_no,8,1),'1','남','2','여')"성별",count(*)"인원수"
from employee
group by substr(emp_no,8,1);

-- group by 절에 여러 컬럼 기술 가능
select dept_code, job_code,count(*),sum(salary)
from employee
group by dept_code, job_code
order by 1;
---------------------------------------------------------------------------------------
/*
        having 절 : 그룹에 대한 조건을 제시할때 사용(주로 그룹함수식을 가지고 조건을 제시항떄 사용)
        
*/
--각 부서별 평균 급여 조회
select dept_code, avg(salary)
 from employee
 group by dept_code;
 
 --아래 식을 그냥 실행하면 avg는 해당 행 전체의 평균으로 행이 하나만 나와서 부서별 급여 조회가 불가능하다.
 --각 부서별 평균 급여가 300만원 이상인 부서들만 조회(그룹에 대한 조건)
select dept_code, avg(salary)
 from employee
 group by dept_code;


--각 부서별 평균 급여가 300만원 이상인 부서들만 조회(그룹에 대한 조건)
select dept_code, avg(salary)
 from employee
 where avg(salary) >-3000000
 group by dept_code;
-- 오류 : 그룹함수에서 조건은 where 절에서 하면 안도미

--각 부서별 평균 급여가 300만원 이상인 부서들만 조회(그룹에 대한 조건)
select dept_code, avg(salary)
 from employee
 group by dept_code
 having avg(salary)>=3000000;
 
 --문제
 --1. 직급별 총 급여합(단, 직급별급여합이 1000만원 이상인 직급만 조회)
 select job_code, sum(salary)
 from employee
 group by job_code
 having sum(salary)>=10000000;

--2.부서별 보너스를 받는 사원이 없는 부서만 부서코드를 조회
select dept_code, count(bonus)
from employee
group by dept_code
having count(bonus) = 0;

/*
    select문 실행 순서
    1. from
    2. on
    3. join
    4. where
    5. group by
    6. having
    7. select
    8. distint
    9. order by
*/

-----------------------------------------------------------------------------------------------------------
/*
        집계함수 : 그룹별로 산출된 겨로가값에 중간집계를 계산해주는 함수
        rollup/cube => group by절에 기술한다.
        - rollup(컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간집계를 내는 함수
        - cube(컬럼1, 컬럼2): 컬럼1을 가지고 중간집계를 내고 컬럼2를 가지고도 중간집계를 냄
*/
--각 직급별 급여합
select job_code, sum(salary)
from employee
group by cube(job_code)--컬럼이 1개 일때는 group by cube를써도 되지만 의미가 없다.
order by job_code;  

--dept_code, job_code 쌍으로 집계를 낼때
select dept_code,job_code, sum(salary)
from employee
group by cube(dept_code,job_code)
order by dept_code; 

--dept_code, job_code 쌍으로 집계를 낼때
select dept_code,job_code, sum(salary)
from employee
group by rollup(dept_code,job_code)
order by dept_code;

--=============================================================================================
--                                      집합 함수
--=============================================================================================
/*
        *집합 연산자= set operation
         여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
         
         - union : or|합집합(두 쿼리문을 수행한 별과값을 더하 ㄴ후 중복되는 값은 한 번만 조회)    union대신 or를 써도 된다
         - intersect : and|교집합(두 쿼리문을 수행한 결과값중 중복된 결과값 조회)              intersect 대신 and를 써도 된다.
         - union all : 합집합+ 교집합(중복된 값은 2번 표현될 수 있다)
         - minus : 차집합(선행결과값에서 후행결과값을 뺀 나머지
         
         ----집합 연산자를 사용할때는 위 아래 select절의 컬럼을 똑같이 써줘야 한다
*/
---------------------------------1. union -----------------------------------------------------------
--부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들 조회

select emp_name, dept_code, salary
from employee
where dept_code='D5'
union
select emp_name, dept_code, salary
from employee
where salary>3000000;
--D5가 아닌 사람은 300만원 넘게 받는 사람, 300만원 보다 적게 받는 사람들은 d5인 사람

select emp_name, dept_code, salary
from employee
where dept_code='D5' or salary>3000000;
--위와 똑같은 결과값을 내는데 이게 훨씬 짧아서 union은 잘 안쓴다.

---------------------------------2. intersect -----------------------------------------------------------
--부서코드가 'D5'이면서 급여가 300만원 초과인 사원

--intersect
select emp_name, dept_code, salary
from employee
where dept_code ='D5'
intersect
select emp_name, dept_code, salary
from employee
where salary>3000000;

--and
select emp_name, dept_code, salary
from employee
where dept_code ='D5' and salary>3000000;

---------------------------------3. unionall -----------------------------------------------------------
--unionall은 and나 or로 대체할게 없기 떄문에 이거는 조금 쓸것 같다.

--부서코드가 'D5'이면서 급여가 300만원 초과인 사원(중복된 갯수만큼 조회)

select emp_name, dept_code, salary
from employee
where dept_code='D5'
union all
select emp_name, dept_code, salary
from employee
where salary>3000000
order by 1;
-- 부서코드가 d6이면서 급여가 300만원 이상인 사람이 두 번 찍혔다

---------------------------------4. minus -----------------------------------------------------------
--and로 대체 가능하다

--부서코드가 'D6'인 사람들 중에서 급여가 300만원을 초과한 사원들을 뺀 나머지 사원 조회
--minus
select emp_name, dept_code, salary
from employee
where dept_code='D5'
minus
select emp_name, dept_code, salary
from employee
where salary>3000000
order by 1;

--and
select emp_name, dept_code, salary
from employee
where dept_code='D5' and salary<=3000000
order by 1;





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
        2. 다중행 서브쿼리 : 서브쿼리의 조회 결과값이 여러개의 행 일때(다중행 1열)
            -  in 서브쿼리 : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면
                >(비교연산자)any 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 클경우
                                        (여러개의 결과값 중에서 가장 작은 값보다 클 경우)
                            또는 > min()
                <(비교연산자)any 서브쿼리 : 여러개의 결과값 중에서 "한개라도" 작을 경우
                                        (여러개의 결과값 중에서 가장 큰값보다 작을 경우)
                            또는 > max()

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

------------------------------------------------------------------------------------------------------------
/*
        *3. 다중열 서브쿼리
          : 결과값이 한 행이고 커럼수가 여러개일떄
          where절에 비교해야할 컬럼 두 개가 모두 들어가야한다 이 떄
          where (컬럼1, 컬럼2)=(다중열 서브쿼리)
          이렇게 하면 된다.
*/

--1) 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 사원들의 사원명, 부서코드, 직급코드, 입사일 조회
--1.1 장정보 사원의 부서코드, 직급코드
-- 다중열 서브쿼리를 단일열 서브 쿼리 두개를 이용
select dept_code, job_code
from employee
where emp_name = '장정보';

select emp_name, dept_code, job_code, hire_date
from emoployee
where dept_code =장정보의 부서코드 and job_code = 장정보의 직급코드;

select emp_name, dept_code, job_code, hire_date
from employee
where dept_code =(select dept_code
                  from employee
                  where emp_name = '장정보'
) and job_code =(select job_code
                 from employee
                 where emp_name = '장정보');

--위의 쿼리를 다중열 서브쿼리로 변경한다.
select emp_name, dept_code, job_code, hire_date
from employee
where (dept_code,job_code) =(select dept_code, job_code
                             from employee
                             where emp_name = '장정보');

--지정보 사원과 같은 직급코드, 같은 사수를 가지고 있는 사원들의 사번, 사원명, 직급코드, 사수번호 조회
select emp_id, emp_name, job_code, manager_id
from employee
where (job_code,manager_id)=(select job_code, manager_id
                             from employee
                             where emp_name = '지정보');

select emp_id, emp_name, job_code, manager_id
from employee
where  emp_name = '지정보';

------------------------------------------------------------------------------------------------------------
/*
        *4. 다중행 다중열 서브쿼리
         : 결과값이 여러행이고 컬럼수가 여러개일때
          --다중행이 들어가면 in을 써줘야 한다.

*/
--1)각 직급별 최소급여 금액을 받는 사원의 사번, 시원명, 직급코드, 급여 조회
--1.1 각 직급별 최소급여
select job_code, min(salary)
from employee
group by job_code;

select emp_id, emp_name, job_code,salary
from employee
group by job_code = 'J1' and salary=8000000
            .....
            
select emp_id, emp_name, job_code,salary
from employee
where (job_code,salary)=('J1',8000000)
      or(job_code,salary)=('J2',3700000);
      .....
      
      --서브쿼리
select emp_id, emp_name, job_code,salary
from employee
where(job_code,salary) in(select job_code, min(salary)
                          from employee
                          group by job_code);

--2)각 부서별 최고 급여를 받는 사원들의 사번, 사원명, 부서코드, 급여 조회
select emp_id, emp_name,dept_code, salary
from employee
where (dept_code,salary) in(select dept_code, max(salary)
                            from employee
                            group by dept_code);
select dept_code, max(salary)
                            from employee
                            group by dept_code;

------------------------------------------------------------------------------------------------------------
--인라인 뷰

/*
        인라인 뷰(inline view)
        :서브쿼리를 수행한 결과를 마치 테이블처럼 사용
         from절에 서브쿼리 작성
         
         --주로 사용하는 예 : 이렇게 하는거를 top-n분석이라고 하는데 이 뜻은 top에서 상위n번째만 가져올때 쓰인다.
*/

--1) 사원들의 사번, 이름, 보너스를 포함한 연봉, 부서코드 조회(연봉에 null이 나오면 안된다.)
--     단, 보너스 포함 연봉이 3000만원 이상인 사원들만 조회 

select emp_id, emp_name, (salary*nvl((1+bonus),1)*12) 연봉,dept_code
from employee
where (salary*nvl((1+bonus),1)*12)>=30000000;

--별칭을 사용하려면 inline view 사용
select *
from(select emp_id, emp_name, (salary*nvl((1+bonus),1)*12) 연봉,dept_code
from employee)
where 연봉>=3000000;

--이 중에서 사번과 이름만 가져오고 싶을때
select b.emp_id,b.emp_name, 연봉, emp_no
from employee A,(select emp_id, emp_name, (salary*nvl((1+bonus),1)*12) 연봉,dept_code
from employee) B
where 연봉>=3000000;

-- top-n분석
--전 직원중 급여가 가장 높은 상위 5명만 조회
--* rownum(행의 번호를 붙여주는것) :오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 순번 부여
--그냥 칼럼을 쓰는곳에 rownum이라고 쓰면 된다.
-- 원래 DB에서 조회할떄는 순서가 없어서 몇 변째꺼를 가져오시오 이런게 존재하지 않는데 rownum 을 쓰면 이게 가능하다.

select rownum emp_id, emp_name, salary
from employee;

--급여 내림차순 정렬 -rownum의 순서가 바뀌어 있다.
select rownum emp_id, emp_name, salary
from employee
order by salary desc;

--inline view를 사용하지 않고 상위 몇 명 가져왔을떄
select rownum emp_id, emp_name, salary
from employee
where rownum <=10
order by salary desc;


--그래서 inline view로 먼저 내림차순 정렬을 해주고 순서를 다시 매긴다.
select rownum ,e.*
from (select emp_id, emp_name, salary
      from employee
      order by salary desc) E
where rownum<=5;

--가장 최근에 입사한 사원 5명의 사원명, 급여, 입사일 조회
select rownum, E.*
from(select emp_name, salary, hire_date
     from employee
     order by hire_date)E
where rownum<6;
--이렇게 써줄수도 있다.
select rownum, emp_name, salary, hire_date
from(select *
     from employee
     order by hire_date)E
where rownum<6;

--3)각 부서별 평균 급여가 높은 3개 부서의 부서코드, 평균급여 조회
--컬럼에 rownum을 안써줘도 where절에서 쓸 수 있다.
select e.* 
from (select dept_code, ceil(avg(salary)) 평균급여
      from employee
      group by dept_code
      order by 평균급여 desc) e
where rownum<=3;

-------------------------------------------------------------------------------------------
/*
        *with
         : 서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 from절에 기술
         
         -장점
          같은 서브쿼리가 여러번 사용될 경우 중복작성을 피할 수 있고, 실행속도가 빠르다. 
          주로 minus나 union을 쓸때 사용한다.
*/
--일회성으로 세미콜론(;)이 붙은 해당 쿼리에서만 사용 가능하고 세미콜론 뒤에 쿼리를 작성하여 호출하면 오류가 난다.
--minus나 union 같은 from절을 2번 쓸때에서 쓸모가 있다.
with topn_sal as(select dept_code, ceil(avg(salary)) 평균급여
                 from employee
                  group by dept_code
                  order by 평균급여 desc)

select *
from topn_sal
where rownum<3;

--============================================================================================
/*
        *순위 매기는 함수(windoe function)
         rank()over(정렬기준)|dense_rank()over(정렬기준)
         - rank()over(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위 계산
                                ex) 공동1위가 2명이면 그 다음 순위는 3위
         - dense_rank()over(order by 정렬기준): 동일한 순위 이후 그 다음 등수를 무조건 1씩 증가 시킴
                                ex) 공동 1위가 2명이면 그 다음 순위는 2위
*/

--급여가 높은 순서대로 순위를 매겨서 사원명, 급여, 순위 조회
select emp_name, salary, rank()over(order by salary desc) 순위
from employee;
--같은 급여면 동순위

select emp_name, salary, dense_rank()over(order by salary desc) 순위
from employee;
--같은 급여일때 다른 순위

--급여가 상위 5위인 사람의 사원명, 급여, 순위 조회
select emp_name, salary, rank()over(order by salary desc) 순위
from employee
where rank()over(order by salary desc)<=5;
--오류 : 윈도우 함수(rank over, dense_rankover)는 where절에서 사용하지 못하고 select에서만 사용할 수 있다.
--그래서 인라인 뷰로 rnack over를 만들어서 사용한다

-->인라인 뷰 사용
select*
from (select emp_name, salary, rank()over(order by salary desc) 순위
        from employee)
where 순위<=5;

--with와 같이 사용
with topn_salary as (select emp_name, salary, rank()over(order by salary desc) 순위
                     from employee)
select *
from topn_salary
where 순위<=5;

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------- 연습문제 --------------------------------------------------------
-- 1. 2020년 12월 25일의 요일 조회
select to_char(to_date('201225','yymmdd'),'day') from dual;
-- 2. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 사원명, 주민번호, 부서명, 직급명 조회    
select emp_name, emp_no,dept_code, job_name
from employee
left join job using(job_code)
where (substr(emp_no,1,2) between '70'and'79')and substr(emp_no,8,1)='2' and emp_name like '전%';
-- 3. 나이가 가장 막내의 사번, 사원명, 나이, 부서명, 직급명 조회

select emp_id, emp_name, to_char((to_date(substr(emp_no,1,2),'yyyy')-extract(year from sysdate)),'yy'),dept_title,job_name
from employee e, job J, department
where to_date(substr(emp_no,1,6),'yymmdd')=(select min(to_date(substr(emp_no,1,6),'yymmdd'))
                                            from employee)
      and dept_id= dept_code and j.job_code=e.job_code;
      
      
-- 4. 이름에 ‘하’가 들어가는 사원의 사번, 사원명, 직급명 조회
select emp_id, emp_name,job_name
from employee
left join job using(job_code)
where emp_name like'%하%';

-- 5. 부서 코드가 D5이거나 D6인 사원의 사원명, 직급명, 부서코드, 부서명 조회
select emp_name, job_name, dept_code, dept_title
from employee E, job j, department
where dept_code in ('D5','D6') and dept_code = dept_id and e.job_code = j.job_code;
-- 6. 보너스를 받는 사원의 사원명, 보너스, 부서명, 지역명 조회
select emp_name, bonus, dept_title, local_name
from employee,department, location
where local_code = location_id and bonus is not null and dept_code = dept_id;
-- 7. 모든 사원의 사원명, 직급명, 부서명, 지역명 조회
select emp_name, job_name, dept_title, local_name
from employee
left join department on(dept_code=dept_id)
left join job using(job_code)
left join location on(location_id=local_code);
-- 8. 한국이나 일본에서 근무 중인 사원의 사원명, 부서명, 지역명, 국가명 조회 
select emp_name, dept_title, local_name, national_name
from employee, department, location l, national n
where national_name in('한국','일본')
    and dept_code=dept_id 
    and location_id=local_code 
    and l.national_code(+)=n.national_code;
-- 9. 하정연 사원과 같은 부서에서 일하는 사원의 사원명, 부서코드 조회
select emp_name, dept_code
from employee
where dept_code = (select dept_code from employee where emp_name ='하정연');
-- 10. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 사원명, 직급명, 급여 조회 (NVL 이용)
select emp_name, job_name, salary*(1+nvl(bonus,0))*12
from employee
left join job using(job_code)
where bonus is null and job_code in('J4','J7');

-- 11. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
select count(end_date) 퇴사한사람,count(nvl2(end_date,null,1)) 퇴사안한사람
from employee;

-- 12. 보너스 포함한 연봉이 높은 5명의 사번, 사원명, 부서명, 직급명, 입사일, 순위 조회
select *
from (select emp_id, emp_name, dept_title, job_name, hire_date, rank()over(order by (salary*(1+nvl(bonus,0))*12) desc),(salary*(1+nvl(bonus,0))*12)   
                                     from employee E, job j, department
                                    where dept_code=dept_id and j.job_code = e.job_code) 
where rownum<=5;

-- 13. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서명, 부서별 급여 합계 조회
--	13-1. JOIN과 HAVING 사용                

select dept_title,sum(salary)
from employee,department
where dept_id=dept_code
group by dept_title
having sum(salary)<(select sum(salary) from employee)*0.2;

--	13-2. 인라인 뷰 사용
select dept_title,sum(salary)
from employee,(select sum(salary)*0.2 "전체급여" from employee),department
where  dept_id=dept_code
group by dept_title
having sum(salary)<(select sum(salary) from employee)*0.2;
--	13-3. WITH 사용
with sum as(select sum(salary)*0.2 "전체급여" from employee)

select dept_title,sum(salary)
from sum, employee, department
where dept_id=dept_code
group by dept_title
having sum(salary)<(select sum(salary) from employee)*0.2;;

-- 14. 부서명별 급여 합계 조회(NULL도 조회되도록)
select dept_title,sum(salary)
from employee, department
where dept_code= dept_id(+)
group by dept_title;
-- 15. WITH를 이용하여 급여합과 급여평균 조회
with sal as(select sum(salary), avg(salary) from employee)
select*
from sal;

































































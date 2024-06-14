/*
        join
        두개 이상의 테이블에서 데이터를 조회하고자 할 떄 사용하는 구문
        조회결과는 하나의 결과물(result set)로 나온다.
        
        => 관계형 데이터베이스에서 sql문을 이용한 테이블간의 '관계'를 맺는 방법이 join이다.
        
        join은 크게 "오라클 전용구문"과"ansi구문"(ansi : 미국 국립표준협회에서 만들었다)이 있다.
        
        
                                [join 용어 정리]
        --------------------------------------------------------------------------------
        |           오라클 전용 구문              |                 ansi                  |        
        --------------------------------------------------------------------------------
        |               등가조인                  |   내부조인(inner join)=>join using|on  |                    
        |            (equal join)               |   자연조인(natural join) => join using | --각 테이블마다 동일한 컬럼이 한개만 있을떄 사용
        --------------------------------------------------------------------------------
        |               포괄조인                  |       왼쪽 외부조인(left outer join)    |
        |            (left outer)               |      오른쪽 외부조인(right outer join)   |
        |           (right outer)               |       전체 외부조인(full outer join)    |
        --------------------------------------------------------------------------------
        |         자체조인(self join)            |                join on                |
        |     비등가 조인(nonequal join)          |                                       |
        --------------------------------------------------------------------------------
        |    카테시안 곱(cartesian product)       |           교차 조인                    |
        --------------------------------------------------------------------------------




*/
--=============================================================================================
--                                         1. 등가조인/내부조인
--=============================================================================================
/*
        1. 등가조인/내부조인
          연결시키는 컬럼의 값이 "일치하는 행들만" 조인되어 조회(=일치하지 않는 행은 조회에서 제외)
*/
------------------------------------------------------------------------------------------------------------
/*
        >> 오라클 전용 구분
            - from절에 조회하고자하는 테이블들을 나열(,구분자로)
            - where절에 매칭시킬 컬럼(연결고리)에 대한 조건을 제시함
*/

--임플로이 테이블의 부서코드는 dept_code이고 department테이블에서 부서코드는 dept_id이다.
--1) 연결한 컬렴명이 다른 경우(employee : dept_code, department : dept_id)
--사원 사원명, 부서콛, 부서명을 조회
--테이블 두 개를 join했을때 A테이블의 행에 B테이블의 어떤 값이 메치가 되는지 기준이 있지 않아서 where절을 쓰지 않을 경우
--행의 갯수는 A 테이블의 행 갯수 * B 테이블의 행 갯수가 조회된다 
--여기서 where절에 조건을 걸어주어 a테이블의 값에 b테이블의 값을 메칭시켜주는것이다.
select emp_id, emp_name, dept_id,dept_title
from employee, department
where dept_code= dept_id
order by 1, department.dept_id;
--일치하는 행이 없으면 조회에서 제외

select *
from employee
join department;

--2)연결할 컬럼명이 같은경우(employee테이블의 job_code와 job테이블의 job_code의 컬럼명이 같다)
--사번, 사원명, 직급콛, 직급명
select emp_id, emp_name, job_code, job_name
 from employee, job
 where job_code=job_code;
 --조회 결과"열의 정의가 애매합니다."
 --이 뜻은 where의 job_code 두 개가 어떤 테이블의 job_code인지 기준을 말해주지 않아서 생기는 오류이다.

select emp_id, emp_name, employee.job_code, job.job_name
 from employee, job
 where employee.job_code=job.job_code;
 
 select emp_id, emp_name, A.job_code , B.job_name
 from employee A, job B
 where A.job_code=B.job_code;
--두 테이블의 컬럼명이 같을 경우 "테이블명.컬럼명"이나 테이블에 별칭을 지정하여 기준을 겅해주어야 한다.
--테이블명에 별칭을 정해두면 컬럼명 앞에 해당 테이블의 별칭을 써서 기준을 알려줄 수도 있다.

------------------------------------------------------------------------------------------------------------
/*
        >> ansi 구문
            - from절에 기준이 되는 테이블을 하나만 기술
            - join절을 작성하여 같이 조회하고자 하는 테이블을 기술 + 매칭시킬 컬럼에대한 기술
            - join using, join on(컬럼명이 같을때와 다를때)
       
*/
--1) 연결한 컬렴명이 다른 경우(employee : dept_code, department : dept_id)
--      => 오로지join on  구문만 사용

--사원 사원명, 부서코드, 부서명을 조회
select emp_id, emp_name, dept_code, dept_title
 from employee
 join department on(dept_code=dept_id);

------------------------------------------------------------------------------------------------------------
--2)연결할 컬럼명이 같은경우(employee테이블의 job_code와 job테이블의 job_code의 컬럼명이 같다)
--연결할 컬럼명이 같을 경우 join on과 join using 둘 다 사용 가능하다

--사번, 사원명, 직급코드, 직급명
--join using 사용
select emp_id, emp_name,job_code, job_name
from employee
join job using(job_code);
--join using은 컬럼 명이 같은 경우 using뒤에 하나의 컬럼명만 넣어도 조회가 된다.

--join on 사용 => 두 테이블의 컬럼명을 모두 기술
select emp_id, emp_name,E.job_code, job_name
from employee E
join job J on(E.job_code=J.job_code);

------------------------------------------------------------------------------------------------------------

--3) 추가 조건이 있을때 
--직급이 대리인 사원의 사번, 사원명, 직급명, 급여를 조회
--        >> 오라클 전용 구분
    select emp_id, emp_name,job_name, salary
    from employee E, job J
    where E.job_code= j.job_code
          and job_name = '대리';

--      >> ansi구문
select emp_id, emp_name,job_name, salary
    from employee
    join job using(job_code)
    where job_name = '대리';

-----------------------------------실습문제-------------------------------------
--1. 부서가 인사관리부인 사원들의 사번,이름, 부서명, 보너스 조회
-->>오라클
select emp_id, emp_name, dept_title, bonus
from employee A, department D
where dept_id=dept_code and dept_title='인사관리부';
-->>ansi
select emp_id, emp_name, dept_title, bonus
from employee
join department on(dept_id=dept_code)
where dept_title='인사관리부';

-- 2. DEPARTMENT과 LOCATION을 참고하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
--  >> 오라클 전용 구문
select dept_id, dept_title, local_code,local_name
from department D,location L
where d.location_id=l.local_code;
--  >> ANSI 구문
select dept_id, dept_title, local_code, local_name
from department
join location on(location_id= local_code);

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
--  >> 오라클 전용 구문
select emp_id, emp_name, bonus, dept_title
from employee E, department D
where e.dept_code = d.dept_id and bonus is not null;

--  >> ANSI 구문
select emp_id, emp_name, bonus, dept_title
from employee E
join department D on(E.dept_code = d. dept_id)
where bonus is not null;

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
--  >> 오라클 전용 구문
select emp_name, salary, dept_title
from employee e, department D
where e.dept_code = d.dept_id and dept_title<>'총무부';

--  >> ANSI 구문
select emp_name, salary, dept_title
from employee
join department on(dept_id = dept_code)
where dept_title ^='총무부';

-----------------------------------------------------------------------------------------------------------------------------
/*
        2.포괄조인/ 외부조인
        :두 테이블 간의 join시 일치하지 않는 행도 포함시켜 조회가능
        단, 반드시left, tight를 지정해야됨(기줌니 되는 테이블 지정)
*/

--사원명, 부서명, 급여,연봉
select emp_name, dept_code,dept_title,salary, salary*12 연봉
from employee, department
where dept_code = dept_id;
--부서배치가 안된 사원 2명 제외, 사원이 없는 부서 제외 되었다.
--부서에 배정된 사원이 업슨ㄴ 부서 제외


--사원명, 부서명, 급여,연봉(부서배치가 안된 사원도 모두 조회)
--1) left[outer]join : 두 테이블 중 왼쪽에 기술된 테이블을 기준으로 join
-- >> ansi구문
select emp_name, dept_code,dept_title,salary, salary*12 연봉
from employee
left join department on (dept_code=dept_id);
--모든 사원이 조회되었다.
--소속 부서가 없는 사람도 null값으로 출력되었다.

-- >> oracle 전용 구문
--기준이 되는 테이블의 반대쪽에 (+)을 넣는다.
select emp_name, dept_code,dept_title,salary, salary*12 연봉
from employee, department
where dept_code=dept_id(+);
    --기준으로 삼고자하는 테이블의 반대편 테이블의 컬럼 뒤에(+) 붙이기

--2) right[outer]join : 두 테이블 중 오른쪽에 기술된 테이블을 기준으로 join
-- >> ansi구문
select emp_name, dept_code,dept_id,dept_title,salary, salary*12 연봉
from employee
right join department on (dept_code=dept_id);
--department 테이블을 기준으로 join했기 때문에 D3부서에 사원이 없는데도 null값으로 출력되었다.

-- >> oracle 전용 구문
--기준이 되는 테이블의 반대쪽에 (+)을 넣는다.
select emp_name, dept_code,dept_title,salary, salary*12 연봉
from employee, department
where dept_code(+)=dept_id;

--3) full[outer]join : 두 테이블이 가진 모든 행 조회 (단 오라클 전용 구문은 없음)

select emp_name, dept_title,salary, salary*12 연봉
from employee
full join department on (dept_code=dept_id);
--사원 중 부서가 없는 사람과, 부서 중 사원이 없는 부서도 조회가 되었다.

-----------------------------------------------------------------------------------------------------------------------------
/*
        3.비등가조인                (dept_code=dept_id)
         :매칭시킬 컬럼에 대한 조건식 작성시 '='(등호)를 사용하지 않는 join
*/

--사원명, 급여, 급여레벨 조회
--  >> 오라클 전용 구문
select emp_name, salary , sal_level
from employee, sal_grade
where salary between min_sal and max_sal;

-- >> ansi구문
select emp_name, salary, sal_level
from employee
join sal_grade on (salary between min_sal and max_sal);

-----------------------------------------------------------------------------------------------------------------------------
/*
        4.자체 조인              
         :같은 테이블을 다시 한번 조인하는 경우
         ex) employee에서 사수 사번을 이용해 사수 이름을 join 하는 경우
*/

--전체 사원의 사원번호, 사원명, 부서코드, 사수번호, 사수명, 사수부서코드
-- >>오라클 전용 구문
select A.emp_id, A.emp_name, A.dept_code,
        b.emp_id,b.emp_name,b.dept_code
from employee A, employee B
where a.manager_id =b.emp_id;

select A.emp_id, A.emp_name, A.dept_code,
        b.emp_id 사수번호,b.emp_name 사수이름,b.dept_code 사수부서코드
from employee A, employee B
where a.manager_id =b.emp_id(+);
--(+)를 넣어서 사수가 없는 사원도 출력이 되었다.

-- -> ansi구문
select A.emp_id, A.emp_name, A.dept_code,
        b.emp_id 사수번호,b.emp_name 사수이름,b.dept_code 사수부서코드
from employee A
left join employee B on( a.manager_id =b.emp_id);

-----------------------------------------------------------------------------------------------------------------------------
/*
        5.다중 조인              
         :1개 이상의 테이블을 join할 
*/

--사원, 사원명, 부서명, 지역명
-->> 오라클 전용 구문(left join을 하지 않으면 null 제외)
select emp_id, emp_name, dept_title, job_name,e.job_code
from employee E, department, job j
where dept_id(+)=dept_code and e.job_code = j.job_code;
--추가 테이블을 from에 이어서 쓰고 where절에 조건 작성

--ansi 구문
select emp_id, emp_name, dept_title, job_name
from employee E
 left join department on (dept_id=dept_code)
 join  job j using(job_code);

--추가 테이블을 join 하나당 하나에 써서 추가 테이블이 2개 인 경우 join도 두 번 쓴다.

--사번, 사원명, 부서명, 지역명 조회
-->> oracle
select emp_id, emp_name, dept_title, local_name
from employee, department, location
where dept_id(+)=dept_code and local_code(+)=location_id;
--다중 조인에서 left, right join을 하려면 left, right을 한 번이 아닌 두 번 써줘야 한다.


-->>ansi
select emp_id, emp_name, dept_title, local_name
from employee
left join department on(dept_id=dept_code)
left join location on(local_code=location_id);
--다중 조인에서 left, right join을 하려면 left, right을 한 번이 아닌 두 번 써줘야 한다.

------------------------------------------  실습 문제  -------------------------------------------
-- 1. 사번, 사원명, 부서명, 지역명, 국가명 조회(EMPLOYEE, DEPARTMENT, LOCATION, NATIONAL 조인)
--  >> 오라클 전용 구문\
select emp_id, emp_name, dept_title, LOCAL_NAME,national_name
from EMPLOYEE, DEPARTMENT, LOCATION lo, NATIONAL na
where dept_id(+)=dept_code and location_id=local_code(+) and lo.national_code=na.national_code(+);

--  >> ANSI 구문
select emp_id, emp_name, dept_title, LOCAL_NAME,national_name
from EMPLOYEE 
left join DEPARTMENT on(dept_id=dept_code) 
left join LOCATION on(location_id=local_code)
left join NATIONAL using(national_code);


-- 2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회 (모든 테이블 다 조인)
--  >> 오라클 전용 구문
select emp_id, emp_name,dept_title, local_name, national_name,sal_level
from EMPLOYEE, DEPARTMENT, LOCATION lo, NATIONAL na, sal_grade
where dept_id(+)=dept_code 
and location_id=local_code(+) 
and lo.national_code=na.national_code(+) 
and salary between  min_sal and max_sal
order by 1;
--  >> ANSI 구문
 select emp_id, emp_name, dept_title, LOCAL_NAME,national_name,sal_level
from EMPLOYEE 
left join DEPARTMENT on(dept_id=dept_code) 
left join LOCATION on(location_id=local_code)
left join NATIONAL using(national_code)
join sal_grade on( salary between  min_sal and max_sal)
order by 1;












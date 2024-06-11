/*
(')홑따옴표 : 문자열
(")쌍따옴표 : 컬럼명
*/
/*
    <select>
    데이터 조회할 때 사용하는 구문
    
    >> RESULT SET : SELECT구문을 통해서 조회된 결과물(즉, 조회된 행들의 집합)
    
    [표현법]
    SELECT 조회하고자하는 컬럼명, 컬렴명, ....(내가 원하는 컬럼명)
    FROM 테이블명;(너무 많을 경우 엔터치고 아레에 프롬을 써도 된다.)
*/

-- EMPLOYEE 테이블의 모든 컬럼(*)조회

SELECT *
FROM employee;

SELECT* FROM department;
SELECT* FROM job;
SELECT JOB_CODE FROM job;
--EMPLOYEE 테이블에서 사번, 이름, 급여만 조회

SELECT EMP_ID, EMP_NAME, SALARY FROM employee;

--DEPARMENT TABLE에서 부서코드, 부서명만 조회
SELECT DEPT_ID, DEPT_TITLE
FROM department;
--1, JOB테이블 직급명만 조회
SELECT JOB_NAME
FROM job;
--2. DEPARTMENT 테이블의 모든 컬럼 조회
SELECT * FROM department;
--3. DEPARTMENT 테이블의 부서 코드, 부서명만 조회
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;
--4. EMPLOYEE 테이블의 사원명, 이메일, 전화번호, 입사일, 급여조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY
FROM employee;

/*
        <컬럼값을 통한 산술 연산>
        select절의 컬럼명 작성부부네 산술 연산 기술 가능(이때 산술연산된 겨로가 조회)
*/
--  employee테이블에서 사원명, 사원의 연봉(급여*12) 조회

select emp_name, salary*12
    from employee;

--EMPLOYEE 테이블의 사원명, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS FROM employee;

--EMPLOYEE 테이블 사원명, 급여, 보너스, 연봉, 보너스를 포함한 연봉(급여 +(보너스*급여))
SELECT EMP_NAME, SALARY, BONUS, SALARY*12, SALARY*12+SALARY+BONUS 
    FROM employee;   
    --> 산술연산 중 NULL값이 존재할 경우 산술연산한 결과값도 무조건 NULL이 됨
    
-- EMPLOYEE 테이블에서 사원명, 입사일, 근무일수(오늘날짜-입사일)
-- DATE형태 연산 가능 : 결과값은 일단위
-- * 오늘 날짜 가져오는 명령어는 SYSDATE이다.

SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE
    FROM employee;
-- 소수점까지 나오는 이유는 시간과 초 단위까지 계산하기 때문
----------------------------------------------------------------------------------
--연봉을 계산해서 출력했을때 '연봉'이 아니라 급여*12로 나왔는데 컬럼명의 별칭을 지정해줄수 있으므로 보기 편하게 할 수 있다.
/*
        <컬럼명 별칭 지정하기>
        산술연산시 컬럼명이 산술에 들어간 수식 그대로 됨, 이때 별칭을 부여하면 별칭이 컬럼명이 된
        
        [표현법]
        1. 컬럼명 별칭
        2. 컬럼명 AS 별칭
        3. 컬럼명 "별칭"
        4. 컬럼명 AS "별칭"
        보통 1, 2, 3을 자주 쓴다.
*/

SELECT EMP_NAME, SALARY, BONUS, SALARY*12 "\연봉(원)", SALARY*12+SALARY*BONUS AS 총연봉 
    FROM employee;   
--특수기호, 띄어쓰기를 할 경우 "(쌍따옴표)를 꼭 써야한다.

--위의 예제에서 사원명, 급여, 보너스, 연봉(원), 총 연봉 별칭 부여하기

SELECT EMP_NAME 사원명, SALARY "급여", BONUS "보너스", SALARY*12 "연봉(원)", SALARY*12+SALARY*BONUS "총 연봉"
  FROM employee;
  
  /*
        <리터럴>
        임의로 지정한 문지열(')
        
        SELECT절에 리터럴을 넣으면 마치 테이블 사엥 조냊하는 데이터처럼 조회 가능
        조회된 ERXULT SET의 모든 행에 반복적으로 같이 출력
*/
--EMPLOYEE 사번, 사원명, 급여조회- 칼럼을 하나 만들어서 원을 넣어주도록함
--컬럼을 만들러주는거
SELECT EMP_ID, EMP_NAME, SALARY, '원' "단위" FROM employee;

-------------------------------------------------------------
/*
        <연결연산자 : ||>
        여러 컬럼값을 마치 하나의 컬럼값인것처럼 연결하거나, 컬럼값과 리터럴을 연결할 수 있다.
        두 개의 컬럼값을 붙여서 하나의 컬럼으로 출력할 수 있도록하는 듯
*/
-- EMPLOYEE 사번, 사원명, 급여를 하나의 컬럼으로 조회
SELECT EMP_ID|| EMP_NAME|| SALARY "사원의 급여"FROM employee;
--컬럼 구분을 ,대신에 ||로 한다.

--컬럼값과 리터럴값 연결
SELECT EMP_NAME||'의 월급은'|| SALARY||'원 입니다.' FROM employee;

SELECT EMP_ID, EMP_NAME, SALARY||'원' FROM employee;
--숫자만 있는 경우 오른쪽 정렬이고 문자는 왼쪽 정렬이다.

----------------------------------------------------------------------------------
/*
        <Distinct>
        칼럼에 중복된 값들은 한번씩만 표시하고자할때 사용

*/
--      employee에 부서코드 중복제거 조회
SELECT distinct dept_code from employee;

--employee에 직급코드 중복제거 조회
select distinct job_code from employee;

--주의사항 : distinct는 select절에 딱 한 번만 기술 가능

--select distinct dept_code distinct job_code
select distinct dept_code, job_code from employee;
--두 컬럼의 조합중 중복되는 값 제거

-----------------------------------------------------
/*
        <where절>
        조회하고자 하는 테이블로부터 특정 조건에 만족하는 데이터만 조회할 떄
        이 때 where절에 조건식을 쓰면된다.
        조건식에서는 다양한 연산자 사용가능
        
        [표현법]
        select 컬럼명,컬럼명,...... 
        from 테이블명
        where 조건식;
        
        -비교 연산자
        [ >, <, >=, <= ]   --> 대소비교
        =                  --> 같은지 비교
        [ !=, ^=, <> ]     --> 같지 않은지 비교
*/

--EMPLOYEE에서 부서코드가 'D9'인 사원들의 모든 컬럼 조회
SELECT * FROM EMPLOYEE WHERE DEPT_CODE ='D9'; 

--EMPLOYEE 에서 부서코드가 'D1'인 사원들의 사원명, 급여, 부서코드 조회
SELECT EMP_NAME, SALARY, DEPT_CODE FROM employee WHERE DEPT_CODE = 'D1';

--EMPLOYEE 에서 부서코드가 'D1'이 아닌 사원들의 사원명, 이메일, 부서코드 조회
SELECT EMP_NAME, EMAIL, DEPT_CODE FROM employee WHERE DEPT_CODE <> 'D1';

--EMPLOYEE에서 급여가 4백만원 이상이 ㄴ사원들의 사우너명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE,SALARY FROM employee WHERE SALARY>=4000000;

--EMPLOYEE에서 재직중인 사원의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE FROM EMPLOYEE WHERE ENT_YN ^= 'Y';

--1. 급여가 300만원 이상인 사원들의 사우너명, 급여, 입사일, (연봉)조회
SELECT EMP_NAME, SALARY, HIRE_DATE,SALARY*12 "연봉"FROM employee WHERE SALARY>=3000000;
--2. 연봉이 5000만원 이상인 사원들의 사원명, 급여, (연봉), 부서코드 조회
SELECT EMP_NAME, SALARY, HIRE_DATE,SALARY*12"연봉",DEPT_CODE FROM employee WHERE SALARY*12>=50000000;
--3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급코드,(퇴사여부)조회
SELECT EMP_ID,EMP_NAME, JOB_CODE, ENT_YN 퇴사여부 FROM employee WHERE JOB_CODE ^='J3';


----------------------------------------------------------------------
        /*
        <논리연산자>
        and(그리고)
        or(또는)
*/

--부서코드가 'D9'이면서 급여가 300만원 이상인 사원들의 사우너명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM employee WHERE DEPT_CODE='D9' AND SALARY>3000000;

--EMPLOYEE에서 급여가 350만원 이상 600만원 이하인 사람드의 사우너명, 사번, 급여 조회
SELECT EMP_NAME, EMP_ID,SALARY FROM employee WHERE SALARY>=3500000 AND SALARY<=6000000;

----------------------------------------------------------------------
/*

        <BETWEEN AND>
        조건식에서 사용되는 구문으로 ~이상 ~이하인 범위에 대한 조건을 사용하는 연산다
        [표현법]
        비교대상 컬럼 BETWEEN 하한값 AND 상한값
        -> 해당 컬럼값이 하한값 이상이고 상한값 이하
*/
SELECT EMP_NAME, EMP_ID,SALARY 
FROM employee 
WHERE SALARY BETWEEN 3500000 AND 6000000;

--입사일이 1990년대인 사원
SELECT EMP_NAME, hire_date FROM employee WHERE hire_date BETWEEN '90/01/01' AND '99/12/31';

SELECT EMP_NAME, hire_date FROM employee WHERE hire_date >= '90/01/01'AND hire_date<='00/01/01';

----------------------------------------------------------------------
/*
        <LIKE>
        비교하고자하는 컬럼값이 내가 제사한 특정 패턴에 만족하는 경우 조회
        
        [표현법]
        비교대상 칼럼 LIKE '특정패턴'
        특정패턴 : '%', '_'를 와일드카드로 쓸 수 있다.
        
        >> '%' : 0글자 이상
        EX) 비교대상 칼럼 LIKE '문자%' => 비교대상의 컬럼값이 '문자'로 시작하는 데이터 조회
        EX) 비교대상 칼럼 LIKE '%문자' => 비교대상의 컬럼값이 '문자'로 끝나는 데이터 조회
        EX) 비교대상 칼럼 LIKE '%문자%' => 비교대상의 컬럼값에 '문자'가 포함되어 있는 데이터 조회
        
        
        >> '_' : 1글자
        EX) 비교대상 칼럼 LIKE '_문자' => 비교대상의 컬럼값이 총 3글자에 '문자'앞에 무조건 한 글자만 있는 데이터 조회
        EX) 비교대상 칼럼 LIKE '__문자' =>비교대상의 컬럼값이 총 4글자에 '문자'앞에 무조건 두 글자만 있는 데이터 조회
        EX) 비교대상 칼럼 LIKE '_문자_' => 비교대상의 컬럼값이 총 4글자에 '문자'앞에 한 글자, 뒤에 한 글자만 있는 데이터 조회
*/

--EMPLOYEE에서 사원의 성이 전씨인 사원들의 사원명, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE 
FROM employee 
WHERE EMP_NAME LIKE '전%';

--EMPLOYEE에서 이름에 '하'가 포함되어있는 사원들의 사원명, 이메일, 전화번호 조회
SELECT emp_name, email, phone from employee where emp_name like '%하%';

--EMPLOYEE에서 이름에 '하' 중간에 포함되어있는 사원들의 사원명, 이메일, 전화번호 조회
SELECT emp_name, email, phone from employee where emp_name like '_하_';

--employee에서 전화번호의 3번쨰 자리가 1인 사원의 사우너명, 전화번호 조회
select emp_name, phone from employee where phone like '__1%';

--이메일 중_(언더바) 앞에 글자가 3글자인 사원들의 사원명,이메일 조회
select emp_name, email from employee where email like '___%';
--와일드카드로 사용하는 문자와 컬럼값에 들어있는 문자가  동일하기 때문에 조회가 안된다.
--이럴 경우 이스케이프 문자를 사용해야 하는데 오라클 DB에서 이스케이프 문자가 뭔지 모름

-->와일드카드와 문자를 구분해줘야함
--> 나만의 와일드카드를 escape로 등록
    -- 데이터값으로 취급하고자하는 값 앞에 나만의 와일드카드(문자, 숫자, 특수문자)를 넣어줌
    -- 특수기호 '&'는 안쓰는것이 좋다. 사용자로부터 입력받을 때 &를 사용함

--> 오라클 db에서 이스케이프 문자는 직접 지정할 수 있음
select emp_name, email 
from employee 
where email like '___/_%'ESCAPE '/';

---------------------------실습문제-------------------------------
--1. employ에서 이름이 '연'으로 끝나는 사원들의 사원명, 입사일 조회
select emp_name, hire_date 
from employee 
where emp_name like '%연';
--2. employee에서 전화번호 처음 3자리가 010이 아닌 사원들릐 사원명, 전화번호 조회
select emp_name, phone
from employee
where phone not like '010%';
--3. employee에서 이름에 '하'가 포함되어잇고 급여가 240만원 이상인 사원들릐 사원명, 급여 조회
select emp_name, salary
from employee
where emp_name like '%하%' and salary>=2400000;

--4. department에서 해외영업부인 부서들의 부서코드, 부서명 조회
select dept_ID, dept_title
from department
where dept_TITLE LIKE '해외영업%';

select dept_ID, dept_title
from department
where location_id BETWEEN 'L2'AND'L5';
------------------------------------------------------------
/*
        <IS NULL/ IS NOT NULL>
        
        컬럼값에 NULL이 있을 경우 NUL값 비교에 사용하는 연산자
*/
--EMPLOYEE에서 보너스를 받지 않는 사원의 사원명, 급여, 보너스를 조회
SELECT EMP_NAME, SALARY, BONUS
FROM employee
WHERE BONUS IS NULL;

--EMPLOYEE에서 보너스를 받는 사원의 사원명, 급여, 보너스를 조회
SELECT EMP_NAME, SALARY, BONUS
FROM employee
WHERE BONUS IS NOT NULL;

--EMPLOYEE에서 사수가 없는(MANAGER_ID값이 NULL인)사원의 사원명, 부서코드 조회
SELECT EMP_NAME, DEPT_CODE,manager_id
FROM employee
WHERE manager_id IS NULL;

--EMPLOYEE에서 부서배치를 받지 않았지만 보너스는 받는 사람의 사원명, 보너스, 부서코드 조히
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM employee
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

----------------------------------------------------------------------------
/*
        <IN/NOT IN>
        IN: 컬럼값이 내가 제시한 목록중에 일치하는것만 조회
        NOT IN : 컬럼 값이 내가 제시한 목록 중에 일치하는 값을 제회하고 조회
        
        [표현법]
        비교대상칼럼 IN ('값1','값2','값3',....)
*/

--      employee에서 부서코드가 D6이거나 D8이거나 D5인 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D6','D8','D5');
--WHERE DEPT_CODE='D5' OR DEPT_CODE='D6' OR DEPT_CODE='D8';

--      employee에서 부서코드가 D6,D8,D5가 아닌 사원들의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D6','D8','D5');

----------------------------------------------------------------------------
/*

        <연산자 우선순위>
        1.()
        2.산술 연산자 (-.+,*....)
        3.연결 연산자 (||).두 개의 칼럼을 연결하는것
        4.비교연산자 (<,>,<=,>=)
        5. IS NULL/LIKE '특정패턴'/IN
        6. BETWEEN AND
        7. NOT(논리연산자)
        8. AND(논리연산자)
        9. OR(논리연산자)
*/
-- 직급코드가 J7이거나 J2인 사원들 중 급여가 200만워ㅏㄴ 이상인 사우너들의 사우너명, 급여, 직급코드 조회
SELECT EMP_NAME, SALARY, JOB_CODE
FROM employee
WHERE (JOB_CODE='J7' OR JOB_CODE = 'J2') AND SALARY >=2000000;
---------------------------실습문제-------------------------------
--1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수사번, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE
FROM employee
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;
--2. 연봉(보너스 포함X)이 3000만원 이상이고 보너스를 받지 않은 사원들의 사번, 사원명, 연봉, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY*12 연봉,BONUS
FROM employee
WHERE SALARY*12>=30000000 AND BONUS IS NULL;
--3. 입사일이 95/01/01이상이고 부서배치를 받은 사우너들의 사번, 사우너명, 입사일, 부서코드 조회
SELECT EMP_ID, EMP_NAME, hIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE>='95/01/01' AND DEPT_CODE IS NOT NULL;

--4. 급여가 200만원 이상 500만원 이하고 입사일이 01/01/01이상이고 보너스를 받지 않는 사우너들의 사번, 사우너명, 급여, 입사일, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 5000000 AND HIRE_DATE>='01/01/01'AND BONUS IS NULL;

--5. 보너스 포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어있는 사원들의 사번, 사우너명, 급여, 보너스 포함 연봉 조회(별칭 부여)
SELECT EMP_ID, EMP_NAME,SALARY, BONUS, SALARY*12+SALARY*BONUS "연봉(보너스 포함)" 
FROM employee
WHERE SALARY*12+SALARY*BONUS IS NOT NULL AND EMP_NAME LIKE '%하%';

----------------------------------------------------------------------------
/*
        <ORDER BY절>
        데이터를 정렬하여 보여줌
        SELECT문의 가장 마지막 줄에 작성뿐만 아니라 실행 순서도 마지막에 실행
        
        [표현법]
        SELECT 조회할 컬럼
        FROM 테이블명
        WHERE 조건식
        ORDER BY 정렬기준의 컬럼명 
        | 별칭(새로 만든 별칭으로 입력하여 정렬 가능)
        | 컬럼 순번(몇 번째 컬럼인지)EX)2 입력시 왼쪽에서 두 번째 컬럼을 기준으로 정렬
        [ASC|DESC][NULLS FIRST|NULLS LAST]
        컬럼 순번의 오름차순 내림차순은 안쓰면 디폴트로 오름차순(ASC)이다.
        NULL FIRST와 NULL LAST는 NULL값을 맨 앞에 둘것인가 가장 뒤에 둘것인가를 정하는것이다.

         - ASC : 오름차순 정렬(생략시 기본값)
         - DESC : 내림차순 정렬
         
         - NULLS FIRST : 컬럼 값에 NULL이 있을 경우 맨 앞에 배치(생략시 DESC일때의 기본값)
         - NULLS LAST : 컬럼 값에 NULL이 있을 경우 맨 뒤에 배치(생략시 ASC일때의 기본값)

*/
 SELECT *
 FROM EMPLOYEE
 ORDER BY BONUS; --보너스 오름차순
 
 SELECT *
 FROM EMPLOYEE
 ORDER BY BONUS NULLS FIRST; --보너스 오름차순, NULL값 처음
 
 SELECT *
 FROM EMPLOYEE
 ORDER BY BONUS DESC; --보너스 내림차순(NULL LAST가 디폴트값)
 
  SELECT *
 FROM EMPLOYEE
 ORDER BY BONUS DESC, SALARY; --보너스 내림차순인데 같을때는 급여 오름차순
 --정렬기준 여러개일때, 앞을 기준으로 정렬하고 값이 같으면 뒤에 기준으로 정렬
 
 --모든 사원의 사원명, 연봉 조회(이때, 연봉의 내림차순 정렬 조회)
 SELECT EMP_NAME, SALARY*12 연봉
 FROM EMPLOYEE
 ORDER BY 연봉 DESC;
 
SELECT EMP_NAME, SALARY*12 연봉
 FROM EMPLOYEE
 ORDER BY 2 DESC; --두번쨰 컬럼으로 내림차순
 
 ---------------------------실습문제-------------------------------
------------------------------- 종합 문제 ----------------------------------
-- 1. JOB 테이블에서 모든 정보 조회
SELECT *
FROM JOB;
-- 2. JOB 테이블에서 직급 이름 조회
SELECT JOB_NAME
FROM JOB;

-- 3. DEPARTMENT 테이블에서 모든 정보 조회
SELECT *
FROM department;

-- 4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE
FROM employee;

-- 5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
SELECT HIRE_DATE, EMP_NAME, SALARY
FROM employee;

-- 6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
SELECT EMP_NAME, SALARY*12 연봉, SALARY*12+SALARY*NVL(BONUS,0) 총수령액, (SALARY*12+SALARY*NVL(BONUS,0))-(SALARY*12*0.03) 실수령액
FROM EMPLOYEE;

-- 7. EMPLOYEE테이블에서 JOB_CODE가 J1인 사원의 이름, 월급, 고용일, 연락처 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, PHONE,JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J1';

-- 8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
SELECT EMP_NAME, SALARY, (SALARY*12+SALARY*BONUS)-(SALARY*12*0.03) 실수령액, HIRE_DATE
FROM EMPLOYEE
WHERE (SALARY*12+SALARY*BONUS)-(SALARY*12*0.03) >=50000000;

-- 9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
SELECT *
FROM EMPLOYEE
WHERE SALARY>=4000000 AND JOB_CODE = 'J2';


-- 10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--     고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
SELECT EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE = 'D9' OR DEPT_CODE = 'D5')AND HIRE_DATE<'02/01/01';

-- 11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
SELECT *
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01'AND '02/01/01';

-- 12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

-- 13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
SELECT EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
-- 14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--     고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
 SELECT *
 FROM EMPLOYEE
 WHERE (EMAIL LIKE '____L_%' ESCAPE 'L') AND (DEPT_CODE='D9' OR DEPT_CODE = 'D6')AND (HIRE_DATE BETWEEN '90/01/01'AND '00/12/01')AND SALARY>=2700000;


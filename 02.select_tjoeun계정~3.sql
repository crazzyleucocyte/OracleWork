
/*
        <함수 function>
        전달된 컬람값을 읽어들여 함수를 실행한 결과 반환
        
        -단일행 함수 : n개의 값을 읽어들였을떄 n개의 결과값 반환(매 행마다 실행)
        -그룹 함수 : n개의 값을 읽어들여서 1개의 결과값 반환(그룹별로 함수 실행)
        
        >>select절에 단일행 함수와 그룹함수를 함께 사용할 수 없음
        >>함수식을 기술할 수 있는 위치 : select절, where절, order by절,having절(그룹을 지울때 씀)
*/
-------------------------------------단일행 함수----------------------------------------------------

        
-------------------------------------문자처리 함수----------------------------------------------------
/*
        length / lengthB => number로 반환
        
        length(컬럼|'문자열') : 해당 문자열의 글자수 반환
        lengthB(컬럼|'문자열') : 해당 문자열의 byte수 반환
          - 한글일때 byte수 : xe버전일때 => 한 글자당 3byte(ㄱ, ㅏ......도 3byte이다.)우리는 지금 이걸 쓴다.
                            ee버전일때 => 1글자당 2byte
          - 그외 : 글자당 1byte
        
*/
select length('오라클'), lengthb('오라클')
from dual;
--dual은 오라클에서 가상으로 만들어준 가상테이블이다.

select length('OraCle'), lengthb('oracle')
from dual;

select emp_name, length(emp_name), lengthb(emp_name),email, length(email), lengthb(email)
from employee;

-------------------------------------------------------------------------------------
/*      오라클의 index번호는 1번부터이다.
        
        * instr : 문자열로부터 특정 문자의 시작위치(index)를 찾아서 반환(반환형:number)
        -oracle에서 index번호는 1부터 시작. 찾을 문자가 없으면 0반환
        
        [표현법] 
               찾으려는 곳                    넣어도 되고 안넣어도 되고
        instr(컬럼|'문자열', '찾고자하는 문자', [찾을 위치의 시작값,[찾은 문자의 몇번째 값의 index를 출력할 것인가]])
         - 찾을 위치 시작값
           1: 앞에서부터 찾기(기본값)
           -1: 뒤에서부터 찾기
*/
select instr('javascriptjavaoracle','a')from dual;

select instr('javascriptjavaoracle','a',1)from dual;
select instr('javascriptjavaoracle','a',-1)from dual;
select instr('javascriptjavaoracle','a',3)from dual; --3번부터 찾으시오

select instr('javascriptjavaoracle','a',1,3)from dual; --앞에서부터 찾는데 a가 3번째 나왔을때의 indx값
select instr('javascriptjavaoracle','a',-1,2)from dual; --뒤에서부터 찾는데 a가 2번째 나왔을때의 indx값

select email, instr(email,'_',1) "_의 위치", instr(email,'@') "@의 위치"
from employee;
--------------------------------------------------------------------------------------------
/*
        *substr : 문자열에서 특정 문자열을 추출하여 반환(반환형 : number)
        
        [표현법]
        substr(컬럼|'문자열',position, [length])
           - position : 문자열을 추출할 시작위치 index
           - length : 추출할 문자의 갯수(생략시 마지막까지 추출)
           
*/
select substr('oraclethmlcss',7) from dual;
select substr('oraclethmlcss',7,4) from dual;
select substr('oraclethmlcss',2,6) from dual;
select substr('oraclethmlcss',-7,4) from dual;

--employee에서 주민번호에서 성별만 추출하기, 주민번호, 성별(주민번호에서 성별만 추출하기)
select emp_no, substr(emp_no,8,1) 성별
from employee;

--employee에서 여자사원들의 사원번호, 사원명, 성별 조회
select emp_id, emp_name, substr(emp_no,8,1) 성별
from employee
where substr(emp_no,8,1)in(2,4);

--employee에서 남자사원들의 사원번호, 사원명, 성별 조회
select emp_id, emp_name, substr(emp_no,8,1) 성별
from employee
where substr(emp_no,8,1)in(1,3)
order by 2;

--employee에서 사원명, 이메일, 아이디 조회(이메일의 @ 앞)
select emp_name, email, substr(email,1,(instr(email,'@',1))-1) 아이디
from employee
order by 아이디;

-------------------------------------------------------------------------------
/*
        * lpad/rpad : 문자열을 조회할 때 통일감 있게 조회하고자 할 때(반환형 : character)
        
        [표현법]
        Lpad/Rpad('문자열', 최종적으로 반환할 문자의 길이, [덧붙이고자하는 문자])
          - 문자열에 덧붙이고자하는 문자를 왼쪽 또는 오른쪽에 덧붙여서 최종 N길이만큼 문자열을 반환
          - 좌우 정렬을 할 수 있다.
*/

--employee에서 사원명, 이메일(길이 20, 오른쪽 정렬)
select emp_name, email, lpad(email,27)  --덧붙이고자하는 문자 생략시 공백으로 채워짐
from employee;
---------------------------------------------------------------------------  
/*
    * LTRIM/RTRIM : 문자열에서 특정문자를 제거한 나머지를 반환(반환형: CHARACTER )
    * TRIM : 문자열에서 앞/뒤 양쪽에 있는 특정문자를 제거한 나머지를 반환
        - 주의사항 : 제거할 문자 1글자만 가능
        
    [표현법]
    LTRIM / RTRIM('문자열',[제거하고자하는 문자들])
    TRIM([LEADING|TRAILING|BOTH]제거하고자하는 문자들 FROM  '문자열')
       
    문자열의 왼쪽 또는 오른쪽으로 제거하고자하는 문자들을 찾아서 제거한 나머지 문자열 반환
*/
-- 제거하고자하는 문자를 넣지않으면 공백 제거
SELECT LTRIM('     tjoeun     ')||'학원' FROM DUAL;
SELECT RTRIM('     tjoeun     ')||'학원' FROM DUAL;

SELECT LTRIM('JAVAJAVASCRIPT','JAVA') FROM DUAL;
SELECT LTRIM('BACACABCFIACB','ABC') FROM DUAL;
SELECT LTRIM('37284BAC38290','0123456789') FROM DUAL;

SELECT RTRIM('BACACABCFIACB','ABC') FROM DUAL;
SELECT RTRIM('37284BAC38290','0123456789') FROM DUAL;

-- BOTH가 기본값 : 양쪽제거
SELECT TRIM('     tjoeun     ')||'학원' FROM DUAL;
SELECT TRIM('A' FROM 'AAABKSLEIDKAAA') FROM DUAL;   -- 1글자만 가능
SELECT TRIM(BOTH 'A' FROM 'AAABKSLEIDKAAA') FROM DUAL;

SELECT TRIM(LEADING 'A' FROM 'AAABKSLEIDKAAA') FROM DUAL;
SELECT TRIM(TRAILING 'A' FROM 'AAABKSLEIDKAAA') FROM DUAL;

---------------------------------------------------------------------------  
/*
    * LOWER / UPPER / INITCAP : 문자열을 대소문자로 변환 및 단어의 앞글자만 대문자로 변환
    
    [표현법]
    LOWER('문자열')
*/
SELECT LOWER('Java JavaScript Oracle') from dual;
SELECT UPPER('Java JavaScript Oracle') from dual; 
SELECT INITCAP('java javaScript oracle') from dual;

-- EMPLOYEE에서 EMAIL 대문자로 출력
SELECT EMAIL, UPPER(EMAIL)
  FROM EMPLOYEE;
 
---------------------------------------------------------------------------  
/*
    * CONCAT : 문자열 두개를 하나로 합친 후 반환
    
    [표현법]
    CONCAT('문자열','문자열')
*/
SELECT CONCAT('Oracle','오라클') FROM DUAL;
SELECT 'Oracle'||'오라클' FROM DUAL;

-- SELECT CONCAT('Oracle','오라클','02-1234-5678') FROM DUAL;  -- 문자열 2개만 넣을 수 있음
SELECT 'Oracle'||'오라클'||'02-1234-5678' FROM DUAL;

---------------------------------------------------------------------------  
/*
    * REPLACE : 기존문자열을 새로운 문자열로 바꿈
    
    [표현법]
    REPLACE('문자열','기존문자열','바꿀문자열')
*/
-- EMPLOYEE에서 EMAIL의 문자를 tjoeun.or.kr -> naver.com으로 바꾸어 출력
SELECT REPLACE(EMAIL, 'tjoeun.or.kr', 'naver.com')
  FROM EMPLOYEE;
  
--=========================================================================
--                                  숫자처리 함수
--=========================================================================  

/*
    * ABS : 숫자의 절대값을 구하는 함수
    
    [표현법]
    ABS(NUMBER)
*/
SELECT ABS(-5) FROM DUAL;
SELECT ABS(-3.14) FROM DUAL;

---------------------------------------------------------------------------  
/*
    * MOD : 두 수를 나눈 나머지값 반환하는 함수
    
    [표현법]
    MOD(NUMBER, NUMBER)
*/
SELECT MOD(10,3) FROM DUAL;

---------------------------------------------------------------------------  
/*
    * ROUND : 반올림한 결과 반환
    
    [표현법]
    ROUND(NUMBER, [위치])
*/
SELECT ROUND(1234.567) FROM DUAL;
SELECT ROUND(1234.123) FROM DUAL;
SELECT ROUND(1234.123, 2) FROM DUAL;
SELECT ROUND(1234.127, 2) FROM DUAL;
SELECT ROUND(1234567, -2) FROM DUAL;

---------------------------------------------------------------------------  
/*
    * CEIL : 올림한 결과 반환
    
    [표현법]
    ROUND(NUMBER)
*/
SELECT CEIL(123.4566) FROM DUAL;
SELECT CEIL(-123.4566) FROM DUAL;

---------------------------------------------------------------------------  
/*
    * FLOOR : 내림한 결과 반환
    
    [표현법]
    FLOOR(NUMBER)
*/
SELECT FLOOR(123.987) FROM DUAL;
SELECT FLOOR(-123.987) FROM DUAL;

---------------------------------------------------------------------------  
/*
    * TRUNC : 위치 지정 가능한 버리처리 함수
    
    [표현법]
    TRUNC(NUMBER, [위치지정])
*/
SELECT TRUNC(123.789) FROM DUAL;
SELECT TRUNC(123.789, 1) FROM DUAL;
SELECT TRUNC(123.789, -1) FROM DUAL;

SELECT TRUNC(-123.789) FROM DUAL;
SELECT TRUNC(-123.789, -2) FROM DUAL;

--=========================================================================
--                                  날짜처리 함수
--=========================================================================  
/*
    * SYSDATE : 시스템 날짜 및 시간 반환
*/
SELECT SYSDATE FROM DUAL;

---------------------------------------------------------------------------  
/*
    * MONTHS_BETWEEN(DATE1, DATE2) : 두 날짜 사이의 개월수
    
    [표현법]
    MONTHS_BETWEEN(날짜, 날짜)
*/
SELECT EMP_NAME, HIRE_DATE, SYSDATE-HIRE_DATE "근무일수"
  FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, CEIL(SYSDATE-HIRE_DATE) "근무일수"
  FROM EMPLOYEE;

SELECT EMP_NAME, HIRE_DATE, MONTHS_BETWEEN(SYSDATE, HIRE_DATE) "근무개월수"
  FROM EMPLOYEE;
  
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무개월수"
  FROM EMPLOYEE;
  
SELECT EMP_NAME, HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) || '개월차' "근무개월수"
  FROM EMPLOYEE;  
  
SELECT EMP_NAME, HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)), '개월차') "근무개월수"
  FROM EMPLOYEE;
  
---------------------------------------------------------------------------  
/*
    * ADD_MONTHS(DATE, NUMBER) : 특정날짜에 해당 숫자만큼 개월수르 더해  반환
*/

SELECT ADD_MONTHS(SYSDATE, 1) FROM DUAL;

-- EMPLOYEE에서 사원명, 입사일, 입사후 정직원된 날짜(입사후 6개월) 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE, 6) "정직원된 날짜"
  FROM EMPLOYEE;

---------------------------------------------------------------------------  
/*
    * NEXT_DAY(DATE, 요일[문자|숫자]) : 특정 날짜 이후에 가까운 해당 요일의 날짜를 반환해주는 함수
      - 1: 일요일
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '금') FROM DUAL;

SELECT SYSDATE, NEXT_DAY(SYSDATE, 6) FROM DUAL;
-- SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;   -- 오류 : 현재언어가 KOREA아기 때문

-- 언어변경
ALTER SESSION SET NLS_LANGUAGE = AMERICAN;
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'FRIDAY') FROM DUAL;
-- SELECT SYSDATE, NEXT_DAY(SYSDATE, '금요일') FROM DUAL;   -- 오류 

ALTER SESSION SET NLS_LANGUAGE = KOREAN;

---------------------------------------------------------------------------  
/*
    * LAST_DAY(DATE) : 해당월의 마지막 날짜를 반환해주는 함수
*/

SELECT LAST_DAY(SYSDATE) FROM DUAL;

-- EMPLOYEE에서 사원명, 입사일, 입사한 날의 마지막 날짜 조회
select emp_name, hire_date,last_day(hire_date) from employee;
-------------------------------------------------------------------------------------
/*
        *extract : 특정 날짜로부터 년도|월|일 값을 추출하여 반환해주는 함수(반환형 : number)
        
        extract(year from date ): 년도 추출
        extract(month from date) : 월만 추출
        extract( day from date): 일만 추출
        
*/
--employee 에서 사원명, 입사년도, 입사월, 입사일 조회
select emp_name, hire_date, extract(year from hire_date)"입사년도"
  ,extract(month from hire_date)"입사월"
  ,extract(day from hire_date) "입사일" 
  from employee
  order by 입사년도, 입사월, 입사일;

--=========================================================================
--                                  형변환 함수
--=========================================================================  

/*
         *to_char : 숫자 또는 날짜 타입의 값을 문자로 변환시켜주는 함수
                    반환 결과를 특정 형식에 맞게 출력할 수도 있다.
                    
            [표현법]
          to_char(숫자|날짜,[포멧])
*/
--------------------------------------------------------------------------------
/*
        숫자=> 문자타입
*/

/*
        [포멧]
        * 접두어 : L -> local(설정된 나라)의 화폐단위가 나온다
        * 9: 해당 자리의 숫자를 의미한다.
          - 해당 자리에 값이 없을 경우 소수점 이상는 공백, 소수점 이하는 0으로 표시 
          
        * 0: 해당 자리의 숫자를 의미한다.
          - 해당자리의 값이 없을 경우 0으로 표시하고, 숫자의 길이를 고정적으로 표시할때 주로 사용
        * fm: 해당 자리에 값이 없을 경우 자리차지를 하지 않음  
*/
-- 문자는 왼쪽 정렬, 숫자는 오른쪽 정렬
select to_char(1234),(1234) from dual; --문자는 왼쪽정렬, 숫자는 오른쪽 정렬
select to_char(1234)+14124124,(1234)+139481794 from dual;--문자로 변환한 숫자값에 숫자를 더하면 문자에서 숫ㅈ자로 다시 형변환된다.

select to_char(1234,'999999') from dual;
select to_char(1234,'000000') from dual;

select to_char(1234,'L999999') from dual;--화폐단위가 들어가서 오른쪽 정렬이 된다.

select to_char(1234,'L999,999') from dual;--콤마를 찍고 싶으면 이렇게 하면 된다.

select emp_name, to_char(salary,'L99,999,999') from employee;
select emp_name, to_char(salary,'L999,999,999') 급여,to_char(salary*12,'L99,999,999') 연봉 from employee;

select to_char(123.456, '999999.999') from dual;
--fm을 안하면     123.456이렇게 출력 되고
--fm을 하면 123.456이렇게 출력된다.
select to_char(123.456, 'fm999999.999'),
    to_char(123.456,'fm90000.99')from dual; --0은 무조건 한 자리 있어야함

select to_char(123.456, 'fm999999.999'),
    to_char(123.456,'fm90000.99'),
    to_char(0.1000,'fm9990.99') -- 0.1을 입력했을때 9로 하면 .1이 나오고 0으로 하면 0.1이 나온다
    from dual; --0은 무조건 한 자리 있어야함

select to_char(123.456, '999999.999'),
    to_char(123.456,'fm90000.99'),
    to_char(0.1000,'fm9990.99'),
    to_char(0.1000,'fm9999.999')-- 0.1을 입력했을때 9로 하면 .1이 나오고 0으로 하면 0.1이 나온다
    from dual; --0은 무조건 한 자리 있어야함

select to_char(123.456, '999999.999'),
    to_char(123.456,'90000.99'), --맨 앞에 9가 있을때 출력되지는 않지만 자리차지는 한다.
    to_char(0.1000,'9990.99'),
    to_char(0.1000,'9999.999')-- 0.1을 입력했을때 9로 하면 .1이 나오고 0으로 하면 0.1이 나온다
    from dual;

-----------------------------------------------------날짜=> 문자타입
-- 시간
select to_char(sysdate,'AM') "korean",--am이든pm이든 현재 기준으로 출력된다.
    to_char(sysdate,'am','nls_date_language=american') "american" --출력되는 시간 기준의 나라를 바꾸는 방법
from dual;--am,pm 상관 없음

alter session set nls_language = american;
alter session set nls_language = korean;

-- 12시간 형식, 24시간 형식
select to_char(sysdate,'am HH:MI:ss')from dual; --12시간 형식

--24시간
select to_char(sysdate,'HH24:MI:ss') from dual; --24시간 형식으로 시간 뒤에 24를 붙인다.

--날짜 포멧
select to_char(sysdate,'yyyy-mm-dd day') from dual; 
select to_char(sysdate,'mon, yyyy') from dual; --mon : 몇 월인가(6월 or jun)

select to_char(sysdate,'yyyy"년" mm"월" dd"일"day') from dual; --한글을 넣고 싶으면 쌍따옴표(")로 감싸면 된다.
select to_char(sysdate, 'dl')from dual; --'dl' = 위의 형식처럼 똑같이 해주는 함수로 나라에 맞게 날짜 형식을 바꿔준다.

--입사일을 0000년 00월 00일 000요일로 출력
select to_char(hire_date,'dl')
from employee;

-------------------년도
/*
        YY : 무조건 앞에 '20'이 붙는다.
        RR : 50년을 기준으로 작으면 '20'을 크면 '19'를 붙인다.
*/
SELECT TO_CHAR(SYSDATE,'YYYY'),
        TO_CHAR(SYSDATE,'RRRR'),
        TO_CHAR(SYSDATE,'YY'),
        TO_CHAR(SYSDATE,'RR')
    FROM DUAL;

--TO_CHAR(날짜,'형식')을 넣었을때 해당 형식으로 날짜를 바꿔준다.
--아래 함수는 TO_CHAR(TO_DATE(문자열,'형식'),'형식')이다.
SELECT TO_CHAR( TO_DATE ('021213','RRMMDD'),'YYYY'),
    TO_CHAR( TO_DATE ('021213','RRMMDD'),'YY'),
    TO_CHAR( TO_DATE ('021213','RRMMDD'),'RRRR'),
    TO_CHAR( TO_DATE ('021213','RRMMDD'),'RR'),
    TO_CHAR( TO_DATE ('021213','RRMMDD'), 'YEAR') FROM DUAL;
    

SELECT TO_CHAR( TO_DATE ('981213','YYMMDD'),'YYYY'),
    TO_CHAR( TO_DATE ('981213','YYMMDD'),'YY'),
    TO_CHAR( TO_DATE ('981213','YYMMDD'),'RRRR'),
    TO_CHAR( TO_DATE ('981213','YYMMDD'),'RR'),
    TO_CHAR( TO_DATE ('981213','YYMMDD'), 'YEAR') FROM DUAL;
    --숫자나 문자를 날짜타입으로 바꾸는 함수

SELECT TO_DATE ('981213','RRMMDD') FROM DUAL;
SELECT TO_DATE ('021213','RRMMDD') FROM DUAL;

SELECT TO_DATE ('981213','RRRRMMDD') FROM DUAL;
SELECT TO_DATE ('981213','YYYYMMDD') FROM DUAL;

---------------------------월
SELECT TO_CHAR(SYSDATE,'MM'),   --06
    TO_CHAR(SYSDATE,'MON'),     --6월
    TO_CHAR(SYSDATE,'MONTH'),   --6월
    TO_CHAR(SYSDATE,'RM')--로마자로 변환
FROM DUAL;

---------------------------일
SELECT TO_CHAR(SYSDATE,'DDD'), --년을 기준으로 몇일째인지
        TO_CHAR(SYSDATE,'DD'), --월을 기준으로 몇일째인지
        TO_CHAR(SYSDATE,'D')   --주(일요일)를 기준으로 몇일째인지
    FROM DUAL;

---------------------------요일
SELECT TO_CHAR(SYSDATE,'DAY'), --수요일
        TO_CHAR(SYSDATE,'DY')  --수
    FROM DUAL;

























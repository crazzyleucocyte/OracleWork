
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










































































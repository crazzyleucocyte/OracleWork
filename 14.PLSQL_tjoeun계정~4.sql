/*
        *pl/sql
        procedual language extemsion to sql
        
        오라클 자체에 내장되어있는 절차적 언어
        sql문장 내에서 변수의 정의, 조건처리(if), 반복처리(loop, for,while)등을 지원하여sql의 단점을 보완함
        다수의 sql문을 한 번 실행 가능(block구조)
        
        *구조
         - [선언부 (declare section)] : declare로 시작, 변수나 상수를 선언 및 초기화하는 부분
         - 실행부 (executable section : begin으로 시작, sql문 또는 제어문(조건문, 반복문)등의 로직을 기술하는 부분
         - [예외처리부(exception section)]: exception으로 시작, 예외 발생시 해결하기 위한 구문을 미리 기술해 두는 부분
*/

--* plsql을 화면에 출력하는 방법
set serveroutput on;
--이거를 꼭 켜줘야 하는데 db를껏다 키면 이게 off로 리셋이 되니 db를 키자마자 이거를 켜줘야 한다. 

begin
    dbms_output.put_line('hello world');
end;
/
--위의 /를 꼭 해줘야 한다 안해주면 아래에 있는 모든 쿼리가 출력되니 조심하자

/*
       1. declare 선언부
          변수, 상수 선언하는 공간(선언과 동시 초기화도 가능)
          일반타입 변수, 레퍼런스타입의 변수, row타입의 변수
          
        1.1 일반타입 변수 선언 및 초기화
            [표현식]
            변수명 [constant]자료형[:=값];   //constant는 상수 표시//값을 입력해주면 초기화를 안해주는것
*/

declare
    eid number;
    ename varchar2(20);
    pi constant number :=3.1415926;
--작성 다 했으면 begin 작성
begin
    eid:=600;
    ename:='임수정';
    dbms_output.put_line('eid : '||eid);
    -- System.out.println("eid : " + eid); 위의 쿼리는 이 자바에서 이 문장과 같은 뜻이다.
    dbms_output.put_line('ename : '||ename);
    dbms_output.put_line('pi : '||pi);
end;
/

--사용자로부터 값을 받아서 입력 받는거

--사용자로부터 입력받아서 출력
declare
    eid number;
    ename varchar2(20);
    pi constant number:=3.1415926535897932384626;
begin
    eid:=&번호;
    ename:='&이름';
--&을 붙이면 사용자에게 입력 받겠다는 뜻
    
    dbms_output.put_line('eid : '||eid);
    dbms_output.put_line('ename : '||ename);
    dbms_output.put_line('pi : '||pi);
end;
/
--------------------------------------------------------------------------------------------------------------
/*
        1.2 레퍼런스타입 변수 선언 및 초기화
            :어떤 테이블의 어떤 컬럼의 데이터타입을 참조하여 그 타입으로 지정 
            
            [표현식]
            변수명 테이블명.컬럼명 %type;    //테이블명에 해당하는 컬럼명의 자료형 타입을 가져와서 내가 지정해주는 변수의 타입으로 지정해준다.   

*/

declare
    eid employee.emp_id%type;
    ename employee.emp_name %type;
    sal employee.salary %type;
begin
    eid:='300';
    ename:='유재석';
    sal:=4000000;
    
    dbms_output.put_line('eid : '||eid);
    dbms_output.put_line('ename : '||ename);
    dbms_output.put_line('sal : '||sal);
end;
/

---------------------------------------------------------------------------------------------------------------
declare
    eid employee.emp_id%type;
    ename employee.emp_name %type;
    sal employee.salary %type;
begin
    --사번이 200번인 사원의 사번, 이름 , 급여 조회하여 각 변수에 대입
    select emp_id,emp_name,salary
    into eid,ename,sal
    from employee
    where emp_id = &사번;
    --사번을 입력하면 해당 사번의  id, name, salary를 가져와서 출력한다
--    into절을 입력안하면 "해당 select문에 into절이 필요합니다"라는 오류 메시지가 뜬다
--    결국 declare문에 있는 변수에 어떤걸 넣어줄지를 정해줘야한다.
dbms_output.put_line('eid : '||eid);
dbms_output.put_line('ename : '||ename);
dbms_output.put_line('salary : '||sal);

end;
/
---------------------------------실-습-문-제------------------------------------------------------
/*
    레퍼런스타입변수로 EID, ENAME, JCODE, SAL, DTITLE를 선언하고
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY), DEPARTMENT (DEPT_TITLE)들을 참조하도록
    
    사용자가 입력한 사번의 사원의 사번, 사원명, 직급코드, 급여, 부서명 조회 한 후 각 변수에 담아 출력
*/
declare
    eid employee.emp_id %type;
    ename employee.emp_name %type;
    jcode employee.job_code %type;
    sal employee.salary %type;
    dtitle department.dept_title %type;
begin
    select emp_id,emp_name,job_code,salary,dept_title
    into eid,ename,jcode,sal,dtitle
    from employee
    join department on(dept_code=dept_id)
    where emp_id = &사번;
    
    dbms_output.put_line('eid : '||eid);
    dbms_output.put_line('ename : '||ename);
    dbms_output.put_line('jcode : '||jcode);
    dbms_output.put_line('sal : '||sal);
    dbms_output.put_line('dtitle : '||dtitle);
end;
/
---------------------------------------------------------------------------------------------------------------
/*
        1.3 row타입의 변수   
            :어떤 테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
            
            [표현식]
            변수명 테이블명%rowtype;
*/

declare
    e employee%rowtype;
begin
    select*
    into e
    from employee
    where emp_id=&사번;
    
    dbms_output.put_line('사원명 : '||e.emp_name);
    dbms_output.put_line('급여 : '||e.salary);
    dbms_output.put_line('보너스 : '||e.bonus);
    dbms_output.put_line('보너스 : '||vnl((e.bonus),'없음'));
    --오류

    
end;
/

declare
    e employee%rowtype;
begin
--rowtype을 사용할때는 무조건 select *를 사용해야한다 그렇지 않으면 값의 수가 너무 많습니다. 라는 오류가 뜬다
-- rowtype을 쓰면 해당 테이블의 모든 컬럼을 가져오는데 값을 지정해줄떄 *가 아닌 몇몇 컬럼만 가져오면 가져온 rowtype중 비어있는 값이 생겨 오류가 뜬다.
    select emp_name, salary, bonus
    into e
    from employee
    where emp_id=&사번;
    
    dbms_output.put_line('사원명 : '||e.emp_name);
    dbms_output.put_line('급여 : '||e.salary);
    dbms_output.put_line('보너스 : '||e.bonus);
end;
/

-----------------------------------------------------------------------------------------------------------------------
/*
        2.실행부
        
            <조건부>
             1)if조건식 then 실행내용 end if; (단일 if문)
*/

--사번을 입력받아 사번, 이름, 급여, 보너스(%) 출력
--단, 보너스를 받지 않는 사원은 '보너스를 지급받지 않는 사원입니다' 출력

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    salary employee.salary%type;
    bonus employee.bonus%type;
begin
    select emp_id, emp_name, salary, nvl(bonus,0)
    into eid, ename, salary,bonus
    from employee
    where emp_id=&사번;

    dbms_output.put_line('사번 : '||eid);    
    dbms_output.put_line('사원명 : '||ename);
    dbms_output.put_line('급여 : '||salary);
    --if 조건문
    if bonus=0
            then dbms_output.put_line('보너스를 받지 않는 사원입니다.');
    end if;
    dbms_output.put_line('보너스 : '||bonus*100||'%');
end;
/

--2)if 조건식 then 실행내용 else 실행내용 end if;   (if-else문)

declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    salary employee.salary%type;
    bonus employee.bonus%type;
begin
    select emp_id, emp_name, salary, nvl(bonus,0)
    into eid, ename, salary,bonus
    from employee
    where emp_id=&사번;

    dbms_output.put_line('사번 : '||eid);    
    dbms_output.put_line('사원명 : '||ename);
    dbms_output.put_line('급여 : '||salary);
    --if 조건문
    if bonus=0
        then dbms_output.put_line('보너스를 받지 않는 사원입니다.');
    else
        dbms_output.put_line('보너스 : '||bonus*100||'%');
    end if;

end;
/

---------------------------------실-습-문-제------------------------------------------------------
/*
    레퍼런스변수 : EID, ENAME, DTITLE, NCODE
          참조컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
          
    일반변수 : TEAM(소속)  
    
    실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
             단) NCODE값이 KO일 경우   => TEAM변수에 '국내팀'
                  NCODE값이 KO가 아닐 경우   => TEAM변수에 '해외팀'
                  
             출력 : 사번, 이름, 부서명, 소속     
*/
declare
    eid employee.emp_id %type;
    ename employee.emp_name %type;
    dtitle department.dept_title %type;
    ncode char(2);
    team varchar2(20);
begin
    select emp_id, emp_name,dept_title, national_code
    into eid, ename, dtitle, ncode
    from employee
    join department on(dept_id= dept_code)
    join location on(local_code=location_id)
    join national using(national_code)
    
    where emp_id=&사번;
    
    dbms_output.put_line('사번 : '||eid);    
    dbms_output.put_line('사원명 : '||ename);
    dbms_output.put_line('부서명 : '||dtitle);
    dbms_output.put_line('근무국가코드 : '||ncode);
    
    if ncode='KO'
        then team:='국내팀';
    else 
         team:='해외팀';
    end if;
        
    dbms_output.put_line('팀 : '||ncode);




end;
/

-----------------------------------------------------------------------------------------------------------------------
/*
        3.if-else if 조건문        
            if 조건식1
                then 실행내용1
            elsif 조건식2
                them 실행내용2
            elsif 조건식3
                them 실행내용3
            else
                실행내용4
            end if;

*/

--사용자로부터 점수를 입력받아 학점 출력
declare
    score number;
    grade varchar2(1);
begin
    score:=&점수;
    if score >= 90 then grade:='A';
    elsif score>=80 then grade:='B';
    elsif score>=70 then grade:='C';
    elsif score>=60 then grade:='D';
    else grade:= 'F';
    end if;
    
    dbms_output.put_line('당신의 점수는'||score||'점 이고, 학점은 '||grade||'입니다.');
end;
/
-------------------------------------------------------------------------------------------------------------------
/*
        사용자로부터 사번을 입력받아 사원의 급여를 조회하여 sal변ㅅ후에 저장
        500만원 이상이면 '고급'
        499~300만원 이면 '중급'
        나머지는 초급
*/


/*
        4) case문(switch case문과 동일)
        case 비교대상자
            when 비교할값1
                then 실행내용1
            when 비교할값2
                then 실행내용2
            when 비교할값3
                then 실행내용3
            when 비교할값4
                then 실행내용4
            else 실행내용(default)
        end;
*/

--사용자로부터 사번을 입력받아 dept_code를 조회
--dept_code가 D1이면 인사관리부.....
declare
    eid employee.emp_id%type;
    ename employee.emp_name%type;
    dcode employee.dept_code%type;
    dname varchar2(30);
begin
    select emp_id,emp_name, dept_code
    into eid, ename,dcode
    from employee
--    join department on(dept_id=dept_code)
    where emp_id='&사번';
    
    dname:= case dcode
        when 'D1' then'인사관리부'
        when 'D2' then '회계관리부'
        when 'D3' then '마케팅부'
        when 'D4' then '국내영업부'
        when 'D8' then '기술지원부'
        when 'D9' then '총무부'
    else '해외영업부'
    end;
    
    dbms_output.put_line(ename||'는'||dname||'입니다.');
   
    
end;
/
-------------------------------------------------------------------------------------------------------------------
/*
        <loop>
        1)loop문
        
        [표현식]
        loop
            반복적으로 실행할 구문;
            - 반복문을 빠져나갈 구문;
        end loop;
        
        *반복문을 빠져나갈 조건문 2가지
          - lf 조건식 then exit; endif;
          - exit when 조검식; 조건식에 해당될떄 exit
*/

--1) if조건식 then exit; end if;
declare
    n number:=1;
begin
    loop
        dbms_output.put_line(n);
        n:=n+1;
        
        if n=6 then exit;
        end if;
    end loop;
end;
/
--n을 1부터 1씩 더하면서 6이 되면 루프 종료

--2) exit when  조건식;
declare
    n number:=1;
begin
    loop
        dbms_output.put_line(n);
        n:=n+1;
        
        exit when n=6;
        
    end loop;
end;
/
--exit when이 더 짧아서 이걸 더 자주 쓴다.

------------------------------------------------------------------------------------------------------------------------------------------------------
/*
        2. for loop문
        
        [표현식]
        for 변수 in [reverse] 초기값..최종값
        loop
            반복할 실행문;
        end loop;
        
        --reverse는 거꾸로 도는거고 괄호 안의 뜻은 초기값에서 최종값까지 도는거
*/
--begin에서 변수를 정의해줘서 declare문을 쓰지 않았다.
--              //12345
begin
    for i in 1..5
    loop
        dbms_output.put_line(i);
    end loop;
end;
/
--reverse     //54321

begin
    for i in reverse 1..5
    loop
        dbms_output.put_line(i);
    end loop;
end;
/

drop table test;

create table test(
    tno number primary key,
    tdate date
);
--루프로 시퀀스값을 1부터 100까지 insert
create sequence seq_tno;

begin
    for j in 1..100
    loop
        insert into test values(seq_tno.nextval,sysdate);
    end loop;
end;
/

------------------------------------------------------------------------------------------------------------------------------------------------------
/*
        3. while loop문
        
        [표현식]
        while 반복문이 수행할 조건
        loop
            반복할 실행문;
        end loop;
        
*/

--1부터 5까지 출력
declare
    n number:=1;
begin
    while n<6
    loop
        dbms_output.put_line(n);
        n:=n+1;
    end loop;
end;
/
------------------------------------------------------------------------------------------------------------------------------------------------------
/*
        3. 예외처리부
            exception : 예외를 처리하는 구문
            
            [표현식]
            exception
                when 예외명1 then 예외처리구문1  //이런 예외명일때 이런 예외처리 구문
                when 예외명2 then 예외처리구문2
                when others then 예외처리구문n
            
            *시스템 예외(오라클에서 미리 정의해둔 예외)
                -no_data_found : select한 결과가 한 행도 없을 경우
                -too_mant_rows : select한 결과가 여러행 일 경우
                -zero_divIde : 0으로 나눌때
                -dup_val_on_index : unique 제약조건에 위배되었을떄
                .....
*/

--ZERO DIVIDE
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT:=10/&숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : '||RESULT);
EXCEPTION
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
END;
/
--DUP_VAL_ON_INDEX  //UNIQUE 조건이 위배 되었을때
BEGIN
    UPDATE EMPLOYEE
        SET EMP_ID= '&변경할 사번'
    WHERE EMP_NAME = '강민석';
EXCEPTION 
    WHEN DUP_VAL_ON_INDEX THEN  DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/
--사수번호가 211번은 1명, 200번은 5명, 202번은 없음
--사수번호를 입력받아 사수로 가지고 있는 사원의 정보 출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
    INTO EID, ENAME
    FROM EMPLOYEE
    WHERE MANAGER_ID = &사수사번;
    
    DBMS_OUTPUT.PUT_LINE('사번 : '||EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : '||ENAME);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('너무 많은 행이 조회되었습니다.');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회결과가 없습니다.');

END;
/
--오류 내용 : 사수 한명에 부사수가 여러명 있을 경우 하나의 변수에 여러개의 변수가 들어갈 수 없기 때문
-- 또다른 오류 : 해당 사수사번의 부사수가 없는경우 값이 없다.

-------------------------------------연-습-문-제-----------------------------------------------------

--        1. 사원의 연봉을 구하는 pl/sql구문 작성, 보너스가 있는 사원은 보너스도 포함하여 계산
declare
    eid  employee.emp_id%type;
    ename employee.emp_name%type;
    esal employee.salary%type;
begin
    select emp_id, emp_name, round(salary*(1+nvl(bonus,0)*12),1)
    into eid, ename,esal
    from employee
    where emp_id=&사번;
    
    dbms_output.put_line('사번 : '||eid);
    dbms_output.put_line('이름 : '||ename);
    dbms_output.put_line('연봉 : '||to_char(esal,'fml999,999,999'));
end;
/
        
        
--        2. 구구단 짝수단 출력(mod 함수 사용 가능)
--            2-1)for loop
begin
    for i in 2..9
    loop
    if i in(2,4,6,8)
        then    
            for j in 1..9
            loop
            dbms_output.put_line(i||' * '||j||' = '||i*j);
            end loop;
--    i:=i+1;
    end if;
    end loop;
end;
/

begin
    for dan in 2...9
    loop
        if mod(dan,2)=0

end;
/


--            2-2) while loop
declare
    i number:=2;
    j number:=2;
begin
    while i<=9
    loop
        while j<=9
        loop
            dbms_output.put_line(i||' * '||j||' = '||i*j);
            j:=j+1;
        end loop;
        j:=2;
        i:=i+2;
    end loop;
end;
/
















/*
        *sequence
         자동으로 번호를 발생시키는 역할을 하는 객체
         정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
         
         ex)회원번호, 사원번호, 게시글번호 .....
         실수로 넣지 않아도 널값이 들어가지 않고 자동 생성되며 unique하다.
*/
/*
        1.시퀀스 객체 생성방법
        
        [표현식]
        create sequence 시퀀스명
        [start with 시작숫자]       --> 처음 발생시킬 시작값 지정(기본값 1)
        [increment by 숫자]        --> 몇씩 증가시킬것인지 지정(기본값 1)
        [maxvalue 숫자]            --> 최대값 지정(기본값 엄청큼)
        [minvalue 숫자]            --> 최소값 지정(기본값 1)
        [cycle|nocycle]           --> max값까지 간 후에 다시 최소값부터 시작할거냐(cycle) max간 후 오류가 날것이냐(nocycle){기본값 nocycle}
        [cache|nocache]           --> 캐시메모리 할당(기본값 cache20)    cache20 = 미리 20까지 만들어두고 20을 다 쓰면 새로 20개를 만든다.
        
        캐시메모리 : 미리 발생될 값들을 생성해서 저장해두는 공간
                   매번 호출 될때마다 새롭게 번호를 생성하는게 아니라 
                   캐시메모리 공간에 미리 생성된 번호를 가져다 쓸 수 있음(속도가 빨라짐)
                   접속을 해제하면 캐시메모리에 미리 만들어준 번호들은 다 날라감
            
        [접두어]       
        테이블     : tb_....
        뷰        : vw_....
        시퀀스     : seq_...
        트리거     : trg_...
*/

--시퀀스 생성
create sequence seq_test;

select * from user_sequences;

create sequence seq_empno
start with 500
increment by 5
maxvalue 510
nocycle
nocache;

/*
        2.시퀀스 사용
        
        시퀀스명.currval : 현재 시퀀스의 값(마지막으로 성공한 nextval의 값)
        시퀀스명.nextval : 시퀀스값에 일정한 값을 증가시켜서 발생된 값
                         현재 시퀀스값에서 increment by값만큼 증가한 값
                         ==시퀀스명.currval + increment by값
    --이미 지나간 sequence번호는 롤백 되지 않음
*/
--1.currval, 2. nextval
select seq_empno.currval from dual;
--오류  /오류가 난 이유 : nextval을 먼저 해야 currval을 쓸 수 있다.
--nextval을 단 한번도 수행하지 않은 이상 currval 할수 없음
--currval 의 뜻은 마지막으로 "성공적으로"수행된 "nextval의 값"을 저장해서 보여주는 임시값

select seq_empno.nextval from dual;
select seq_empno.nextval from dual;
select seq_empno.nextval from dual;
select seq_empno.nextval from dual;
--정상 출력
--지정한 maxval을 초과했기 때문에 오류가 난다

select seq_empno.currval from dual;
--더이상 nextval을 하지 못해도 currval은 출력된다.
rollback;
/*
        3.시퀀스 구조 변경
        
        alter sequence 시퀀스명
        [increment by 숫자]
        [maxvalue 숫자]
        [minvalue 숫자]
        [cycle|nocycle]
        [cache 바이트크기|nocache]
        **주의 start with는 변경 불가
        
*/

alter sequence seq_empno
increment by 10
maxvalue 600
minvalue 450
cycle
nocache;

select seq_empno.nextval from dual;

----------------------------------------------------------------------------------------------
/*
        4.시퀀스 삭제
*/
drop sequence seq_empno;

----------------------------------------------------------------------------------------------
/*
        ******실제 적용
*/
create sequence seq_eid
start with 401
nocache;

insert into employee (emp_id,emp_name,emp_no,job_code,hire_date) 
               values(seq_eid.nextval,'우재남','870510-135765','J2',sysdate); 
--실제 적용할떄 sequence.nextval을 insert할떄 값으로 넣어주면 된다.
insert into employee (emp_id,emp_name,emp_no,job_code,hire_date) values(seq_eid,'우재남','870510-135765','J2',sysdate); 





































































































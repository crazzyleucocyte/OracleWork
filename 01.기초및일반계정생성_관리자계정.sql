--이렇게 대시를 두개 쓰면 한 줄 주석이다. 이클립스랑 단축키가 똑같이 컨트롤 슬래시이다.


/*여러줄 주석은 알트 쉬프트 c이다.
ㄹ
ㄹㄹ
ㄹ
ㄹ
*/


--나의 계정 보기
show user;
-- 실행 단축키
-- 커서가 있는 줄 실행은 컨트롤 엔터
--컨트롤 d를 누르면 여기 쓴 모든것이 삭제된다.

--사용자 계정 조회
/*
   - 조회시
     select ~ from  -- ~에 들어가는것은 속성명을 써준다
     조회 양식 : select 속성명 from 테이블명
*/

select * from dba_users;
select username,user_id from dba_users;
-- 데이터를 제외한 속성같은거는 대소문자를 가리지 않고 가져옴
//select는 조회해 갖고오시오라는 뜻
//*라는 속성은 모든 속성 다 가져오시오라는 뜻

---내가 사용할 user를 계정 생성
--mysql에서는 database를 생성해서 사용하지만 오라클에서는 그렇게 하지 않고 user에 테이블을 생성한다

/*
      오라클 12버전부터 일반사용자는 c##으로 시작하는 이름을 가져야함
      비밀번호는 문자로만 가능
*/
--유저 생성 명령어
-- 유저 이름이 오류
--CREATE user user1 IDENTIFIED BY 1234;   

//비밀번호가 오류
--CREATE user c##user1 IDENTIFIED BY 1234;

CREATE user c##user2 IDENTIFIED BY "1234";

--c##키워드를 회피하는 설정 
alter session set "_oracle_script"=true;
--출력값은 session이 변경되었습니다.

--수업시간에 사용할 user생성
/*
        계정명은 대소문자 안가림
        create user 계정명 identified by 비밀번호
        위 양식으로 작성
*/

create user tjoeun identified by 1234;
--위에 세션을 바꿔줘서 c##을 입력하지 않아도 된다.

--권한 생성을 해줘야 한다.
/*
        권한 생성 양식으로 마지막에 작성한 계정명에 작성한 권한을 준다
        계정명과 grant를 쓸때 대소문자 구분 없이 써도 인식 된다.
        [표현법] grant 권한1, 권한2, ..... TO 계정명;
*/

grant resource, connect to TjoEUN;

-- user 삭제
-- drop user 유저명 cascaed; 유저와 그 유저가 가지고 있는 테이블 삭제

--데이터를 넣을때 insert를 사용한다.
-- insert시 생성된 유저에게 테이블스페이스에 얼마만큼의 영역을 할당할것인지를  정해줘야함

--무한으로 쓰는 권한 보통 디폴트값으로 지정 항상 기억하고 있을 수는 없으니 어디 메모해두고 쓰던지 쓸때 찾던지 해야한다.
alter user tjoeun default tablespace users quota unlimited on users;

--특정 용량만큼 정해서 할당
alter user tjoeun quota 30M on users;


02.select_tjoeun계정

--전체 실행은 f5

--춘대학교 사용자 만들기
alter session set "_oracle_script" = true; 
create user chun identified by "1234";
grant resource, connect to chun;
alter user chun default tablespace users quota unlimited on users;

--ddl사용자 만들기
alter session set "_oracle_script" = true; 
create user ddl identified by "1234";
grant resource, connect to ddl;
alter user ddl default tablespace users quota unlimited on users;

alter session set "_oracle_script" = true; 
create user MART identified by "1234";
grant resource, connect to MART;
alter user MART default tablespace users quota unlimited on users;

alter session set "_oracle_script" = true; 
create user jsp identified by "1234";
grant resource, connect to jsp;
alter user jsp default tablespace users quota unlimited on users;

alter session set "_oracle_script" = true; 
create user vote identified by "1234";
grant resource, connect to vote;
alter user vote default tablespace users quota unlimited on users;

alter session set "_oracle_script" = true; 
create user board identified by "1234";
grant resource, connect to board;
alter user board default tablespace users quota unlimited on users;

alter session set "_oracle_script" = true; 
create user mybatis identified by "1234";
grant resource, connect to mybatis;
alter user mybatis default tablespace users quota unlimited on users;

alter session set "_oracle_script" = true; 
create user springboot identified by "1234";
grant resource, connect to springboot;
alter user springboot default tablespace users quota unlimited on users;

alter session set "_oracle_script" = true; 
create user semiproject identified by "1234";
grant resource, connect to semiproject;
alter user semiproject default tablespace users quota unlimited on users;

alter session set "_oracle_script" = true; 
create user semiprojecttest identified by "1234";
grant resource, connect to semiprojecttest;
alter user semiprojecttest default tablespace users quota unlimited on users;

alter session set "_oracle_script" = true; 
create user dicom identified by "1234";
grant resource, connect to dicom;
alter user dicom default tablespace users quota unlimited on users;
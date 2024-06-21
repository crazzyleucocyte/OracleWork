/*
        *DCL(data control language): 데이터 제어 언어
         계정(사용자)에게 시스템 권한 또는 객체에 접근할 수 있는 접근권한을 부여(grant)하거나 회수(revok)하는 구문
         
         >>시스템 권한 : db에 접근하는 권한, 객체를 생성할 수 있는 권한
            시스템 권한의 종류
              - create session  : 접속할 수 있는 권한
              - create table    : 테이블을 생성할 수 있는 권한
              - create view     : 뷰를 생성할 수 있는 권한
              - create sequence : 시퀀스를 생성할 수 있는 권한
         >>객체 접근 권한 : 특정 객체들을 조작할 수 있는 권한
            객체 접근 권한의 종류
            
            권한 종류
             select         table, view, sequence
             insert         table, view
             update         table, view
             delete         table, view
             .....      
*/

------------------------------------------------------------------------------------
--시스템 권한
--1. sample/1234 계정 생성
create user c##sample identified by 1234;

--c##을 안써도 되도록 세션을 바꿔주는 쿼리
alter session set "_oracle_script"=true;
create user sample identified by 1234;
--이거만 하면 계정을 생성할 수 있는 권한을 부여하지 않아 계정을 생성(왼쪽 상단 +버튼)할 수 없다.

--2. 접속을 위한 권한 부여
grant create session to sample;
-- 이걸 해줘야 계정 생성해서 테이블에 접속할 수 있다
CREATE GRANT SESSIon to SAMPLE;

--3.테이블을 생성할 수 있는 권한
GRANT CREATE TABLE TO SAMPLE;

--4.TALBESPACE할당(USER가 이미 존재하는 TABLESPACE의 권한을 바꿔주는것이므로 ALTER를 사용)
ALTER USER SAMPLE QUOTA 2M ON USERS; --사용 가능한 용량을 정해주거나
ALTER USER SAMPLE DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;--용량을 무제한으로 정해주거나

------------------------------------------------------------------------------------------------------------------------------------------------
--객체 접근
--4. SAMPLE 계정에게 TJOEUN 계정의 EMPLOYEE를 SELECT할 수 있는 권한
GRANT SELECT ON TJOEUN.EMPLOYEE TO SAMPLE;

--5.SAMPLE 계정에게 TJOEUN 계정의 EMPLOYEE를 INSERT할 수 있는 권한
GRANT INSERT ON TJOEUN.EMPLOYEE TO SAMPLE;
------------------------------------------------------------------------------------------------------------------------------------------------
/*
        권한 회수
        REVOKE 회수할 권한 ON테이블명 FROM 계정명;
*/
--SAMPLE로부터 SELECT할 수 있는 권한 회수
REVOKE SELECT ON TJOEUN.EMPLOYEE FROM SAMPLE;
--SAMPLE로부터 더조은.임플로이에 INSERT할 수 있는 권한 회수
REVOKE INSERT ON TJOEUN.EMPLOYEE FROM SAMPLE;

--grant resource, connect to chun;
--위와 같은 권한 부여는 여러 특정 권한을 묶어둔 것으로 이것만 쓰면 권한을 다 줄 수 있다.
--------------------------------------------------------------------------------------------------------------------------------------------
/*
        *ROLE
         :특정 권한들을 하나의 집합으로 모아놓은것
         
         CONNECT : CREATE, SESSION
         RESOURCE : CREATE TABLE + CREATE SEQUENCE + ....(다른것들을 만들 수 있는 권한)
         DBA : 시스템 및 객체 관리에 대한 모든 권한을 갖고 있는 롤
        
        --ROLE을 사용할떄는
        GRANT CONNECT, RESOURCE TO 계정명;
*/












/*
        * DDL(DATA DEFINITION LANGUAGE)
            오라클에서 제공하는 객체(object)를 만들고(create).구조를 변경(alter)하고, 구조자체를 삭제(DROP)하는 언어
            즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
            주로 DB관리자, 설계자가 사용함
            
            - 오라클에서 객체(구조) : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE), 인덱스( INDEX), 페키지(PAKAGE), 트리거(TRIGGER),
                                  프로시듀얼(PROCEDURE), 함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)

*/
--===============================================================================
/*
        *CREATE
          :객체를 생성하는 구문
*/
------------------------------------------------------------------------------------------------------------------------
/*
        1. 테이블 생성
         - 테이블이란 : 행(ROE)과 열(COLUMN)로 구성된 가장 기본적인 데이터베이스 객체
                      모든 데이터들은 테이블을 통해 저장됨
                      {표 형태를 DB에서는 테이블)
                      
            [표현법]
        CREATYE TABLE 테이블명(
          컬럼명 자료형(크기),
          컬럼명 자료형(크기),
          컬럼명 자료형(크기),
          컬럼명 자료형,
          .......
        );
        
        *오라클에서 말하는 자료형
         - 문자 (CHAR(바이트크기)) | VARCHAR2(바이트크기)) -> 문자형은 반드시 크기 지정해야함 
           -> CHAR : 최대 2000BYTE까지 지정 가능
                     고정길이(지정한 크기보다 더 적은 값이 들어와도 공백으로라도 채워서 처음 지정한 크기만큼 고정)
                     고정된 데이터를 넣을때 사용
                     -한글은 글자당 3바이트
           -> VARCHAR2 : 최대 4000BYTE까지 지정가능
                         가변길이(들어온 값의 크기에 따라 달라짐)
                         몇 글자가 들어올지 모를떄 사용
           -> NUMBER(숫자): 정수, 실수, 음수, 양수 구분 없이 다 들어간가
           -> DATE(날짜)
         
*/

--회원에 대한 데이터를 담기 위한 테이블 MEMBER생성
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);

SELECT* FROM MEMBER;

--사용자가 가지고 있는 테이블 정보
--데이터 딕셔너리 : 다양한 객체들의 정보를 저장하고 있는 시스템 테이블등
--[참고]USER_TABLES :이 사용자가 가지고 있는 테이블의 전반적인 구조를 확인할 수 있는 시스템 테이블
SELECT * FROM USER_TABLES;

--[참고] USER_TAB_COLUMNS : 사용자가 가지고 있는 테이블의 모든 컬럼의 전반적인 구조를 확인할 수 있는 시스템 테이블
SELECT* FROM USER_TAB_COLUMNS;

------------------------------------------------------------------------------------------------------------------------------------
/*
        2. 컬럼에 주석 달기
        
        [표현법]
        conmment on column 테이블명.컬럼명 is'주석내용';
        
        >>잘못 작성했을떄는 그냥 수정한 후 다시 실행하면 덮어쓰기가 됨(COMMENT만 가능)

*/

COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_NO IS'회원번호';
COMMENT ON COLUMN MEMBER.MEM_PWD IS'회원 비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원 이름';
COMMENT ON COLUMN MEMBER.GENDER IS '회원성별(남,여)';
COMMENT ON COLUMN MEMBER.PHONE IS'회원 전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS'회원 전화번호';
COMMENT ON COLUMN MEMBER.MEM_DATE IS'회원가입일';

COMMENT ON COLUMN MEMBER.MEM_DATE IS'가입일';

--테이블에 데이터를 추가시키는 구문
--INSERT INTO 테이블명 VALUES();
INSERT INTO MEMBER VALUES(1,'user01','pass01','홍길동','남','010-1234-5678','user01@naver.com','24/06/01');
INSERT INTO MEMBER VALUES(2,'user02','pass02','남길동','남',null,null,sysdate);

INSERT INTO MEMBER VALUES(null,null,null,null,null,null,null,null);

------------------------------------------------------------------------------------------------------------------------------------
/*
        3. 제약조건(constraints)
          - 원하는 데이터값(유효한 형식의 값)만 유지하기 위해 특정 컬럼에 설정하는 제약
          - 데이터 무결성 보장을 목적으로 한다
           : 데이터의 결함이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
            1. 개체 부결성 제약조건 : not null, unique(중복되지 않도록),primary key조건 위배가 되는지
            2. 참조 무결성 제약조건 : foreign key(외래키) 조건 위배되는지
            
            종류 : not null, unique,primary key, check(조건),foreign key
          
          제약조건을 부여하는 방식 2가지
          1) 컬럼 레벨 방식   : 컬럼명 자료형 옆에 기술
          2) 테이블 레벨 방식 : 모든 컬럼들을 나열한 후 마지막에 기술
*/

/*
        *not null 제약조건
          해당 컬럼에 반드시 값이 존재해야만 할 경우(즉, 컬럼값에 null이 들어오면 안됨)
          삽입/수정시 null값을 허용하지 않도록 제한
       -->> not null 제약조건 컬럼 레벨 방식만 사용 가능하다
*/

--not null제약조건
--테이블을 하나 새로 만든다
--테이블의 열에대한 조건을 볼때 nullable 열에 yes나 no로 기재되어 있다.
create table mem_notnull(
  mem_no number not null,
  mem_id varchar2(20) not null,
  mem_pwd varchar2(20) not null,
  mem_name varchar2(20) not null,
  gender char(3),
  phone varchar2(13),
  email varchar2(50)
);
insert into mem_notnull values(1,'user01','pass01','이고잉','여','010-1234-5678','user01@gmail.com');
insert into mem_notnull values(null,'user01','pass01','이고잉','여','010-1234-5678','user01@gmail.com');--오류 : 제약조건 위배
--not null 제약조건에 위배
insert into mem_notnull values(1,'user01','pass03','김앤북','여','010-1234-2000','user03@gmail.com');
-------------------------------------------------------------------------------------------
/*
        *unique 제약조건
         : 해당 컬럼에 중복된 값이 들어가서는 안되는 경우
           삽입/수정시 기존에 있는 데이터의 중복값이 있을 경우 오류 발생
           >>컬럼래벨방식, 테이블 레벨방식 모두 가능

*/
create table mem_unique(
 eme_no number not null,
 eme_id varchar2(20) not null unique,
 emp_pwd varchar2(20) not null,
 emp_name varchar2(20) not null,
 gender char(3),
 phone varchar2(13),
 email varchar2(50)
);

insert into mem_unique values(1,'user01','pass01','이고잉','여','010-1234-5678','user01@gmail.com');
insert into mem_unique values(2,'user01','pass01','최규태','여','010-1234-5678','user01@gmail.com');
-- 오류 : 무결성 제약조건에 위배됩니다.(eme_id의 제약 조건에 unique가 있기 때문)

--테이블 레벨방식
create table mem_unique2(
 eme_no number not null,
 eme_id varchar2(20) not null,
 emp_pwd varchar2(20) not null,
 emp_name varchar2(20) not null,
 gender char(3),
 phone varchar2(13),
 email varchar2(50),
 unique(eme_id)
);
insert into mem_unique2 values(1,'user01','pass01','이고잉','여','010-1234-5678','user01@gmail.com');
insert into mem_unique2 values(2,'user01','pass01','최규태','여','010-1234-5678','user01@gmail.com');

--각 컬럼별로 중복값 확인(ex)
create table mem_unique3(
 eme_no number not null,
 eme_id varchar2(20) not null,
 emp_pwd varchar2(20) not null,
 emp_name varchar2(20) not null,
 gender char(3),
 phone varchar2(13),
 email varchar2(50),
 unique(eme_no),
 unique(eme_id)
);

insert into mem_unique2 values(1,'user01','pass01','이고잉','여','010-1234-5678','user01@gmail.com');
insert into mem_unique2 values(2,'user01','pass01','최규태','여','010-1234-5678','user01@gmail.com');

--2개의 컬럼을 묶어서 중복값 확인(ex)(1, user01) != (1, user02)  )
create table mem_unique4(
 eme_no number not null,
 eme_id varchar2(20) not null,
 emp_pwd varchar2(20) not null,
 emp_name varchar2(20) not null,
 gender char(3),
 phone varchar2(13),
 email varchar2(50),
 unique(eme_id, eme_no)
 --이렇게 괄호 안에 두 개를 써주면 두개의 값이 다 똑같은것만 걸러진다.
 --즉, id는 같고 no가 다르면 데이터가 들어간다.

);
insert into mem_unique4 values(1,'user01','pass01','이고잉','여','010-1234-5678','user01@gmail.com');
insert into mem_unique4 values(2,'user01','pass01','최규태','여','010-1234-5678','user01@gmail.com');
insert into mem_unique4 values(3,'user03','pass03','우재남','ㄴ','010-1234-5678','user01@gmail.com');
--성별에 ㄴ만 있는거는 들어가면 안된다.(성별이 유효한 값이 아니어도 들어감)
-------------------------------------------------------------------------------------------
/*
        *check(조건식) 제약조건
         : 사용자가 정의한 제약조건을 넣고 싶을때 

*/

--컬럼레벨 방식
create table mem_check(
 mem_no number not null,
 mem_id varchar2(20) not null unique,
 emp_pwd varchar2(20) not null,
 emp_name varchar2(20) not null,
 gender char(3) check(gender in ('남','여')),
 phone varchar2(13),
 email varchar2(50)
);

insert into mem_check values(1,'user01','pass01','이고잉','여','010-1234-5678','user01@gmail.com');
insert into mem_check values(2,'user02','pass02','이고잉','ㅇ','010-1234-5678','user01@gmail.com');
--오류 : check 제약조건 위배

--테이블 레벨 방식
create table mem_check2(
 mem_no number not null,
 mem_id varchar2(20) not null,
 emp_pwd varchar2(20) not null,
 emp_name varchar2(20) not null,
 gender char(3) ,
 phone varchar2(13),
 email varchar2(50),
 unique(mem_id),
 check (gender in('남','여'))
);

------------------------------------------------------------------------------------------------------------------------------
/*
        *primary key(기본키) 제약조건
         : 테이블에서 각 행들을 식별하기 위해 사용될 컬러명 부여하는 제약조건(식별자 역할)

          ex) 회원번호, 학번, 사원번호, 주문번호, 예약번호, 운송장번호,.....을 주로 기본키로 사용한다.
          
          -primary key(기본기)제약조건을 부여하면 not null + unique 제약조건을 의미
          >>대체적으로 검색, 수정, 삭제할때 기본키의 컬럼값을 이용함
          
          *주의사항 : 한 테이블 당 오로지 1개만 설정 가능
          
          
*/

--컬럼레벨 방식
create table mem_primary(
 mem_no number primary key,
 mem_id varchar2(20) not null,
 mem_pwd varchar2(20) not null,
 mem_name varchar2(20) not null,
 gender char(3),
 phone varchar2(13),
 email varchar2(50)
 );

/*
    * 제약조건 부여시 제약조건명까지 지어주는 방법
    
    >> 컬럼 레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형 [CONSTRAINT 제약조건명] 제약조건,
        컬럼명 자료형
    );
    
    >> 테이블 레벨 방식
    CREATE TABLE 테이블명(
        컬럼명 자료형,
        컬럼명 자료형,
        [CONSTRAINT 제약조건명] 제약조건(컬럼명)
    );
*/

--테이블 레벨 방식
--제약조건 이름 변경 : constraint 제약조건의이름(사용자정의) 제약조건명(not null, unique)
-- 제약조건 이름 변경시 유의사항 : 계정에는 같은 이름의 제약조건이 존재할 수 없다.
create table mem_primary2(
 mem_no number,
 mem_id varchar2(20) not null,
 mem_pwd varchar2(20) not null,
 mem_name varchar2(20) not null,
 gender char(3) ,
 phone varchar2(13),
 email varchar2(50),
 constraint mem_pk_ primary key(mem_no)
 );

insert into mem_primary values(1,'user01','pass01','홍길동','남',null,null);
insert into mem_primary values(2,'user02','pass02','우재남','남',null,null);
insert into mem_primary values(2,'user03','pass03','이고잉','여',null,null);
--오류 : 무결성 제약조건(DDL.SYS_C007836)에 위배됩니다.(primary key 제약조건을 위해되서)
--어떤 오류인지 제약조건의 코드(DDL.SYS_C007836)를 찾아가면 알 수 있는데 이거를 사용자가 변경해줄 수 있다.

create table mem_primary3(
 mem_no number,
 mem_id varchar2(20) not null constraint id_unique unique,
 mem_pwd varchar2(20) not null,
 mem_name varchar2(20) not null,
 gender char(3) constraint gen check(gender in ('남','여')),
 phone varchar2(13),
 email varchar2(50),
 constraint _pk primary key(mem_no)
 );

--아래의 방식을 복합키라고 한다.
--테이블 레벨방식만 가능한데
--기본키를 2개 넣었을때 2개를 묶어서 하나의 기본키로 설정됨
create table mem_primary4(
 mem_no number,
 mem_id varchar2(20) not null constraint id_unique unique,
 mem_pwd varchar2(20) not null,
 mem_name varchar2(20) not null,
 gender char(3) constraint mem_gen check(gender in ('남','여')),
 phone varchar2(13),
 email varchar2(50),
 constraint mem_pk primary key(mem_no,mem_id)
 );

/*
        --복합기 사용 예시(찜 기능)
        //2개를 묶어서 하나의 기본키 역할을 한다.
        1. 1번 회원이 A상품을 찜했다
        2. 1번 회원이 B상품을 찜했다.
        3. 1번 회훤이 A상품을 찜했다. ---불가능
        
        1.2번 회원이 A상품을 찜했다
        2.2번 회원이 B상품을 찜했다
        3.2번 회원이 C상품을 찜했다

*/

create table tb_like(
    mem_no number,
    product_name varchar2(20),
    like_date date,
    primary key(mem_no, product_name)
);

insert into tb_like values(1,'A',sysdate);
insert into tb_like values(1,'B',sysdate);

insert into tb_like values(2,'A',sysdate);
insert into tb_like values(2,'B',sysdate);

--복합키로 지정한 mem_no, product_name와 같은 값이 입력 되어서 오류가 뜬다.
insert into tb_like values(1,'A',sysdate);
insert into tb_like values(2,'A',sysdate);

--복합키도 primary key이므로 primary key로 지정한 컬럼에 null값을 지정할 수 없다.
--각 컬럼은 null값은 안되고, 2개의 컬럼을 합쳐서 유일해야함
insert into tb_like values(null,'A',sysdate);

--=====================================================================================================
-- 회원등급 테이블과 회원테이블 2개 생성
--회원등급 테이블
create table mem_grade(
    grade_code number primary key,
    grade_name varchar2(30) not null
);
--회원등급을 3개로 나눔
insert into mem_grade values(10,'일반회원');
insert into mem_grade values(20,'우수회원');
insert into mem_grade values(30,'특별회원');

--회원테이블 생성 후 회원별 등급
create table mem(
    mem_no number constraint pk2 primary key,
    mem_id varchar2(20) not null unique,
    mem_pw varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3) constraint gen2 check(gender in('남','여')),
    grade_id number);
    
insert into mem values(1,'user01','pass01','이고잉','여',10);
insert into mem values(2,'user02','pass02','나남자','남',30);
insert into mem values(3,'user03','pass03','차규남','남',100);
-- 유효한 회원등급번호가 아님에도 불구하고 입력됨
--100은 유효하지 않은 번호이다.

---------------------------------------------------------------------------------------------------------------------

/*
        * 외래키(froeign key)제약조건
         : 다른 테이블에 존재하는 값만 들어와야하는 특정컬럼에 부여하는 제약조건
          -->다른 테이블을 참조한다고 표현
          -->주로 외래키 제약조건에 의해 테이블 간의 관계가 형성됨
          
          >>컬럼레벨방식
             컬럼명 자료형 [constraint 제약조건명] references 참조할 테이블명[(탐조할 컬럼명)]
             //참조할 컬럼명에 컬럼명이 같으면 넣어주지 않아도 된다.//넣어주지 않으면 primary key가 자동으로 들어온다.

          >> 테이블 레벨 방식
             [constraint 제약조건명] foreign key(컬럼명(내꺼)) reference 참조할 테이블명[(탐조할 컬럼명)]

*/

create table mem2(
    mem_no number primary key,
    mem_id varchar2(20) not null unique,
    mem_pw varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3) check(gender in('남','여')),
    grade_id number references mem_grade(grade_code)  --컬럼레벨 방식
    --foreign key(grade_id) references mem_grade(grade_code)--테이블 레벨 방식
    );

insert into mem2 values(1,'user01','pass01','이고잉','여',10);
insert into mem2 values(2,'user02','pass02','나남자','남',30);
insert into mem2 values(3,'user03','pass03','차규남','남',100);
--외래키 제약조건 위배 but not null을 써주지 않아 null가능
-- grade_id number references mem_grade(grade_code) not null 이렇게 쓰면 된다.
insert into mem2 values(3,'user03','pass03','차규남','남',null);


-- mem_grade(부모테이블)-|-------<--mem2(자식테이블)
--자식테이블의 값은 맘데로 삭제가 되지만 부모테이블은 함부로 삭제할 수 없다. 삭제하면 자식테이블이 외래키 위반이 된다.

-->이때 부모 테이블 데이터 타입을 삭제할 경우 문제가 발생한다
--데이터 삭제: delete from 테이블명 where 조건;  //주의 : where을 쓰지 않으면 테이블 전체가 사라진다.

--자식테이블에서 사용하지 않는 컬럼값은 삭제가 가능하다.
delete from mem_grade where grade_code = 20;

--자식테이블에서 사용하는 컬럼값은 삭제가 불가능하다.
delete from mem_grade where grade_code = 10;
-- 자식 레코드가 발견되었습니다라는 오류가 뜬다. // 오류코드는 자식테이블에 있는 코드가 뜬다.
-- 그래서 여기에 하나씩 데이터를 입력해서 추가하지 않고 사용자로부터 받아서 추가 했을때 자식테이블에서 사용하는 foreign key를 지울때는 신중해야하고
-- 자식테이블의 해당 값을 null값으로 바꾸고 할 수 있다.

------------------------------------------------------------------------------------------------------------------------
/*
        *자식테이블 생성시 외래키 제약조건 부여할 때 삭제 옵션 지정 가능
         - 삭제 옵션 : 부모테이블의 데이터 삭제 시 자식테이블이 사용하고 있는 값을 어떻게 처리할지
         
         1) on delete restricted(기본값) : 삭제 제한 옵션, 자식테이블이 쓰고 있는 값이면 부모테이블에서 삭제 불가
         2) on delete set null : 부모테이블의 데이터 삭제 시 자식테이블이 쓰고 있는 값들을 null로 변경하고 부모 테이블의 행 삭제
         3) on delete cascade : 부모테이블의 데이터 삭제시 자식테이블이 쓰고 있는 행도 삭제 

*/
drop table mem; 
drop table mem2;

--외래키 생성시 참조테이블명만 넣으면 참조테이블의 기본키의 컬럼이 자동으로 설정됨
create table mem(
    mem_no number constraint pk2 primary key,
    mem_id varchar2(20) not null unique,
    mem_pw varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3) check(gender in('남','여')),
    grade_id number references mem_grade on delete set null
    );

insert into mem values(1,'user01','pass01','이고잉','여',10);
insert into mem values(2,'user02','pass02','나남자','남',30);
insert into mem values(4,'user04','pass04','송미영','여',20);
insert into mem values(3,'user03','pass03','김앤북','여',20);
insert into mem values(5,'user05','pass05','차규남','남',null);

delete from mem_grade where grade_code = 30;
--삭제됨 자식은 null값으로 바뀜

drop table mem;
create table mem(
    mem_no number constraint pk2 primary key,
    mem_id varchar2(20) not null unique,
    mem_pw varchar2(20) not null,
    mem_name varchar2(20) not null,
    gender char(3) check(gender in('남','여')),
    grade_id number references mem_grade on delete cascade
    );
delete from mem_grade where grade_code=30;

---------------------------------------------------------------------------------------------------------
/*
        *default 값 설정하기
          컬럼의 값이 들어오지 않앙ㅆ을때 기본값으로 넣어줌
          컬럼명 자료형 default 기본값[제약조건]
*/

create table member2(
    mem_no number primary key,
    mem_id varchar2(20) not null,
    mem_age number,
    hobby varchar2(20) default '없음',
    mem_date date default sysdate
);

insert into member2 values(1,'user01',25,'잠자기','24/06/13');
insert into member2 values(2,'user02',null,null,null);
insert into member2 values(3,'user03',27,default,default);

--insert하고 싶은 컬럼만 정해서 입력했을때 입력하지 않은 값은 default값으로 입력된다.

insert into member2 (mem_no,mem_id,mem_age) values(4,'user04',28);

--==================================================================================================
--------------------------------------------tjoeun 계정에서 실행
/*  --이미 있는 테이블의 구조 복사
        *subquery를 이용한 테이블 생성
          테이블 복사하는 개념
          
          [표현식]
          create table 테이블명 as 서브쿼리;
*/

--emoployee테이블을 복제(컬럼값까지)한 새로운 테이블 생성
create table employee_copy
as select * from employee;
-- 컬럼, 데이터값 복사됨
--제약조건은 not null만 복사됨
-- default, column은 복사 안됨

--emoployee테이블을 복제(컬럼값 제외 구조만)한 새로운 테이블 생성
create table employee_copy2
as select * 
   from employee
   where 1=0;
--조건이 맞는 데이터가 없으므로 데이터를 하나도 안가져온다는 뜻

--emoployee테이블을 복제(컬럼값 제외 구조만)한 컬럼을 내가 원하는 컬럼으로만 새로운 테이블 생성
create table employee_copy3
as select emp_id, emp_name, salary 
   from employee
   where 1=0;

--emoployee테이블을 복제(컬럼값 제외 구조만)한 컬럼을 기준테이블에 없는 컬럼도 생성(컬럼의 별칭을 꼭 넣어주어야 한다.)
create table employee_copy4
as select emp_id, emp_name, salary, salary*12 연봉  
   from employee;
    --서브쿼리 select 절에는 산술식 또는 함수식이 기술된 경우 반드시 별칭을 지정해야 됨

drop table employee_copy3;
drop table employee_copy4;

------------------------------------------------------------------------------------------------
/*
        * 테이블 생성 후 제약조건 추가
          alter table 테이블명 변경할 내용
           - primary key : alter table 테이블명 add primary key(컬럼명)
           - forrign key : alter talbe 테이블명 add foreign key(나의 컬럼명) reference 참조할 테이블명[(참조할 컬럼명)]
           - unique : alter table 테이블명 add unique(컬럼명)
           - check : alter table 테이블명 add check(컬럼에 대한 조건식)
           - not null : alter table 테이블명 modify 컬럼명 not null
*/
--employee_copy 테이블에 primary key 제약조건 추가
alter table employee_copy add primary key(emp_id);

--employee_copy 테이블에 foreign key 제약조건 추가
alter table employee_copy add foreign key(dept_code)references department(dept_id);

--commemt 추가
comment on column employee_copy.emp_id is '사원아이디';

---------------------------------------------------------연--습--문--제---------------------------------------------------------------------------------------
--  DDL 계정에서

--도서관리 프로그램을 만들기 위한 테이블들 만들기
--이때, 제약조건에 이름을 부여할 것.
--       각 컬럼에 주석달기
--
--1. 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER)
--   컬럼  :  PUB_NO(출판사번호) NUMBER -- 기본키(PUBLISHER_PK) 
--	PUB_NAME(출판사명) VARCHAR2(50) -- NOT NULL(PUBLISHER_NN)
--	PHONE(출판사전화번호) VARCHAR2(13) - 제약조건 없음
--
--   - 3개 정도의 샘플 데이터 추가하기
   create table tb_publisher(
    pub_no number constraint tb_publisher primary key,
    pub_name varchar2(50) constraint publisher_nn not null,
    phone varchar2(13)
   );
   comment on column tb_publisher.pub_no is '출판사번호';
    comment on column tb_publisher.pub_name is '출판사명';
    comment on column tb_publisher.phone is '출판사 번화전호';

    insert into tb_publisher values(1,'한국잡지','02-123-4567');
    insert into tb_publisher values(2,'좋은나라','041-234-7896');
    insert into tb_publisher values(3,'뿌리깊은나무','031-6789-3445');

--2. 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
--   컬럼  :  BK_NO (도서번호) NUMBER -- 기본키(BOOK_PK)
--	BK_TITLE (도서명) VARCHAR2(50) -- NOT NULL(BOOK_NN_TITLE)
--	BK_AUTHOR(저자명) VARCHAR2(20) -- NOT NULL(BOOK_NN_AUTHOR)
--	BK_PRICE(가격) NUMBER
--	BK_PUB_NO(출판사번호) NUMBER -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
--			         이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
--   - 5개 정도의 샘플 데이터 추가하기
    create table tb_book(
    bk_no number constraint book_pk primary key,
    bk_title varchar2(50) constraint book_nn_title not null,
    bk_author varchar2(20) constraint book_nn_author not null,
    bk_price number,
    bk_pub_no number constraint book_fx references tb_publisher on delete cascade
    );
    
    comment on column TB_BOOK.bk_no is '도서번호';
    comment on column TB_BOOK.bk_title is '도서명';
    comment on column TB_BOOK.bk_author is '저자명';
    comment on column TB_BOOK.bk_price is '가격';
    comment on column TB_BOOK.bk_pub_no is '출판사 번호';
--도서번호(숫자로만 8글자),'도서명'(한글 10글자 이내),'저자명'(한글),가격(숫자)
insert into tb_book values(9791165341909,'죽고 싶지만 떡볶이는 먹고 싶어','백세희',13500,1);
insert into tb_book values(9788950980414,'아몬드','손원평',12000,1);
insert into tb_book values(9788936433598,'채식주의자','한강',11000,2);
insert into tb_book values(9788982814471,'엄마를 부탁해','신경숙',14000,3);
insert into tb_book values(9788965746766,'소년이 온다','한강',13000,3);

--3. 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
--   컬럼명 : MEMBER_NO(회원번호) NUMBER -- 기본키(MEMBER_PK)
--   MEMBER_ID(아이디) VARCHAR2(30) -- 중복금지(MEMBER_UQ)
--   MEMBER_PWD(비밀번호)  VARCHAR2(30) -- NOT NULL(MEMBER_NN_PWD)
--   MEMBER_NAME(회원명) VARCHAR2(20) -- NOT NULL(MEMBER_NN_NAME)
--   GENDER(성별)  CHAR(1)-- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
--   ADDRESS(주소) VARCHAR2(70)
--   PHONE(연락처) VARCHAR2(13)
--   STATUS(탈퇴여부) CHAR(1) - 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
--   ENROLL_DATE(가입일) DATE -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)
--
--   - 5개 정도의 샘플 데이터 추가하기

create table tb_member(
member_no number ,
 member_id varchar2(30)  ,
 member_pwd varchar2(30) constraint member_nn_pwd not null,
 member_name varchar2(20) constraint member_nn_name not null,
 gender char(1) ,
 address varchar2(70),
 phone varchar2(13),
 status char(1) default 'N',
 enroll_date date default sysdate constraint member_nn_en not null,
 
 constraint member_pk primary key,
 constraint member_uq unique,
 constraint member_ck_gen check(gender in('M','F')),
  constraint mem_ck_sta check(status in('N','Y'))
);
comment on column tb_member.member_no is'회원번호';
comment on column tb_member.member_id is '아이디';
comment on column tb_member.member_pwd is'비밀번호';
comment on column tb_member.member_name is'회원명';
comment on column tb_member.GENDER is'성별';
comment on column tb_member.ADDRESS is'주소';
comment on column tb_member.PHONE is '연락처';
comment on column tb_member.STATUS is'탈퇴여부';
comment on column tb_member.ENROLL_DATE is'가입일';

insert into tb_member values(1, 'user001', 'password123', '홍길동', 'M', '서울특별시 강남구', '01012345678', 'Y', '2023-01-15');
insert into tb_member values(2, 'user002', 'pass456', '김영희', 'F', '부산광역시 해운대구', null, 'N', '2023-02-20');
insert into tb_member values(3, 'user003', 'mypassword', 'Lee Minho', 'M', '대구광역시 중구', '01034567890', default, '2023-03-10');
insert into tb_member values(4, 'user004', 'securepass', '박지은', 'F', null, '01045678901', default, '2023-04-05');
insert into tb_member values(5, 'user005', 'password789', 'Choi Jungwoo', 'M', null, '01056789012', default, default);

--4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블(TB_RENT)
--   컬럼  :  RENT_NO(대여번호) NUMBER -- 기본키(RENT_PK)
--	RENT_MEM_NO(대여회원번호) NUMBER -- 외래키(RENT_FK_MEM) TB_MEMBER와 참조하도록
--			이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
--	RENT_BOOK_NO(대여도서번호) NUMBER -- 외래키(RENT_FK_BOOK) TB_BOOK와 참조하도록
--			이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
--	RENT_DATE(대여일) DATE -- 기본값 SYSDATE
--
--   - 3개 정도 샘플데이터 추가하기
create table tb_rent(
rent_no number constraint rent_pk primary key,
rent_mem_no number constraint rent_fk_mem references tb_member on delete set null,
rent_book_no number constraint rent_fk_book references tb_book on delete set null,
rent_date date default sysdate
);

comment on column tb_rent.rent_no is '대여번호';
comment on column tb_rent.RENT_MEM_NO is'대여회원번호';
comment on column tb_rent.RENT_BOOK_NO is'대여도서번호';
comment on column tb_rent.RENT_DATE is'대여일';

insert into tb_rent values(1,1,9788950980414,'2023-12-23');
insert into tb_rent values(2,4,9788982814471,'2023-02-20');
insert into tb_rent values(3,5,9791165341909,default);




















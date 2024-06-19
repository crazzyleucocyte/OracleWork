--데이터를 변경하는건 update, 구조를 변경하는건 alter이다
--데이터 : update, insert, delete
--테이블 : alter,  create, drop

/*
        DDL(DATADEFINITION LANGUAGE)
        *alter
         객체를 변경하는 구문
         
         [표현식]
         alter table 테이블명 변경할내용;

          -변경할 내용
           1) 컬럼 추가/수정/삭제
           2) 제약조건 추가/삭제 -> 수정 불가(수정하려면 삭제하고 다시 새로 추가)
           3) 컬럼명/제약조건명/테이블명 변경할때 사용

*/
--------------------------------------------------------------------------------------------------------------------
/*
                   1) 컬럼 추가/수정/삭제
*/
/*
        1.1 컬럼 추가(add)
        
        [표현법]
        add 컬럼명 데이터타입[default 기본값]
*/

--dept_copy에 cname컬럼 추가--- not null 불가.
--아마 새로 추가하면 모든 행의 값이 다 null이 되서 그런듯, default값을 지정해주면 not null가능할듯
alter table dept_copy add cname varchar2(20);

--dept_copy에 lname컬럼 추가, 기본값으로 '한국'
alter table dept_copy add lname varchar2(30) default '한국';
--기존에 문자로 되어있던 컬럼을 숫자 타입으로 변경하려면 update로 모두 null로 바꾸고 alter해줘야 한다.

/*
        1.2 컬럼 수정(modify)
        
        [표현법]
        --데이터 타입을 수정할 때
        modify 컬럼명 바꾸려는데이터타입
        
        --default 값 수정
         modify 컬럼명 default 바꾸고자하는기본값
*/

--dept_copy 테이블의 dept_id의 자료형을 char3바이트로 변경
alter table dept_copy modify dept_id char(3);

--dept_copy 테이블의 dept_id의 자료형을 number로 변경
alter table dept_copy modify dept_id number;
--오류
--dept_copy 테이블의 dept_title의 자료형을 varchar2(10)로 변경
alter table dept_copy modify dept_title varchar2(10);
--오류 : 들어있는 데이터값이 변경하고자하는 자료형보다 큰 값이 들어있기 때문

--dept_copy테이블의 dept_title의 자료형 varchar2(40)변경
alter table dept_copy modify dept_title varchar2(40);
--dept_copy테이블의 location_id의 자료형 varchar2(2)변경
alter table dept_copy modify location_id varchar2(2);
--dept_copy테이블의 lname컬럼의 기본값을 '미국'으로 변경
alter table dept_copy modify lname default '미국';
--다중변경 가능
alter table dept_copy modify dept_title varchar2(40)
                      modify location_id varchar2(2)
                      modify lname default '미국';
/*
        1.3 컬럼 삭제(drop column)
        
        [표현법]
         drop column 컬럼명

        --롤백이 안됨..?
*/
--dept_copy테이블에서 cname컬럼 삭제
alter table dept_copy drop column cname;
--drop은 다중삭제 안됨

alter table dept_copy drop column dept_title;
alter table dept_copy drop column location_id;
alter table dept_copy drop column lname;

--위의 쿼리를 다 실행하면 dept_id하나 남는데 하나 남은 컬럼은 삭제할 수 없다.
alter table dept_copy drop column dept_id;
--오류 : 테이블에 최소 하나의 컬럼은 존재해야하기 때문에 

----------------------------------------------------------------------------------------------------------------
/*
        *제약조건 추가/삭제
         - 제약조건 추가
          * 테이블 생성 후 제약조건 추가
          alter table 테이블명 변경할 내용
           - primary key : alter table 테이블명 add primary key(컬럼명)
           - forrign key : alter talbe 테이블명 add foreign key(나의 컬럼명) reference 참조할 테이블명[(참조할 컬럼명)]
           - unique : alter table 테이블명 add unique(컬럼명)
           - check : alter table 테이블명 add check(컬럼에 대한 조건식)
           - not null : alter table 테이블명 modify 컬럼명 not null

        >제약조건명을 지정하려면 constraint 제약조건명 제약조건
        
        >제약조건 삭제
         drop constraint 제약조건
         modify 컬럼명 null(not null 제약조건을 null로 바꿀때)
*/

-- department테이블을 복사하여 dept_copy 테이블 생성
create table dept_copy
as select* from department;
--dept_copy테이블에 lname 컬럼 추가
alter table dept_copy 
add lname varchar2(30);

alter table dept_copy 
modify lname default '미국';

update dept_copy
set lname = default;

--dept_copy테이블 제약조건 추가
--1) dept_id 컬럼에 기본기
alter table dept_copy 
add constraint d_copy_pk primary key(dept_id);

alter table dept_copy drop constraint SYS_C008050;
--2) dept_title에 unique
alter table dept_copy 
add constraint d_copt_uq unique(dept_title);
--3) lname컬럼에 not null
alter table dept_copy 
modify lname constraint d_copy_nn not null;


--제약조건 삭제
alter table dept_copy drop constraint d_copy_pk;
alter table dept_copy drop constraint SYS_C008051
                      drop constraint SYS_C008052;

------------------------------------------------------------------------------------------------------------------------------------------
/*
        3. 컬럼명/ 제약조건명/테이블명 변겅
            --컬럼명/제약조건명
          alter table 테이블명 rename(column, constraint) 기존이름 to 바꿀 이름
            --테이블명
          alter table 테이블명 rename[기존테이블명]to 바꿀 테이블명
        
          3.1 컬럼명 변경
          
            [표현볍]
             rename column 기존컬럼명 to 바꿀 컬럼명
*/
--dept_copy테이블의 dept_title컬럼명을 dept_name으로 변경
alter table dept_copy rename column dept_title to dept_name;

/*
        3.2 제약조건명 변경
        
          [표현법]
          rename constraint 기존 제약조건명 to 바꿀 제약조건명
*/

alter table dept_copy rename constraint d_copt_uq to d_copy_unique;
/*
        3.3 테이블명 변경
        
          [표현법]
          rename [기존테이블명]to바꿀 테이블명


*/

alter table dept_copy rename to dept_test;
--------------------------------------------------------------------------------------------------------------------------------------------
--테이블 삭제
drop table dept_test;

/*
        -테이블 삭제시 외래키가 걸린 부모 테이블은 삭제가 되지 않는다.
         그래도 삭제하고 싶다면
         * 방법1 : 자식테이블을 먼저 삭제하고 부모테이블을 삭제한다.
         * 방법2 : 부모테이블만 삭제하는데 제약조건을 같이 삭제하는 방법(외래키 삭제)
                  drop talbe 부모테이블명 cascade constraint;
                  
        --테이블 우클릭하고 삭제할때 계단식 제약조건 체크박스가 뜻하는게 이거다
        --삭제하려는 테이블이 부모테이블이고 외래키가 있을때 그 외래키 제약조건을 자식테이블에서도 삭제시켜준다.
*/




































































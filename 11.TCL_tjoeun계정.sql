
/*
        *TCL(transaction control language) : 트랜젝션 제어 언어
        
        *트랜잭션
         - 테이터 베이스의 논리적 연산단위
         - 데이터의 변경사항(dml)들을 하나의 트랙잭션에 묶어서 모아두었다가 처리
              DML문(데이터 조작 언어, insert, update, delete)
           DML문 한개를 수행할 떄 트랜잭션이 존재하면 해당 드랜잭션이 같이 묶어서 처리
                                        존재하지 않으면 트랜잭션을 만들어서 묶어서 처리
           commit하기 전까지의 변경사항들을 하나의 트랜잭션에 담아줌
         - 트랜잭션의 대상이 되는 sql문 : insert, update, delete
         
         commit(트랜잭션 종료 처리 후 확정)
         rollback(트랜잭션 취소)
         savepoint(임시저장)
         
         - commit : 한 트랜잭션에 담겨있는 변경사한들을 실제 db에 반영시키겠다는 의미(이후에 트랜잭션은 사라짐)
         - rollback : 한 트랜잭션에 담겨있는 변경사항들을 삭제(취소)한 후 마지막 commit시점으로 돌아감
         - savepoint : 현재 이 시점에 해당 포인트명으로 임시저장점을 정의해 두는것
                       rollback 진행 시 전체 변경사항을 삭제하는것이 아니라 일부만 삭제
        
        dml문으로 변경사항(insert, update, delete)이 생긴 상태에서 커밋 후 롤백은 되지 않지만
        커밋 하기 전에 롤백을 하면 변경사항이 저장되지 않는다.
*/
--select는 그냥 보여주고 끝이다.
select*from emp_01;

--사번이 302번인 사원 삭제
delete from emp_01 where emp_id=302;

-------끄적
insert into emp_01(emp_id) values(4);
insert into emp_01(emp_id) values(2);
insert into emp_01(emp_id) values(3);
delete from emp_01 where emp_id=1;
delete from emp_01 where emp_id=2;
rollback;
commit;
----끄적

select* from emp_01;

insert into emp_01 values(500,'김미영','인사관리부');

commit;

rollback; --commit이 되었기 때문에 롤백이 되지 않음

---------------------------------------------------------------------------
--사번이 200,201,202인 사원 삭제
delete from emp_01
where emp_id in(200,201,202);

--임시저장 지점
savepoint sp;

--사원 추가
insert into emp_01 values(501,'이세종','총무부');

--220사원 삭제
delete from emp_01
where emp_id=220;

--그냥 롤백하면 임시저장지점과 상관 없이 전부 롤백이 된다.`
rollback;

--근데 이렇게 롤백 to 임시저장 이름을 하면 임시저장한 곳까지만 롤백이 된다.
rollback to sp;

commit;

select *from emp_01;

------------------------------------------------------------------------------------------------------
/*
        *자동 커밋이 되는 경우
         - 정상 종료가 되었을때
         - dcl(계정 관렬)과 ddl(create, alter, drop)문이 수행된 경우
        
        *자동 롤백이 되는 경우
         - 비정상 종료
         - 전원꺼짐, 컴퓨터 down....등등
*/
--4번 사원 삭제
delete from emp_01 where emp_id=4;

--500번 사원 삭제
delete from emp_01 where emp_id=500;

--테이블 생성
create table test(
tid number);
rollback;
--dml문 이후  트랙잭션에 담겨있던 변경사항들이 ddl문이 실행됨으로 인해 커밋이 되어 롤백을 해도 돌아가지 않는다.





























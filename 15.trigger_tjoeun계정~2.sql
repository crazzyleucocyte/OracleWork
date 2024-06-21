
/*
        *trigger 
         : 테이블에서 dml문에 의해 변경사항이 생길때마다 자동으로 실행할 내용을 미리 정의해 둘수 있는 객체
         
         ex)
         - 회원탈퇴시 회원 테이블에서는  delete를 할 때, 탈퇴회원들만 보관하느 ㄴ테이블에 자동으로 insert처리
         - 신고 횟수가 일정 수를 넘으면 자동으로 해당 회원을 블랙리스트로 처리하게
         - 입출고에서 insert 될때마다 해당상품의 재고수량이 update를 해야될때
         
         * 트리거의 종류
            - sql문 실행시기에 따른 분류
             > before trigger : 명시된 테이블에 이벤트가 발생되기 전에 트리거 실행
             > after trigger : 명시된 테이블에 이벤트가 발생되고난 후에 트리거 실행

            - sql문에 의해 영향을 받는 각 행에따른 분류
             > statement trigger(문장 트리거) : 이벤트가 발생한 sql문에 대해 딱 한번만 트리거 실행
             > row trigger(행 트리거) : 해당 sql문 실행할 때마다 트리거 실행
                                      (for each row 옵션 기술해야됨)
                                      > :old - 기존 컬럼에 들어있던 값
                                      > :new - 새로 들어온 값
                                      
        *트리거 생성
        [표현법]
        
        create [or replace] trigger 트리거명
        before|after insert|update|delete on 테이블명
        [for each row] //각 행마다 실행해야할때 쓴다
        [declare
            변수 선언;]
        begin
          실행내용
        [exception
            예외처리 구문]
        end;
        /   
        
*/ 
--employee테이블에 insert발생하고 난 후 환영인사 트리거
set serveroutput on; --출력할 수 있도록 켜주는거

create or replace trigger trg_01
after insert on employee
--employee테이블에 insert가 되었을때
begin
    dbms_output.put_line('신입사원님 지옥에 오신걸 환영합니다');
end;
/

insert into employee(emp_id, emp_name, emp_no,job_code)
values(304,'처음처럼','021012-412303','J1');

insert into employee(emp_id, emp_name, emp_no,job_code)
values(306,'참이슬','021012-412303','J1');

--상품 입고 및 출고시 재고수량이 변경되도록 트리거 생성
-->> 필요한 테이블과 시퀀스 생성

--1. 상품을 보관할 테이블 생성
create table tb_product(
    pcode number primary key,       --상품번허
    pname varchar2(30) not null,    --상품명
    brand varchar2(30) not null,    --브랜드명
    stock_quant number default 0    --재고
);

--1.2 상품 번호에 넣을 시퀀스 생성
create sequence seq_pcode
start with 200
increment by 5;

--1.3 상품 추가
insert into tb_product values(seq_pcode.nextval,'갤럭시폴드4','삼성',default);
insert into tb_product values(seq_pcode.nextval,'아이폰 15 pro','apple',default);
insert into tb_product values(seq_pcode.nextval,'흥미노트','샤오미',default);

--2. 상품 입고 테이블 생성
create table tb_prostock(
    tcode number primary key,               --입고 번호
    pcode number references tb_product,     --상품 번호
    tdate date,                             --입고 날짜
    stock_count number not null,            --입고 수량
    stock_price number not null             --입고 단가
);
alter table tb_prostock rename column pname to pcode;
alter table tb_prosale modify pcode number;
alter table tb_prosale add foreign key(pcode) references tb_product;

--2.2 상품 번호에 넣을 시퀀스 생성
create sequence seq_tcode;

--3.상품판매 테이블 생성
create table tb_prosale(
    scode number primary key,               --출고 번호
    pcode varchar2(30) not null,            --상품 번호
    sdate date,                             --출고 날짜
    sale_product number not null,           --출고 수량
    sale_price number not null              --출고 단가
);
--3.1 출고번호에 넣을 시퀀스 생성
create sequence seq_scode;


-------------------------------------------------입고
--상품 10개 입고테이블에 입고
insert into tb_prostock
values(seq_tcode.nextval,200,sysdate,10,2100000);
--상품이 입고 되면 제품 테이블에 재고수량을 10개 더해주는 update를 해줘야 한다.

--재고 테이블 수량 변경
update tb_product
    set stock_quant=stock_quant + 10
where pcode=200;

commit;

--210번 제품이 5개가 판매 되었다.

insert into tb_prosale
values(seq_scode.nextval,210,sysdate,5,350000);
--제품 테이블에 재고수량 10개 update
update tb_product
    set stock_quant=stock_quant - 5
where pcode=210;
update tb_product
    set stock_quant=stock_quant + 10
where pcode=205;
commit;

--tb_product 테이블에 매번 자동으로 재고수량 update하는 트리거 정의

--tb_prostock테이블에 insert 이벤트 발생시
delete from tb_prosale;
update tb_product
    set stock_quant=stock_quant - 5
where pcode=210;
/*
update tb_product
    set stock_quant=stock_quant+입고된 수량(insert된 자료의 stock_count)
where pcode = 입고된 상품번호(insert된 자료의 pcode값)
*/

create or replace trigger trg_stock
after insert on tb_prostock
for each row
begin
update tb_product
    set stock_quant=stock_quant+:new.stock_count
    --insert 된 것중 최근에 새로 들어온 값 :new.stock_count
    where pcode = :new.pcode;
end;
/

--205번 3개 입고
insert into tb_prostock 
values(seq_tcode.nextval,205, sysdate,3,1900000);

--210번 5개 입고
insert into tb_prostock 
values(seq_tcode.nextval,210, sysdate,5,350000);

create or replace trigger trg_sale
after insert on tb_prosale
for each row
begin
    update tb_product
    set stock_quant= stock_quant - :new.sale_count
    where pcode=:new.pcode;
end;
/
alter table tb_prosale rename column sale_product to sale_count;
--210번 10개 판매
insert into tb_prosale values(seq_scode.nextval,210,sysdate,10,400000);

--200번 3개 판매
insert into tb_prosale values(seq_scode.nextval,200,sysdate,3,100000);


--판매시 더 많이 판매하지 못하도록 하는 트리거 생성
--판매하기 전에 재고 파악을 먼저 해야하니 before 트리거를 사용해야할듯
/*
        사용자 정의 exception
            raise_applicateion_error([에러코드],[에러 메시지])
            --사용자 정의 예외 처리는 무조건 위 처럼 만들어야 한다.
            
            --사용자 정의 에러코드는 -20000 ~ -20999사이의 코드만 써야한다.

*/
create or replace trigger trg_sale
before insert on tb_prosale
for each row
declare
    scount number;
begin
    --판매하기 전의 재고수량을 scount에 저장
    select stock_quant
    into scount
    from tb_product
    where pcode= :new.pcode;
    --if조건문으로 출고 요청이 들어온 갯수와 현재 재고를 비교
    if (scount> :new.sale_count)
        --판매 가능하여 update
        then update tb_product
              set stock_quant= stock_quant - :new.sale_count
              where pcode=:new.pcode;
    else
        --판매 불가능하여 사용자 정의 에러코드로 재고수량 부족 출력
        raise_application_error(-20001,'재고수량 부족');
    end if;
end;
/

--200번 5개 판매
insert into tb_prosale values(seq_scode.nextval,200,sysdate,5,3000000);

--205번 15개 판매
insert into tb_prosale values(seq_scode.nextval,205,sysdate,15,3000000);














































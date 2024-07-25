create table board(
    num number primary key,
    name varchar2(20) not null,
    subject varchar2(50) not null,
    content varchar2(4000) not null,
    pos number,
    ref number,
    depth number,
    regdate date,
    pass varchar2(50) not null,
    ip varchar2(50),
    count number default 0
);
drop table board;
comment on column board.num is '게시번호';
comment on column board.name is '작성자 이름';
comment on column board.subject is '글 제목';
comment on column board.content is '글 내용';
comment on column board.pos is '상대적위치값';
comment on column board.ref is '부모글';
comment on column board.depth is '글 깊이';
comment on column board.regdate is '작성된 날짜';
comment on column board.pass is '글 비밀번호';
comment on column board.ip is '작성자ip';
comment on column board.count is '글 조회수';

create sequence seq_board nocycle nocache;

insert into board values(SEQ_BOARD.NEXTVAL, '박길동', '제목1', '내용1', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-01', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '김길동', '제목2', '내용2', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-05', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '송길동', '제목3', '내용3', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-12', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '한길동', '제목4', '내용4', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-14', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '곽길동', '제목5', '내용5', 0, SEQ_BOARD.CURRVAL, 0, '2023-04-25', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '원길동', '제목6', '내용6', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-04', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '임길동', '제목7', '내용7', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-07', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '신길동', '제목8', '내용8', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-11', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '박길동', '제목9', '내용9', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-22', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '정길동', '제목10', '내용10', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-29', '1234', '0:0:0:0:0:0:0:1', default);


insert into board values(SEQ_BOARD.NEXTVAL, '엄준식', '제목11', '내용11', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-11', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '김철수', '제목12', '내용12', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-22', '1234', '0:0:0:0:0:0:0:1', default);
insert into board values(SEQ_BOARD.NEXTVAL, '이영미', '제목13', '내용13', 0, SEQ_BOARD.CURRVAL, 0, '2023-05-29', '1234', '0:0:0:0:0:0:0:1', default);

select * 
from 
    (select ROWNUM as RNUM, BT1.* 
     from 
        (select * 
         from board 
         order by ref desc, pos) BT1) 
where RNUM between 1 and 10;

select * 
from 
    (select ROWNUM as RNUM, BT1.* 
     from 
        (select * 
         from board
         where name like('%동%')
         order by ref desc, pos) BT1) 
where RNUM between 1 and 10;

select * from (select ROWNUM as RNUM, BT1.* from (select * from board where name like('%동%')order by ref desc, pos) BT1) where RNUM between 1 and 10;

select count(num) from board;

select * from (select ROWNUM as RNUM, BT1.* from (select * from board where null like '%null%' order by ref desc, pos) BT1) where RNUM between 1 and 10;






































































create table votelist(
    num number primary key,
    question varchar2(200) not null,
    sdate date,
    edate date,
    wdate date,
    type number  default 1,
    active number default 1);

comment on column votelist.num is '설문 번호';
comment on column votelist.question is '설문 내용';
comment on column votelist.sdate is '투표 시작 날짜';
comment on column votelist.wdate is '설문 작성 날짜';

comment on column votelist.edate is '투표 종료 날짜';
comment on column votelist.type is '중복투표 허용 여부';
comment on column votelist.num is '';
comment on column votelist.active is '설문 활성화 여부';

create table voteitem(
    listnum number ,
    itemnum number ,
    item varchar2(50),
    count number default 0,
    primary key(listnum, itemnum)
);
create sequence seq_vote;

COMMENT ON COLUMN VOTEITEM.LISTNUM IS '답변이소속된설문번호';
COMMENT ON COLUMN VOTEITEM.ITEMNUM IS '답변번호';
COMMENT ON COLUMN VOTEITEM.ITEM IS '답변내용';
COMMENT ON COLUMN VOTEITEM.COUNT IS '투표수';




























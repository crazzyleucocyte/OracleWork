create table boardtest(
    boardno number primary key,
    title varchar2(50),
    writer varchar2(20),
    content varchar2(500)
);

create sequence seq_boardtest;


insert into boardtest values(seq_boardtest.nextval, '제목1','유저1','하하호호');
insert into boardtest values(seq_boardtest.nextval, '제목2','유저2','히히하하');

commit;
insert into boardtest values(seq_boardtest.nextval, '제목3','유저3','하하호호');
insert into boardtest values(seq_boardtest.nextval, '제목4','유저4','히히하하');
insert into boardtest values(seq_boardtest.nextval, '제목5','유저5','하하호호');
insert into boardtest values(seq_boardtest.nextval, '제목6','유저6','히히하하');

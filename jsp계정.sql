create table member(
    id varchar2(20) primary key,
    pwd varchar2(20) not null,
    name varchar2(20) not null,
    gender char(1),
    birthday char(6),
    email varchar2(30),
    zipcode char(5),
    address varchar2(100),
    detailAddress varchar2(50),
    hobby char(5),
    job varchar2(30)
);
comment on column member.id is '아이디';
comment on column member.pwd is '비밀번호';
comment on column member.name is '이름';
comment on column member.gender is '성별';
comment on column member.birthday is '생일';
comment on column member.email is '이메일';
comment on column member.zipcode is '우편번호';
comment on column member.address is '주소';
comment on column member.detailaddress is '상세주소';
comment on column member.hobby is '취미';
comment on column member.job is '직업';

CREATE TABLE REPLY (
    NO NUMBER PRIMARY KEY,
    CONTENT VARCHAR2(400),
    REF NUMBER,
    NAME VARCHAR2(20),
    REDATE DATE
);

CREATE SEQUENCE SEQ_REPLY NOCACHE;

INSERT INTO REPLY VALUES(SEQ_REPLY.NEXTVAL, '와우!! 첫 댓글', 1, '김처음', '2024/07/01');
INSERT INTO REPLY VALUES(SEQ_REPLY.NEXTVAL, '굉장하군요', 1, '박굉장', '2024/07/20');
INSERT INTO REPLY VALUES(SEQ_REPLY.NEXTVAL, '멋져요', 1, '이멋짐', '2024/07/26');




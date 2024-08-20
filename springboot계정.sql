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

create table jpaPaging (
    id number PRIMARY KEY,
    name varchar(20),
      email varchar(50)
);

create SEQUENCE jpaPaging_seq nocache;

insert into jpaPaging values(jpaPaging_seq.nextval, 'user01', 'user01@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user02', 'user02@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user03', 'user03@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user04', 'user04@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user05', 'user05@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user06', 'user06@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user07', 'user07@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user08', 'user08@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user09', 'user09@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user10', 'user10@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user11', 'user11@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user12', 'user12@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user13', 'user13@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user14', 'user14@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user15', 'user15@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user16', 'user16@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user17', 'user17@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user18', 'user18@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user19', 'user19@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user20', 'user20@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user21', 'user21@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user22', 'user22@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user23', 'user23@test.com');
insert into jpaPaging values(jpaPaging_seq.nextval, 'user24', 'user24@test.com');
commit;


insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '김치찌개', 8000, '찌개백반', 'HOT', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '된장찌개', 8000, '찌개백반', 'NORMAL', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '짜장면', 7000, '이향', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '무스비', 12000, '하나스시', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '스시', 15000, '스시비쇼쿠', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '짬뽕', 10000, '이향', 'HOT', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '물냉면', 8000, '김밥천국', 'MILD', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '삼선간짜장', 9000, '피챠이', 'NORMAL', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '기스면', 7000, '만리향', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '비빔냉면', 8000, '김밥천국', 'HOT', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '오차즈케', 10000, '스시비쇼쿠', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '팔보채', 30000, '피챠이', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '치라시즈시', 12000, '미소푸', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '제육덮밥', 9000, '국밥', 'HOT', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '깐쇼새우', 30000, '만리향', 'HOT', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '갈비탕', 16000, '국밥', 'MILD', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '하이라이스', 8000, '미소푸', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '비빔밥', 8000, '찌개백반', 'HOT', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '탕수육', 25000, '이향', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '규동', 9000, '하나스시', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '유산슬', 30000, '피챠이', 'MILD', 'CH');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '텐동', 10000, '하나스시', 'MILD', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '야끼소바', 8000, '스시비쇼쿠', 'NORMAL', 'JP');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '불고기', 10000, '김밥천국', 'MILD', 'KR');
insert into menu(id, name, price, restaurant, taste, type) values(menu_seq.nextval, '카마메시', 12000, '미소푸', 'NORMAL', 'JP');
commit;
-- 본인의 이름 주석으로 작성
-- 최기제


-- 데이터베이스 초기화를 위해 기존의 테이블과 시퀀스를 모두 삭제
-- 초기화를 위해 테이블(2개)과 시퀀스(2개)를 모두 삭제합니다.
drop TABLE book;
drop table author;
select table_name from tabs;
drop sequence seq_book_id;
drop sequence seq_author_id;
select * from user_sequences;


-- 시퀀스 생성 쿼리문 2개
-- 테이블 t_author와 t_book에서 사용할 PK를 위한 시퀀스 생성
CREATE SEQUENCE seq_book_id
    start with 1
    increment by 1
    maxvalue 1000000;
CREATE SEQUENCE seq_author_id
    start with 1
    increment by 1
    maxvalue 1000000;
select * from user_sequences;


-- 테이블 생성 쿼리문 2개
/*
컬럼명은 문제 이미지를 참고합니다.
각각의 테이블의 pk 컬럼은 시퀀스 객체를 이용하여 입력합니다
author_id 는 pk, fk 관계입니다.
*/
create table t_book(
    book_id number(10),
    title varchar2(100),
    pubs VARCHAR2(100),
    pub_date date default sysdate,
    author_id number(10),
    primary key (book_id)
);
desc t_book;
create table t_author(
    author_id number(10),
    author_name varchar2(100) not null,
    author_desc varchar2(500),
    primary key (author_id)
);
desc t_author;
alter table t_book
    add constraint fk_author_id foreign key (author_id)
        REFERENCES t_author(author_id);

-- t_author테이블 데이터 입력 쿼리문 6개
-- 문제 이미지의 결과가 나오도록 데이터를 입력합니다.
insert into T_author (author_id, author_name, author_desc)
    values (seq_author_id.nextval, '이문열', '경북 영양');

insert into T_author (author_id, author_name, author_desc)
    values (seq_author_id.nextval, '박경리', '경상남도 통영');

insert into T_author (author_id, author_name, author_desc)
    values (seq_author_id.nextval, '유시민', '17대 국회의원');

insert into T_author (author_id, author_name, author_desc)
    values (seq_author_id.nextval, '강풀', '온라인 만화가 1세대');
    
insert into T_author (author_id, author_name, author_desc)
    values (seq_author_id.nextval, '김영하', '알쓸신잡');
    
insert into T_author (author_id, author_name, author_desc)
    values (seq_author_id.nextval, '류츠신', '휴고상 수상 SF 작가');

select * from t_author;


-- book테이블의 데이터 입력 쿼리문 9개
-- 문제 이미지의 결과가 나오도록 데이터를 입력합니다.
insert into T_book (book_id, title, pubs, pub_date, author_id)
    values (seq_book_id.nextval, '우리들의 일그러진 영웅', '다림', '1998-02-22', 1);
    
insert into T_book (book_id, title, pubs, pub_date, author_id)
    values (seq_book_id.nextval, '삼국지', '민음사', '2002-03-01', 1);
    
insert into T_book (book_id, title, pubs, pub_date, author_id)
    values (seq_book_id.nextval, '토지', '마로니에북스', '2012-08-15', 2);
    
insert into T_book (book_id, title, pubs, pub_date, author_id)
    values (seq_book_id.nextval, '유시민의 글쓰기 특강', '생각의길', '2015-04-01', 3);
    
insert into T_book (book_id, title, pubs, pub_date, author_id)
    values (seq_book_id.nextval, '순정만화', '재미주의', '2011-08-03', 4);
    
insert into T_book (book_id, title, pubs, pub_date, author_id)
    values (seq_book_id.nextval, '오직두사람', '문학동네', '2017-05-04', 5);
    
insert into T_book (book_id, title, pubs, pub_date, author_id)
    values (seq_book_id.nextval, '26년', '재미주의', '2012-02-04', 4);
    
insert into T_book (book_id, title, pubs, pub_date, author_id)
    values (seq_book_id.nextval, '삼체', '자음과모음', '2020-07-06', 6);
    
insert into T_book (book_id, title, pub_date)
    values (seq_book_id.nextval, 'AI 시대의 히치하이커', '2023-09-24');
    
select * from t_book;
commit;

-- 현재 작성된 두 개의 테이블에 대한 SELECT 권한을 hr에게 부여
-- 현재 작성된 두 개의 테이블을 조회할 수 있도록 권한을 hr 계정에게 부여합니다
grant select on himedia.t_book to hr;
grant select on himedia.t_author to hr;


-- 아래의 조건에 맞는 책목록 리스트 쿼리문 1개
/*
(1)등록된 모든 책이 출력되어야 합니다.(9권)
(2)출판일은 ‘1998년 02월 02일’ 형태로 보여야 합니다.
(3)정렬은 책 제목을 내림차순으로 정렬합니다.
*/
select book_id, title, pubs, to_char(pub_date, 'YYYY"년" MM"월" DD"일"') as pub_date, htb.author_id, hta.author_id, author_name, author_desc
from himedia.t_book htb left outer join himedia.t_author hta on htb.author_id = hta.author_id
order by title desc;



-- [산출물]
/*
- 아래 2개의 산출물을 이름.zip 파일로 압축해서 제출합니다.
- book_test.sql
- book_list.jpg
*/

-- 수고하셨습니다

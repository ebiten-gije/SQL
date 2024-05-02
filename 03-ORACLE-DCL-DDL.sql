----------------
--  DCL and DDL
----------------
--  사용자 생성
--  create user 권한이 있어야 함
--  system 계정으로 수행
--  connect system/manager

--  himedia 라는 이름의 계정을 만들고 비밀번호 himedia 로 설정
create user himedia identified by himedia;

--  oracle 18버전부터 container database 개념 도입
--  계정 생성 방법1) 사용자 계정 C##
create user C##HIMEDIA identified by himedia;

--  비밀번호 변경 : ALTER USER
alter user C##HIMEDIA identified by new_password;

--  계정 삭제: DROP USER
drop user C##HIMEDIA CASCADE; --cascade: 폭포수, 연결된 것

--  계정 생성 방법 2) CD 기능 무력화
--  연습 상태, 방법 2를 사용해서 사용자 생성 (비추)
alter session set "_ORACLE_SCRIPT" = true;
create user himedia identified by himedia;
--  아직 접속 불가함
--  데이터베이스 접속, 테이블 생성, 데이터베이스 객체 작업을 수행 -> connect, resource role

--  grant 시스템 권한 목록 to 사용자| 역할| public [with admin option]  -> 시스템 권한 부여
--  revoke 회수할 권한 from 사용자| 역할| public 

--  grant 객체 개별 권한 | ALL on 객체명 to 사용자|역할|public [with admin option]
--  revoke 회수할 권한 on 객체명 from 사용자|역할|public

grant connect, resource to himedia;
--  create table test (a NUMBER);
--  desc test; ->  test 구조 보기

--  himedia 사용자로 진행
--  create TABLE test(a NUMBER);
--  데이터 추가
describe test;
insert into test values (2024);
--  USERS 테이블 스페이스에 대한 권한이 없다
--  18이상은 그럼;;

--  우측 위 System 계정으로 수행
alter user himedia default tablespace users
    quota unlimited on users;

--  himedia 계정으로 복귀
insert into test values (2024);
select * from test;

select * from user_users;       --  현재 로그인한 사용자 정보 (나)
select * from all_users;        --  모든 사용자 정보
--  DBA 전용 (sysdba로 로그인해야 사용가능)
--  cma -> sqlplus Sys/oracle as sysdba -> sysdba로 접속 가능
select * from dba_users;    --cmd

--  hr 스키마의 employees 테이블 조회 권한을 himedia 에게 부여하고자 한다
--  HR 스키마의 owner = hr -> hr 로 접속
grant select on employees to himedia;

--  himedia 권한
select * from hr.employees; --   hr.employees 에 select 할 수 잇는 권한
select * from hr.departments;   --  hr.departments 에 대한 권한은 없다

--  현재 사용자에게 부여된 ROLE의 확인
select * from USER_ROLE_PRIVS;

--  connect와 resource 역할은 어떤 권한으로 구성되어있는거?
--  cmd 에서 sysdba로 진행
--  sqlplus sys/oracle as sysdba
--  desc role_sys_privs;

--  connect 롤에는 어떤 권한이 포함되어 있는가?
--  select privilege from role_sys_privs where role='CONNECT';
--  resource 롤에는 어떤 권한?
--  select privilege from role_sys_privs where role='RESOURCE';

-----------------------------
--  DDL
-----------------------------
--스키마 내의 모든 테이블 확인
select table_name from tabs;    --  tabs: 테이블 정보 dictionary

--  테이블 생성: create table
create table book (
    book_id number(5),
    title varchar2(50),
    author varchar2(10),
    pub_date date default sysdate
);

--  테이블 정보 확인
desc book;

--  subquery 이용한 테이블 생성
select * from hr.employees;

--  hr.employees 테이블에서 job_id가 IT관련된 직원의 목록으로 새 테이블 생성
select * from hr.employees where job_id like 'IT_%';
create table emp_IT as (
    select * from hr.employees where job_id like 'IT_%'
);
--  not null 제약조건만 물려받음

desc emp_IT;
select * from emp_IT;

--  테이블 삭제
drop table emp_IT;
select * from tabs;

desc book;
select * from book;

--  author 테이블 생성
create table author(
    author_id number(10),
    author_name varchar2(100) not null,
    author_desc varchar2(500),
    primary key (author_id)
);

desc author;

--  book 테이블의 author 컬럼 삭제
--  나중에 author_id 컬럼 추가 -> author.author_id와 참조 연결할 예정
alter table book drop column author;
desc book;

--  book 테이블에 author_id 컬럼 추가
--  author.author_id 를 참조하는 컬럼, author.author_id 와 같은 형태여야 함
alter table book add (author_id number(10));
desc book;

--  book 테이블의 book_id도 author 테이블의 pk와 같은 데이터 타이븡(number 10)로 변경
alter table book modify (book_id number (10));
desc book;

--  book 테이블의 book_id 컬럼에 primary key 제약조건을 부여
alter table book 
    add constraint pk_book_id primary key (book_id);
desc book;

--  book 테이블의 author_id 컬럼과 author 테이블의 author_id 를 fk로 연결
alter table book
    add constraint fk_author_id foreign key (author_id)
        REFERENCES author(author_id);
desc book;

--  Dictionary

--  User_ : 현재 로그인된 사용자에게 허용된 부
--  ALL_ : 모든 사용자 뷰
--  DBA_ : DBA에게 허용된 뷰

--  모든 딕셔너리 확인
select * from dictionary;

--  사용자 스키마 객체: USER_OBJECTS
select * from USER_OBJECTS;
--  사용자 스키마의 이름과 타입 정보 출력
select OBJECT_NAME, OBJECT_TYPE from USER_OBJECTS;

--  제약 조건 확인
select * from USER_CONSTRAINTS;
select CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION, TABLE_NAME
from USER_CONSTRAINTS;

--  book 테이블에 적용된 제약 조건의 확인
select CONSTRAINT_NAME, CONSTRAINT_TYPE, SEARCH_CONDITION
from USER_CONSTRAINTS
where TABLE_NAME = 'BOOK';


truncate table author;
-----------------------------------
--  INSERT : 테이릅렝 새 레코드 (튜플) 추가
--  제공된 컬럼 목록의 순서와 타입, 값 목록의 순서와 타입이 추가되어야 함
--  컬럼 목록을 제공하지 않으면 테이블 생성시 정의된 컬럼의 순서의 타입을 따른다

--  컬럼 목록이 제시되지 않았을 때
insert into author
values (1, '나쓰메 소세키', '도련님 작가');

--  컬럼 목록을 제시했을 때,
--  제시한 컬럼의 순서와 타입대로 값 목록을 제공해야 함
insert into author (author_id, author_name)
values (2, '아쿠타가와 류노스케');

--  컬럼 목록을 제공했을 때,
--  테이블 생성 시 정의된 컬럼의 순서와 상관 없이 데이터 제공 가능
insert into author(author_name, author_desc, author_id)
values ('미시마 유키오', '금각사가 유명해', 3);

select * from author;

rollback;       --  반영 취소

insert into author
values (1, '나쓰메 소세키', '도련님 작가');
insert into author (author_id, author_name)
values (2, '아쿠타가와 류노스케');
insert into author(author_name, author_desc, author_id)
values ('미시마 유키오', '금각사가 유명해', 3);

select * from author;

commit;
select * from author;

--  UPDATE
--  특정 레코드의 컬럼 값을 변경한다
--  where 절이 없으면 모든 레코드가 변경
--  가급적 where 절로 변경하고자 하는 러코드를 지정하도록 하자
update author set author_desc = '나생문 작가';
select * from author;
rollback;
select * from author;

UPDATE author set author_desc = '나생문 작가'
where author_name = '아쿠타가와 류노스케';

select * from author;
commit;


--  DELETE
--  테이블로부터 특정 레코드를 삭제
--  where 젉이 없으면 모든 레코드를 삭제 (주의!!)

--  연습
--  hr.employees 테이블을 기반으로 department_id 10, 20, 30 인 직원들만 새 테이블 emp123으로 생성
create table emp123 as 
    (select * from hr.employees
        where department_id in (10, 20, 30));
        
desc emp123;
select first_name, salary, department_id from emp123;

--  부서가 30번인 직원들의 급여를 10퍼센트 인상해보자
update emp123 set salary = salary * 1.1
where department_id = 30;

select * from emp123;

--  job_id 가 MK_로 시작하는 직원들 삭제
delete from emp123
where job_id like 'MK_%';
select * from emp123;

delete from emp123;     --  where 절이 생략된 DELETE문은 모든 레코드를 삭제 -> 주의
select * from emp123;

rollback;

------------------------
-- transaction
------------------------

--  트렌젝션 테스트 테이블
create table t_test (
    log_text varchar2(100)
);

--  첫번째 DML이 수행된 시점에서 Transaction
insert into t_test values ('트랜잭션 시작');
select * from t_test;
insert into t_test values ('데이터 INSERT');
select * from t_test;

savepoint sp1;  --  세이브 포인트 설정
insert into t_test values ('데이터 2 INSERT');
select * from t_test;

savepoint sp2;  --  세이브 포인트 설정

update t_test set log_text = '업데이트';
select * from t_test;

rollback to sp1;
select * from t_test;

insert into t_test values ('데이터 3 인서트');
select * from t_test;

--  반영은 commit or 취소는 rollback
--  명시적으로 트랜젝션 종료 상황
commit;
select * from t_test;

rollback;
select * from t_test;
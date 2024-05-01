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
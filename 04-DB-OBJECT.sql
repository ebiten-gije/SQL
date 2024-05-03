-------------------
--  DB OBJECT
-------------------

--  System 으로 진행
--  view 생성을 위한 System 권한

grant create view to himedia;
grant select on hr.employees to himedia;
grant select on hr.departments to himedia;

--  다시 himedia로 
--  simple view
--  단일 테이블 혹은 단일 뷰를 베이스로 함수, 연산식을 포함하지 않은 뷰

--  emp123
desc emp123;

--  emp123테이블을 기반으로 department_id가 10 부서 소속 사람만 조회하는 뷰
create or REPLACE view emp10
    as select employee_id, first_name, last_name, salary
    from emp123
    where department_id = 10;
    
desc emp10;
select * from tabs;
--  일반 테이블처럼 활용할 수 있다.
select * from emp10;
select first_name || ' ' || last_name, salary from emp10;

--  SIMPLE vIEW 는 제약사항에 걸리지 않는다면, insert, update, delete 할 수 있다
update emp10 set salary = salary * 2;
select * from emp10;

rollback;

--  가급적 뷰는 조회용으로만 활용하자
--  with read only : 읽기 전용 뷰
create or REPLACE view emp10
    as select employee_id, first_name, last_name, salary
    from emp123
    where department_id = 10
with read only;

select * from emp10;
update emp10 set salary = salary * 2;

--  complex view
--  한 개 혹은 여러 개의 테이블 혹은 뷰에 함수, 연산자 등을 활용한 view
--  특별한 경우가 아니라면 insert, update, delete 할 수 없음;;

create or replace view emp_detail
    (employee_id, employee_name, manager_name, department_name)
as select emp.employee_id, emp.first_name || ' ' || emp.last_name,
        man.first_name || ' ' || man.last_name, dept.department_name
    from hr.employees emp
        join hr.employees man on emp.manager_id = man.employee_id
        join hr.departments dept on emp.department_id = dept.department_id;

desc emp_detail;
select * from emp_detail;

--  view 를 위한 딕셔너리 : views
select * from user_views;
select * from user_objects; --  view 를 포함한 모든 DB 객체들의 정보

--  view 삭제: drop view
--  view 를 삭제해도 기반 테이블의 데이터는 삭제되지 않음;;
drop view emp_detail;
select * from user_views;

----------------------
--  INDEX
----------------------

--  hr.employees  테이블 복사해서 s_emp 테이블 생성
create table s_emp 
as select * from hr.employees;

desc s_emp;
select * from s_emp;

--  s_emp 테이블의 employee_id에 UNIQUE INDEX를 걸어봄
create unique index s_emp_id_pk
on s_emp (employee_id);

--  사용자가 가지고 있는 INDEX 확인
select * from user_indexes;
--  어느 인덱스가 어느 컬럼에 걸려있는지 확인
select * from user_ind_columns;

--  어느 인덱스가 어느 컬럼에 걸려있는지 JOIN해서 알아보자
select t.index_name, t.table_name, c.column_name, c.column_position
from user_indexes t join user_ind_columns c on t.index_name = c.index_name
where t.table_name = 'S_EMP';


-------------------------------
--  sequence
-------------------------------

select *from author;
desc author;
--  새로운 레코드를 추가, 겹치치 않는 유일한 PK가 필요
insert into author (author_id, author_name)
values (
    (select max(author_id) + 1 from author),
    '이문열');
    
select * from author;
rollback;

--  순차 객체 sequence
create sequence seq_author_id
    start with 4
    increment by 1
    maxvalue 1000000;
    
--  PK 는 sequence 객체로부터 생성
insert into author (author_id, author_name, author_desc)
    values (seq_author_id.nextval, '다자이 오사무', '인간실격');
    
select * from author;

select seq_author_id.currval from dual;

--  새 시퀀스
create sequence my_seq
    start with 1
    increment by 1
    maxvalue 10;
    
select my_seq.nextval from dual;    --  다음 시퀀스 추출 가상 칼럼
select my_seq.currval from dual;    --  현재 상태

--  시퀀스 수정
alter sequence my_seq
    increment by 2
    maxvalue 1000000;
    
select my_seq.currval from dual;
select my_seq.nextval from dual;

--  시퀀스를 이용한 딕셔너리
select * from user_sequences;
select * from user_objects
where OBJECT_TYPE = 'SEQUENCE';

--  시퀀스 삭제
drop sequence my_seq;
select * from user_sequences;

--  book 테이블 PK의 현재값 확인
select max(book_id) from book;

create sequence seq_book_id
    start with 3
    increment by 1
    maxvalue 1000000
    NOCACHE;
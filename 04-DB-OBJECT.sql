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
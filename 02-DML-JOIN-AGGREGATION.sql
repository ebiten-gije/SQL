----------------------------
--  JOIN
----------------------------

--  employees, departments
desc employees;
desc departments;

select * from employees;    --  107개
select * from departments;  --  27개

select * from employees, departments;   --  107 * 27 = 2889개
--  가티젼 프로덕트

select *
from employees, departments
where employees.department_id = departments.department_id;
--  Inner join, equi-join

--  alias 를 이용한 원하는 필드의 projection
------------------------------------------
--  simple join or equi-join
------------------------------------------

select First_name, emp.department_id, department_name
from employees emp, departments dep
where emp.department_id = dep.department_id;
--  dep_id null이면 join에서 배제됨;;

select * from employees
where department_id is null;

select emp.First_name, dep.department_name, department_id
from departments dep join employees emp
using (department_id);

------------------
-- theta join
------------------

--  join 조건이 "=" 가 아닌 다른 조건들

--  급여가 직군 평균 급여보다 낮은 직원들 목록
select emp.employee_id, emp.first_name, emp.salary, emp.job_id,
    js.job_id, js.job_title
from employees emp join jobs js on emp.job_id = js.job_id
where emp.salary <= (js.min_salary + js.max_salary) / 2
;

-----------------------
--  outer join
-----------------------

--  조건을 만족하는 짝이 없는 튜플도 null을 포함해서 결과 출력 참여시키는 방법
--  모든 결과를 표현할 테이블이 어느 쪽에 위치하는가에 따라 LEFT,RIGHT, FULL OUTER join으로 구분
--  ORACLE SQL의 경우 null이 출력되는 쪽에 (+) 를 붙임

--  LEFT OUTER JOIN
--  oracle sql
select emp.First_name, emp.department_id, dep.department_id, dep.department_name
from employees emp, departments dep
where emp.department_id = dep.department_id(+); --  null이 포함된 쪽에 (+) 표기

select * from employees where department_id is null;    --  Kimberely 소속 부서 없음

--  ANSI SQL : 명시적으로 JOIN 방법을 정한다
select First_name, emp.department_id, dep.department_id, department_name
from employees emp LEFT OUTER JOIN departments dep
on emp.department_id = dep.department_id;

--  RIGHT OUTER JOIN
--  right 테이블의 모든 레코드가 출력 결과에 참여
--  oracle sql
select First_name, emp.department_id, dep.department_id, department_name
from employees emp, departments dep
where emp.department_id(+) = dep.department_id; --  department 테이블 레코드 전부를 출력에 참여
--  null이 포함된 쪽에 (+) 표기

--  ANSI SQL
select First_name, emp.department_id, dep.department_id, department_name
from employees emp right OUTER JOIN departments dep
on emp.department_id = dep.department_id;

--------------------------
--  full outer join
--------------------------]

--  join 에 참여한 모든 테이블의 모든 레코드를 출력에 참여
--  짝이 없는 레코드는 null을 포함해서 출력에 참여

--ansi
select first_name, emp.department_id, dep.department_id, dep.department_name
from employees emp full outer join departments dep
on emp.department_id = dep.department_id;

------------------
--  natural join
------------------
--  조인할 테이블에 같은 이름의 컬럼이 있을 경우 , 해당 컬럼을 기준으로 join
select * from employees emp natural join departments dep;

--select * from employees emp join departments dep on emp.department_id = dep.department_id;
--select * from employees emp join departments dep on emp.manager_id = dep.manager_id;
select * from employees emp join departments dep on emp.manager_id = dep.manager_id and emp.department_id = dep.department_id;


-----------------------
--  self join
-----------------------
--  자기 자신과 JOIN
--  자기 자신을 두번 호출 -> 각각의 테이블에 alias(별칭)을 반드시 부여해야함

select * from employees;
select emp.employee_id, emp.first_name, 
    emp.manager_id, man.first_name manager
--from employees emp join employees man
--    on emp.manager_id = man.employee_id;
from employees emp, employees man
where emp.manager_id = man.employee_id(+);


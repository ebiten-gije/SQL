--  01
select 
count(manager_id) "haveMngCnt"
from employees
;

--  02
select max(salary), min(salary), max(salary) - min(salary) "최고임금 - 최저임금"
from employees;

--  03
select to_char(max(hire_date), 'YYYY"년" MM"월" DD"일"')
from employees;

--  04
select employees.department_id
from employees
order by department_id desc;

--  05

--  06


--  07


--  08


--  09


--  10
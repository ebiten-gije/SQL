--  01
select count(salary)
from employees
where salary < (select avg(salary) from employees);

--  02 
select employee_id, first_name, salary, 
(select round(avg(salary), 1) from employees) as 평균급여,
(select max(salary) from employees) as 최대급여
from employees
where salary >= (select avg(salary) from employees)
and salary <= (select max(salary) from employees)
order by salary;

--  03
select location_id, street_address, postal_code, city, state_province, country_id
from locations
where location_id = 
(select location_id from departments where department_id in 
(select department_id from employees where first_name = 'Steven' and last_name = 'King'));

--  04
select employee_id, first_name, salary
from employees
where salary < any (select salary from employees where job_id = 'ST_MAN')
order by salary desc;

--  05
select employee_id, first_name, salary, department_id
from employees
where (department_id, salary) in
(select department_id, max(salary) from employees group by department_id)
order by salary desc;

select emp.employee_id, emp.first_name, emp.salary, emp.department_id
from employees emp join (select department_id, max(salary) subSal from employees group by department_id) sub
on emp.department_id = sub.department_id and emp.salary = sub.subSal
order by salary desc;

--  06
select job_title, jobSal.sumSal from jobs, 
(select job_id, sum(salary) sumSal from employees group by job_id) jobSal
where jobs.job_id = jobSal.job_id
order by jobSal.sumSal;

--  07
select emp.employee_id, emp.first_name, emp.salary, avGo.avS as "소속 부서의 평균 급여"
from employees emp join
(select department_id, round (avg(salary), 2) avS from employees
group by department_id) avGo
on emp.department_id = avGo.department_id
where emp.salary > avGo.avS;

--  08
select rn, employee_id, first_name, salary, hire_date
from
(select rownum rn, employee_id, first_name, salary, hire_date
from (select * from employees order by hire_date asc))
where rn > 10 and rn <= 15;

select rn, employee_id, first_name, salary, hire_date
from
(select row_number () over (order by hire_date asc) as rn, employee_id, first_name, salary, hire_date
from (select * from employees))
where rn > 10 and rn <= 15;
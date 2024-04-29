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
select employees.department_id, max(salary), min(salary), round (avg(salary),2)
from employees join departments
on employees.department_id = departments.department_id
group by employees.department_id
order by department_id desc;

--  05
select employees.job_id, max(salary), min(salary), round (avg(salary), 0)
from employees join jobs
on employees.job_id = jobs.job_id
group by employees.job_id
order by min(salary) desc, avg(salary);

--  06
select to_char(min(hire_date), 'YYYY-MM-DD DAY')
from employees;

--  07
select employees.department_id, round (avg(salary),2) 평균임금, min(salary) 최저임금, 
round (avg(salary),2) - min(salary) "평균임금 - 최저임금"
from employees join departments
on employees.department_id = departments.department_id
group by employees.department_id
having avg(salary) - min(salary) < 2000
order by avg(salary) - min(salary) desc;

--  08
select job_title, max_salary - min_salary
from jobs
order by max_salary - min_salary desc ;

--  09
select manager_id--, round(avg(salary),1) as 평균임금, min(salary), max(salary)
from employees
where hire_date >= '15/01/01'
group by manager_id
having avg(salary) >= 5000
order by avg(salary) desc;

--  10
select first_name, hire_date, 
case 
when hire_date < '12/12/31' then '창립맴버'
when hire_date >= '13/01/01' and hire_date < '14/01/01' then '13년 입사'
when hire_date >= '14/01/01' and hire_date < '15/01/01' then '14년 입사'
else '상장이후입사'
end as optDate
from employees
order by hire_date;


select emp.employee_id "사번", emp.first_name "이름", emp.hire_date "입사일",
    man.first_name "매니저 이름", man.hire_date "매니저 입사일"
from employees emp, employees man, departments dept
where emp.manager_id = man.employee_id and emp.department_id = dept.department_id(+);
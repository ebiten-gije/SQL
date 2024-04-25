--  1
select First_name || ' ' || Last_name 이름, salary 월급, phone_number 전화번호,
hire_date 입사일 from employees order by hire_date asc;

--  2
select job_title "업무 이름", Max_salary "최고 월급" from jobs 
order by max_salary desc;

--  3
select First_name || ' ' || Last_name 이름, manager_id "매니저 아이디",
commission_pct "커미션 비율", salary 월급 from employees
where manager_id is not null and commission_pct is null and salary > 3000;

--  4
select job_title "업무의 이름", max_salary "최고 월급"
from jobs
where max_salary >= 10000
order by max_salary desc;

--  5
select first_name 이름, salary 월급, nvl(commission_pct, 0) commission
from employees
where salary >= 10000 and salary < 14000
order by salary desc
;

--  6
select first_name 이름, salary 월급,
to_char (hire_date, 'YYYY-MM') 입사일,
department_id 부서번호
from employees
where department_id in (10, 90, 100)
;

--  7  
select first_name 이름, salary 월급
from employees
where Upper (first_name) like '%S%'
;

--  8
select department_name "부서 이름"
from departments
order by length (department_name) desc
;

--  9  
select upper (country_name) 나라이름
from countries
order by country_name
;

--  10
select first_name 이름, salary 월급, 
substr (replace (phone_number, '.', '-'), 3) 전화번호,
hire_date 입사일
from employees
where hire_date < '13/12/31';
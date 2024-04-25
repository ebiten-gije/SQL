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
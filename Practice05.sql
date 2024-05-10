--  01
select first_name, manager_id, commission_pct, salary
from employees
where manager_ID is not null
and commission_pct is null
and salary > 3000;

--  02
select employee_id 직원번호, first_name 이름, salary 급여, to_char (hire_date, 'YYYY-MM-DD DAY') 입사일,
replace (phone_number, '.', '-') 전화번호,
department_id 부서번호
from employees
where (salary, department_id) in (select max(salary), department_id from employees GROUP by department_id)
order by salary desc;

select max(salary), department_id from employees GROUP by department_id;

--  03
--매니저별로 평균급여 최소급여 최대급여를 알아보려고 한다.
--통계대상(직원)은 2015년 이후의 입사자 입니다.
--매니저별 평균급여가 5000이상만 출력합니다.
--매니저별 평균급여의 내림차순으로 출력합니다.
--매니저별 평균급여는 소수점 첫째자리에서 반올림 합니다.
--출력내용은 매니저 아이디, 매니저이름(first_name), 매니저별 평균급여, 매니저별 최소급여, 
--매니저별 최대급여 입니다.
--(9건)
select res.emId, empt.first_name, res.avgSal, res.minSal, res.maxSal 
from (
    select emp.employee_id as emId, round (avg(sub.salary), 1) as avgSal,
        max(sub.salary) maxSal, min(sub.salary) as minSal
    from employees emp 
    join (
        select employee_id, salary, manager_id from employees where hire_date >= '15/01/01') sub
    on emp.employee_id = sub.manager_id
    group by emp.employee_id
    having avg(sub.salary) >= 5000
    order by avgSal desc
    ) res
join employees empt on res.emid = empt.employee_id;
select emp.first_name, emp.last_name, man.first_name from employees emp join employees man on emp.manager_id = man.employee_id order by emp.first_name;

select man.manId, emp.first_name, man.avgSal, man.minSal, man.maxSal
from employees emp 
join (
    select manager_id as manId, round (avg(salary), 1) as avgSal, min(salary) as minSal, max(salary) as maxSal
    from employees
    where hire_date >= '15/01/01'
    group by manager_id) man on man.manId = emp.employee_id
where man.avgSal >= 5000
order by avgSal desc;

--  04
select emp.employee_id, emp.first_name, department_name, man.first_name
from employees emp left outer join departments dept on emp.department_id = dept.department_id
join employees man on emp.manager_id = man.employee_id
;

--  05
select emp.employee_id, emp.first_name, department_name, emp.salary, emp.hire_date
from employees emp join departments dept on emp.department_id = dept.department_id
join (
    select rownum rn, employee_id 
    from (
        select * from employees 
        where hire_date >= '15/01/01' order by hire_date)
    ) emem on emem.employee_id = emp.employee_id
where rn > 10 and rn <= 20;
    
select employee_id from employees where hire_date >= '15/01/01' order by hire_date;

--  06
select first_name || ' ' || last_name as 이름, salary, department_name, hire_date
from employees emp join departments dept on emp.department_id = dept.department_id
where hire_date in (select max(hire_date) from employees);

--  07
select emp.employee_id as 사번, emp.first_name as 성, emp.last_name as 이름, emp.salary as 급여, av.avSal, jobs.job_title
from employees emp join jobs on emp.job_id = jobs.job_id
join(
    select rownum rn, department_id, avSal
    from (
        select department_id, avg(salary) avSal
        from employees
        group by department_Id
        order by avSal desc
    )
) av on emp.department_id = av.department_id
where av.rn = 1;

--  08
select dept.department_name
from departments dept join (
    select row_number () over (order by avSal desc) rn, department_id
    from(
        select department_id, avg(salary) as avSal
        from employees
        group by department_id
    )
) rnSal on dept.department_id = rnSal.department_id
where rn = 1;

--  09
select regiName
from(
    select rownum rn, regiName
    from (
        select avg(empSal) as regiAvgSal, regiId, regiName
        from (
            select emp.salary as empSal, cou.region_id as regiId, reg.region_name as regiName
            from employees emp
            join departments dept on emp.department_id = dept.department_id
            Join locations loca on dept.location_id = loca.location_id
            join countries cou on loca.country_id = cou.country_id
            join regions reg on cou.region_id = reg.region_id
        ) jat
        group by regiId, regiName
        order by regiAvgSal desc
    )
)
where rn = 1;

--  10
select job_title
from jobs join (
    select rank () over (order by avSal desc) rn, jobId
    from (
        select job_id as jobId, avg(salary) avSal
        from employees
        group by job_id
        order by avSal desc
    )
) sub on jobs.job_id = sub.jobId
where rn = 1;

select job_id, avg(salary) avSal
    from employees
    group by job_id
    order by avSal desc;
--------------------------------

select emp.first_name as "직원 이름", emp.hire_date as "직원 입사일",
emp.salary as "직원 급여", emp.manager_id "매니저 아이디", man.first_name as "매니저 이름",
man.hire_date as "매니저 입사일", avMan.avSal, avMan.minSal, avMan.maxSal
from employees emp
join employees man on emp.manager_id = man.employee_id
join (
    select manager_id avId, round (avg(salary), 1) avSal, min(salary) minSal, max(salary) maxSal
    from employees
    group by manager_id
) avMan on avMan.avId = emp.manager_id
order by man.hire_date;

select manager_id from employees group by manager_ID;

select emp.employee_id as "manager", sub.employee_id as "employee", sub.salary as salary
from employees emp  join
(select employee_id, salary, manager_id from employees where hire_date >= '15/01/01') sub
on emp.employee_id = sub.manager_id;

select emp.employee_id as emId, round (avg(sub.salary), 1) as avgSal,
        max(sub.salary) maxSal, min(sub.salary) as minSal
    from employees emp 
    join (
        select employee_id, salary, manager_id from employees where hire_date >= '15/01/01') sub
    on emp.employee_id = sub.manager_id
    group by emp.employee_id
    order by avgSal desc;

select res.emId, empt.first_name, res.avgSal, res.maxSal, res.minSal
from (
    select emp.employee_id as emId, round (avg(sub.salary), 1) as avgSal,
        max(sub.salary) maxSal, min(sub.salary) as minSal
    from employees emp 
    join (
        select employee_id, salary, manager_id from employees where hire_date >= '15/01/01') sub
    on emp.employee_id = sub.manager_id
    group by emp.employee_id
    order by avgSal desc
    ) res
join employees empt on res.emid = empt.employee_id
where res.avgSal >= 5000;
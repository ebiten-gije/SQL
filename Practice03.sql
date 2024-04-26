--  01
select employee_id, first_name, last_name, department_name
from employees emp, departments dep
where emp.department_id = dep.department_id
order by department_name, employee_id desc;

--  02
select employee_id 사번, first_name 이름, salary 급여, department_name 부서명, job_title 현재업무
from employees emp, departments dep, jobs jb
where emp.department_id = dep.department_id and emp.job_id = jb.job_id
order by employee_id;

--  02-1
select employee_id 사번, first_name 이름, salary 급여, department_name 부서명, job_title 현재업무
from employees emp, departments dep, jobs jb
where emp.department_id = dep.department_id(+) and emp.job_id = jb.job_id
order by employee_id;

--  03
select dept.location_id, city, department_name, department_id
from locations loca, departments dept
where loca.location_id = dept.location_id
order by location_id;

--  03-1
select dept.location_id, city, department_name, department_id
from locations loca, departments dept
where loca.location_id = dept.location_id(+)
order by location_id;

--  04
select region_name, country_name
from regions regi, countries cou
where regi.region_id = cou.region_id
order by region_name, country_name desc;

--  05
select emp.employee_id "사번", emp.first_name "이름", emp.hire_date "입사일",
    man.first_name "매니저 이름", man.hire_date "매니저 입사일"
from employees emp, employees man
where emp.manager_id = man.employee_id and emp.hire_date < man.hire_date;

--  06
select cou.country_name "나라명", cou.country_id "나라 아이디",
loca.city "도시 이름", loca.location_id "도시 아이디", dept.department_name "부서명", dept.department_id "부서 아이디"
from countries cou, locations loca, departments dept
where cou.country_id = loca.country_id and loca.location_id = dept.location_id
order by country_name;

--  07
select emp.employee_id, first_name || ' ' || last_name "이름", jh.job_id, start_date, end_date
from employees emp, job_history jh
where emp.employee_id = jh.employee_id and jh.job_id = 'AC_ACCOUNT'
;

--  08
select dept.department_id "부서 번호", dept.department_name "부서 이름", emp.first_name "매니저",
loca.city"도시 이름", cou.country_name "나라 이름", region_name "지역 이름"
from departments dept, employees emp, locations loca, regions regi, countries cou
where dept.location_id = loca.location_id 
and loca.country_id = cou.country_id 
and cou.region_id = regi.region_id 
and dept.manager_id = emp.employee_id
;

--  09
select emp.employee_id "사번", emp.first_name "이름", dept.department_name "부서명",
    man.first_name "매니저 이름"
from employees emp, employees man, departments dept
where emp.manager_id = man.employee_id and emp.department_id = dept.department_id(+);

--  
select emp.employee_id "사번", emp.first_name "이름", dept.department_name "부서명",
    man.first_name "매니저 이름"
from employees emp, departments dept, employees man
where man.employee_id = dept.manager_id and emp.department_id = dept.department_id(+);
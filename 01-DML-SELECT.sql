--  "--": sql 문장의 주석, ";": 마지막에 찍어줘야함;;
--  키워드들, 테이블명, 컬럼 이름 등은 대소문자를 구분하지 않는다.
--  실제 데이터의 경우 대소문자를 구분한다.

--  테이블 구조 확인 (DESCRIBE);
describe employees;
--DESCRIBE EMPLOYEES;
Describe departments;


--  DML (Data Manipulation Language);

--  SELECT
--  *: 테이블 내의 모든 컬럼 Projection, 테이블 설계시에 정의한 순서대로
select * FROM employees;
--  특정 컬럼만 projection 하고 싶다면 열 목록을 명시
select FIRST_NAME, PHONE_NuMBER, HIRE_DATE, SALARY from employees;
select first_name, last_name, salary, phone_number, hire_date from employees;
--  사원 정보로부터 사번, 이름, 성 출력
select Employee_id, first_name, Last_name from Employees;


--  산술연산: 기본적인 산술연산을 수행할 수 있다.
--  특정 테이블 값이 아닌 시스템으로부터 데이터를 받아오고자 핧 때, dual;
select 3.141592 *10 * 10 from dual;
--  특정 컬럼의 값을 산술 연산에 포함
select first_name, salary * 12 from employees;
select first_name, job_id * 12 from employees;
--  오류의 원인: job_id는 문자열(varChar2)
desc employees;
select hire_date * 2 from employees;


--  null
--  이름과 급여를 출력
select first_name, salary, commission_pct from employees;
--  이름과 커미션까지 포함한 급여를 출력
select first_name, salary, commission_pct, salary + salary * commission_pct from employees;
--  null이 포함된 연산식의 결과는 null
--  null을 처리하기 위한 함수 nvl이 필요
--  nvl(값1, 값1이 null일 경우 대체를 위한 값2)
select first_name, last_name, salary, commission_pct, salary + salary * nvl(commission_pct, 0) sal from employees;

--  null 은 0이나 ""와 다르게 빈 값이다
--  null은 산술연산 결과, 통계결과를 왜곡 -> null에 대한 처리는 철저하게!!


--  별칭 Alias
--  projection 단계에서 출력용으로 표시되는 임시 컬럼 제목

--   컬럼명 뒤에 별칭, 컬럼명 뒤에 as 별칭
--  표시명에 특수문자나 공백 포함된 경우 ""로 묶어서 부여
select first_name || ' ' || last_name as "e-name" from employees;
select employee_id "직원 아이디", first_name || ' ' || last_name 이름, hire_date 입사일, phone_number 전화번호, salary 급여, salary *12 연봉 from employees;

--  직원 이름 (f-name, l-name 합쳐서)name
--  급여(커미션이 포함된 급여), 급여 * 12 를 연봉 별칭으로
select first_name || ' ' || last_name name,
    salary + salary * nvl(commission_pct, 0) "급여(커미션 포함)",
    salary * 12 연봉
from employees;

--------------
--  where
--  특정 조건을 기준으로 레코드를 선택 (selection)

--  비교 연산: =, <>, <, >, <=, >=
--  사원들 중 급여가 15,000 이상인 직원의 이름과 급여
select first_name || ' ' || last_name name, salary from Employees where salary >= 15000;
--  입사일이 17/01/01 이후인 직원
select first_name || ' ' || last_name name, hire_date 입사일 from employees where hire_date >= '17/01/01';
--  급여가 4000 이하이거나 17000 이상인 경우
select first_name || ' ' || last_name name, salary 급여 from employees where salary <= 4000 or salary >= 17000;
--  급여가 14000 이상, 17000 이하
select first_name || ' ' || last_name name, salary 급여 from employees where salary >= 14000 and salary < 17000;

--  between: 범위 비교
select first_name || ' ' || last_name name, salary 급여 from employees where salary between 14000 and 17000;

--  null 체크: is null, is not null (=, <> 사용하면 안 됨)
--  커미션을 받지 않는 사람들
select first_name || ' ' || last_name 이름, salary 급여, commission_pct from employees where commission_pct is null;    -- null check
--  커미션을 받으면?
select first_name || ' ' || last_name 이름, salary 급여, commission_pct from employees where commission_pct is not null;    -- null check

--  in 연산자: 특정 집합의 요소와 비교
--  사원들 중에 10, 20, 40번 부서에서 근무하는 직원들의 이름과 부서 id
select first_name || ' ' || last_name 이름, department_id from employees where department_id = 10 or department_id = 20 or department_id = 40;
select first_name || ' ' || last_name 이름, department_id from employees where department_id in (10, 20, 40);

--  이름이 'lex'인 사원의 연봉, 입사일, 부서 id
select salary, hire_date, job_id from employees where first_name = any ('Lex');


-----------------
--  like 연산
-----------------
--  와일드카드(%, _)를 이용한 부분 문자열 매핑
--  %: 0개 이상의 정해지지 않은 문자열
--  _: 1개의 정해지지 않은 문자

--  이름에 am 을 포함한 사원
select first_name || ' ' || last_name 이름, salary 급여 from employees where lower (first_name) like '%am%';
--  이름의 두번째 글자가 a 인 사원
select first_name || ' ' || last_name 이름, salary 급여 from employees where first_name like '_a%';

--  이름의 네번째 글자가 a 인 사원의 이름과 급여
select first_name || ' ' || last_name 이름, salary 급여 from employees where first_name like '___a%';
--  이름이 4글자인 사원들 중에서 두번째 글자가 a인 사원
select first_name || ' ' || last_name 이름, salary 급여 from employees where first_name like '_a__';

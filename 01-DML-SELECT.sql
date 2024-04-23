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
select 3.141592 *10 * 10 from dual;

--  특정 컬럼의 값을 산술 연산에 포함
select first_name, salary * 12 from employees;

select first_name, job_id * 12 from employees;
--  오류의 원인: job_id는 문자열(varChar2)
desc employees;
select hire_date * 2 from employees;
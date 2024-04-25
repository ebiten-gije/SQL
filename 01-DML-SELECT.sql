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
--  부서 id가 90이며 급여가 20000 이상인 사원
select first_name || ' ' || last_name 이름, salary 급여, department_id "부서 id" from employees where department_id = 90 and salary >= 20000;
--  입사일이 11/01/01 ~ 17/12/31 구간의 사원 목록
select first_name || ' ' || last_name 이름, hire_date 입사일 from employees where hire_date between '11/01/01' and '15/12/31';
--  manager_id가 100, 120, 147인 사원의 명단
select first_name || ' ' || last_name 이름, manager_id from employees where manager_id = 100 or manager_id = 120 or manager_id = 147;
select first_name || ' ' || last_name 이름, manager_id from employees where manager_id in (100, 120, 147);


-----------------------
--  order by
-----------------------

--  특정 컬럼명, 연산식, 별칭, 컬럼 순서를 기준으로 레코드 정렬
--  asc (오름차순, default), desc (내림차순)
--  여러 개의 컬럼에 적용할 수 있고 ','로 구분

--  부서 번호의 오름차순으로 정렬, 부서번호, 급여, 이름 출력
select department_id "부서 번호", salary 급여, first_name || ' ' || last_name 이름 from employees order by department_id asc;
--  급여가 10000 이상인 직원 대상, 급여의 내림차순으로 출력,
select first_name || ' ' || last_name 이름, salary 급여 from employees where salary >= 10000 order by salary desc;
--  부서 번호, 급여, 이름 순으로 출력, 정렬 기준 부서번호 오름차순, 급여 내림차순
select department_id "부서 번호", salary 급여, first_name || ' ' || last_name 이름 from employees order by department_id, salary desc;

--  정렬 기준을 어떻게 세우느냐에 따라 성능, 출력 결과에 영향을 미칠 수 있다.


-------------------
--  단일행 함수  --
-------------------

--  단일 레코드를 기준으로 특정 컬럼의 값에 적용되는 함수
--  문자열 단일행 함수
select first_name, last_name,
    concat(first_name, concat(' ', Last_name)) 이름,  --  문자열 연결 함수
    first_name || ' ' || last_name 이름2,  --  문자열 연결 연산
    initcap(first_name || ' ' || last_name)     --  각 단어의 첫 글자를 대문자로
from employees;

select first_name, last_name,
    lower(First_name)소문자 ,     --  모두 소문자
    upper(first_name)대문자,      --  모두 대문자]
    lpad (first_name, 10, '*'),  --  왼쪽 빈자리 채움 
    rpad (first_name, 10, '*')   --  오른쪽 빈자리 채음
from employees;

select '    Oracle      ',
'***********Database**********',
    ltrim('    Oracle      '),  --  왼쪽 빈공간 삭제
    rtrim('    Oracle      '),  --  오른쪽 빈봉간 삭제
    trim('*' from '***********Database**********'),  --  앞뒤 잡음 문자 제거
    substr('Oracle database', 8, 4),     --  부분 문자열
    substr('Oracle database', -8, 6),    --  역인덱스 이용 부분 문자열
    length ('Oracle database')           --  문자열 길이
from dual;

--  수차형 단일행 함수

select 3.141592,
    abs(-3.141592),  --  절댓값
    ceil(3.14),      --  올림
    floor(3.14),     --  버림
    round(3.5),      --  반올림
    round(3.141592, 3),  --  소수점 셋째 자리까지
    trunc (3.35),   --  버림
    trunc (3.141592,3),  --  소수점 셋째까지 남김
    sign (-3.141592),   --  부호 판단 (-1 음수, 0은 0, 1 양수)
    mod (7, 3),      --  7을 3으로 나눈 나머지
    power(2, 4)     --  2의 4제곱
from dual;

-------------------
--  DATA FORMAT
-------------------

--  현재 세션 정보 확인
select * from nls_session_parameters;
--  현재 날짜 포맷이 어떻게 되는가
select value from nls_session_parameters
where parameter = 'NLS_DATE_FORMAT';

--  현재 날짜: sysdate
select sysdate from dual;   -- 가상 테이블 dual로부터 받아오므로 1개의 레코드
select sysdate from employees;  --  employees 테이블에서 받아오므로 그 테이블 레코드 갯수만큼

--  날짜 관련 단일행 함수
select
    sysdate,
    ADD_MONTHs(sysdate, 2),   --  2개월 지난 후의 날짜
    Last_day (sysdate), --  현재 달의 마지막날
    months_between('12/09/24', sysdate), -- 두 날짜 사이의 개월 차
    next_day(sysdate, 5),   --  1:일 ~ 7:토
    round(sysdate, 'month'),    --  month를 기준으로 반올림
    trunc(sysdate, 'MONTH')     --  month를 기준으로 버림
from dual;

select first_name, hire_date, round (MONTHS_BETWEEN (sysdate, hire_date)) 근속개월수
from employees;


------------------
--  변환 함수
--=---------------

--  to_number(s, fmt): 문자열 -> 숫자
--  to_date(s, fmt): 문자열 -> 날짜
--  to_char(o, fmt): 숫자, 날짜 -> 문자열

--  to_char
select first_name, hire_date,
    to_char(hire_date, 'YYYY-MM-DD')
from employees;

--  햔재 시간을 년월시분초로 표기
select sysdate,
    to_char(sysdate, 'YYYY-MM-DD HH24:MI:SS')
from dual;

select
    to_char(1000000000, 'L999,999,999,999.99')
from dual;

--  모든 직원의 이름과 연봉 정보를 표시
select first_name 이름, salary 급여, commission_pct 커미션,
    to_char(((salary + salary * nvl(commission_pct, 0)) * 12), '$999,999,999.99') 연봉
from employees;

--  문자 -> 숫자 : to_number
select '$57,600',
    to_number('$57,600', '$99,999') / 12 월급
from dual;

--  문자열 -> 날짜
select '2012-09-24 13:15:34',
    to_date('2012-09-24 13:15:34', 'YYYY-MM-DD HH24:MI:SS')
from dual;

--  날짜 연산
--  Date +/- number : 날짜에서 특정 날수를 더하거나 뺄 수 있다
--  date - date : 두 날짜 사이의 차
--  date + number / 24 : 특정 시간이 지난 후의 날짜
select sysdate,
    sysdate +1, sysdate -1,
    (sysdate - To_date('19971126')) / 365,
    sysdate + 48 / 24
from dual;

--  nvl function
select first_name, salary,
    nvl(salary * commission_pct, 0) 커미션 -- nvl(표현식, 대체값)
from employees;

--  nvl2 function
select first_name, salary,
    nvl2(commission_pct, salary * commission_pct, 0) 커미션 -- nvl2(표현식, null이 아닐때, null일때)
from employees;

--  case function
--  보너스를 지급하기로 했을 때
--  ad 관련 직종에게는 20%, sa 관련 직종이네느 10%, IT관련 8%, 나머지 5%
select first_name, job_id, salary,
    substr (job_id, 1, 2) "직종 체크",
    case substr (job_id, 1, 2) when 'AD' then salary * 0.2
                    when 'SA' then salary * 0.1
                    when 'IT' then salary * 0.08
                    else salary * 0.05
    end 보너스
from employees;

--  decode 함수
select first_name, job_id, salary,
    substr(job_id, 1, 2) "직종 체크",
    decode(substr(job_id, 1, 2),
        'AD', salary * 0.2,
        'SA', salary * 0.1,
        'IT', salary * 0.08,
        salary * 0.05) 보너스    
from employees;

select First_name from employees where salary = 12008;

select first_name 이름, department_id 부서,
    case 
    when department_id <= 30 then 'A-GROUP'
    when department_id <= 50 then 'B-GROUP'
    when department_id <= 100 then 'C-GROUP'
    else 'REMAINDER'
    end 팀
from employees    order by 팀, department_id;

select first_name, replace (first_name, 'a', '*'), replace (first_name,
substr(first_name, 2, 3), '***') from employees;

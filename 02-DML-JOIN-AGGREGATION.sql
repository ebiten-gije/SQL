----------------------------
--  JOIN
----------------------------

--  employees, departments
desc employees;
desc departments;

select * from employees;    --  107개
select * from departments;  --  27개

select * from employees, departments;   --  107 * 27 = 2889개
--  가티젼 프로덕트

select *
from employees, departments
where employees.department_id = departments.department_id;
--  Inner join, equi-join

--  alias 를 이용한 원하는 필드의 projection
------------------------------------------
--  simple join or equi-join
------------------------------------------

select First_name, emp.department_id, department_name
from employees emp, departments dep
where emp.department_id = dep.department_id;
--  dep_id null이면 join에서 배제됨;;

select * from employees
where department_id is null;

select emp.First_name, dep.department_name, department_id
from departments dep join employees emp
using (department_id);

------------------
-- theta join
------------------

--  join 조건이 "=" 가 아닌 다른 조건들

--  급여가 직군 평균 급여보다 낮은 직원들 목록
select emp.employee_id, emp.first_name, emp.salary, emp.job_id,
    js.job_id, js.job_title
from employees emp join jobs js on emp.job_id = js.job_id
where emp.salary <= (js.min_salary + js.max_salary) / 2
;

-----------------------
--  outer join
-----------------------

--  조건을 만족하는 짝이 없는 튜플도 null을 포함해서 결과 출력 참여시키는 방법
--  모든 결과를 표현할 테이블이 어느 쪽에 위치하는가에 따라 LEFT,RIGHT, FULL OUTER join으로 구분
--  ORACLE SQL의 경우 null이 출력되는 쪽에 (+) 를 붙임

--  LEFT OUTER JOIN
--  oracle sql
select emp.First_name, emp.department_id, dep.department_id, dep.department_name
from employees emp, departments dep
where emp.department_id = dep.department_id(+); --  null이 포함된 쪽에 (+) 표기

select * from employees where department_id is null;    --  Kimberely 소속 부서 없음

--  ANSI SQL : 명시적으로 JOIN 방법을 정한다
select First_name, emp.department_id, dep.department_id, department_name
from employees emp LEFT OUTER JOIN departments dep
on emp.department_id = dep.department_id;

--  RIGHT OUTER JOIN
--  right 테이블의 모든 레코드가 출력 결과에 참여
--  oracle sql
select First_name, emp.department_id, dep.department_id, department_name
from employees emp, departments dep
where emp.department_id(+) = dep.department_id; --  department 테이블 레코드 전부를 출력에 참여
--  null이 포함된 쪽에 (+) 표기

--  ANSI SQL
select First_name, emp.department_id, dep.department_id, department_name
from employees emp right OUTER JOIN departments dep
on emp.department_id = dep.department_id;

--------------------------
--  full outer join
--------------------------]

--  join 에 참여한 모든 테이블의 모든 레코드를 출력에 참여
--  짝이 없는 레코드는 null을 포함해서 출력에 참여

--ansi
select first_name, emp.department_id, dep.department_id, dep.department_name
from employees emp full outer join departments dep
on emp.department_id = dep.department_id;

------------------
--  natural join
------------------
--  조인할 테이블에 같은 이름의 컬럼이 있을 경우 , 해당 컬럼을 기준으로 join
select * from employees emp natural join departments dep;

--select * from employees emp join departments dep on emp.department_id = dep.department_id;
--select * from employees emp join departments dep on emp.manager_id = dep.manager_id;
select * from employees emp join departments dep on emp.manager_id = dep.manager_id and emp.department_id = dep.department_id;


-----------------------
--  self join
-----------------------
--  자기 자신과 JOIN
--  자기 자신을 두번 호출 -> 각각의 테이블에 alias(별칭)을 반드시 부여해야함

select * from employees;
select emp.employee_id, emp.first_name, 
    emp.manager_id, man.first_name manager
--from employees emp join employees man
--    on emp.manager_id = man.employee_id;
from employees emp, employees man
where emp.manager_id = man.employee_id(+);


---------------------------
--  GROUP AGGREGATION
-----------------------------

--  집계: 여러 행으로부터 데이터를 수집, 하나의 행으로 반환

--  count: 갯수 세기 함수
--  employees 테이블의 총 레코드 갯수:
select count(*) from employees;

--  * 로 카운트하면 모든 행의 수를 반환
--  특정 컬럼 내에 null값의 포함여부는 중요치 않음

--  commission 받는 직원의 수를 알고 싶을 경우
--  commission_pct가 null인 경우를 제외하고 싶다면;
select count (commission_pct) from employees;
--  컬럼 내에 포함된 null 데이터를 카운트하지 않음

--  위 쿼리는 아래와 같다
select count (*) from employees
where commission_pct is not null;

--  sum : 합계함수
--  모든 사원의 급여의 합계
select sum (salary) from employees;

--  avg: 평균 함수
--  사원들의 평균 급여?
select avg(salary) from employees;

--  사원들의 커미션 비율 평균은?
select avg (commission_pct) from employees; --  0.222
--  avg 함수는 null값이 포함되어있을 경우, 그 값을 집계 수치에서 제외
--   null값을 집계 결과에 포함시킬지의 여부는 정책으로 결정하고 수행해야 한다
select avg (NVL(commission_pct, 0)) from employees; --  0.072

--  min / max: 최솟값 / 최댓값
--  avg / median: 산술평균 / 중앙값
select 
    min(salary),
    max(salary),
    avg(salary),
    median(salary)
from employees;

--  흔히 범하는 오류ㄷㄷ
--  부서별 평균 급여를 구하고 싶을 때,
select department_id, avg(salary)
from employees;

select department_id from employees;    --  여러개의 레코드
select avg(salary) from employees;      --  단일 레코드

select department_id, salary
from employees
order by department_id;

--  GROUP by
select department_id, round (avg(salary), 2)
from employees
group by department_id      --  집계 위해 특정 컬럼 기준으로 그룹핑
order by department_id;

--  부서별 평균 급여에 부서명도 포함하여 출력
select emp.department_id, dep.department_name, round( AVG(salary), 0)
from employees emp join departments dep on emp.department_id = dep.department_id
group by emp.department_id, dep.department_name
order by emp.department_id;

--  GROUP by 절 이후에는 GROUP BY 에 참여한 컬럼과 집계함수만 남는다


--  평균 급여가 7000 이상인 부서만 출력해보기
select department_id, avg(salary)
from employees
where avg(salary) >= 7000   --  아직 집계함수 시행되지 않은 상태, 집계함수의 비교 불가
group by department_id
order by department_id;

--  집계 함수 이후의 조건 비교 => having 절을 이용
select department_id, avg(salary)
from employees
group by department_id
having avg(salary) >= 7000  --  GROUP bY AGGREGATION의 조건 필터링
order by department_id;


--  ROLLUP
--  GROUP by 절과 함꼐 사용
--  그룹 지어진 결과에 대한 좀 더 상세한 요약을 제공하는 기능 수행
--  일종의 Item Total
select department_id, job_id, sum(salary)
from employees
group by rollup (department_id, job_id);


--  CUBE
--  CrossTab에 대한 Summary를 함께 추출하는 함수
--  RollUp 함수에 의해 출력되는 Item Total 값과 함께
--  Columm Total값을 함께 출력
select department_id, job_id, sum(salary)
from employees
group by cube (department_id, job_id)
order by department_id;


---------------------------------
--  SUBQUERY
-------------------------------

--  모든 직원 급여의 중앙값보다 많은 급여를 받는 사원의 목록
--  1) 급여의 중앙값?
--  2) 1번보다 많은 급여를 받는 직원의 목록

--  1)
select median (Salary) from employees;  --  6200

--  2) 1번 결과 (6200) 보다 많은 급여를 받는 직원의 목록
select first_name, salary
from employees
where salary >= 6200;

--  1) 과 2) 쿼리 합치기
select first_name, salary
from employees
where salary >= (select median (Salary) from employees)
order by salary desc;

--  Susan 보다 늦게 입사한 사람의 정보
--  1) susan의 입사일
--  2) 1)보다 늦게 입사한 사원의 정보

--  1) Susan으ㅟ 입사일
select hire_date
from employees
where first_name = 'Susan';

--  2) 12/06/07보다 늦게 입사한 사람
select first_name, hire_date
from employees
where hire_date > '12/06/07'
order by hire_date;

--  1) 2) 합치기
select first_name, hire_date
from employees
where hire_date > (select hire_date
from employees
where first_name = 'Susan')
order by hire_date;


--  연습
--  급여를 모든 직원 급여의 중앙값보다 많이 받기, 수잔보다 늦게 입사하기
select first_name, salary, hire_date
from employees
where hire_date > (select hire_date from employees
where first_name = 'Susan')
and salary > (select median (Salary) from employees)
order by salary, hire_date;


-----------------
--  다중행 서브쿼리
--  서브쿼리 결과가 둘 이상의 레코드일때 단일행 비교연산자는 사용할 수 없다
--  집합 연산에 관련된 IN, ANY, ALL, EXISTS 등을 사용해야 한다

--  직원들 중, 110번 부서 사람들이 받는 급여와 같은 급여를 받는 직원들의 목록
--1) 110번 부서 사람들은 얼마의 급여를 받는가
select first_name, salary from employees
where department_id =110;
--2) 직원들 중 급여가 12008, 8300인 직원은?
select first_name, salary from employees
where salary in (12008, 8300);

--  합치기
select first_name, salary from employees
where salary in     (select salary from employees
                    where department_id =110
);

--  110번 부서 사람들이 받는 급여보다 많은 급여를 받는 직원들의 목록
--  1) 110번 부서 사람들이 받는 급여?
select first_name, salary from employees
where department_id =110;

--  2) 1번 쿼리 전체보다 많은 급여를 받는 직원의 목록
select first_name, salary from employees
where salary > all (12008, 8300);

--  110번 부서 사람들이 받는 급여 중 하나보다 많은 급여를 받는 직원들의 목록
--  1) 110번 부서 사람들이 받는 급여?
select first_name, salary from employees
where department_id =110;

--  2) 1번 쿼리 중 하나보다 많은 급여를 받는 직원들의 목록
select first_name, salary from employees
where salary > any (12008, 8300);

select first_name, salary from employees
where salary > all (select salary from employees
                    where department_id =110);


-----------------------------
--  Correlated Query
--  바깥쪽 쿼리 (OUTET Query)와 안쪽 쿼리 (Inner Query)가 서로 연관된 커리
select first_name, salary, department_id
from employees outer
where salary > (select avg(salary) from employees where department_id =
outer.department_id);
--  외부 쿼리: 급여를 특정 값보다 많이 받는 직원의 이름, 급여, 부서 아이디
--  내부 쿼리: 특정 부서에 소속된 직원의 평균 급여

--  자신이 속한 부서의 평균 급여보다 많이 받는 직원의 목록을 구하려는 의미
--  외부 쿼리가 내부 쿼리에 영향을 미치고, 내부 쿼기 결과가 다시 외부에 영향을 끼침


--  서브쿼리 연습
--  각 부서별로 최고 급여를 받는 사원의 목록 (조건절에서 서브쿼라 활용)
--  1) 각 부서별 최고급여 출력
select department_id, max(salary) from employees
group by department_id;
--  2) 1번 쿼리에서 나온 department_id와 max값을 사용해서 외부쿼리 작성
select department_id, employee_id, first_name, salary
from employees
where (department_id, salary) in (select department_id, max(salary) from employees
group by department_id);

--  각 부서별 최고급여를 받는 사원의 목록 (서브쿼리를 이용, 임시 테이블 생성 -> 테이블 조인 결과 뽑기)
--  1. 각 부서의 최고 급여를 출력하는 쿼리 생성
select department_id, max(salary) from employees
group by department_id;
--  2. 1번 쿼리에서 생성한 임시 테이블과 외부 쿼리를 조인하는 쿼리
select emp.department_id, emp.employee_id, emp.first_name, emp.salary
from employees emp, (select department_id, max(salary) subSal from employees
group by department_id) sub
where emp.department_id = sub.department_id     --  join 조건
and emp.salary = sub.subSal
order by emp.department_id;


-------------------
--  top-k 쿼리 
--  질의의 결과로 부여된 가상 컬럼 rownum 값을 사용해서 쿼리 순서를 반환
--  rownum 값을 활용해서 상위 k의 값을 얻어오는 쿼리

--  2017년 입사자 중에서 연봉순위 5위까지
--  1. 2017년 입사자는 누구냐
select * from employees where hire_date like '17%'
order by salary desc;
--  2. 1번 쿼리를 활용해서 rownum값까지 확인, rownum <= 5 인 레코드 -> 상위 5개
select rownum, first_name, salary from (select * from employees where hire_date like '17%'
order by salary desc) where rownum <= 5;

--  집합연산
select first_name, salary, hire_date from employees where hire_date < '15/01/01';       --  24
select first_name, salary, hire_date from employees where salary > 12000;               --  8

--  합집합
select first_name, salary, hire_date from employees where hire_date < '15/01/01'
union       --  중복 레코드 1개로 취급
select first_name, salary, hire_date from employees where salary > 12000;         --  26

select first_name, salary, hire_date from employees where hire_date < '15/01/01'
union all --    중복 레코드는 별개로 취급
select first_name, salary, hire_date from employees where salary > 12000;     --  32 

select first_name, salary, hire_date from employees where hire_date < '15/01/01'
intersect --    교집합 --  inner join  과 비슷
select first_name, salary, hire_date from employees where salary > 12000;     --  6

select first_name, salary, hire_date from employees where hire_date < '15/01/01'
minus --    차집합
select first_name, salary, hire_date from employees where salary > 12000;     --  18 


--  rank 관련 함수
select salary, first_name, 
    rank () over (order by salary desc) as rank, -- 일반적인 순위
    dense_rank () over (order by salary desc) as dense_rank,
    row_number () over (order by salary desc) as row_number,    --  정렬 했을 때의 실제 행 번호
    rownum      --  쿼리 결과의 행번호 (가상 칼럼)
from employees;

--  Hierarchical Query  (oracle 특화)
--  트리 형태 구조 표현
--  level 가상 컬럼 활용 쿼리
select level, employee_id, first_name, manager_id
from employees
start with manager_id is null               --  트리 형태의 root가 되는 조건 명시
connect by prior employee_id = manager_id   --  상위 레벨과의 연결 조건  (가지치기 조건)
order by level                              --  트리의 길이를 나타내는 oracle 가상 컬럼
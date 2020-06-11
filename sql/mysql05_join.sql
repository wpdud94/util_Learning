-- [Join] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
클래스간의 연간 = hasing
hasing 방법 = 필드 주입, 생성자 or setter

# 테이블 간 연간
- 부모자식 관계
- Foreign Key 갖는 쪽이 자식 : 그 테이블이 필드니까
- 이 외의 관계는 없다

# 용어
- join : 하나 이상의 테이블로부터 데이터를 질의하기 위해서 조인을 사용. 다수의 테이블을 활용하는 것
- selfjoin이 있어서 하나 이상이라고 하지만 보통은 두 개 이상임
*/

SELECT * FROM emp;
SELECT * FROM dept;
SELECT DISTINCT deptno FROM emp;
-- MultiPulisty
/*
>- 라는 형식으로 관계를 표현
emp의 다수의 직원이 dept에 연관됨
[그림]
emp					detp
0...M >-------------0 / 1 
*/

-- 특정 사원이 소속된 부서 정보를 검색(사원의 정보 + 부서 정보 모두 알고 싶다)
-- 그러려면 [다중테이블]로부터 질의를 해야 함
SELECT * FROM emp, dept;
/*
Cartesiann Product
- 단순 곱의 형태로 나오는 것
- 직원이 14명인데, 다중테이블로 질의했을 때 56줄이 나오는 상황 (14 x 4 = 56)

Cartesiann Product 도출되는 경우
1) 조인 조건을 안 줬거나
2) 조인 조건을 잘못줬거나
결론: 조인 조건을 잘 주어라
*/
/*
Join 조건 : 양쪽테이블에 존재하는 컬럼, Foreign Key. --> deptno
Join 조건 주는 방식
1) where 절 이용해서 각각 테이블의 공통 컬럼을 명시
where emp.deptno=dept.deptno
해당 부서하고만 연결. 각각의 부서에 대한 정보를 찾아오는 식
*/
SELECT * FROM emp, dept;
-- 1) 컬럼명을 일일이 명시해야 한다... 공개되지 않아야 하는 or 불필요한 컬럼이 출력되는 것을 방지한다... for 재사용성
-- Projection : 명시하고 싶은 컬럼만 명시한다.
-- Selection : 원하는 행만 명시한다
SELECT * FROM emp, dept WHERE emp.deptno=dept.deptno; -- 14줄 산출

-- 2) 중복되는 컬럼 중 어느 테이블을 뽑아야 하는지 모른다. ambiguous
-- 각각의 컬럼이 어느 테이블에 있는지 명시하는 게 중요하다.
-- 컬럼명 앞에 table alias를 부여. 모두!
SELECT empno, ename, sal, deptno, dname, loc 
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 3) 테이블 명을 일일이 붙이는 게 번거롭다. 
SELECT emp.empno, emp.ename, emp.sal, emp.deptno, dept.dname, dept.loc 
FROM emp, dept
WHERE emp.deptno = dept.deptno;

-- 4) 테이블 명을 줄인다
SELECT e.empno, e.ename, e.sal, e.deptno, d.dname, d.loc 
FROM emp e, dept d
WHERE e.deptno = d.deptno;

-- 예제1
-- 사원의 이름, 급여, 부서번호, 부서명을 검색. 단, 급여가 2000 이상이고 30번 부서에 한해서만 검색
-- where 절에서 join 조건과 비조인 조건이 혼용
SELECT e.ename, e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal >= 2000
AND e.deptno = 30;
-- --------------------------------------------------------------------------------------------------------
-- [self join] %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- selection한 테이블을 하나의 테이블로 본다. 각 테이블을 조인
-- From절 뒤 sub query
-- 조인 조건 찾아내는 게 키포인트
SELECT empno, ename, mgr FROM emp WHERE ename = 'BLAKE'; -- e
SELECT empno, ename FROM emp WHERE empno = 7839; -- m

-- BLAKE라는 사원의 상사 이름을 검색하는데... 사원번호, 사원이름, 상사번호, 상사이름 검색
-- 1)
SELECT empno, ename, mgr FROM emp; -- 특정 사원의 상사 검색. 해당 사원의 상사번호를 알아야 함
SELECT empno, ename FROM emp; -- 상사의 정보
-- 2)
SELECT * FROM (SELECT empno, ename, mgr FROM emp) e, (SELECT empno, ename FROM emp) m; -- Cartesian Talbe
-- 3) 조인 조건 : 상사번호 = 사원번호
SELECT * FROM (SELECT empno 사원번호, ename 사원명, mgr FROM emp) e, 
(SELECT empno, ename FROM emp) m
WHERE e.mgr = m.empno;
-- 4)
SELECT e.empno 사원번호, e.ename 사원명, m.ename 상사명 FROM (SELECT empno, ename, mgr FROM emp) e, 
(SELECT empno, ename FROM emp) m
WHERE e.mgr = m.empno;
-- 5)
SELECT e.empno 사원번호, e.ename 사원명, m.ename 상사명 FROM (SELECT empno, ename, mgr FROM emp) e, 
(SELECT empno, ename FROM emp) m
WHERE e.mgr = m.empno
AND
e.ename = 'BLAKE';

-- --------------------------------------------------------------------------------------------------------
-- [Outer Join]
/*
# Outer Join이란?
- A, B 테이블을 조인할 경우, 조건에 맞지 않는 데이터는 디스플리에되지 않는다.
- 조건에 맞지 않는 데이터도 디스플레이하고 싶을 때 Outer Join 사용

# Outer Join 종류
- 데이터가 어느 쪽에 있는가에 따라서 종류의 이름이 정햄
1) LEFT OUTER JOIN
2) RIGHT OUTER JOIN
3) FULL OUTER JOIN 
- 실행이 안 됨. 그럴 때 어떻게 해야 하느냐?
*/

-- 예제 1 : 조건에 맞지 않는 데이터가 디스플레이 되지 않는 경우 중 deptno 문제. RIGHT OUTER JOIN
-- 사원의 이름, 부서번호, 부서이름을 검색 --> deptno = 40 인 데이터가 안 나옴. emp 테이블에 없기 때문.
SELECT e.ename, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno;
-- d의 내용을 모두 공개하고 싶다. 그래서 right outer join. 
-- 벤다이어그램에서 교집합에 해당하지 않는 부분이 어느 방향이냐에 따라서 left, right 다름
-- 우측테이블이 기준이 되어 결과를 생산 : d가 기준이고 e의 교집합이 부는 느낌
SELECT e.ename, d.deptno, d.dname
FROM emp e RIGHT OUTER JOIN dept d ON e.deptno = d.deptno; -- deptni = 40인 데이터 디스플레이됨.

-- 예제2 : 특정 상사의 이름 검색 시 누락부분. LEFT OUTER JOIN
SELECT CONCAT(e.ename, '의 매니저는 ', m.ename, '입니다.') Info
FROM emp e, emp m -- emp 테이블을 둘 로 나눈 것. duplicate 느낌. 가상 공간에서 원본 복사본 가지고 노는 느낌
WHERE e.mgr = m.empno;
-- KING은 매니저가 없기에 위 테이블에 나타나지 않는다.

-- King이 나오도록. 조인 조건에 의해 m에서는 mgr이 없는 king은 없어짐. 따라서 king 데이는 e에 있다.
SELECT CONCAT(e.ename, '의 매니저는 ', m.ename, '입니다.') Info
FROM emp e LEFT OUTER JOIN emp m -- emp 테이블을 둘 로 나눈 것. duplicate 느낌. 가상 공간에서 원본 복사본 가지고 노는 느낌
ON e.mgr = m.empno;

-- 3) FULL
-- A : 10 20 30 FULL OUTER JOIN B : 10 ,20, 40 --> 10, 20, 30, 40
-- 중복 제거한 합집한 논리. but 안 돌아감
-- union 연사자 사용
/*
FULL OUTER JOIN을 실습할 수 있는 간단한 테이블을 만들고 예제 풀자
*/
CREATE TABLE outer1(sawonid int);
CREATE TABLE outer2(sawonid int);

INSERT INTO outer1 VALUES (10);
INSERT INTO outer1 VALUES (20);
INSERT INTO outer1 VALUES (40);

INSERT INTO outer2 VALUES (10);
INSERT INTO outer2 VALUES (20);
INSERT INTO outer2 VALUES (30);

-- FULL OUTER JOIN 사용
SELECT sawonid FROM outer1
UNION
SELECT sawonid FROM outer2
ORDER BY sawonid;

-- UNION ALL : 중복 허용alter

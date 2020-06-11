-- Sub Query
/*
Q. 서브 쿼리문, Inner Query이란?
하위 쿼리문 같은 것
가장 중요

# 용어정리
- Main Query, OuterQuery : Sub Query를 포함한 쿼리

# 서브쿼리 rule과 특성
1. 서브쿼리가 먼저 돌아간 결과값을 가지고 메인쿼리가 실행된다.
2. 서브쿼리는 ?에 해당것을 먼저 해결할 때 사용한다.
3-1. 서브쿼리는 반드시 ()로 쌓여야 한다.
3-2. 서브쿼리는 비교 연산자의 오른쪽에 있어야 한다.
3-3. 서브쿼리는 Order By 절에 포함하지 않는다.
order는 메인에서 도니까
3-4. 단일 행 서브쿼리에는 단일 연산자, 다중행에는 연산자
*/
SELECT sal FROM emp WHERE ename = 'CLARK';    
SELECT ename, sal FROM emp WHERE sal > 2450;

SELECT ename, sal FROM emp WHERE sal > (SELECT sal FROM emp WHERE ename = 'CLARK');    
;

/*
# 서브쿼리 유형
a. 위치
(1) From절 뒤
(2) Where절 뒤 : 필드 간 비교 시 
(3) Having절 뒤 : 그룹함수 간 비교 시

b. 행수
(1) 단일행 서브쿼리(스칼라 서브 쿼리)
단일행 연산자와 사용
(2) 다중행 서브쿼리
다중행 연산자와 사용
In, Any 기억!
*/

-- 급여를 가장 많이 받는 사원 5명 검색
SELECT ename, sal From emp ORDER BY sal DESC limit 5; -- limit로 인해 서브쿼리 안 써도 됨

-- ename인 King인 사원과 같은 부서에서 근무하는 사원을 검색
SELECT * FROM emp WHERE deptno IN(SELECT deptno FROM emp WHERE ename = 'KING');

-- 10번 부서에서 근무하는 사원 중에서 사원 전체 평균 급여보다 더 많은 급여를 받는 사원 검색
SELECT *
FROM emp
WHERE deptno = 10 
AND sal > (SELECT AVG(sal) FROM emp);

-- job별 가장 적은 평균급여를 검색. ? = 
-- MySQL에서는 그룹함수 중첩이 안 된다... 오라클과의 차이점
-- (in Oracle)
SELECT job, round(AVG(sal),1) 평균급여 FROM emp GROUP BY job
HAVING AVG(sal)=(SELECT MIN(AVG(sal)) FROM emp GROUP BY job);
-- 그래서 limit 사용
SELECT job, round(AVG(sal),1) 평균급여 FROM emp GROUP BY job ORDER BY sal limit 1;

-- sccott의 급여보다 더 많은 급여를 받는 사원 검색
-- (테이블 알리야스를 사용하는 방법 추가) 
-- 1)
SELECT * FROM emp WHERE sal > (SELECT sal FROM emp WHERE ename = 'SCOTT');
-- 2) 테이블 전체를 알리야스 부여 가능 (이게 있고 저게 있는데 이것과 저것 비교)
SELECT * FROM emp a , (SELECT sal FROM emp WHERE ename = 'SCOTT') b 
WHERE a.sal > b.sal;

-- 직속상관이 KING(자신의 mgr번호가 emp 넘버)인 사원의 이름, 급여를 검색
SELECT ename, sal, empno, mgr FROM emp 
WHERE MGR = (SELECT EMPNO FROM emp WHERE ename = 'KING');

-- job이 사원 7369번의 업무와 같고, 급여가 사원 7876번보다 많은 사원을 검색
SELECT * FROM emp 
WHERE sal > (SELECT sal FROM emp WHERE empno=7876)
AND job = (SELECT job FROM emp WHERE empno = 7369);

-- 부서별 최소급여 중에서 20번 부서의 최소급여보다 더 큰 최소급여를 검색
SELECT deptno, min(sal) 최소급여 FROM emp
GROUP BY deptno
Having min(sal) > (SELECT min(sal) FROM emp WHERE deptno = 20);

-- 부서별 최소급여와 같은 급여를 가지는 사원을 검색
SELECT * FROM emp
WHERE sal IN(SELECT min(sal) FROM emp GROUP BY deptno); -- 다중행 쿼리는 다중행 연산자

-- 급여를 3000 이상 받는 사원이 소속된 부서와 동일한 부서의 근무하는 사원하는 검색
SELECT * FROM emp
WHERE deptno IN(SELECT DISTINCT deptno FROM emp WHERE sal>=3000);

-- 다중행 연산자
/*
(1) IN
- (A or B or C)
- 여러 개 중에서 같은 값을 찾음
- NOT IN ( ~A and ~B and ~C). 문제는 null은 연산이 안 됨. 그래서 값이 안 나옴
(2) ANY
- 메인 쿼리 비교 조건이 서브 쿼리 검색 결과와 하나 이상만 일치하면 참
(3) ALL
- 메인 쿼리 비교 조건이 서브 쿼리 검색 결과와 모든 값이 일치해야 참

> ANY보다 크다 = 최소값보다 크다 (범위 그림 생각하기)
< ANY = 최대값보다 작다
< All보다 크다 = 최대값보다 크다
> All = 최소값보다 작다

NULL값 핸들리이 중요
*/

-- 급여가 어떤 점원(CLERK)보다도 작으면서 clerk인 아닌 사람을 검색
SELECT * FROM emp WHERE job='CLERK'; -- 하나만이라도 일치 --> any최대값 보다 작다
SELECT * FROM emp 
WHERE sal < ANY(SELECT sal FROM emp WHERE job='CLERK')
AND job<>'CLERK';

-- 급여가 모든 부서의 평균보다 많은 사원 검색
SELECT * FROM emp WHERE sal > ALL(SELECT AVG(sal) FROM emp GROUP BY deptno); -- 전부, 최대값보다 크다.

-- 1) 급여가 10번부서에 속한 어떤 사원의 급여보다 더 많은 급여를 받는 사원을 검색. 이때 10번 부서에 속한 사원은 제외.
-- 정렬은 사원번호 순
SELECT * FROM emp
WHERE sal > ANY(SELECT sal FROM emp WHERE deptno = 10)
AND deptno <> 10
ORDER BY empno;

-- 2) 30번 소속 사원들 중에서 급여를 가장 많이 받는 사원보다 더 많은 급여를 받는 사원의 이름과 급여를 검색
SELECT ename, sal, deptno FROM emp
WHERE sal > ALL(SELECT sal FROM emp WHERE deptno = 30);

SELECT ename, sal, deptno FROM emp
WHERE sal > (SELECT MAX(sal) FROM emp WHERE deptno = 30);

SELECT ename, sal, deptno FROM emp
WHERE sal > (SELECT MAX(sal) FROM emp
GROUP BY deptno
HAVING deptno =30);

-- 부하직원 거느린 사원(empno가 mgr에 있는 사람)을 검색
-- 1)
SELECT * FROM emp WHERE empno IN (SELECT mgr FROM emp);
-- 2) 알리아스 사용
SELECT e.ename 상사이름, e.empno '상사사원번호' FROM emp e WHERE e.empno IN (SELECT m.mgr FROM emp m);

-- 부하직원을 거느리지 않는 사원을 검색
SELECT * FROM emp WHERE empno NOT IN (SELECT ifnull(mgr,0) FROM emp);
-- 1. ACCOUNTING 부서에서 근무하는 직원의 이름, 급여, 입사일을 검색하시오
-- 조인 사용
SELECT e.ename, e.sal, e.hiredate FROM emp e, dept d
WHERE e.deptno = d.deptno 
AND d.dname = 'ACCOUNTING';

-- sub query 사용
SELECT ename, sal, hiredate FROM emp
WHERE deptno = (SELECT deptno FROM dept WHERE dname = 'ACCOUNTING');

-- 2. 'TURNER' 와같은부서에서근무하는 직원의이름과부서번호를조회하시오
SELECT ename, deptno FROM emp
WHERE deptno = (SELECT deptno FROM emp WHERE ename = 'TURNER');

-- 3.  10번 부서의평균급여보다많은급여를받는직원의이름, 부서번호, 급여를 조회하시오.
SELECT ename, deptno, sal FROM emp
WHERE sal >= (SELECT AVG(sal) FROM emp WHERE deptno = 10 GROUP BY deptno);

-- 4. King에게 보고하는모든사원의이름과급여를표시하시오. 사원의이름은직원으로 Alias를부여하시오
SELECT empno FROM emp WHERE ename = 'KING';

SELECT ename 직원, sal FROM emp
WHERE mgr = (SELECT empno FROM emp WHERE ename = 'KING');

-- 5. 평균급여보다많은급여를받고이름에 u가 포함된사원과같은부서에서 근무하는 모든사원의사원번호, 이름및급여를표시하시오

SELECT empno, ename, sal FROM emp
WHERE ename LIKE '%u%'
AND sal > (SELECT AVG(sal) FROM emp);


-- 6. 평균급여보다높고최대급여보다 낮은월급을받는사원의정보를조회 하시오.
SELECT * FROM emp
WHERE sal between (SELECT AVG(sal) FROM emp) and (SELECT MAX(sal) FROM emp);




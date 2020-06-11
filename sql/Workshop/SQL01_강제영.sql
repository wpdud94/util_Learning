-- 1. 급여가 1500 이상인 직원들의 이름, 급여, 부서번호를 조회하시오 
SELECT ename, sal, deptno
FROM emp
WHERE sal >= 1500;
-- ORDER BY sal;

-- 2. 직원 중에서 연봉이 2000 이상인 직원들의 이름, 연봉을 조회하시오
SELECT ename, sal
FROM emp
WHERE sal >=2000;
-- ORDER BY AnnualSal;

-- 3. 직원 중에서 comm이 없는 직원의 이름과 급여, 업무, comm을 조회하시오.
SELECT ename, sal, job, comm
FROM emp
WHERE comm is null;

-- 4. 입사한지 가장 오래된 직원 순으로 5명을 조회하시오
SELECT ename, hiredate
FROM emp
ORDER BY hiredate
limit 5;

-- 5. 1981년에 입사한 직원들 중에서 급여가 1500이상 2500이하인 직원들의 이름, 급여, 부서번호, 입사일을 조회하시오
SELECT ename, sal, deptno, hiredate
FROM emp
WHERE year(hiredate) = '1981' AND sal between 1500 and 2500;

-- 6. 이름이 A로 시작하는 직원의 이름, 급여 입사일을 조회하시오
SELECT ename, sal, hiredate
FROM emp
WHERE ename Like 'A%';

-- 7. 5월에 입사한 직원의 이름, 급여 입사일을 조회하시오
SELECT ename, sal, hiredate
FROM emp
WHERE month(hiredate) = '5';

-- 8. 세 번째 이름이 A가 들어간 직원의 이름, 급여 입사일을 조회하시오
SELECT ename, sal, hiredate
FROM emp
WHERE ename Like '__A%';

-- 9. 이름이 K로 끝나는 직원의 이름, 급여, 입사일을 조회하시오
SELECT ename, sal, hiredate
FROM emp
WHERE ename LIKE '%K';

-- 10. 커미션을 받는 직원의 이름, 커미션, 급여를 조회하시오
SELECT ename, comm, sal
FROM emp
WHERE comm is not null
ORDER BY comm;
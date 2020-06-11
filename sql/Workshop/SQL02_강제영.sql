-- 1. 이름이 'adam'인 직원의 급여와 입사일을 조회하시오.
SELECT ename, sal, hiredate 
FROM emp
WHERE lower(ename) LIKE 'adam%' or'%adam';

-- 2. 7년 이상 장기 근속한 직원들의 이름, 입사일 ,급여, 근무 년차를 조회
SELECT ename, sal, hiredate, abs(year(hiredate)-year(curdate())) 근무년차
FROM emp
WHERE abs(year(hiredate)-year(curdate())) >= 7
ORDER BY 근무년차, hiredate desc;

-- 3. 각 부서별 인원수를 조회하되 인원수가 5명 이상인 부서만 출력되도록 하시오.
SELECT deptno, count(EMPNO) 인원수
FROM emp
GROUP BY deptno
HAVING 인원수 >= 5
ORDER BY deptno;

-- 4. 각 부서별 최대급여와 최소급여를 조회. 단, 최대급여와 최소급여가 같은 부서는 직원이 한 명일 가능성이 높기에 결과에서 제외
SELECT deptno, max(sal) 최대급여, min(sal) 최소급여
FROM emp
GROUP BY deptno
HAVING 최대급여 <> 최소급여
ORDER BY deptno;

-- 5. 10, 20번 부소에 속해있으면서 급여가 2000이상인 직원의 이름, 급여, 업무,부서번호를 조회
SELECT ename, sal, job, deptno
FROM emp
WHERE sal >= 2000 
and deptno in (10, 20)
ORDER BY deptno;

/*6. 1981년대에 입사해서 10, 20, 30번 부서에 속해있으면서,
급여를 1500이상 3000이하를 받는 직원을 조회.
단 커미션을 받지 않는 직원들은 검색에서 제외시키며
먼저 입사한 직원이 머저 출력
입사일이 같은 경우 급여가 많은 직원이 먼저 출력되도록 하시오.
*/
SELECT ename, sal, deptno, hiredate, comm
FROM emp
WHERE year(hiredate) LIKE '1981' 
AND deptno in (10,20,30) 
AND sal between 1500 and 3000
AND comm is not null
ORDER BY hiredate, sal desc;

/* 7
부서가 10,20,30번인 직원들 중에서 급여를 1500이상 3000이하를 받는
직원들을 대상으로 부서별 평균급여를 조회.
단, 평균급여가 2000이상인 부서만 출력
출력결과를 평균급여가 높은 부서 먼저 출력되도록 해야 한다.
*/
SELECT deptno, round(AVG(sal)) 평균급여
FROM emp
WHERE deptno in (10,20,30) 
AND sal between 1500 and 3000
GROUP BY deptno
HAVING AVG(sal)>=2000
ORDER BY 2 desc;
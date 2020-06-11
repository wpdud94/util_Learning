-- 1. 'ACCOUNTING‘ 부서에서 근무하는직원들의이름, 급여, 입사일을조회하시 오.      (    조건  join 사용 )
SELECT e.ename, e.sal, e.hiredate
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND
d.dname = 'ACCOUNTING';

-- select * from emp e, dept d WHERE e.deptno = d.deptno;

-- 2. 직원의이름과관리자이름을조회하시오. 
SELECT e.ename 직원이름, m.ename 관리자이름
FROM emp e, (SELECT empno, ename, mgr FROM emp) m
WHERE e.mgr = m.empno;

-- 3.  관리자이름과관리자가관리하는 직원의수를조회하시오. 단, 관리직원수가 3명이상인관리자만 출력되도록하시오.
SELECT m.ename 관리자이름, COUNT(m.ename) 관리직원수
FROM emp e, (SELECT empno, ename, mgr FROM emp ) m
WHERE e.mgr = m.empno
GROUP BY m.ename
HAVING COUNT(m.ename) >= 3;


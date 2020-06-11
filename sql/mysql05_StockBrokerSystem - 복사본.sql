-- //////////////////////////////// 분석함수 //////////////////////////////////////////////
/*
MySQL 분석함수
(1) 순위함수 : rank, dense_rank, row_number, ntitle
(2) 집계함수(그룹함수) : sum, min, max, avg, count
sum과 avg가 다른 집계함수와의 차이점 : 숫자데이터에만 적용
문자는 서열변수로 생각하면 됨. 하지만 위 두 개는 등간변수만 사용가능하다고 보면 되
(3) 기타함수 : read, lag, first_value, last_value, ratio_to_report(mariaDB 지원 x)
*/
-- (1) 순위 함수
-- rank : order by 절을 포함한 쿼리문에서 특정한 항목에 대한 순위를 지정, 출력할 때 사용하는 함수. 단, 기준이 필요
SELECT empno, ename, deptno, sal,
rank() over(order by sal DESC) 급여순위 -- over 뒤에 rank의 기준을 말해줌
FROM emp;

-- dense_rank : rank()와 흠사하지만, 동일한 순위를 하나의 건수로 취급하는 데 차이남
SELECT empno, ename, deptno, sal,
dense_rank() over(order by sal DESC) 급여순위 
FROM emp;

-- ntitle : 버킷 단위(괄호 안)로 나누어 출력. 괄호 안 숫자 개수만큼 계급을 나눠 표현
-- mySQL의 유니크 함수
SELECT empno, ename, deptno, sal,
ntile(5) over(order by sal DESC) 소득등급
FROM emp;

-- row_number : 일련번호 출력. limit가 있어서.... 잘 안 씀
SELECT empno, ename, hiredate, row_number() over() FROM emp;
SELECT empno, ename, hiredate, row_number() over() Numbering FROM emp; -- 또는 순번
-- Numbering을 where절에 직접 못 쓴다.
-- Alias는 where절에 못 들어가고, 
-- 1) limit
SELECT empno, ename, hiredate, row_number() over() FROM emp limit 2;
-- 2) FROM subquery
SELECT empno, ename, hiredate
FROM (SELECT empno, ename, hiredate, row_number() over() Numbering FROM emp) n
WHERE n.Numbering =2 ;
-- 특정 컬럼 순으로 가능
SELECT empno, ename, hiredate, row_number() over(order by hiredate ASC) Numbering FROM emp;

-- (2) 집계함수
-- sum
SELECT empno, ename, sal, hiredate, deptno, sum(sal) sumsal FROM emp; -- 하나의 sum만 나옴
SELECT empno, ename, sal, hiredate, deptno, sum(sal) over() sumsal FROM emp;-- sum이 전체 행에 다 붙음
-- group by 절이 필요없게 됨
SELECT empno, ename, sal, hiredate, deptno, 
sum(sal) over() 총급여, 
sum(sal) over(partition by deptno) 부서별총급여
FROM emp
order by 부서별총급여;-- sum이 전체 행에 다 붙음

SELECT empno, ename, sal,
round(avg(sal) over(partition by job)) 업무별평균급여,
max(sal) over(partition by job) 업무별최대급여
FROM emp;
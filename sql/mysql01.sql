SELECT * FROM emp;
SELECT * FROM dept;
/* 	[간단한 데이터 타입 정리]
------------------------정수---------------------------
tinyint 아주 작은 범위의 정수 -128~127(0~255) / 100단위까지
smallint 작은 범위의 정수 -32768~32768(0~65535)
int 정수 	-20억 ~ 20억(40억) / 엥간히 크면 이거 쓰기
decimal 고정 소스. 소수점 고정. (전체자리수, 소수점 자리) 
		ex) decimal(5,1)

------------------------문자열---------------------------
char(3)		고정형
varchar(20) 문자수가 최대 n개인 문자열. 엥간하면 이거 써라.
text		문자수가 최대 65535개인 무자열.

------------------------날짜---------------------------
date		년, 월, 일 출력. 이거 많이 씀
datetime	년, 월, 일, 시, 분, 초 출력. 잘 안 씀

*/ 
-- [Projection | Selection]
/*
(1) Projection : 원하는 컬럼명을 지정해서 데이터를 가져오는 쿼리문
	ex) SELECT * FROM emp; // * 잘 안 씀. 보안 문제alter
*/
SELECT empno, ename, job, deptno FROM emp;
-- emp테이블에서 모든 사원의 이름과 입사일을 가져오기
SELECT ename, hiredate FROM emp;

-- 중복처리 : emp테이블에서 부서번호만 검색, 중복 제외 키워드... DISTINCT 사용... SELECT 바로 다음에 온다
SELECT DISTINCT deptno FROM emp;
SELECT DISTINCT(deptno) FROM emp;

-- 정렬 : 모든 데이터는 정렬이 되어서 나와한다. 기본은 오름차순(ASC). | 내림차순(DESC)... 가장 마지막 위치.
SELECT DISTINCT(deptno) FROM emp ORDER BY deptno ASC;

-- 사원 중에서 입사일이 가장 빠른 사원순으로 출력... --
SELECT ename, hiredate FROM emp order by hiredate ASC;

-- 사원중에서 월급이 가장 많이 받는 사원 순으로 검색되도록 --
SELECT ename, job, sal FROM emp ORDER BY sal DESC;

-- Limit(매우 중요) : 사원 중에서 입사일이 가장 늦은 사원 2명만 검색되도록 --
SELECT ename, hiredate, job FROM emp ORDER BY hiredate desc limit 0,2;
SELECT ename, hiredate, job FROM emp ORDER BY hiredate desc limit 3;
/*
limit
::
출력하는 개수를 제한
시작은 0부터. 
인자 설명 (시작하는 인덱스, 개수)
limit 0,2 0인덱스부터 2개만 출력

인덱스 디폴트 = 0 ==> limit 3 == limit 0, 3
*/
-- 월급 2등 3등 출력
SELECT ename, job, sal FROM emp ORDER BY sal DESC limit 1,2;

-- (2) SELECTION 
-- 조건에 따라서 해당하는 조건을 만족하는 행을 검색
-- # 조건부여 : WHERE
SELECT * FROM emp WHERE deptno=10;-- 10번 부서 사람만 뽑아냄

-- 예시 + 없는 열 만들기 : emp 테이블에서 업무가 SALESMAN 인 사원의 이름, 급여 연봉을 검색 + 없는 열도 만들어서 가능
SELECT ename, sal, sal*12+comm FROM emp WHERE job='SALESMAN';

-- Heading Display가 sal*12+comm로 표시되는 문제
-- Alias(별칭) 지정법 : 
-- 1) column명 as Alias
-- 2) column명 Alias : 1에 비해 많이 쓰임
-- 3) "Alias" : 띄어 쓰기가 있을 때
SELECT ename, sal, sal*12+comm AS AnnualSalary FROM emp WHERE job='SALESMAN';
SELECT ename, sal, sal*12+comm AnnualSalary FROM emp WHERE job='SALESMAN';
SELECT ename, sal, sal*12+comm '일년 총급여' FROM emp WHERE job='SALESMAN';

-- # 정렬에서 Alias 사용 
-- - '' 방법 말고는 됨
SELECT ename, sal, sal*12+comm '일년 총급여' FROM emp WHERE job='SALESMAN' ORDER BY '일년 총급여' DESC;
SELECT ename, sal, sal*12+comm AS AnnualSalary FROM emp WHERE job='SALESMAN' ORDER BY AnnualSalary DESC;
SELECT ename, sal, sal*12+comm AnnualSalary FROM emp WHERE job='SALESMAN' ORDER BY AnnualSalary DESC;

-- [SELECT 쿼리문]
-- 표기법 : 절마다 끊어서 하기
-- 문법적 순서(대게) : SELECT, FROM, WHERE, ORDER BY 
-- DB서버에서 실행 순서 : FROM, WHERE, SELECT, ORDER BY
-- 스키마는 use로 정했으니 어느 테이블에서 가져올 것인지 먼저 본다
-- 그 다음 조건에 맞는 데이터를 가져온다
-- 순서정리해서 디스플레이
SELECT ename, sal, sal*12+comm 연봉 
FROM emp 
WHERE job='SALESMAN' 
ORDER BY 연봉 desc;

-- # Null 처리, 치환 : ifnull
-- 모든 사원의 이름, 급여, 연봉을 검색. 연봉 순
-- Null값 문제
-- Null값은 나름의 의미를 가지지만 연산 불가 ==> Null
-- Null이면 0으로 치환
/*
ifnull(comm,0)
comm이 null이면 0으로
아니면 comm으로
*/
SELECT ename, sal, sal*12+ifnull(comm,0) AnnualSal
FROM emp
ORDER BY AnnualSal desc;

-- # Null 조건
-- comm이 null인 사원들의 이름, 업무, 급여, comm을 검색
SELECT ename, job, sal, comm
FROM emp
WHERE comm is null;

-- # 정렬 시 Null값의 크기
-- 상사번호만 디스플레이. 별칭은 상사번호
SELECT distinct MGR 상사번호
FROM emp
ORDER BY 상사번호 DESC; 


-- [2. 함수 -- 날짜 관련 함수 - YEAR(날짜) | MONTH(날짜)]
-- 사원 중에서 81년도에 입사 사원들의 정보를 디스플레이 
SELECT ename, hiredate, year(hiredate) 입사연도
FROM emp
WHERE year(hiredate) = 1981;
-- 5월 입사한 사원만
SELECT ename, hiredate, month(hiredate) 입사월
FROM emp
WHERE month(hiredate) = 5;

-- [3. LIKE 연사자와 와일드카드 %, _]
-- LIKE : 특정 단어와 같은 데이터 뽑아낼 때
-- 와일드카드 : 특정 단어가 들어있는 데이터를 뽑아낼 때
-- 사원 이름 중에 "A" 들어간 사람 다 뽑기
SELECT ename, job, deptno
FROM emp
WHERE ename LIKE '%A%'; -- 앞뒤로 어떤 데이터가 나와도 상관없을 때

SELECT ename, job, deptno
FROM emp
WHERE ename LIKE '_A%'; -- 두 번째 철자가 A인 사람 찾기, _는 한 문자랑 같음 

-- Q. 사원 중에서 마지막철자가 G로 끝나는 사원을 검색 --
SELECT ename, job, deptno
FROM emp
WHERE ename LIKE '%G';


-- ===============<이튿날>=========================
-- 1.문자 관련 함수
-- 1) cocat : concatatation(문자, 열 합쳐 문자열로 반환)
SELECT concat(ename, ' is a  ' , job) Message FROM emp;

-- 2) substr() : (중요) 문자열을 잘라내는 함수 (대상, 시작열(1이 시작), 개수)
SELECT ename, substr(hiredate, 1, 4) 입사년도 FROM emp;
SELECT ename, year(hiredate) 입사년도 FROM emp;
SELECT ename, substr(hiredate, 6, 2) 입사월 FROM emp;
SELECT ename, substr(hiredate, 9, 2) 입사일 FROM emp;
SELECT ename, day(hiredate) 입사일 FROM emp;

-- 2. 숫자 관련 함수 : abs(), mod(), round(), ceiling(), Floor(), truncate() 
-- 1) abs()
-- Blake 와 Smith의 월급 차이
SELECT distinct abs((SELECT sal FROM emp WHERE ename='SMITH')-(SELECT sal FROM emp WHERE ename='BLAKE')) 
'sal gap'
FROM emp;

-- 2) mod() : % : 나머지를 구하기
-- 사원번호가 홀수인 사원 검색
SELECT empno, ename FROM emp WHERE mod(empno,2)=1;

-- 업무가 salesman인 모든 사원에 대해서 comm에 대한 급여비율의 나머지를 검색.
SELECT ename, job, sal, comm, ifnull(mod(sal, comm), 'comm=0') FROM emp
WHERE job = 'SALESMAN';

-- 3) 올림, 반올림, 내림에 대하여
SELECT round(45.923,2); -- (숫자, .을 중심으로 x번자리까지 나타내라)
SELECT round(45.923); -- default == 0 
SELECT round(45.923, -1); -- 굳이 소수점에 국한되지 않음. 

SELECT floor(45.923); -- floor는 자리수를 지정하면 안 됨.

SELECT truncate(45.923, 2);-- 자리수 지정해야 함

-- 3. 날짜함수
SELECT now(); -- 년월일시분초
SELECT sysdate(); -- 년월일시분초
SELECT curdate(); -- 년월일
SELECT current_time(); -- 일시분초

-- 오세훈이 오늘까지 살아온 일수 구하기
SELECT (curdate()-('1997-06-19')) 살아온날; -- 날짜 - 문자했기에 이상함 ==> 변환함수 써야함
-- 문자를 날짜로 바꾸기 ==> 잘 안 먹힘
SELECT (curdate()-(str_to_date('1997-06-19', '%Y-%m-%d'))) 살아온날;
SELECT (curdate()-(date(19970619))) 살아온날;
-- 최종 : datediff()
SELECT datediff(curdate(), str_to_date('1997-06-19', '%Y-%m-%d')) 살아온날;
SELECT datediff(curdate(), '1997-06-19') 살아온날;

SELECT abs(datediff('1996-04-10', '1997-01-26')) 살아온날;

-- emp 테이블에서 모든 사원들이 지금까지 근무한 일수
SELECT ename, datediff(curdate(), hiredate) 근무일수 FROM emp;mytable
-- emp 테이블에서 모든 사원들이 지금까지 근무한 주수 
SELECT ename, floor(datediff(curdate(), hiredate)/7) 근무주수 FROM emp;

-- 오늘 사귀기 시작. 100일째 되는 날 검색
SELECT date_add(curdate(), interval 100 day) 오늘부터100일;

/* 
날짜 - 날짜 = 일수
날짜 -+ 숫자 = 날짜
*/

-- 4. 그룹함수 책.197
-- 그룹함수 : 그룹 내 데이터를 전부 다 보고 연산함
-- 유형 : AVG, SUM, MIN/MAX, COUNT
SELECT COUNT(*) FROM emp; -- 기본키에 해당하는 열의 행 수
SELECT COUNT(-1) FROM emp; -- 맨마지막 열 ==> 데이터 많을 때 사용하면 정확도 높아짐
SELECT COUNT(empno) FROM emp;
SELECT COUNT(MGR) FROM emp; -- null값은 그룹함수 연산에서 제외됨

SELECT MIN(hiredate) 가장빠른입사일, MAX(hiredate) 가장최근입사일 FROM emp;

SELECT SUM(sal) 사원총급여 FROM emp;
SELECT round(AVG(sal)) 평균급여 FROM emp;

-- 업무가 manager인 사람의 평균급여를 검색
SELECT round(AVG(sal)) FROM emp WHERE job = 'manager';

-- 모든 사원의 보너스 평균을 검색
SELECT round(AVG(ifnull(comm,0))) FROM emp;
SELECT AVG(comm) FROM emp;

-- 사원테이블에서 모든 부서의 개수를 출력
SELECT count(distinct deptno) FROM emp;

-- 부서번호가 10번이거나 20버인 사원의 인원수
SELECT count(deptno) FROM emp WHERE deptno = 10 or deptno = 20;
SELECT count(deptno) FROM emp WHERE deptno in(10, 20);

-- 사원번호가 7369이거나 7521이거나 7876인 사원 정보 검색
SELECT * FROM emp WHERE empno = 7369 or empno = 7521 or empno = 7876;
SELECT * FROM emp WHERE empno in(7369, 7521, 7876);

-- 부서번호가 10번이거나 20버인 사원의 인원수
SELECT count(deptno) FROM emp WHERE deptno != 10 and deptno != 20;
SELECT count(deptno) FROM emp WHERE deptno not in(10, 20);

-- 각 부서 평균급여를 검색. 
-- 그룹함수에 적용되지 않은 컬럼이 select절에 나열되면 group by 절뒤에 명시해야 한다.
-- 그룹함수에 적용되는 컬럼은 sal. 근데 부서별로도 구하니까 group by로 해줘야 함.
SELECT deptno, round(AVG(sal)) 평균급여 FROM emp;
SELECT deptno, round(AVG(sal)) 평균급여 FROM emp GROUP BY deptno ORDER BY deptno;
SELECT deptno, sum(sal) 평균급여 FROM emp GROUP BY deptno ORDER BY deptno;

-- 입사년도별 사원의 인원수
SELECT year(hiredate) 입사년도, count(-1) 인원수 FROM emp GROUP BY 입사년도;

-- 부서별 평균급여를 구하는데 20번 부서는 제외하고 구하세요
SELECT deptno, round(AVG(sal)) 
FROM emp 
WHERE deptno not in (20) 
GROUP BY deptno
ORDER BY deptno;

-- 부서별 평균급여가 2000달러 이상인 부서의 부서번호와 평균급여를 구하세요
SELECT deptno, round(AVG(sal)) 
FROM emp 
WHERE AVG(sal)>= 2000 
GROUP BY deptno
ORDER BY deptno;
-- sal열 평균값을 먼저 구하고 group by하니까... 어쨌든 where절에서는 그룹함수 못 쓴다.
-- 그룹하고 나서 걸러라 ==> having절 

-- Having 절 : 그룹함수 쓰고 나서 조건 달 때 사용. group by 뒤에 붙이기
SELECT deptno, round(AVG(sal)) 
FROM emp 
GROUP BY deptno
HAVING AVG(sal)>= 2000 
ORDER BY deptno;

-- 부서별 평균급여가 2000달러 이상인 부서의 부서번호와 평균급여를 구하세요. 단, 10번 부서는 제외하세요
SELECT deptno, round(AVG(sal)) 평균급여
FROM emp 
WHERE deptno not in (10)
GROUP BY deptno
HAVING AVG(sal)>= 2000 
ORDER BY deptno;

-- [문장의 흐름]
-- 1) 문법적 순서 || select, from, where, group by, having, order by
-- 2) 실행 순서 || from, where, group, having, select, order

-- [CRUD]
-- command 형식으로
/*
show databases;
use scott;

테이블 만들기
create table mytable(
id tinyint not null,
name varchar(10),
addr varchar(50),
birthDate date);

정보삽입
insert into mytable (id, name, addr, birthDate) Values(1, '아이유', '서초동', '1989-02-11');
insert into mytable (id, name, addr, birthDate) Values(2, '임영웅', '신사동', curdate());
insert into mytable (id, name, addr, birthDate) Values(3, '장만호', '신사동', curdate());

delete
delete from mytable; 다 지움
delete from mytable where id=3;

update
update mytable set addr='여의도', name='임영장' where id = 2;
*/

-- 실제로 해보기
-- 1. 테이블 생성
create table myTest(
		id tinyint not null,
        name varchar(10),
        addr varchar(50),
        birthDate date);
-- 2. 테이블에 값 입력
insert into myTest (id, name, addr, birthDate) Values(1, 'A', '가동', '1989-02-11');
insert into myTest (id, name, addr, birthDate) Values(2, 'B', '나동', '1995-04-21');
	
select * from myTest;
-- 3. 삭제
DELETE FROM myTest WHERE id = 1;

-- 4. 테이블 컬럼값 수정
UPDATE myTest set name='A', addr='나동' WHERE id = 1;

-- ----------------------------------------------------------------------------------------
create table test01(
	num int auto_increment primary key, -- 기본키가 자동생성되면서 하나씩 증가
    name varchar(10),
    age tinyint,
    height decimal(5,1),
    birthday datetime,
    hiredate date);

desc test01;

-- 데이터 추가
insert into test01 (name, age, height, birthday) values('김준현', 44, 185.4, now());
insert into test01 (name, age, height, birthday) values('이영자', 21, 165.1, now());
insert into test01 (name, age, height, birthday) values('강호동', 21, 186.2, now());

select * from test01;

delete from test01 WHERE num = 4;

update test01 set num=3 WHERE num=6;

-- 컬럼명 변경 : ALTER
alter table test01 change birthdate birthday  date;

-- 컬럼 데이터 타입 변경하기 : ALTER
alter table test01 change birthdate birthdate date;

-- num이 3번인 데이터를 삭제
Delete from test01 where num=3;

-- num이 2번인 데이터의 키와 나이를 수정하기
-- 기본키는 update의 대상이 아니다. 기본키를 제외하나 나머지 컬럼이 수정의 대상이 되어야 한다
update test01 set height = 172.3, age= 39 where num=2;

/* 
[데이터 삭제]
delete from tst01 : 데이터 다 지우기. 테이블 구조 남김. 한 줄씩 지우기. 기존 데이터 이어서 incrument.
truncate table test01 : 데이터 다 지우기. 테이불 구조 남김. 데이터 전체를 들어버리기(빠름). auto_incrument 다시 시작
drop table test01 : 테이블 구조까지 다 날림.

SQL 하위카테고리 2가지
:: structed querry langage
DML(Manupalation 데이터) : insert, update, delete(종류==> truncate)
DDL(Define 구조) : create, drop, alter

*/

-- -----------------------------------------------------------------------------
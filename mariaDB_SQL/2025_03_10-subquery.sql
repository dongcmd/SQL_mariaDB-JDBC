/*
	join 구문 : 여러 개의 테이블을 연결하여 데이터 조회.
		cross join : m * n 개수로 레코드 생성. 사용시 주의
		등가 조인 (equi join) : 조인컬럼을 이용해 조건에 맞는 레코드 선택. 조건문이 '='인 경우
		비등가 조인 (non equi join) : 조인컬럼을 이용해 조건에 맞는 레코드 선택. 조건문이 '='이 아닌 경우
		셀프 조인 (selft join) : 같은 테이블을 join 하는 경우
											테이블의 alias 설정 필수. 컬럼 조회시 alias 호출 필수.
		
		inner join : 조인컬럼을 이용해 조건에 맞는 레코드만 선택
		outer join : 조인컬럼을 이용해 조건에 맞는 레코드만 선택.
							한쪽 또는 양쪽 테이블에서 조건이 맞지 않아도 선택 가능.
							left outer join : left join 예약어
							right outer join : right join 예약어
							full outer join : union 사용해 구현
*/
/*
	subquery : select 구문 내부에 select 구문이 존재.
					where 조건문에서 사용되는 select 구문
	subquery 가능 부분별 호칭
		where 조건문 : subquery 서브쿼리
		from			 : inline view 인라인 뷰
		컬럼부분		: Scalar subquery 스칼라
*/
/*
	단일행 서브쿼리 : 서브쿼리의 결과가 1개 행인 경우
				크기 비교 연산자 사용 가능
	복수행 서브쿼리 : 서브쿼리의 결과가 여러 행인 경우
				사용 가능한 연산자 : in, all, any
*/	
-- emp / 김지애 사원보다 많은 급여를 받는 직원
-- 1. 김지애의 급여 조회
SELECT salary FROM emp WHERE eNAME='김지애'
-- 2. 550보다 많이 받는 직원 조회
SELECT * FROM emp WHERE salary > 550
-- 1, 2 동시에
SELECT * FROM emp WHERE salary > (SELECT salary FROM emp WHERE eNAME='김지애')

-- 김종연 학생보다 윗학년의 이름, 학년, 전공번호, 학과명 출력
SELECT s.NAME, s.grade, s.major1, m.name
FROM student s, major m
WHERE s.grade > (SELECT grade FROM student WHERE NAME = '김종연')
AND s.major1 = m.code;

SELECT s.NAME, s.grade, s.major1, m.name
FROM student s join major m
ON s.major1 = m.code
WHERE s.grade > (SELECT grade FROM student WHERE NAME = '김종연')

-- 사원직급의 평균급여보다 적게 받는 / 사원번호, 이름, 직급, 급여 출력
SELECT e.empno, e.ename, e.job, e.salary
FROM emp e
WHERE e.salary < (SELECT avg(salary) FROM emp WHERE job ='사원');

-- 복수행 서브쿼리
-- emp, dept 테이블 이용, 근무지역 서울인 사원의 / 사원번호, 이름, 부서코드 ,부서명 조회
SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
where e.deptno = d.deptno
 AND e.deptno IN (SELECT deptno FROM dept WHERE loc = '서울')

-- 1학년 학생과 같은 키를 가진 2학년 학생의 / 이름, 키, 학년 조회
SELECT NAME, height, grade
FROM student
WHERE height IN (SELECT height FROM student WHERE grade = 1)
 AND grade = 2;

SELECT s1.NAME, s1.height, s1.grade
FROM student s1, student s2
WHERE s1. height = s2.height AND s2.grade = 1 AND s1.grade = 2;

-- 사원 직급의 최대 급여보다 급여가 높은 직원 // 이름, 직급, 급여
-- > all : 복수 결과 값의 모든 값 보다 큰 경우. 그룹함수 사용
-- < all : 복수 결과 값의 모든 값 보다 작은 경우.
-- > any : 복수 결과 값 중 하나 보다 큰 경우. 그룹함수 사용
-- < any : 복수 결과 값 중 하나 보다 값 보다 작은 경우.

SELECT ename, job, salary
FROM emp
WHERE salary > (SELECT salary FROM emp WHERE job='사원' GROUP BY job);

-- major 테이블에서 컴퓨터정보학부에 소속된 학생의 / 학번, 이름, 학과번호, 학과명 출력
SELECT s.studno, s.name, s.major1, m.name
FROM student s, major m
WHERE s.major1 = m.code
 AND m.part = (SELECT code from major WHERE NAME = '컴퓨터정보학부');
 
SELECT s.studno, s.name, s.major1, m.name
FROM student s join major m
ON s.major1 = m.code
 AND m.part = (SELECT CODE FROM major WHERE NAME = '컴퓨터정보학부');

/*
	다중 컬럼 서브쿼리 : 비교 대상 컬럼이 2개 이상인 경우
*/
-- 학년 별 최대키 가진 학생 / 학년, 이름, 키
SELECT grade, NAME, height, max(height)
FROM student
GROUP BY grade

SELECT grade, NAME, height FROM student WHERE grade = 1
 AND height = (SELECT MAX(height) FROM student WHERE grade = 1)
union
SELECT grade, NAME, height FROM student WHERE grade = 2
 AND height = (SELECT MAX(height) FROM student WHERE grade = 2)
union
SELECT grade, NAME, height FROM student WHERE grade = 3
 AND height = (SELECT MAX(height) FROM student WHERE grade = 3)
union
SELECT grade, NAME, height FROM student WHERE grade = 4
 AND height = (SELECT MAX(height) FROM student WHERE grade = 4)
 
SELECT grade, NAME, height 
FROM student
WHERE (grade, height) IN
 (SELECT grade, MAX(height) FROM student GROUP BY grade);

-- emp 테이블에서 직급별 해당 직급의 최대 급여를 받는 직원 정보 조회 
SELECT *
FROM emp
WHERE (job, salary)
 IN (SELECT job, MAX(salary) FROM emp GROUP BY job)
ORDER BY salary DESC;

-- 학과별 입사일이 가장 오래된 교수의 / 교수번호, 이름, 입사일, 학과명 조회
SELECT p.no, p.name, p.hiredate, m.`name`
FROM professor p, major m
WHERE p.deptno = m.code
 AND (deptno, hiredate)
 IN (SELECT deptno, min(hiredate) 
 	FROM professor p
	   GROUP BY deptno);
	   
SELECT p.no, p.name, p.hiredate, m.`name`
FROM professor p join major m
ON p.deptno = m.code
WHERE (deptno, hiredate)
 IN (SELECT deptno, min(hiredate) 
 	FROM professor p
	   GROUP BY deptno);

/*
	상호 연관 서브쿼리 : 외부 쿼리의 컬럼이 서브쿼리에 영향을 주는 쿼리
					성능이 좋지 않음.
	
*/
-- 직원의 '현재 직급의 평균급여' 이상의 급여를 받는 직원 정보 조회
SELECT *
FROM emp e1
WHERE salary >= (SELECT AVG(salary) FROM emp e2 WHERE e2.job = e1.job);

-- 교수의 '현재 직급의 평균급여' 이상 받는 교수 / 이름, 직급, 급여 조회
SELECT name, `position`, salary
FROM professor p1
WHERE salary >= (SELECT AVG(salary) FROM professor p2 WHERE p1.`position` = p2.position);

-- 사원이름, 직급, 부서코드, 부서명 조회
SELECT e.ename, e.job, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno

SELECT e.ename, e.job, e.deptno, d.dname
FROM emp e JOIN dept d
on e.deptno = d.deptno

-- join 사용하지 않고 조회
-- 컬럼부분에 subquery 사용 > 스칼라 서브쿼리  scalar subquery
SELECT ename, job, deptno,
	(SELECT d.dname FROM dept d WHERE d.deptno = e.deptno) 부서명
FROM emp e

-- '학년별 평균 체중이 가장 적은 학년'의 학년과 평균체중 조회
-- from 구문에 사용되는 subquery = inline 뷰 서브쿼리
-- 			inline view는 반드시 alias가 필요
SELECT * FROM(
	SELECT grade, 	AVG(weight) avg 
	FROM student
	group BY grade
	) a
WHERE AVG = (
	SELECT MIN(AVG)
	FROM (SELECT grade, AVG(weight) avg 
		FROM student
		group BY grade
	) a
)

/*
	DDL : Date Definition Language (데이터 정의어)
			객체의 구조를 생성 create, 수정 alter, 제거drop 하는 명령어
			create : 객체 생성 명령어
				table 생성 : create table
				user 생성 : create user
				index 생성 : create index
				
			alter : 객체 수정 명령어. 컬럼 추가, 컬럼 제거, 컬럼 내용 변경, 컬럼 크기 변경 등
			drop : 객체 제거 명령어
			truncate : 데이터 삭제. 객체와 데이터를 분리.
			
	DDL의 특징 : 트랜잭션 transaction 처리 불가. commit, rollback 관련 명령어 (TCL)
	트랜잭션 transaction : 최소 업무 단위. all or nothing
*/
-- create table
-- no int, name varchar(20), birth datetime 컬럼을 가진 / test1 테이블 생성하기
CREATE TABLE test1 (
	NO INT,
	NAME VARCHAR(20),
	birth datetime
);
-- desc 명령어로 스키마 조회
DESC test1
-- 기본키 : Primary Key. 각각의 레코드를 구분할 수 있는 데이터.
--			ex) 학번, 주민번호
--				기본키의 컬럼값은 중복불가.(unique). null 불가 (not null)
-- no int, name varchar(20), birth datetime 컬럼을 가진 / test2 테이블 생성하기. no를 기본키로
CREATE TABLE test2 (
	NO INT PRIMARY KEY AUTO_INCREMENT, -- 제약조건
	NAME VARCHAR(20),
	birth datetime
);
DESC test2

CREATE TABLE test3 (
	NO INT,
	NAME VARCHAR(20),
	birth DATETIME,
	PRIMARY KEY(NO)
);
DESC test3

-- auto_increment : 자동으로 1씩 증가. 숫자형 기본키에만 사용 가능.
		>> 오라클 사용 불가. (시퀀스 객체를 이용)

INSERT INTO test2 (NAME, birth) VALUES ('홍길동', '1990-01-01');
SELECT * from test2

-- primary key가 여럿일 때
CREATE TABLE test4(
	NO INT,
	seq INT,
	NAME VARCHAR(20),
	PRIMARY KEY(NO, seq)
);
DESC test4
/*		primary key가 여러 컬럼에 설정되어 있는 건, primary key가 2개인 게 아니라, 2개가 1쌍(조합으로 판단)
	no			seq
	1			1	가능
	1			2	가능
	2			1	가능
	2			1	불가능
*/ /*
	default : 값을 입력하지 않을 경우, 기본값
*/
CREATE TABLE test5 (
	NO INT PRIMARY KEY,
	NAME VARCHAR(30) DEFAULT '홍길동'
)
DESC test5

INSERT INTO test5 (NO) VALUES (1)
SELECT * FROM test5

/*
	create table 테이블명 (
		컬럼명1 자료형 [제약조건 : primary key, auto_increament, default],
		컬럼명2 자료형 ...
		primary key(컬럼명1, 컬럼명2) -- 기본키 설정
*/ /*
기존 테이블을 이용해 새로운 테이블 생성하기
*/
-- dept 테이블의 모든 컬럼과 모든 레코드를 가진 depttest1 테이블 생성하기
CREATE table depttest1 AS SELECT * FROM dept
SELECT * FROM depttest1
DESC dept;
DESC depttest1;

-- dept 테이블의 모든 컬럼과 지역이 서울인 레코드만 가진 depttest2 생성하기
CREATE TABLE depttest2 AS SELECT * FROM dept WHERE loc = '서울';
DESC dept;
DESC depttest2;
SELECT * FROM depttest1;
SELECT * FROM depttest2;

-- dept tb에서 deptno, dname 컬럼만가지고 있고, 레코드는 없는 depttest3 tb 생성
CREATE TABLE depttest3 AS SELECT deptno, dname FROM dept WHERE 1 = 2;
DESC depttest3;
SELECT * from depttest3;

-- 교수 tb에서 101학과 교수들만 professor_101 tb 생성 / 교수번호, 이름, 학과코드, 직책, 학과명
CREATE TABLE professor_101
As
SELECT p.NO, p.name, p.deptno, POSITION, m.name mname
FROM professor p, major m
WHERE p.deptno = m.code
 AND p.deptno = 101;


DESC professor_101
SELECT * from professor_101

-- 학생 테이블에서 1학년 학생들만 student1 테이블로 생성하기
-- 학번, 이름, 전공1코드, 학과명
CREATE TABLE student1
AS
SELECT studno, student.NAME, major1, major.`name` 학과명
FROM student JOIN major
ON student.major1 = major.code
WHERE grade = 1;
DESC student1;
SELECT * FROM student1

-- 내가 가진 database에 속한 table들의 목록 조회
SHOW TABLES

CREATE sequence testseq -- 시퀀스 객체 생성

/*
	alter : 테이블 구조 수정
*/
DESC depttest3
-- depttest3 tb에 loc 컬럼 추가
SELECT * from depttest3
ALTER TABLE depttest3 ADD loc VARCHAR(30);

--depttest3 tb에 INT 컬럼 part 추가
ALTER TABLE depttest3 ADD part INT;

-- part 컬럼의 자료형을 int >> int(2)로 변경
ALTER TABLE depttest3 MODIFY part INT(2);

-- loc 컬럼 varchar(100) 크기변경
ALTER TABLE depttest3 MODIFY loc VARCHAR(100);

-- depttest3 tb에서 part 컬럼 제거
ALTER TABLE depttest3 DROP part;

-- depttest3 tb에서 loc 컬럼의 이름을 area로 이름 변경
DESC depttest3
ALTER TABLE depttest3 CHANGE loc AREA VARCHAR(30);
ALTER TABLE depttest3 CHANGE loc loc VARCHAR(100);
/*
	컬럼 관련 수정
	alter table 테이블명 (명령여)
	컬럼 추가			: add 컬럼명 자료형
	컬럼 크기변경 : modify 컬럼명 자료형
	컬럼 제거 		: drop 컬럼명
	컬럼 이름 변경 : change (전)컬럼명 (후)컬럼명 자료형
	 제약조건 { add | drop } constraint 제약조건명
*/
/*
	제약 조건 수정
*/
-- depttest3 tb의 deptno컬럼을 기본키 설정
ALTER TABLE depttest3 ADD CONSTRAINT PRIMARY KEY (deptno);
DESC depttest3

-- professor_101 tb의 no컬럼은 professor tb의 no컬럼을 참조하도록 외래키로 설정
ALTER TABLE professor_101 ADD CONSTRAINT FOREIGN KEY (NO)
REFERENCES professor(NO);

DESC professor_101
SELECT * FROM professor_101
SELECT no FROM professor
SELECT no FROM professor_101
-- professor_101 tb에 교수번호가 2000인 교수 추가
insert INTO professor_101 (NO, NAME, POSITION, mname)
VALUES (5010, '임시', '임시강사', '임시학과');

-- professor_101 tb에 deptno 컬럼은 major tb의 code 컬럼을 참조하도록 외래키 등록
ALTER TABLE professor_101 ADD CONSTRAINT FOREIGN KEY(deptno)
REFERENCES major(CODE);

-- professor_101 tb에 기본키 설정하기. no컬럼
ALTER TABLE professor_101 ADD CONSTRAINT PRIMARY KEY(NO);
DESC professor_101;
-- 하나의 tb에 외래키 Foreign key 여러개 가능
-- 하지만, 기본키는 Primary key 하나만 가능
-- 제약조건(constraint) 조회방법
USE information_schema; -- information_schema database 선택
								-- information_schema의 tb/view를 선택
USE gdjdb;
SELECT * FROM TABLE_CONSTRAINTS -- 제약조건 조회
WHERE TABLE_NAME='professor_101';

-- 제약조건 제거하기
-- 기본키 제거
ALTER TABLE professor_101 DROP PRIMARY KEY

SELECT * FROM professor_101
DESC professor_101

-- 외래키 제거
ALTER TABLE professor_101 DROP FOREIGN KEY professor_101_ibfk_1;
ALTER TABLE professor_101 DROP FOREIGN KEY professor_101_ibfk_2;
ALTER TABLE professor_101 DROP KEY deptno;

SHOW TABLES
DROP TABLE test1
DESC test1

/*
	TRUNCATE : 테이블과 데이터 분리
*/
SELECT * FROM professor_101
-- DELETE 명령문 비교 : AUTOCOMMIT FALSE설정
SET autocommit = FALSE
SHOW VARIABLES LIKE 'autocommit%'
-- delete 명령어로 데이터 제거 : rollback 가능
SELECT * FROM professor_101
DELETE FROM professor_101
ROLLBACK
SELECT * FROM professor_101

-- truncate로 데이터 제거 : rollback 불가능
TRUNCATE table professor_101
SELECT * FROM professor_101
ROLLBACK
SELECT * FROM professor_101

/*
	DML : Data Manipulation Language : 데이터 처리(조작)어
			추가 변경 삭제 조회
		insert : 데이터 추가 C
		update : 데이터 수정 U
		delete : 데이터 삭제 D
		select : 데이터 조회 R
		
		CRUD : Create, Read, Update, Delete
	Transaction 처리 가능 : commit, rollback 가능
*/
/*
	insert : 데이터(레코드) 추가
		insert into 테이블명 [ (컬럼명1, 컬럼명2, ...) ] values (값1, 값2, ...)
		--> 컬럼명 개수와 값의 개수 동일해야 함.
		
		컬럼명 생략시 스키마 순서대로 값을 입력해야 함.
		(컬럼명을 쓰는 걸 권장)
*/
SELECT * FROM depttest1;
-- depttest1 tb에 90번 특판팀 추가
INSERT INTO depttest1 (deptno, dname) VALUES (90, '특판팀');
SELECT * FROM depttest1;
ROLLBACK -- insert 내용 취소
SELECT * FROM depttest1;
-- depttest1 tb에 91번 특판1팀 추가
INSERT INTO depttest1 VALUES (91, '특판1팀'); -- 컬럼명 미기재 시 스키마 순서대로 입력해야 함.
INSERT INTO depttest1 VALUES (91, '특판1팀', NULL);
SELECT * FROM depttest1;
COMMIT; -- transaction 실행완료. commit 이후 rollback은 무의미.
ROLLBACK; SELECT * FROM depttest1;

-- depttest1 tb에 70, 총무부 레코드 추가하기 -- 컬럼명 생략하기
-- depttest1 tb에 80, 인사부 레코드 추가하기 -- 컬럼명 기술하기
INSERT INTO depttest1 VALUES (70, '총무부', NULL);
INSERT INTO depttest1 (deptno, dname) VALUES (80, '인사부');
SELECT * FROM depttest1;
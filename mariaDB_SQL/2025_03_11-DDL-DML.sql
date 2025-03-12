
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

-- 여러 개의 레코드 한번에 추가하기
-- (91, '특판1팀', null), (50, '운용팀', '울산'), (70, '총무부', '울산'), (80, '인사부', '서울')
SELECT * FROM depttest2;
INSERT INTO depttest2 VALUES (91, '특판1팀', NULL),
	(50, '운용팀', '울산'),
	(70, '총무부', '울산'),
	(80, '인사부', '서울');
SELECT * FROM depttest2;

-- 기존의 tb 이용해 데이터 추가하기
SELECT * FROM depttest3;
INSERT INTO depttest3 SELECT * FROM depttest2;
SELECT * FROM depttest3;

-- professor_101 tb에 내용을 추가하기
SELECT * from professor_101;
INSERT INTO professor_101 (NO, NAME, deptno, POSITION, mname)
SELECT p.no, p.name, p.deptno, p.position, m.name
FROM professor p, major m
WHERE p.deptno = m.code
 AND p.deptno=101;
SELECT * from professor_101;
/*
	데이터를 추가할 테이블의 컬럼의 개수와 select을 통해 조회한 컬럼의 개수가 동일해야 함.
*/
INSERT INTO professor_101
SELECT * FROM professor p join major m
on p.deptno = m.code
where p.deptno = 101

-- test3 테이블에 3학년 학생의 정보 젖아하기
SELECT * FROM test3;
DESC test3;
INSERT INTO test3 (NO, NAME, birth)
SELECT studno, NAME, birthday
FROM student
WHERE grade = 3;
SELECT * FROM test3;
/*
	update : 데이터 변경
	update 테이블명 set 컬럼명1 = 값, 컬럼명2 = 값, ...
	[where 조건문] --> 없으면 모든 레코드값 변경 / 있으면 참인 결과만 변경
*/
SELECT * FROM EMP WHERE JOB='사원'
UPDATE emp SET bonus  = ifnull(bonus, 0) + 10
WHERE job = '사원';

-- '이상미 교수와 같은 직급의 교수' 중 급여가 350 미만인 교수의 급여 10% 인상
SELECT * FROM professor
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '이상미')
 AND salary < 350;

UPDATE professor SET salary = salary * 1.1
WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '이상미')
 AND salary < 350;

-- bonus가 없는 시간강사의 보너스를 '조교수의 평균 보너스의 50%'로 변경
SELECT * FROM professor
WHERE POSITION = '시간강사' AND bonus IS NULL;

SELECT AVG(bonus)/2 FROM professor
WHERE POSITION = '조교수';

UPDATE professor SET bonus =
	(SELECT AVG(bonus)/2 FROM professor
	WHERE POSITION = '조교수')
WHERE POSITION = '시간강사' AND bonus IS NULL;

SELECT * FROM professor
WHERE POSITION = '시간강사';

-- 지도교수가 없는 학생의 지도교수를 이용학생의 지도교수로 변경하기
SELECT profno FROM student WHERE NAME = '이용';
SELECT * FROM student WHERE profno IS NULL;

UPDATE student SET profno =
	(SELECT profno FROM student
	 WHERE NAME = '이용')
where profno IS NULL;
SELECT * FROM student WHERE grade = 1;
ROLLBACK

-- 교수 중 김옥남교수와 같은 직급의 교수의 급여를 101 학과의 평균으로 변경하기 / 소수점 이하 반올림해 정수로 저장
SELECT * FROM professor
WHERE POSITION = 
	(SELECT POSITION FROM professor WHERE NAME = '김옥남');

SELECT round(AVG(salary)) FROM professor WHERE deptno = 101;

UPDATE professor SET salary = 
	(SELECT round(AVG(salary)) FROM professor
	WHERE deptno = 101)
WHERE POSITION = 
	(SELECT POSITION FROM professor WHERE NAME = '김옥남');
ROLLBACK
/*
	delete 레코드 삭제
	
	delete from 레코드명
	[where ...]
*/
SELECT * FROM depttest1;
-- depttest1 모든 레코드 삭제하기
DELETE FROM depttest1;

SELECT * FROM depttest2;
-- depttest2 tb에서 기획부 삭제하기
DELETE FROM depttest2 WHERE dname = '기획부';
SELECT * FROM depttest2;

-- depttest2 tb에서 부서명에 '기' 문자가 있는 부서 삭제하기
DELETE FROM depttest2 WHERE dname LIKE '%기%';

-- 교수 중 김옥남 교수와 같은 보수의 교수정보 제거
SELECT * FROM PROfessor WHERE deptno = (SELECT deptno FROM professor WHERE NAME = '김옥남');
DELETE FROM professor WHERE deptno = (SELECT deptno FROM professor WHERE NAME = '김옥남');
ROLLBACK

DROP TABLE test2 -- DDL 수행 > autocommit > rollback 무의미

/*
	SQL의 종류 (Structured Query Language 구조적 쿼리 언어)
		DDL : Date Definition Language 데이터 정의어
			Create, Alter, Drop, Truncate
			Transaction 처리 불가. (rollback 무의미, autocommit)
			
		DML : Data Manipulation Language 데이터 조작어(처리어)
			Insert, Select, Update, Delete  (CRUD : Create, Read, Update, Delete)
			Transaction 처리 가능. (rollback, commit 됨)

		TCL : Trnasaction Control Language 트랜잭션 제어어
			Commit, Rollback
		
		DCL : Data Control Language 데이터 제어어 --> DB관리자의 언어
			grant : 사용자에게 db 권한 부여
			revoke : 부여한 db 권한 회수
*/
/*
	View : 가상 테이블 (Virtual Table)
				물리적으로 메모리 할당 없음. 테이블처럼 join, subquery 가능.
*/
-- 2학년 학생의 학번, 이름, 키, 몸무게 가진 뷰 v_stu2 생성
CREATE OR REPLACE VIEW v_stu2
AS SELECT studno, NAME, height, weight FROM student WHERE grade = 2;

-- 232001, 홍길동, 2, 160, 60, hongkd 학생테이블 추가
-- 242001, 김길동, 2, 165, 65 kimsk 학생테이블 추가
INSERT INTO student (studno, NAME, grade, height, weight, id, jumin) 
	VALUES (232001, '홍길동', 2, 160, 60, 'hongkd', 12345), (242001, '김삿갓', 2, 165, 65, 'kimsk', 67890);

SELECT * FROM v_stu2;
USE information_schema;
select view_definition FROM views
WHERE TABLE_NAME="v_stu2";

select `gdjdb`.`student`.`studno` AS `studno`,
`gdjdb`.`student`.`name` AS `NAME`,
`gdjdb`.`student`.`height` AS `height`,
`gdjdb`.`student`.`weight` AS `weight` 
 from `gdjdb`.`student`
  where `gdjdb`.`student`.`grade` = 2

CREATE OR REPLACE VIEW v_stu2
AS SELECT studno, NAME, height, weight FROM student WHERE grade = 2;

-- 2학년 학생의 학번, 이름, 국, 영, 수 값을 가지는 v_score2 뷰 생성
CREATE OR REPLACE VIEW v_score2
AS SELECT s.studno, NAME, kor, eng, math
 FROM student s  JOIN score sc
  ON s.studno = sc.studno
 WHERE grade = 2;
-- create or replace : table은 불가.
SELECT * FROM v_score2;
-- v_stu2, v_score2 뷰를 이용해 학번, 이름, 점수들, 키 ,몸 조회
SELECT v2.*, v1.height, v1.weight
FROM v_stu2 v1, v_score2 v2
WHERE v1.studno = v2.studno;

-- v_score2 V와 student TB을 이용해 학번, 이름, 점수들, 학년, 지도교수번호 출력

SELECT v.*, s.grade, s.profno
FROM v_score2 v join student s
ON v.studno = s.studno;

-- v_score2 V와 student TB, professor TB을 이용해
-- 학번, 이름, 점수들, 학년, 지도교수번호, 지도교수명  출력
SELECT v.*, s.grade, s.profno, p.name
FROM v_score2 v join student s
ON v.studno = s.studno left JOIN professor p
ON s.profno = p.no;

SELECT v.*, s.grade, s.profno, p.name
FROM v_score2 v, student s, professor p
where v.studno = s.studno and s.profno = p.no;

DROP VIEW v_stu2
SELECT * FROM v_stu2;
/*
	inline view : 뷰의 이름 없고, 일회성으로 사용되는 뷰
						select 구문의 from 절에 사용되는 subquery
						alias 설정 필수.
*/
-- 학생의 학번, 이름, 학년, 키, 몸, 학년의 평균 키, 학년의 평균 몸무게 조회
SELECT s1.studno, s1.NAME, s1.grade, s1.height, s1.weight, AVG(s2.height), AVG(s2.weight)
FROM student s1, student s2
WHERE s1.grade = s2.grade
GROUP BY s1.studno

SELECT s1.studno, s1.NAME, s1.grade, s1.height, s1.weight, 
	(SELECT AVG(height) FROM student s2 WHERE s1.grade = s2.grade) 평균키,
	(SELECT AVG(weight) FROM student s2 WHERE s1.grade = s2.grade) 평균몸
FROM student s1

SELECT s1.studno, s1.NAME, s1.grade, s1.height, s1.weight, avg_h 평키, avg_w 평몸
FROM student s1,
	(SELECT grade, AVG(height) avg_h,
	 AVG(weight) avg_w
	 FROM student GROUP BY grade) sq
WHERE s1.grade = sq.grade;

-- emp TB에서 사원번호, 사원명, 직급, 부서코드, 부서명, 부서별 평급, 부서별 평보 (보없0)
SELECT e1.empno, e1.ename, e1.job, e1.deptno, d.dname, 평급, 평보
FROM emp e1 JOIN dept d
on e1.deptno = d.deptno JOIN (
	SELECT deptno, AVG(salary) 평급, AVG(IFNULL(bonus, 0)) 평보
	FROM emp GROUP BY deptno) 부서별정보
ON e1.deptno = 부서별정보.deptno

SELECT e1.empno, e1.ename, e1.job, e1.deptno, d.dname, 평급, 평보
FROM emp e1, dept d, (
	SELECT deptno, AVG(salary) 평급, AVG(IFNULL(bonus, 0)) 평보
	FROM emp GROUP BY deptno) 부서별정보
where e1.deptno = d.deptno
 and e1.deptno = 부서별정보.deptno

/*
	사용자 관리
*/
-- DB 생성
CREATE DATABASE mariadb;
-- db 목록 조회
SHOW DATABASES;
-- TB 목록 조회
SHOW TABLES FROM gdjdb;

-- 사용자 생성
mariadbUSE mariadb;
CREATE USER test1;
-- 비번 설정
SET PASSWORD FOR 'test1' = PASSWORD('pass1');
-- 권한 부여
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, CREATE view
ON mariadb.* TO 'test1'@'%';

grant select,insert,update,delete,create,drop,create VIEW
on mariadb.* to 'test1'@'%'
GRANT ALTER ON mariadb.* TO 'test1'@'%';

-- 권한 조회
SELECT * FROM USER_PRIVILEGES WHERE grantee LIKE '%test1%';

-- 권한 회수 : revoke
REVOKE ALL PRIVILEGES ON mariadb.* FROM test1@'%';

-- test1 사용자 삭제하기
DROP USER 'test1'@'%';

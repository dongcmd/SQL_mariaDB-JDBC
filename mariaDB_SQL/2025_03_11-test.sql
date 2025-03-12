-- 1. 테이블 test11를 생성하기. 
--    컬럼은 정수형인 no 가 기본키로 
--    name 문자형 20자리
--    tel 문자형 20 자리
--   addr 문자형 100자리로 기본값을 서울시 금천구로 설정하기
CREATE TABLE test11 (
	NO INT PRIMARY KEY,
	NAME VARCHAR(20),
	tel VARCHAR(20),
	addr VARCHAR(200) DEFAULT '금천구'
);
DESC test11

-- 2. 교수 테이블로 부터 103 학과 교수들의 
-- 번호, 이름, 학과코드, 급여, 보너스, 직급만을 컬럼으로
-- 가지는 professor_103 테이블을 생성하기 102 데이터 다 날라감
CREATE TABLE professor_103
AS SELECT NO, NAME, deptno, salary, bonus, POSITION FROM professor WHERE deptno = 103;
gdjdbSELECT * FROM professor_102;
SELECT * FROM professor;

-- 3. 사원테이블에서 사원번호 3001, 이름:홍길동, 직책:사외이사
-- 급여:100,부서:10 입사일:2025년04월01일 인 레코드 추가하기
INSERT emp (empno, ename, job, salary, deptno, hiredate) VALUES (3001, '홍길동', '사외이사', 100, 10, '2025-04-01');
SELECT * FROM emp;

-- 4. 교수 테이블에서 이상미교수와 같은 직급의 교수를 퇴직시키기
DELETE from professor WHERE POSITION = (SELECT POSITION FROM professor WHERE NAME = '이상미');
SELECT * FROM professor

-- 5.교수번호,교수이름,직급, 학과코드,학과명 컬럼을 가진 테이블 professor_201을 생성하여
-- 	201학과에 속한 교수들의 정보를 저장하기
CREATE table professor_201
AS SELECT p.no, p.NAME 교수명, p.POSITION, p.deptno, m.name 학과명
FROM professor p, major m WHERE p.deptno = 201 GROUP BY p.no;
SELECT * FROM professor_201;

-- 6. 사원테이블에 사원번호:3001, 이름:홍길동, 직책:사외이사, 
--   급여:100, 부서:10, 입사일:오늘인 레코드 등록하기 -> 컬럼명 지정
SELECT * FROM emp;
insert emp (empno, ename, job, salary, deptno, hiredate) VALUES (3001, '홍길동', '사외이사', 100, 10, CURDATE());

-- 7. 사원테이블에 사원번호:3002, 이름:홍길동, 직책:사외이사, 
--   급여:100, 부서:10, 입사일:오늘인 레코드 등록하기 -> 컬럼명 지정안함
INSERT emp VALUES (3002, '홍길동', '사외이사', NULL, NULL, CURRENT_DATE, 100, NULL, 10);

-- 8. student 테이블과 같은 컬럼을 가진 테이블 stud_male 테이블 생성하기.
--     student 데이터 중 남학생 정보만 stud_male 테이블에 저장하기
--    성별은 주민번호를 기준으로 한다.
CREATE TABLE stud_male
AS SELECT * FROM student WHERE SUBSTR(jumin, 7, 1) not IN (1, 3);
SELECT * FROM stud_male;

-- 9.  2학년 학생의 학번,이름, 국어,영어,수학 값을 가지는 score2 테이블 생성하기
CREATE TABLE score2
AS SELECT s.studno, s.name, sc.kor, sc.eng, sc.math FROM student s, score sc WHERE s.studno = sc.studno AND grade = 2;
SELECT * FROM score2;

-- 10. 김유태 교수와 같은 조건으로 오늘 입사한 이몽룡 교수 추가하기
--    교수번호 : 6003,이름:이몽룡,입사일:오늘,id:monglee
--    나머지 부분은 김유태 교수 정보와 같다.
CREATE table kyt3 AS SELECT * FROM professor WHERE NAME = '김유태';
INSERT professor VALUES (
	6003, '이몽룡', 'monglee', 
	(select POSITION from kyt2), 
	(select salary from kyt2), 
	CURDATE(), (select bonus from kyt2), 
	(select deptno from kyt2), (select email from kyt2),
	 (select url from kyt2));


-- 11. major 테이블에서 code값이 200 이상인 데이터만 major2에 데이터 추가하기
SELECT * FROM major;
SELECT * FROM major2;
CREATE TABLE major2 AS SELECT * FROM major WHERE CODE >= 200;

-- 12.  major2 테이블에 공과대학에 속한 학과 정보만 추가하기
TRUNCATE TABLE major2
INSERT into major2 SELECT * FROM major WHERE part in (SELECT CODE FROM major WHERE NAME = '공과대학')
 OR part in (
 	SELECT CODE FROM major WHERE part = (
	 	SELECT CODE FROM major WHERE NAME = '공과대학'));

-- 13. '이영국 직원과 같은 직급의 직원의 급여'는 
--    '박진택 직원의 같은 부서의 평균급여의 80%'로 변경하고, 보너스는 현재 보너스보다 15%를 인상하여 변경하기
-- 김경선, 이영국 650 -> 560 // 200 > 230
UPDATE emp
SET salary = (
			SELECT AVG(salary) * 0.8 FROM emp 
			WHERE deptno = (
				SELECT deptno FROM emp
				 WHERE ename = '박진택')),
	bonus = bonus * 1.15
WHERE job = (SELECT job FROM emp WHERE eNAME = '이영국');

SELECT ename, salary, bonus FROM emp WHERE job = (SELECT job FROM emp WHERE eNAME = '이영국');
SELECT AVG(salary) *0.8 FROM emp WHERE deptno = (SELECT deptno FROM emp WHERE ename = '박진택');

SELECT * FROM emp

-- 14. student 테이블과 같은 컬럼과, 학생 중 남학생의 정보만을 가지는  v_stud_male 뷰 생성하기.
--    성별은 주민번호를 기준으로 한다.
CREATE OR REPLACE VIEW v_stud_male
AS SELECT * FROM student WHERE SUBSTR(jumin, 7, 1) IN (1, 3);
SELECT * FROM v_stud_male;

-- 15.  교수번호,이름,부서코드,부서명,자기부서의 평균급여, 평균보너스 조회하기
--       보너스가 없으면 0으로 처리한다.
SELECT p.no, p.name, p.deptno, m.name, (SELECT AVG(salary) FROM professor p2 WHERE p.deptno = p2.deptno) 평급,
	(SELECT AVG(IFNULL(bonus, 0)) FROM professor p3 WHERE p.deptno = p3.deptno) 평보
FROM professor p, major m
WHERE p.deptno = m.code;
SELECT * FROM professor;
SELECT * FROM dept;

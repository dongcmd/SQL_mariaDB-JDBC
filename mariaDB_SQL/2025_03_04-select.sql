-- desc : 테이블의 구조(스키마) 조회
-- desc 테이블명
DESC dept;

-- SQL : Structured Query Language (구조적 커리 언어)는
-- 		RDB(Relational DB)에서 데이터 처리를 위한 언어
-- select :  데이터 조회를 위한 언어
-- emp 테이블의 모든 데이터를 조회하기
SELECT * FROM emp;
-- emp 테이블의 empno, ename, deptno 컬럼의 모든 레코드 조회
SELECT empno, ename, deptno FROM emp;

-- 리터널 컬럼 사용하기 : 상수값을 하기
-- 학생(student)의 이름 뒤에 '학생' 문자열 붙이기

SELECT NAME, '학생'
FROM student;
/*
 1. 교수테이블(professor)의 구조를 조회
*/
DESC professor;
/*
 2. 교수테이블(professor)에서 교수번호(no), 교수이름(name), 뒤에 '교수' 문자열 붙여서 조회
*/
/*
	문자열형 상수 : '', "" 동일.
	단 오라클db에선 ''만 사용가능.
*/
SELECT NO, NAME, '교수' FROM professor;
SELECT NO, NAME, "교수" FROM professor;

-- 컬럼명을 별명(alias) 설정 : 조회되는 컬러명 변경하기
SELECT NO 교수번호, NAME '교수이름', '교수' FROM professor;
SELECT NO '교수 번호', NAME '교수 이름', '교수' FROM professor;
SELECT NO as'교수 번호', NAME as'교수 이름', '교수' FROM professor;

-- 컬럼에 연산자(+, -, *, /) 사용 가능
-- emp테이블에서 사원이름(ename), 현재급여(salary), 10%인상 예상급여 조회

SELECT ename '사원이름', salary '현재급여', salary*1.1 FROM emp;

-- distinct : 중복을 제외하고 하나만 조회
--					컬럼의 처음에 한번만 구현해야 함
-- 교수(professor)테이블에서 교수가 속한 부서코드(deptno) 조회
SELECT distinct deptno FROM professor;
-- 교수(professor)테이블에서 교수가 속한 직급(position) 조회
SELECT DISTINCT position FROM professor;
-- 교수(professor)테이블에서 부서별 교수가 속한 직급(position) 조회하기
-- 여러개의 컬럼 앞의 distinch는 기술된 컬럼의 값들이 중복되지 않도록 조회
SELECT DISTINCT deptno, DISTINCT POSITION FROM professor; -- 오류
SELECT DISTINCT deptno, POSITION FROM professor;
/*
	select 컬럼명(컬럼, 리터널컬럼, 연산된컬럼, *, 별명, distinct)
	from 테이블명
	where 레코드 선택 조건.
			조건문 X 경우  : 모든 레코드를 조회
			조건문 O 경우 : 조건문 결과가 참인 레코드만 조회
*/
-- 학생테이블(student)에서 1학년 학생의 모든 컬럼을 조회
SELECT * FROM student WHERE grade = 1;
-- 학생테이블(student)에서 3학년 학생 중 전공1코드(major1)가 101인 학생의
-- 학번(studno), 이름(name), 학년(grade), 전공1학과(major1) 컬럼 조회하기
-- 논리연산 : and, or
SELECT studno, NAME, grade, major1 FROM student
WHERE grade = 3 AND major1 = 101;

-- 학생테이블(student)에서 3학년 학생 이거나 전공1코드(major1)가 101인 학생의
-- 학번(studno), 이름(name), 학년(grade), 전공1학과(major1) 컬럼 조회하기
SELECT studno, NAME, grade, major1 FROM student
WHERE grade = 3 OR major1 = 101;
/*
 문제
*/
SELECT ename, salary, deptno FROM emp WHERE deptno = 10;

SELECT ename, salary FROM emp WHERE salary > 800;

SELECT NAME, deptno, POSITION FROM professor WHERE POSITION = '정교수';

-- where 조건문에 연산처리하기
-- emp테이블에서 모든 사원의 급여를 10% 인상할 때, 인상 예정 급여가 1000이상인
-- 사원의 이름, 현재급여, 인상예정급여, 부서코드 조회하기
SELECT ename, salary, salary * 1.1, deptno FROM emp WHERE salary * 1.1 >= 1000;

--- where 조건문에서 사용되는 연산자 ---
-- between : 범위 지정 연산자
-- where 컬럼명 between A and B : A <= 컬럼명 <= B 레코드 선택
-- 학생 중 1,2 학생의 모든 컬럼을 조회하기
SELECT * FROM student WHERE grade = 1 OR grade = 2;
SELECT * FROM student WHERE grade >= 1 AND grade <= 2;
SELECT * FROM student WHERE grade BETWEEN 1 AND 2;

-- 문제
-- 1학년 학생 중 몸무게(weight)가 70이상 80이하인 학생의
-- 이름name, 학년grade, 몸무게weight, 전공1학과major1 조회
SELECT NAME, grade, weight, major1 from student WHERE grade = 1 and weight BETWEEN 70 AND 80;

-- 제1 전공학과가 101번 학생 중 몸무게가 50이상 80이하인 학생의
-- 이름(name), 몸무게(weight), 1전공학과코드(major1)를 출력하기
SELECT NAME, weight, major1 FROM student WHERE major1 = 101 AND weight BETWEEN 50 AND 80;
/*
	where 조건문의 연산자 : in
									or 조건문으로 표현
*/
-- 전공1학과가 101, 201학과에 속한 학생의 모든 정보 조회
SELECT * FROM student WHERE major1 = 101 OR major1 = 201 OR major1 = 301;
SELECT * FROM student WHERE major1 IN (101, 201);

SELECT NO, NAME, deptno, hiredate FROM professor WHERE deptno IN(101, 201);
SELECT studno, NAME, weight, height, major1
FROM student WHERE major1 NOT in(101, 201) AND height >= 170;

/*
	like 연산자 : 일부분 일치
	 % : 0개 이상 임의의 문자
	 _ : 1개의 임의의 문자
*/
-- 김씨인 학생의 학번 studno, 이름 name, 학과코드1 major1 조회
SELECT studno, NAME, major1 FROM student WHERE NAME LIKE '김%';

-- '진'이란 이름을 가진 
SELECT studno, NAME, major1 FROM student WHERE NAME LIKE '%진%';

-- 이름이 2자인 학생의 학번, 이름, 학과코드1 조회하기
SELECT studno, NAME, major1 FROM student WHERE NAME LIKE '__';
/*
문제
	1. 이름의 끝자가 '훈'인 학생의 학번, 이름, 전공코드1
	2. 전화번호tel가 서울02인 학생 ㅣㅇ름, 학번, 전번 출력
*/
SELECT studno, NAME, major1 FROM student WHERE NAME LIKE '%훈';
SELECT NAME, studno, tel FROM student WHERE tel LIKE '02%';

-- 교수테이블에서 id내용의 k 문자를 가지고 있는 교수의
-- name, id, position
SELECT NAME, id, POSITION FROM professor WHERE id LIKE '%K%';
-- 대소문자 구분을 위해서는 binary 예약어를 사용
SELECT NAME, id, POSITION FROM professor WHERE id LIKE binary '%k%';

-- not like 연산자 : like 반대
-- 이 씨 성이 아닌 학생의 학번 이름 전공코드1 조회
SELECT studno, NAME, major1 FROM student WHERE name NOT LIKE '이%';

/*
 1. 성이 김씨가 아닌 학생의 이름, 학년, 전공1학과 조회
 2. 교수 테이블에서 101, 201 학과에 속한 교수가 아닌 교수 중
 	 김씨가 아닌 교수의 이름, 학과코드, 직급 조회
*/
SELECT NAME, grade, major1 FROM student WHERE name NOT LIKE '김%';
SELECT NAME, deptno, POSITION FROM professor
WHERE deptno NOT IN(101, 201) AND name NOT LIKE '김%';
/*
	null 의미 : 값이 없다. 비교 대상이 될 수 없음.
	is null		: 컬럼의 값이 null인 경우
	is not null : 컬럼의 값이 null이 아닌 경우
*/
-- 보너스가 없는 교수의 이름, 급여 보너스 조회
SELECT NAME, salary, bonus FROM professor where bonus IS NULL
-- 보너스가 있는 교수의 이름, 급여 보너스 조회
SELECT NAME, salary, bonus FROM professor where bonus IS not NULL
/*
 지도교수가 없는 학생의 학번 이름 전공학과1 지도교수번호profno 조회
*/
SELECT studno, NAME, major1, profno FROM student WHERE profno IS NULL;

-- 교수의 교수번호no 이름name 현재급여salary 상여금bonus 통상입금salary+bonus

SELECT NAME, NO, salary, bonus, salary+bonus FROM professor;
/*
	null은 비교, 연산의 대상이 아님
	null이랑 연산의 결과는 null
*/
-- 보너스가 있는 교수의 [이름 급여 보너스 연봉] 조회
SELECT NAME, salary, bonus, (salary*12+bonus) FROM professor WHERE bonus IS NOT NULL
-- 보너스 없는 교수 [이름 급여 연봉] 조회
SELECT NAME, salary, salary*12, bonus FROM professor WHERE bonus IS NULL
/*
	실행순서 3 : select *(모든컬럼) || 컬럼명1, 컬럼명2 별명,  ...
	실행순서 1 : from 테이블명
	실행순서 2 : [where 조건문]
						조건문이 생략되면 모든 레코드 선택
						조건문이 있다면, 결과가 참인 레코드만 선택
	실행순서 4 : [order by 컬럼명 || 조회된 컬럼순서 || 별명 [asc / desc]]
																			select 문장의 마지막에 작성
	order by : 정렬관련 구문
		오름차순 : asc 예약어. 기본값(생략가능)
		내림차순 : desc 예악어. 생략 불가
*/
-- 1학년 학생의 이름, 키 조회. 키가 큰 순 출력
-- (1) 컬럼명으로 정렬
SELECT NAME, height FROM student WHERE grade = 1 ORDER BY height DESC
-- (2) 조회된 컬럼 순서로 정렬 name(1), height(2)
SELECT NAME, height FROM student WHERE grade = 1 ORDER BY 2 DESC
-- (3) 별명으로 정렬
SELECT NAME 이름, height 키 FROM student WHERE grade = 1 ORDER BY 키 ASC

-- 학생 [이름 학년 키] 조회. 학년순 중 키가 큰 순으로
SELECT NAME, grade, height FROM student ORDER BY grade ASC, height DESC
SELECT NAME, grade, height FROM student ORDER BY 2, 3 DESC
-- 컬럼의 순서, 별명으로 ㅈ어렬시 반드시 해당 컬럼이 조회되어야 함.
-- 컬럼명으로 정렬시 조회된 컬럼이 아니어도 가능.
SELECT NAME FROM student WHERE grade = 1 ORDER BY height DESC
/*
	문제 1 professor[no, name, deptno, salary, salary*1.1] 출력. 학과코드 순, 예상급여 역순 조회
	문제 2 student[studno, name, profno, major1] profno값이 null인 학생 학과코드 순으로 조회
	문제 3 student[name, height, weight] 1학년 학생만, 키는 작은 순, 몸무게는 큰 순 조회
*/
SELECT NO, NAME, deptno, salary, salary * 1.1 FROM professor ORDER BY deptno ASC, salary*1.1 DESC
SELECT studno, NAME, profno, major1 FROM student WHERE profno IS NULL ORDER BY 4
SELECT NAME, height 키, weight 무게 FROM student WHERE grade = 1 ORDER BY 키, 무게 desc
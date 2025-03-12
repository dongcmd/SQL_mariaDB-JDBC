/*
	desc : 테이블의 구조(스키마)
	
	select * | 컬럼명들
	from 테이블명
	[where 조건문] => 구현이 안 된 경우 : 모든 행 선택
							구현이 된 경우 	: 조건문의 결과가 참인 레코드만 선택
							
	컬럼 부분
	 * : 모든 컬럼
	 컬럼명 목록 : 구현 컬럼만 조회
	 컬럼에 리터널 컬럼 : 상수 컬럼
	 컬럼에 연산자 사용 가능 : + - * /
	 별명(alias) 사용 가능
	 distinct : 중복 없이 조회. 컬럼명 앞에 한 번만 사용 가능
	 
	where 조건문에서 사용되는 연산자
		관계 연산자 : =, >, <, >=, <=, <> (!=)
		논리 연산자 : and, or
		between : 컬럼명 between A and B  → A <= 컬럼명 <= B 
		in		: 컬럼명 in (A, B, ...) → 컬럼의 값이 A or B or ... 인 경우
		like : 부분적으로 일치하는 문자열 ㅏㅊㅈ기
			% : 0개 이상의 임의문자
			_ : 1개의 임의문자
			binary : 대소문자 구분. MariaDB에서만 사용
		is null : null과 연산, 비교 불가(결과값 null)
		not : 위의 연산자의 반대를 뜻함 ex) not null, not in 등
		
	order by : 정렬. select 구문의 마지막에 기술되어야 함.
		asc : 오름차순(기본값, 생략가능)
		desc : 내림차순
	order by 컬럼1, 컬럼2 → 컬럼1 정렬 후, 컬럼2로 2차정렬렬
		컬럼명, 컬렴의 순서, 컬렴의 별명으로 기입 가능 ★컬럼명으로 사용 권장★
*/
-- 집합 연산자
-- 교수 테이블에서 name, deptno, salary, 연봉 조회하기
-- 보너스가 있는 경우 : 급여 * 12 + 보너스
-- 보너스가 없는 경우 : 급여 * 12
/*
	합집합 : union, union all
	union : 합집합.
	union all : 두 쿼리 문장의 결과를 합해 출력. 중복 제거 안됨
	두 개의 select문의 조회되는 컬럼에 갯수가 같아야 한다.
	첫 번째 select문의 
*/

SELECT NAME, deptno, salary, bonus, salary*12+bonus FROM professor
WHERE bonus IS NOT NULL
union
SELECT NAME, deptno, salary, bonus, salary*12 FROM professor
WHERE bonus IS NULL

-- 전공1학과가 202학과이거나, 전공2학과가 101학과인 학생의
-- studno, name, major1, major2 조회
SELECT studno, NAME, major1, major2 FROM student
WHERE major1 = 202 OR major2 = 101;
SELECT studno, NAME, major1, major2 FROM student
WHERE major1 = 202
UNION 
SELECT studno, NAME, '', major2 FROM student
WHERE major2 = 101;
/*
	교수 중 급여가 450 이상인 경우, 5% 인상예정
	급여가 450 미만인 경우, 10% 인상예정
	no, name, salary, 인상예정급여 조회
	인상예정급여가 큰 순으로 조회
*/
SELECT NO, NAME, salary, salary*1.05 인상예정급여 FROM professor
WHERE salary >= 450
UNION
SELECT NO, NAME, salary, salary*1.1 FROM professor
WHERE NOT salary >= 450 ORDER BY 4 DESC
/*
	교집합 : intersect
				and 조건 연산자를 이용하는 경우가 많음
*/
-- 김씨인 학생 중 이름이 '훈'으로 끝나는 학생의
-- name, major1 조회
SELECT NAME, major1 FROM student WHERE NAME LIKE '김%훈'
SELECT NAME, major1 FROM student WHERE NAME LIKE '김%'
INTERSECT
SELECT NAME, major1 FROM student WHERE NAME LIKE '%훈'
/*
	전공1학과가 202이고 전공2학과가 101인 학생의
	studno, name, major1, major2 조회
*/
SELECT studno, NAME, major1, major2 FROM student WHERE major1 = 202 and major2 = 101
SELECT studno, NAME, major1, major2 FROM student WHERE major1 = 202
INTERSECT
SELECT studno, NAME, major1, major2 FROM student WHERE major2 = 101
/*
	함수
		단일행 함수 : 하나의 레코드에서만 사용되는 함수
 		그룹 함수 : 다수의 행에 관련된 기능을 처리하는 함수
 							group by, having 구문과 관련있는 함수
*/
-- 문자 관련 단일행 함수
-- 대소문자 변환 함수, upper(), lower()
-- 전공1학과가 101인 학생의 name, id, 대문자id, 소문자id 출력
SELECT NAME, id, UPPER(id), LOWER(id) FROM student
WHERE major1 = 101

-- 문자열 길이 함수 : length(), char_length()
-- length() : 저장된 바이트 수. 오라클(lengthb)
-- char_length() : 문자열의 길이. 오라클(length)
-- 학생의 이름, 아이디, 이름글자수, 이름 바이트수, id글자수, id바이트 수 조회
SELECT NAME, id, CHAR_length(NAME), LENGTH(NAME), CHAR_length(id), LENGTH(id) FROM student
/*
	영문자, 숫자의 경우 : 바이트 수와 문자열의 길이가 같음
	한글의 경우 :  문자열 길이 * 3 = 바이트 수 길이 (UTF-8 기준)
			한글을 저장하는 컬럼의 경우, VARCHAR자료형의 크기는 글자수 *3 만큼 설정해야 함.
*/
SELECT LENGTH('가나다라마바사아'), LENGTH('1234567890'), LENGTH('ABCDEFGHI')

-- 문자열 연결 함수 : CONCAT
-- 교수의 이름과 직급을 연결하여 조회하기
SELECT CONCAT(NAME, ' ', POSITION, '님') 교수명 FROM professor
-- 학생 정보를 [이름 0학년 000cm 00kg] 출력하기

SELECT grade, NAME, CONCAT(NAME, ' ', grade, '학년 ', height, 'cm ', weight, 'kg') 학생정보 FROM student
WHERE CHAR_LENGTH(NAME) = 3
UNION
SELECT grade, name, CONCAT(' ', NAME, ' ', grade, '학년 ', height, 'cm ', weight, 'kg') FROM student
WHERE CHAR_LENGTH(NAME) = 2 
ORDER BY grade, NAME

-- 부분 문자열 : substr
-- substr(컬럼명/문자열, 시작 인덱스, 글자 수)
-- substr(컬럼명/문자열, 시작 인덱스) : 시작 인덱스부터 문자열 끝까지
-- left	(컬럼명/문자열, 글자수) : 왼쪽부터 글자 수만큼 부분 문자열로 리턴
-- right (컬럼명/문자열, 글자수) : 오른쪽부터 글자 수만큼 부분 문자열로 리턴
-- 학생의 이름 2자만 조회
SELECT NAME, SUBSTR(NAME, 1, 2), SUBSTR(NAME, 2), LEFT(NAME, 2), RIGHT(NAME, 2) FROM student

-- 학생의 이름, 주민번호 기준 생일 출력
SELECT NAME, jumin, substr(jumin, 1, 6), LEFT(jumin, 6) FROM student

-- 생일이 3월인 학생의 이름, 생년월일 조회 (생일은 주민번호 기준)
SELECT NAME, left(jumin, 6) 생년월일 FROM student WHERE SUBSTR(jumin, 3, 2) = '03'

-- 이름, 학년, 생년월일 조회 (주민기준, 형식 00년 00월 00일) 월 기준으로 정렬
SELECT NAME, grade,
	CONCAT(SUBSTR(jumin, 1, 2), '년 ', SUBSTR(jumin, 3, 2) , '월 ', SUBSTR(jumin, 5, 2), '일') 생년월일
FROM student ORDER BY SUBSTR(jumin, 3, 2)

-- 문자열에서 문자의 위치 인덱스를 리턴 : instr
-- instr( {컬럼 | 문자열} , 문자) 컬럼에서 문자의 위치 인덱스 값을 리턴
-- 학생의 이름, 전화번호, 전화번호에서 ')'의 위치값 출력
SELECT NAME, tel, INSTR(tel, ')') FROM student

-- 학생의 이름, 전화번호, 전화번호의 지역번호 출력
SELECT NAME, tel, LEFT(tel, INSTR(tel,')')-1 ) 지역번호 FROM student

-- 학생의 지역번호 목록
SELECT DISTINCT LEFT(tel, INSTR(tel,')')-1 ) 지역번호 FROM student ORDER BY tel

-- 교수 테이블에서 name, url, homepage('https://' 제외한) 조회하기
SELECT NAME, URL, SUBSTR(URL, INSTR(URL, '//')+2) homepage FROM professor

-- 문자 추가 함수 : lpad, rpad
-- lpad(컬럼, 전체 자리 수, 추가 문자) : rpad는 오른쪽
--									컬럼을 전체 자리 수 출력시 빈자리는 왼쪽에 추가 문자로 채움

-- 학생의 학번, 이름 조회 모두 10자리
-- 학번 빈자리 오른쪽 *
-- 이름 빈자리 왼쪽 #
SELECT rpad(studno, 10, '*'), LPAD(NAME, 10, '#') FROM student

-- 교수 테이블에서 이름, 직급 출력
-- 직급 12자리, 빈자리 오른쪽 *
SELECT NAME, RPAD(POSITION, 12, '*') FROM professor

-- 문자 제거 함수 : trim(), ltrim(), rtrim()
-- trim(문자열) : 좌우 공백 제거
-- ltrim(문자열) : 왼쪽 공백 제거
-- rtrim(문자열) : 오른쪽 공백 제거
-- trim( { LEADING | TRAILING | BOTH} 변경할 from 문자열)
--		leading : 왼쪽 문자 제거
--		trailing : 오른쪽 문자 제거
--		both : 양쪽 문자 제거
SELECT CONCAT('***', TRIM( '    both 공백 제거       '), '***');
SELECT CONCAT('***', LTRIM( '    left 공백 제거       '), '***');
SELECT CONCAT('***', rTRIM( '    right 공백 제거       '), '***');
SELECT TRIM(BOTH '0' FROM '00012002141420000');
SELECT TRIM(leading '0' FROM '00012002141420000');
SELECT TRIM(trailing '0' FROM '00012002141420000');

-- 교수 테이블에서 교수 이름, url, homepage 출력
SELECT NAME, URL, TRIM(leading 'http://' FROM URL) homepage FROM professor

-- 문자 치환 함수 : replace
-- replace(컬럼명, 문자1, 문자2) : 컬럼값의 문자1을 문자2로 치환
-- 학생의 성을 #으로 바꿔 출력
SELECT NAME, REPLACE(NAME, SUBSTR(NAME, 1, 1), '#') FROM student

-- 학생의 이름 중 두 번째 문자를 #으로 변경하여 출력
SELECT NAME, REPLACE(NAME, SUBSTR(NAME, 2,1 ), '#') FROM student

-- 101학과 학생의 이름, 주민 출력, 주민 뒷자리는 *
SELECT NAME, REPLACE(jumin, RIGHT(jumin, 6), '******') FROM student WHERE major1 = 101

-- find_in_set : ,로 나누어진 문자열에서 그룹의 위치 리턴
--	find_in_set( 문자열, {,로 나누어진 문자열} ) : ',로 나누어진 문자열' 에서 문자열이 없으면 0 리턴
SELECT FIND_IN_SET('Y', 'x,y,z') -- 2 리턴
SELECT FIND_IN_SET('a', 'x,y,z') -- 0 리턴

/*
	숫자 관련 함수
*/
-- 반올림 함수 : round()
--		round(숫자) : 소수점 이하 첫 번째 자리에서 반올림하여 정수형으로 출력
--		round(숫자, 자리수) : 소수점을 기준으로 자리수[왼쪽은 -, 오른쪽은 +]로 반올림
SELECT ROUND(12.3456, -1) r1, ROUND(12.3456) r2, ROUND(12.3456, 0) r3,
			ROUND(12.3456, 1) r4, ROUND(12.3456, 2) r5, ROUND(12.3456, 3) r6
-- 버림 함수 : truncate()
--		truncate(숫자, 자리수) : 소수점을 기준으로 자리수[왼쪽은 -, 오른쪽은 + 에서] 버림
sELECT truncate(12.3456, -1) r1, truncate(12.3456, 0) r2, truncate(12.3456, 0) r3,
		truncate(12.3456, 1) r4, truncate(12.3456, 2) r5, TRUNCATE(12.3456, 3) r6

-- 교수 급여에서 15% 인상하여 정수로 출력.
-- 교수이름, 정수로 출력된 반올림 예상 급여, 절삭된 예상 급여
SELECT NAME, round(salary * 1.15) '반올림 예상 급여', TRUNCATE(salary*1.15, 0) '절삭된 예상 급여' FROM professor

-- score 테이블에서 학생의 학번, 국어, 수학, 영어, 총점, 평균 조회
-- 평균은 소수점 2번째 자리로 반올림 출력 // 총점의 내림차순으로 정렬

SELECT studno, kor, math, eng, kor+math+eng 총점, ROUND((kor+math+eng)/3, 2) 평균 FROM score ORDER BY 총점 DESC

-- 근사 함수 : 가장 가까운 정수값
-- ceil() : 큰 근사정수
-- floor() : 작은 근사정수
SELECT CEIL(12.3456), FLOOR(12.3456), CEIL(-12.3456), FLOOR(-12.3456)

-- 나머지 함수 : mod() , 연산자 %로도 가능
-- 제곱함수 : power()
SELECT 21/8, 21%8, MOD(21, 8), POWER(3, 3)

-- 날짜 관련 함수
-- 현재 날짜
-- now() : 날짜와 시간 리턴
-- curdate(), current_date, current_date() 오늘 날짜 리턴

SELECT NOW(), CURDATE(), CURRENT_DATE, CURRENT_DATE()
SELECT CURDATE()+1 -- 익일 출력
SELECT CURDATE()-1 -- 전일 출력

-- 날짜 사이의 일수 
-- datediff(날짜1, 날짜2) : 날짜1 - 날짜2
SELECT NOW(), '2025-01-01', DATEDIFF(NOW(), NOW()) -- 0
SELECT NOW(), '2025-01-01', DATEDIFF(NOW(), '2025-01-01')
-- 학생의 이름, 생일, 생일로부터 지금까지 몇 일이 지났는지 조회
SELECT NAME, birthday, DATEDIFF(NOW(), birthday) FROM student

-- 학생의 이름, 생일, 생일로부터 지금 나이 조회 (정수형으로)
SELECT NAME, birthday, truncate(DATEDIFF(NOW(), birthday)/365, 0) FROM student

-- 학생의 이름, 생일, 현재 개월 수, 나이 출력 / 생일을 통해 /30 (반올림) /365 (절삭)
SELECT grade, NAME, birthday, round(DATEDIFF(NOW(), birthday)/30) 생후개월,
	TRUNCATE(DATEDIFF(NOW(), birthday)/365, 0) 나이
FROM student
ORDER BY grade, 나이

-- 학생의 이름과 생년 조회
SELECT NAME, LEFT(birthday, 4), SUBSTR(birthday, 1, 4) FROM student

--학생의 이름과 생년월일 년 월 일 따로 출력
SELECT NAME, birthday, SUBSTR(birthday, 1, 4), SUBSTR(birthday, 6, 2), SUBSTR(birthday, 9, 2) FROM student
/*
	year(), month(), day()
	weekday() 0 월요일 ~ 6 일요일
	dayofweek() 1 일요일 ~ 7 토요일
	week() 연 기준 몇 주째
	last_day() 당월의 마지막 날짜
*/
SELECT NAME, YEAR(birthday), month(birthday), day(birthday) FROM student
SELECT WEEKDAY(NOW()), DAYOFWEEK(NOW()), WEEK(NOW()), LAST_DAY(NOW())

-- 교수 이름, 입사일 hiredate, 입사년도 휴가보상일, 올해의 휴가보상일 조회
-- 휴가보상일 : 입사 월의 마지막 일자
SELECT NAME, hiredate, LAST_DAY(hiredate) '당년 휴가보상일',
last_day(CONCAT(YEAR(NOW()), SUBSTR(hiredate, 5))) '올해 휴가보상일'
FROM professor

-- 입사월이 1 ~ 3월인 교수의 급여를 15% 인상 예정
-- 이름 현재급여 인상예정급여 급여소급일(올해 입사월 마지막날)
-- 인상 예정급여, 반올림 정수 // 인상예정 교수만 출력
SELECT NAME, salary, round(salary * 1.15), LAST_DAY(CONCAT(YEAR(NOW()), SUBSTR(hiredate, 5))) FROM professor
WHERE MONTH(hiredate) BETWEEN 1 AND 3
/*
	date_add(날짜, interval 숫자 기준상수)
	 >> date_add(now(), interval 3 month) : 현재 기준 3개월 이후 날짜 및 시각 리턴
	date_sub(날짜, INTERVAL 숫자 기준상수)
	 >> date_sub(now(), interval 2 hour) : 현재 기준 2시간 전 날짜 및 시각 리턴
*/
-- 문제1
-- 교수번호, 이름, 입사일, 정식입사일 조회
-- 정식입사일 : 입사일 3개월 이후
-- 문제2
-- emp 테이블에서 정식 입사일은 입사일의 2개월 이후 다음 달 1일로 한다.
-- 사원번호 이름 입사일 정식입사일 출력 
SELECT NO, NAME, hiredate, DATE_ADD(hiredate, INTERVAL 3 MONTH) 정식입사일 FROM professor
SELECT empNO, eNAME, hiredate, DATE_ADD( concat(left(hiredate, 7), '-01'), INTERVAL 3 MONTH) FROM emp
SELECT empNO, eNAME, hiredate, DATE_ADD(last_day(DATE_ADD( hiredate, INTERVAL 2 MONTH)), INTERVAL 1 day) FROM emp

-- 퇴직 신청 가능일 : 퇴직일 기준 2달 전
-- 오늘을 퇴직일로 볼 때, 신청 기준일 출력
SELECT DATE_SUB(NOW(), INTERVAL 2 MONTH)

-- 날짜 관련 변환 함수
-- date_format : 날짜를 지정된 문자열로 변환. 날짜 >> 형식화 문자열
-- str_to_date : 형식화된 문자열을 날짜로 변환. 형식화된 문자열 >> 날짜
/*
	형식화 문자열
	%Y : 4자리 년도 / %y : 2자리 년도
	%M : 영문 월 / %m : 2자리 월
	%D : 1st 형식 일 / %d : 2자리 일
	%H : 00~23 hour / %h : 1~12 hour
	%i : minute / %s : second
	%p : AM/PM
	%W : Monday 형식 요일 / %w : 1~7 월 ~ 일 weekday
	%a : 약자표시 요일 Wed
*/
SELECT NOW(), DATE_FORMAT(NOW(), '%Y년 %m월 %d일 %H:%i:%s'), DATE_FORMAT(NOW(), '%y년 %M월 %D일 %h:%I:%S')

-- 2025-12-31 요일 출력
select DATE_FORMAT('2025-12-31', '%a, %W') '2025-12-31 요일', DATE('2025-12-31')
-- 2025년12월31일 < 이 문자열로 요일 구하기
SELECT DATE_FORMAT((STR_TO_DATE('2025년12월31일', '%Y년%m월%d일')), '%W')

-- 교수의 이름, 직책, 입사일, 정식입사일(입사 후 3개월) 출력 yyyy년mm월dd일

SELECT NAME, POSITION, date_format(hiredate, '%Y년%m월%d일') 입사일,
	date_format(DATE_ADD(hiredate, INTERVAL 3 MONTH), '%Y년%m월%d일') 정식입사일 FROM professor
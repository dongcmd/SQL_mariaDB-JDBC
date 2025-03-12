/*
	1. 집합 연산자
		union : 합집합. 중복 X
		union all : 중복 O. 2개 쿼리의 결과를 연결하여 조회
		** 2개의 select에서 조회되는 컬럼의 수가 같아야 한다.
		intersect : 교집합. and 조건문으로 대부분 가능
		
	2. 함수 - 단일행 함수 : 하나의 레코드에서만 처리되는 함수. where 조건문에서 사용 가능
				 그룹 함수 : 여러 개의 레코드에서 처리되는 함수. having 조건문에서 사용 가능
				 
	3. 문자열 관렴 함수
		- 대소문자 변경 : upper(문자열), lower(문자열)
		- 문자열의 길이 : length(문자열) 바이트 수 리턴, char_length(문자열) 길이 리턴
		- 부분 문자열 : substr(문자열, 시작인덱스[, 개수]), left(문자열, 개수), right(문자열, 개수)
		- 문자 연결 함수 : conact(문자열, ...)
		- 문자의 위치 : instr(문자열, 문자) = > 문자열에서 문자의 위치 인덱스 리턴, 1부터 시작
		- 문자 추가 : lpad(문자열, 전체자리수, 채울문자), rpad(동일)
		- 문자 제거 : trim(문자열) 양쪽 공백 제거
						  ltrim(문자열), rtrim(문자열)  좌/우 공백 제거
						  trim( {leading | trailing | both }  제거할 문자 from 문자열) 지정한 문자를 제거
						  				왼쪽		오른쪽 	 양쪽
		- 문자 치환 : replace(문자열, 문자1, 문자2) 문자열에서 문자1 --> 문자2 치환
		- 그룹의 위치 : find_in_set(문자, 문자열) ','를 가진 문자열에서 문자가 몇 번째 위치인지 리턴
		
	4. 숫자 관련 함수
		- 반올림 : round(숫자[, 소수점 자리 수]) 자리수 생략시 정수로 출력
		- 버림 : truncate(숫자, 소수점 자리 수)
		- 나머지 : mod(), %연산자로 가능
		- 제곱 : power(x, y) x^y
		- 근사 정수 ceil() : 큰 근사 정수
						floor() : 작은 근사 정수
	
	5. 날짜 관련 함수
		- 현재 일시 : now()
		- 현재 일자 : curdate(), current_date, current_date()
		- 년, 월, 일 : year(), month(), day(), weekday() 0월~6일, dayofweek() 1일7토, last_day() 해당 월의 마지막 일 리턴
		- 이전/이후 : date_sub( 날짜, interval 숫자 {year | month | day | hour | minute | second} )
						 date_add( 날짜, interval 숫자 {year | month | day | hour | minute | second} )
		- 날짜 변환 함수 : date_format() 날짜 --> 문자열
								 str_to_date() 문자열 --> 날짜
				%Y, %m, %d, ...
*/
/*
	기타 함수
*/
-- ifnull(컬럼, 기본값) : 컬럼값이 null이면 기본값으로 치환
-- 교수 이름, 급여, 보너스, 급+보

SELECT NAME, salary, bonus, salary+bonus FROM professor WHERE bonus IS NOT NULL
UNION
SELECT NAME, salary, bonus, salary FROM professor WHERE bonus IS null

-- IFNULL(bonus, 0)
-- bonus가 null이면 0으로 치환
SELECT NAME, salary, bonus, salary+IFNULL(bonus, 0) FROM professor
-- ifnull(salary+bonus, salary)
-- salary + bonus가 null이면 salary 치환
SELECT NAME, salary, bonus, ifnull(salary+bonus, salary) FROM professor

-- 교수 이름 급여 보너스 출력
-- 보너스가 없으면 '보너스없음' 출력
SELECT NAME, salary ,IFNULL(bonus, '보너스없음') FROM professor

-- 학생 이름, 지도교수번호 출력 / 지도교수 없으면 9999
SELECT NAME, ifnull(profno, 9999) FROM student
/*
	조건 함수 : if, case
*/
-- if(조건문, 참, 거짓)
-- 1학년 학생은 신입생, 나머진 재학생
SELECT distinct grade, if(grade=1, '신입생', '재학생') 구분 from student

-- 교수 이름 학과번호 학과명 출력, 학과명이 101 : 컴공 나머지는 그 외
SELECT NAME, deptno, if(deptno=101, '컴공', '그 외') 학과명 FROM professor

-- 학생 이름, 주민번호 / 주민번호로 성별 출력
SELECT NAME, right(jumin, 7), if(
							SUBSTR(jumin, 7, 1) =1 , '남자', if(
								SUBSTR(jumin, 7, 1) = 3, '남자', '여자' ) 
							) 성별 FROM student
SELECT NAME, SUBSTR(jumin, 7, 1), if(
											SUBSTR(jumin, 7, 1) IN (1,3), '남자', if(
												SUBSTR(jumin, 7, 1) IN (2,4), '여자', '주민번호 오류')
										) 성별 FROM student
										
-- 문제) 교수 이름, 학과번호, 학과명 출력
-- 학과명 101 컴공 / 102 멀미공 / 201 기공 / 그외
SELECT NAME, deptno, if(deptno = 101, '컴공', if(deptno = 102, '멀미공', if(deptno = 201, '기공', '그외'))) 학과명 FROM professor

/*
	case 조건문
		case 컬럼명 when 값1 then 문자열 when 값2 then 문자열 ...
			else 문자열 end
			
		case when 조건문1 then 문자열 ... else 문자열 end
*/
-- 교수 이름, 학과코드, 학과명 출력 / 101 컴공 / 나머지 공란
SELECT NAME, deptno, case deptno
								when 101 then '컴공'
								ELSE '' end
FROM professor
SELECT NAME, deptno, case deptno when 101 then '컴공' ELSE '그외' END FROM professor

-- 교수 이름, 학과번호, 출신 출력 101,102,201 공과대학 나머지 그외
SELECT NAME, deptno, if(deptno IN(101, 102, 201), '공대', '그외') 출신 FROM professor
SELECT NAME, deptno, case deptno when 101 then '공대'
											 when 102 then '공대'
											 when 201 then '공대'
											 ELSE '그외' END '출신대학' FROM professor
SELECT NAME, deptno, case when deptno IN(101, 102, 201) then '공대' ELSE '그외' END 대학 FROM professor

-- 학생 이름, 주민, 출생분기 출력 주민 1-3월 1분기
SELECT NAME, substr(jumin, 3, 4) 생일, case when SUBSTR(jumin, 3, 2) <= '03' then '1분기'
		when SUBSTR(jumin, 3, 2) <= '06' then '2분기'
		when SUBSTR(jumin, 3, 2) <= '09' then '3분기'
		when SUBSTR(jumin, 3, 2) <= '12' then '4분기'
		ELSE 'error' end 출생분기 FROM student ORDER BY 생일
		
--문제) 학생 이름, 생일, 출생분기 생일기준
SELECT NAME, month(birthday), case when MONTH(birthday) <= 3 then '1분기'
										when MONTH(birthday) <= 6 then '2분기'
										when MONTH(birthday) <= 9 then '3분기'
										when MONTH(birthday) <= 12 then '4분기'
										ELSE 'error' END '분기(생일기준)' FROM student ORDER BY 2

/*
	그룹 함수 : 다수 행의 정보를 이용하여 결과 리턴 함수, (단, null은 제외)
	select { 컬럼명 | * } from 테이블명
	[where 조건문]
	[group by 컬럼명] 컬럼명을 기준으로 레코드를 그룹화.
							group by 구문이 없다면, 모든 레코드가 하나의 그룹으로 처리
	[having 조건문]
	[order by { 컬럼명 | alias | 컬럼순서 { [ asc ] | desc } }
*/
-- count() : 레코드 개수 리턴, null은 제외
-- count(*) 레코드의 수
-- 교수 전체 인원수, 보너스 받는 인원수 조회
SELECT COUNT(*), COUNT(bonus) FROM professor

-- 학생의 전체 인원과 지도교수를 배정받은 학생의 인원수 조회
 SELECT COUNT(*), COUNT(profno) FROM student
-- 전공학과1이 101인 학생의 인원 수
SELECT * FROM student WHERE major1 = 101

-- 1학년 학생의 전체인원 및지도교수 배정받은 학생의 수
SELECT COUNT(*), COUNT(profno) FROM student WHERE grade = 1

-- 학년별 전체 인원수와 지도교수 배정받은 학생 수 조회
SELECT grade, COUNT(*), COUNT(profno) FROM student GROUP BY grade

--학과별 전체 인원 수 및 지도교수 배정받은 학생 수
SELECT major1, COUNT(*), COUNT(profno) FROM student GROUP BY major1

--지도교수가 배정되지 않은 학생의 학년별 전체 인원수
SELECT GRADE, COUNT(*) FROM student GROUP BY grade HAVING COUNT(profno) = 0

-- 합계 sum, 평균 avg
-- avg(bonus) 단null제
-- avg(ifnull(bonus, 0)) null도 포함
-- 교수의 급여 합, 보너스 합
SELECT SUM(salary) 급합, SUM(bonus) 보합 FROM professor
SELECT SUM(salary) 급합, SUM(bonus) 보합, COUNT(*), COUNT(bonus), avg(salary) 급평, avg(bonus) 보평 FROM professor
-- 보너스 없는 교수도 포함해 평균
SELECT SUM(salary) 급합, SUM(bonus) 보합, COUNT(*), COUNT(bonus), avg(salary) 급평, avg(ifnull(bonus, 0)) 보평 FROM professor

--문제) 교수의 부서코드 ,부서별 인원, 급합, 보합, 급평, 보평 출력 / 단 보없교도 평균에 포함
SELECT deptno, COUNT(*), SUM(salary), SUM(ifnull(bonus, 0)), AVG(salary), AVG(IFNULL(bonus, 0)) FROM professor GROUP by deptno

--문제) 학년별, 학생 수, 키/몸 평, 학년 순으로 정렬
SELECT grade, COUNT(*), AVG(height), AVG(weight) FROM student GROUP BY grade ORDER BY grade

--문제) 부서별 교수 급합, 보합, 연합, 급평, 보평, 연평, 보너스 없으면 0, 평균은 소수점 2자리로 반올림
SELECT deptno, COUNT(*), SUM(salary), SUM(IFNULL(bonus, 0)),  SUM(salary * 12+IFNULL(bonus, 0)),
	round(AVG(salary), 2), round(AVG(IFNULL(bonus, 0)), 2), round(AVG(salary * 12+IFNULL(bonus, 0)), 2) FROM professor GROUP BY deptno
	
/*
	최소값, 최대값 - min(), max()
*/
-- 전공1 학과별 가장 큰 키와 작은 키 출력
SELECT major1, Max(height), MIN(height) FROM student
GROUP BY major1

-- 교수 중 가장 많은 급여와 적은 급여
SELECT MAX(salary), MIN(salary) FROM professor

/*
	표준편차 : stddev()
	분산		: variance()
*/
-- 교수 급여의 평균, 표준편차, 분산
SELECT avg(salary), STDDEV(salary), variance(salary) FROM professor

-- score 테이블에서 합계의 평균, 표준편차, 분산 조회
SELECT avg(kor+math+eng) 합평, STDDEV(kor+math+eng) 표준편차, VARIANCE(kor+math+eng) 분산 FROM score

-- having : group 조건
-- 학과별 가장 큰 키, 가장 작은 키,  학과별 평균키 출력
SELECT major1, MAX(height), MIN(height), AVG(height) FROM student GROUP BY major1
HAVING AVG(height) >= 170
-- 교수 테이블에서 학과별 평급이 350 이상인 부서의 코드와 평급 출력
SELECT deptno, AVG(salary) FROM professor GROUP BY deptno HAVING AVG(salary) >= 350

-- 학생 중, 주민번호 기준 남/녀 최대/최소/평균키 조회
SELECT if(SUBSTR(jumin, 7, 1) IN(1,3), '남', '녀') 성별, MAX(height), MIN(height), AVG(height) FROM student GROUP BY 성별

SELECT SUBSTR(jumin, 7, 1) 성별, MAX(height), MIN(height), AVG(height) FROM student GROUP BY 성별

-- 학생의 생일에서 태어난 월별 인원 수 출력
SELECT MONTH(birthday) 태어난월, COUNT(*) 인원 FROM student GROUP BY 태어난월 ORDER BY 태어난월

SELECT CONCAT(COUNT(*) +"", '명') 전체,
		SUM( if( MONTH(birthday) = 1, 1, 0) ) 1월,
		SUM( if( MONTH(birthday) = 2, 1, 0) ) 2월,
		SUM( if( MONTH(birthday) = 3, 1, 0) ) 3월,
		SUM( if( MONTH(birthday) = 4, 1, 0) ) 4월,
		SUM( if( MONTH(birthday) = 5, 1, 0) ) 5월,
		SUM( if( MONTH(birthday) = 6, 1, 0) ) 6월,
		SUM( if( MONTH(birthday) = 7, 1, 0) ) 7월,
		SUM( if( MONTH(birthday) = 8, 1, 0) ) 8월,
		SUM( if( MONTH(birthday) = 9, 1, 0) ) 9월,
		SUM( if( MONTH(birthday) = 10, 1, 0) ) 10월,
		SUM( if( MONTH(birthday) = 11, 1, 0) ) 11월,
		SUM( if( MONTH(birthday) = 12, 1, 0) ) 12월 FROM student

--그룹함수 전
SELECT NAME, birthday,
	if(month(birthday) = 1, 1, 0)1월,
	if(month(birthday) = 2, 1, 0)2월,
	if(month(birthday) = 3, 1, 0)3월,
	if(month(birthday) = 4, 1, 0)4월,
	if(month(birthday) = 5, 1, 0)5월,
	if(month(birthday) = 6, 1, 0)6월,
	if(month(birthday) = 7, 1, 0)7월,
	if(month(birthday) = 8, 1, 0)8월,
	if(month(birthday) = 9, 1, 0)9월,
	if(month(birthday) = 10, 1, 0)10월,
	if(month(birthday) = 11, 1, 0)11월,
	if(month(birthday) = 12, 1, 0)12월 FROM student

/*
	순위 지정 함수 : rank() over(정렬방식)
	누계 함수 : sum(컬럼명) over(정렬방식)
*/
--교수의 번호, 이름 급여, 급여 많이 받는 순위
SELECT NO, NAME, salary, RANK() OVER(ORDER BY salary DESC) 급여순위 FROM professor

-- score 테이블에서 학번 국어 수학 영어 총점 총점등수, 과목별 등수도
SELECT studno, kor, math, eng, kor+math+eng 총점, RANK() OVER(ORDER BY 총점 DESC) 총점등수 FROM score
SELECT *, kor+math+eng 총점, RANK() OVER(ORDER BY 총점 DESC) 총점등수,
	RANK() OVER(ORDER BY kor DESC) kor등수, 
	RANK() OVER(ORDER BY math DESC) math등수, 
		RANK() OVER(ORDER BY eng DESC) eng등수 FROM score
		
-- 교수의 이름, 급여, 보너스, 급여누계 조회
SELECT NAME, salary, bonus, SUM(salary) OVER(ORDER BY salary desc) 급여누계 FROM professor

-- score 테이블에서 학번, 국, 수, 영, 총점, 총점누계, 총점등수 조회
SELECT *, kor+math+eng '총점', SUM(kor+math+eng) OVER(ORDER BY 총점 DESC) 총점누계, RANK() OVER(OrdeR BY 총점 desc) 총점등수 FROM score

-- 부분합 : rollup
-- 국어, 수학의 합계 합을 구하기
SELECT kor, math, SUM(kor+math) FROM score GROUP BY kor,math WITH ROLLUP

-- student에서 학년별, 지역별(전화번호로) 키/몸 평균
SELECT grade, SUBSTR(tel, 1, INSTR(tel, ')')-1) 지역, AVG(weight) 몸평, AVG(height) 키평 FROM student GROUP BY grade, 지역
SELECT grade, SUBSTR(tel, 1, INSTR(tel, ')')-1) 지역, AVG(weight) 몸평, AVG(height) 키평 FROM student GROUP BY grade, 지역 WITH ROLLUP
SELECT grade, AVG(weight) 몸평, AVG(height) 키평 FROM student GROUP BY grade

-- 각 학년의 성별 몸평/키평 + 학년별 평균 조회
SELECT grade, if(SUBSTR(jumin, 7, 1) IN(1,3), '남자', '여자') sex, AVG(weight) 몸평, AVG(height) 키평
FROM student GROUP BY grade, sex WITH ROLLUP


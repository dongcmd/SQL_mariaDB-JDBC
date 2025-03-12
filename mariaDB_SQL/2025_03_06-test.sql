 1. 학생의 이름과 지도교수번호 조회하기
   지도교수가 없는 경우 지도교수배정안됨 출력하기
SELECT NAME, ifnull(profno, '배정안됨') FROM student

 2. major 테이블에서 코드, 코드명, build 조회하기
   build 값이 없는 경우 '단독 건물 없음' 출력하기
SELECT CODE, NAME, ifnull(build, '단독 건물 없음') FROM major


 3. 학생의 이름, 전화번호, 지역명 조회하기
 지역명 : 지역번호가 02 : 서울, 031:경기, 032:인천 그외 기타지역
SELECT NAME, tel, case SUBSTR(tel, 1, INSTR(tel, ')')-1) when '02' then '서울'
										when '031' then '경기'
										when  '032' then '인천' ELSE '기타' end 지역명 FROM student

 4. 학생의 이름, 전화번호, 지역명 조회하기
 지역명 : 지역번호가 02,031,032: 수도권, 그외 기타지역 
SELECT NAME, tel, case when SUBSTR(tel, 1, INSTR(tel, ')')-1) IN ('02', '031', '032') then '수도권' ELSE '기타' END FROM student

SELECT tel, if(LEFT(tel,INSTR(tel,')')-1) IN('02','031','032') , '수도권', '기타') FROM student

5. 학생을 3개 팀으로 분류하기 위해 학번을 3으로 나누어 
   나머지가 0이면 'A팀', 
   1이면 'B팀', 
   2이면 'C팀'으로 
   분류하여 학생번호, 이름, 학과번호, 팀 이름을 출력하여라
SELECT STUDNO, NAME, major1, CASE Major1%3 WHEN 0 THEN 'A팀' WHEN 1 THEN 'B팀' WHEN 2 THEN 'C팀' END '팀이름' FROM STUDENT


 6. score 테이블에서 학번, 국어,영어,수학, 학점, 인정여부 을 출력하기
    학점은 세과목 평균이 95이상이면 A+,90 이상 A0
                        85이상이면 B+,80 이상 B0
                        75이상이면 C+,70 이상 C0
                        65이상이면 D+,60 이상 D0
     인정여부는 평균이 60이상이면 PASS로 미만이면 FAIL로 출력한다.                   
    으로 출력한다.
SELECT STUDNO, kor, eng, math, (kor+eng+math)/3 평균, case when (kor+eng+math)/3 >= 95 then 'A+'
								when (kor+eng+math)/3>= 90 then 'A0'
								when (kor+eng+math)/3>= 85 then 'B+'
								when (kor+eng+math)/3>= 80 then 'B0'
								when (kor+eng+math)/3>= 75 then 'C+'
								when (kor+eng+math)/3>= 70 then 'C0'
								when (kor+eng+math)/3>= 65 then 'D+'
								when (kor+eng+math)/3>= 60 then 'D0' ELSE 'F' END '학점',
								case when (kor+eng+math)/3>= 60 then 'pass' ELSE 'fail' END '인정여부'FROM score ORDER BY 평균 DESC

   
 7. 학생 테이블에서 이름, 키, 키의 범위에 따라 A, B, C ,D그룹을 출력하기
      160 미만 : A그룹
      160 ~ 169까지 : B그룹
      170 ~ 179까지 : C그룹
      180이상       : D그룹
SELECT NAME, height, case when height >= 180 then 'D' when height BETWEEN 170 AND 179 then 'b' when height BETWEEN 160 AND 169 then 'c'
ELSE 'a' END 키그룹 FROM student ORDER BY height desc
       
 8. 교수테이블에서 교수의 급여액수를 기준으로 200이하는 4급, 201~300 : 3급, 301~400:2급
     401 이상은 1급으로 표시한다. 교수의 이름, 급여, 등급을 출력하기
     단 등급의 오름차순으로 정렬하기
SELECT NAME, salary, if(salary > 400, '1st', if(salary > 300, '2nd', if(salary > 200, '3rd', '4th'))) 등급 FROM professor ORDER BY 등급

9 학생의 학년별 키와 몸무게 평균 출력하기.
   학년별로 정렬하기. 
   평균은 소숫점2자리 반올림하여 출력하기
SELECT grade, round(avg(height), 2), round(avg(weight), 2) FROM student group by grade ORDER BY grade

10. 평균키가 170이상인  전공1학과의 
    가장 키가 큰키와, 가장 작은키, 키의 평균을 구하기 
 SELECT major1, MAX(height), MIN(height), AVG(height) FROM student GROUP BY major1 HAVING AVG(height) >= 170
 
11.  사원의 직급(job)별로 평균 급여를 출력하고, 
     평균 급여가 1000이상이면 '우수', 작으면 '보통'을 출력하여라
SELECT job, AVG(salary) 평균급여, case when AVG(salary) >= 1000 then '우수' ELSE '보통' END 급여수준
FROM emp GROUP BY job ORDER BY 평균급여 desc
 
SELECT job, AVG(salary), if( AVG(Salary) >= 1000, '우수', '보통') FROM emp GROUP BY job
 

12. 학과별로 학생의 평균 몸무게와 학생수를 출력하되 
    평균 몸무게의 내림차순으로 정렬하여 출력하기
SELECT major1, AVG(weight) 평몸, COUNT(*) 학생수 from student group by major1 ORDER BY 평몸 desc

13. 학과별 교수의 수가 2명 이하인 학과번호, 인원수를 출력하기
SELECT deptno, COUNT(*) FROM professor GROUP BY deptno HAVING COUNT(*) <= 2

14. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
     학생의 인원수를 조회하기
SELECT SUBSTR(tel, 1, INSTR(tel, ')')-1) 지역번호, case SUBSTR(tel, 1, INSTR(tel, ')')-1) when '02' then '서울'
when '031' then '경기' when '051' then '부산' when '052' then '경남' ELSE '그외' END 지역, COUNT(*)
FROM student GROUP BY 지역

15. 전화번호의 지역번호가 02서울 031 경기, 051 부산, 052 경남, 나머지 그외지역
     학생의 인원수를 조회하기. 가로출력
SELECT COUNT(*) 합계, SUM(if(SUBSTR(tel, 1, INSTR(tel, ')')-1) = '02', 1, 0)) 서울,
	SUM(if(SUBSTR(tel, 1, INSTR(tel, ')')-1) = '031', 1, 0)) 경기,
	SUM(if(SUBSTR(tel, 1, INSTR(tel, ')')-1) = '051', 1, 0)) 부산,
	SUM(if(SUBSTR(tel, 1, INSTR(tel, ')')-1) = '052', 1, 0)) 경남,
	SUM(if(SUBSTR(tel, 1, INSTR(tel, ')')-1) NOT IN('02', '031', '051', '052'), 1, 0)) 기타
 FROM student

16. 교수들의 번호,이름,급여,보너스, 총급여(급여+보너스)
     급여많은순위,보너스많은순위,총급여많은 순위 조회하기
     총급여순위로 정렬하여 출력하기. 보너스없는 경우 0으로 함
SELECT NO, NAME, salary, IFNULL(bonus, 0), salary+IFNULL(bonus, 0) 총급여,
RANK() OVER(ORDER BY salary DESC) 급여순위,
RANK() OVER(ORDER BY bonus DESC) 보너스순위,
RANK() OVER(ORDER BY 총급여 DESC) 총급여순위
FROM professor ORDER BY 총급여순위

17.  교수의 직급,직급별 인원수,급여합계,보너스합계,급여평균,보너스평균 출력하기
    단 보너스가 없는 교수도 평균에 포함되도록 한다.
    급여평균이 높은순으로 정렬하기
SELECT POSITION, COUNT(*), SUM(salary), SUM(ifnull(bonus, 0)), AVG(salary), AVG(ifnull(bonus, 0)) FROM professor GROUP BY POSITION
ORDER BY AVG(salary) desc

18. 1학년 학생의 인원수,키와 몸무게의 평균 출력하기
SELECT COUNT(*) 인원수, AVG(height), AVG(weight) FROM student GROUP BY grade HAVING grade = 1
SELECT grade, COUNT(*) 인원수, AVG(height), AVG(weight) FROM student GROUP BY grade

19. 학생의 점수테이블(score)에서 수학 평균,수학표준편차,수학분산 조회하기
SELECT AVG(math), STDDEV(math), VARIANCE(math) FROM score

20. 교수의 월별 입사 인원수를 출력하기
SELECT month(hiredate) 입사월, COUNT(*) FROM professor GROUP BY 입사월




/*
	단일행 함수
	 기타함수
	 - ifnull(컬럼, 기본값) : 컬럼의 값이 null인 경우, 기본값으로 치환
	 									오라클 : nvl(컬럼, 기본값)
	 - 조건 함수 : if, case
	 		if(조건문, 참, 거짓) : 중첩 가능
	 										오라클 : decode(조건문, 참, 거짓)
	 		case 
			 1) case 컬럼명 when 값 then 출력값 ... [else 값] end
	 		
 			 2) case when 조건문 then 출력값 ... [else 값] end
 			 
 			 
 	 그룹함수 : 여러 개의 레코드에서 정보를 얻어 리턴
 	  개수 : count(*) --> 조회된 레코드의 개수
 	  			count(컬럼명) --> 해당 컬럼의 값이 null이 아닌 레코드의 개수
 		합계 : sum(컬럼명)
 		평균 : avg(컬럼명) --> 컬럼의 값이 null이면 평균의 대상이 안 됨. 포함하고 싶다면 ifnull() 사용
 		최대값, 최소값 : max(컬럼), min(컬럼)
 		표준편차, 분산 : stddev(컬럼명), variance(컬럼명)
 		
 	  순위, 누계 지정 함수
 	   - rank() over(정렬방식)
 	   - sum(컬럼명) over(정렬방식)
 	  
 	 group by 컬럼명 : 그룹 함수를 사용할 때, 그룹화 되는 기준의 컬럼.
 	            group by에서 사용된 컬럼을 select 구문에서 조회해야 함.
 	            
 	 having 조건문 : 그룹 함수의 조건문
 	 
 	 rollup : 부분합계
 	
	 select 구문 구조

	 select { 컬럼명 | * | 상수값 | 연산 | 단일행함수 }
	 from 테이블명 
	 [where 조건문] --> 레코드 조건문
	 [group by 컬럼명] 그룹화의 기준이 되는 컬럼
	 [having 조건문] --> 그룹 함수 조건문
	 [order by { 컬럼명, | alias | 컬럼의 순서 }]
*/

/*
	join : 여러 개의 테이블에서 조회
*/
SELECT * from emp -- 14r, 9c
SELECT * from dept -- 5r, 3c
SELECT * FROM emp CROSS JOIN dept -- 14*5 = 40r, 9+3 = 12c

-- 사원번호emp.empno, 사원명emp.ename, 직책emp.job,
-- 부서코드emp.deptno, 부서명dept.dname cross join 하기
-- 중복된 컬럼은 테이블명을 표시해야 함.
-- 중복되지 않은 컬럼은 생략 가능.
SELECT e.empno, e.ename, e.job, e.deptno, d.deptno, d.dname, e. FROM emp e, dept d -- 테이블명 alias 설정 가능
/*
	등가조인 : equi join
			조인컬럼을 이용해 필요한 레코드만 조회.
			조인컬럼의 조건이 = 인 경우
*/
-- 사원번호, 사원명, 직책, 부서코드, 부서명 조회하기
-- mariaDB 방식
SELECT e.empno, e.ename, e.job, e.deptno, d.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno -- join 컬럼
-- ANSI 방식
SELECT e.empno, e.ename, e.job, e.deptno, d.deptno, d.dname
FROM emp e JOIN dept d
on e.deptno = d.deptno -- join 컬럼

--학생student 테이블과 학과major 테이블을 사용해 학생이름, 전공학과번호, 전공학과이름 조회
DESC student
DESC major

SELECT s.name, s.major1, m.name
FROM student s JOIN major m
ON s.major1 = m.code

-- 문) 학생의 이름, 지도교수번호, 지도교수이름 출력
-- mariaDB
SELECT s.name 학생, s.profno, p.name 교수
FROM student s, professor p
WHERE s.profno = p.no
-- ANSI
select s.name, s.profno, p.name
FROM student s JOIN professor p
ON s.profno = p.no

-- 문) 학생테이블에서 학번, 이름 score테이블에서 학번에 해당하는 국, 수, 영, 총점 조회
-- maria
SELECT stu.studno, stu.name, sc.kor, sc.math, sc.eng, (sc.kor+ sc.math+ sc.eng) 총점
FROM student stu, score sc
WHERE stu.studno = sc.studno
-- ansi
SELECT st.studno, st.name, sc.kor, sc.math, sc.eng, (sc.kor+ sc.math+ sc.eng) 총점
FROM student st join score sc
ON st.studno = sc.studno ORDER BY 총점 DESC

-- 학생 이름, 학과 이름, 지도교수 이름 조회
SELECT s.name 학생, m.`name` 학과, p.name 지도교수
FROM student s, major m, professor p
WHERE s.major1 = m.code
 AND s.profno = p.no
 
SELECT s.name 학생, m.`name` 학과, p.name 지도교수
FROM student s join major m
on s.major1 = m.code
JOIN professor p
ON s.profno = p.no

-- 문) emp tb, p_grade tb 조회해 사원 이름, 직급, 현재연봉, 해당직급의 연봉하한/상한 금액 출력. 연봉(급 * 12 + 보) * 1만
SELECT e.ename, e.job, (e.salary*12+ifnull(e.bonus, 0)) * 10000 현재연봉, pg.s_pay 연봉하한, pg.e_pay 연봉상한
FROM emp e, p_grade pg
WHERE e.job = pg.position

SELECT e.ename, e.job, (e.salary*12+ifnull(e.bonus, 0)) * 10000 현재연봉, pg.s_pay 연봉하한, pg.e_pay 연봉상한
FROM emp e join p_grade pg
ON e.job = pg.position

-- 장성태 학생의 학번, 이름, 전공1학과번호 , 전공1학과이름, 학과 위치 출력 tb student, tb major
SELECT s.studno, s.name, s.major1, m.name, m.build
FROM student s, major m
where s.NAME = '장성태' AND s.major1 = m.code

SELECT s.studno, s.name, s.major1, m.name, m.build
FROM student s join major m
ON s.name = '장성태'
where s.major1 = m.code

-- 몸 80kg 이상 학생의 학번, 이름, 체중, 학과이름, 학과위치 출력

SELECT s.studno, s.name, s.weight, m.name, m.build
FROM student s, major m
WHERE s.major1 = m.code AND weight >= 80

SELECT s.studno, s.name, s.weight, m.name, m.build
FROM student s join major m
on s.major1 = m.code
WHERE weight >= 80

--학생의 학번, 이름, score tb에서 학번에 해당하는 점수 조회. + 1학년 학생 정보 조회
SELECT st.studno, st.name, sc.kor, sc.eng, sc.math
FROM student st, score sc
WHERE st.studno = sc.studno AND st.grade = 1

SELECT st.studno, st.name, sc.kor, sc.eng, sc.math
FROM student st JOIN score sc
on st.studno = sc.studno
where st.grade = 1
/*
	비등가 조인 : non equi join
			조인컬럼의 조건이 =이 아닌 경우. 범위값으로 조인.
*/

SELECT * FROM guest -- 고객테이블
SELECT * FROM pointitem -- 상품테이블

-- 고객은 자기 포인트 이하의 상품을 선택 가능. 외장하드를 받을 수 있는 고객의
-- 고객명과 고객이 포인트로 받을 수 있는 상품명, 시작/종료포인트 조회
SELECT g.name, g.point, p.name, p.spoint, p.epoint
FROM guest g, pointitem p
WHERE p.name = '외장하드' AND g.point >= p.spoint

SELECT g.name, g.point, p.name, p.spoint, p.epoint
FROM guest g join pointitem p
on g.point >= p.spoint
WHERE p.name = '외장하드'

-- 이 사람이 선택할 수 있는 상품 종류의 개수 조회
SELECT g.name, g.point, COUNT(*) 선택폭
FROM guest g, pointitem p
WHERE g.point >= p.spoint
GROUP BY g.name ORDER BY 3 desc

SELECT g.name, g.point, COUNT(*)
FROM guest g join pointitem p
ON g.point >= p.spoint
GROUP BY g.name ORDER BY 3 desc

-- 상품 개수가 2개 이상인 정보만 조회
SELECT g.name, g.point, COUNT(*) 선택폭
FROM guest g join pointitem p
ON g.point >= p.spoint
GROUP BY g.name
HAVING 선택폭 >= 2
ORDER BY 3, g.name

SELECT * FROM scorebase
SELECT * FROM student
SELECT * FROM score
-- 학생의 학번, 이름, 국, 수, 영, 총점, 평균, 학점 출력. 평균은 반올림한 정수
SELECT st.studno, st.name, sc.kor, sc.math, sc.eng, sc.kor+sc.math+sc.eng 총점, ROUND((sc.kor+sc.math+sc.eng)/3) 평균, sb.grade
FROM student st, score sc, scorebase sb
WHERE st.studno = sc.studno
  AND ROUND((sc.kor+sc.math+sc.eng)/3) BETWEEN sb.min_point AND sb.max_point
ORDER BY sb.grade

SELECT st.studno, st.name, sc.kor, sc.math, sc.eng, sc.kor+sc.math+sc.eng 총점, ROUND((sc.kor+sc.math+sc.eng)/3) 평균, sb.grade
FROM student st join score sc
on st.studno = sc.studno
JOIN scorebase sb
on ROUND((sc.kor+sc.math+sc.eng)/3) BETWEEN sb.min_point AND sb.max_point
ORDER BY sb.grade

/*
	self join : 같은 테이블의 다른 컬럼들을 조인 컬럼으로 사용.
					테이블 alias 설정 필수
					모든 컬럼에 테이블 alias을 기재 필수
*/

SELECT * from emp 
-- mgr : 상사의 사원번호
-- tb emp에서 사원번호, 이름, 상사의 사원번호, 상사이름 조회
SELECT e1.empno, e1.ename, e2.empno, e2.ename
FROM emp e1, emp e2
WHERE e1.mgr = e2.empno

SELECT e1.empno, e1.ename, e2.empno, e2.ename
FROM emp e1 join emp e2
on e1.mgr = e2.empno

SELECT * FROM major
-- code : 전공학과 코드
-- part : 상위학부 코드
-- tb major 에서 학과코드, 학과명, 상위학과 코드, 상위학과명
SELECT m1.code, m1.name, m1.part, m2.name
FROM major m1, major m2
WHERE m1.part = m2.code

SELECT m1.code, m1.name, m1.part, m2.name
FROM major m1 JOIN major m2
ON m1.part = m2.code

-- 교수번호, 이름, 입사일, 입사일이 빠른사람의 수 조회, 입사일 빠른순으로 정렬
SELECT p1.no, p1.NAME, p1.hiredate, COUNT(*)
FROM professor p1 join professor p2
on p1.hiredate > p2.hiredate
GROUP BY p1.no
ORDER BY p1.hiredate, p1.name

-- 교수번호, 이름, 입사일, 입사일이 같은사람 인원수. 입사일 빠른 순으로 정렬
SELECT p1.NO, p1.NAME, p1.hiredate, COUNT(*)-1
FROM professor p1 join professor p2
ON p1.hiredate = p2.hiredate
GROUP BY p1.no
ORDER BY p1.hiredate

/*
	inner join : 조인컬럼의 조건과 맞는 레코드만 조회. 
	 - equi join
	 - non equi join
	 - self join
*/
SELECT * FROM major -- 11r

SELECT m1.code, m1.name, m1.part, m2.name -- 9r
FROM major m1, major m2
WHERE m1.part = m2.code

/*
	outer join : 조인컬럼의 조건이 맞지 않아도, {한쪽 | 양쪽} 레코드 조회
		left outer join :  left table의 모든 레코드 조회
		right outer join : right table의 모든 레코드 조회
		full outer join : 양쪽 테이블의 모든 레코드 조회 (mariaDb 에선 구현 안됨,  union 활용)
*/
-- 학생 이름, 지도교수 이름
SELECT s.name 학생, p.name 지도교수 
FROM student s join professor p -- innedr join
ON s.profno = p.no
-- 지도교수 없어도 조회되게
SELECT s.name 학생, p.name 지도교수 
FROM student s LEFT outer JOIN professor p
ON s.profno = p.no

-- 학생의 학번, 이름, 지도교수 이름조회. 지도교수 없어도 조회, ㅈ없으면 없다 출력
SELECT s.studno, s.name, ifnull(p.name, '지도 교수가 없는데요')
FROM student s LEFT OUTER join professor p
ON s.profno = p.no

-- 지도학생 없는 교수도 조회, 없으면 없다 ㅜ출력
SELECT s.studno, ifnull(s.name, '학생이 없다요'), p.name
FROM student s RIGHT OUTER join professor p
ON s.profno = p.no

/* 오라클 구현 방식 (+)이 붙지 않은 테이블의 모든 레코드 조회. ANSI 방식은 동일 (full outer join 구현됨)

SELECT s.studno, ifnull(s.name, '학생이 없다요'), p.name
FROM student s, professor p
where s.profno(+) = p.no
*/

-- full outer join. 학생 이름, 지도교수 이름 조회 지도교수 없고 지도학생 없어도 조회
SELECT s.name 학생, ifnull(p.name, '교수가 없다') 교수
FROM student s left join professor p
ON s.profno = p.no
UNION
SELECT ifnull(s.name, '가르칠 대상이 없어요') 학생, p.name 교수
FROM student s right join professor p
ON s.profno = p.no

--문) emp, p_Grade tb 조인. 사원이름, 직급, 현재연봉, 해당직급 연봉하/상한 조회. 연봉 (급* 12 + 보) * 1만. 보없 0. 모든사원 출력
SELECT e.ename, e.job, (e.salary * 12 + ifnull(bonus, 0)) * 10000 연봉, p.s_pay 하한, p.e_pay 상한
FROM emp e left outer join p_grade p
ON e.job = p.position
ORDER BY 연봉 desc

--문) 사원이름, 입사일, 직급, 예상직급, 근속년도, 현재직급, 근속년도기준 예상직급 출력
-- 근속년도는 오늘을 기준으로 정수(소수점 버림)
SELECT e.ename, e.hiredate, e.job, truncate(DATEDIFF(NOW(), e.hiredate)/365, 0) 근속년수, p.position
FROM emp e LEFT join p_grade p
ON truncate(DATEDIFF(NOW(), e.hiredate)/365, 0) between p.s_year AND p.e_year

--문) 사원 이름, 생일, 나이, 현재직급, 나이기준 예상직급 출력
-- 나이는 정수, 생일로 처리. 모든사원 출력
SELECT e.ename, e.birthday, TRUNCATE(DATEDIFF(NOW(), e.birthday)/365, 0) 나이, e.job 현재직급, p.position 예상직급
FROM emp e LEFT join p_grade p
ON TRUNCATE(DATEDIFF(NOW(), e.birthday)/365, 0) BETWEEN s_age AND e_age
ORDER BY e.birthday

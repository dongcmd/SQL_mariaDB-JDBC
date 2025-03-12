-- 1. 지도 교수가 지도하는 학생의 인원수를 출력하기.
SELECT p.name, p.no, COUNT(s.name)
FROM professor p LEFT outer join student s
ON p.no = s.profno
GROUP BY p.name
ORDER BY COUNT(s.name) DESC

SELECT * from student
SELECT * FROM professor
-- 2. 지도 교수가 지도하는  학생의 인원수가 2명이상인 지도교수 이름를 
-- 출력하기.
SELECT p.name, COUNT(*)
FROM professor p join student s
ON p.no = s.profno
GROUP BY p.name
HAVING COUNT(*) >= 2
ORDER BY 2 desc

SELECT p.name, COUNT(*)
FROM professor p, student s
where p.no = s.profno
GROUP BY p.name
HAVING COUNT(*) >= 2

-- 3. 지도 교수가 지도하는  학생의 인원수가 2명이상인 
-- 지도교수 번호,이름,학과코드,학과명 출력하기.

SELECT p.no, p.name, p.deptno, m.name -- , count(*) 지도학생수
FROM professor p join student s
ON p.no = s.profno
JOIN major m
ON p.deptno = m.code
GROUP BY p.no
HAVING COUNT(*) >= 2

SELECT p.no, p.name, p.deptno, m.name, COUNT(*)
FROM professor p, student s, major m
WHERE p.no = s.profno AND p.deptno = m.code
GROUP BY p.no
HAVING COUNT(s.name) >= 2

-- 4. 학생의 이름과 지도교수 이름 조회하기. 
--    지도 교수가 없는 학생과 지도 학생이  없는 교수도 조회하기
--    단 지도교수가 없는 학생의 지도교수는  '0000' 으로 출력하고
--    지도 학생이 없는 교수의 지도학생은 '****' 로 출력하기
SELECT s.name, ifnull(p.name, '0000')
FROM student s LEFT join professor p
ON s.profno = p.no
UNION
SELECT ifnull(s.name, '****'), p.name
FROM student s right join professor p
ON s.profno = p.no

-- 5. 지도 교수가 지도하는 학생의 인원수를 출력하기.
--    단 지도학생이 없는 교수의 인원수 0으로 출력하기
--    지도교수번호, 지도교수이름, 지도학생인원수를 출력하기
SELECT p.no, p.name, COUNT(s.name)
FROM professor p LEFT JOIN student s
ON p.no = s.profno
GROUP BY p.no

-- 6.교수 중 지도학생이 없는 교수의 번호,이름, 학과번호, 학과명 출력하기
SELECT  p.no, p.name, p.deptno, m.`name`



SELECT COUNT(s.name), p.no, p.name, p.deptno, m.name
FROM professor p JOIN student s
ON p.no = s.profno
JOIN major m
ON p.deptno = m.code
GROUP BY p.no
HAVING COUNT(*) >= 2


-- 7. emp 테이블에서 사원번호, 사원명,직급,  상사이름, 상사직급 출력하기
--   모든 사원이 출력되어야 한다.
--    상사가 없는 사원은 상사이름을 '상사없음'으로  출력하기
SELECT e1.empno, e1.ename, e1.job, ifnull(e2.ename, '상사없음'),ifnull(e2.job, '')
FROM emp e1 left join emp e2
ON e1.mgr = e2.empno

-- 8.교수 테이블에서 송승환교수보다 나중에 입사한 
-- 교수의 이름, 입사일,학과코드,학과명을 출력하기 

SELECT p2.name, p2.hiredate, p2.deptno, m.`name`
FROM professor p1 JOIN professor p2
ON p1.name = '송승환' AND p1.hiredate < p2.hiredate
JOIN major m
ON p2.deptno = m.code



-- 9.학생 중 2학년 학생의 최대 체중보다 
-- 체중이 큰 1학년 학생의 이름, 몸무게, 키를 출력하기
SELECT s1.grade, s1.NAME, s1.weight, s1.height, max(s2.weight)
FROM student s1 join student s2
ON s1.grade = 1 AND s2.grade = 2
GROUP BY s1.name
HAVING MAX(s2.weight) < s1.weight


-- 10.학생테이블에서 전공학과가 101번인 학과의 평균몸무게보다
--   몸무게가 많은 학생들의 이름과 몸무게, 학과명 출력
SELECT s2.name, s2.weight, m.`name`
FROM student s1, student s2, major m
WHERE s1.major1 = '101' AND s2.major1 = m.code
GROUP BY s2.name
HAVING AVG(s1.weight) < s2.weight

-- 11.이상미 교수와 같은 입사일에 입사한 교수 중 이영택교수 보다 
--   월급을 적게받는 교수의 이름, 급여, 입사일 출력하기
SELECT p2.NAME, p2.salary, p2.hiredate
FROM professor p1, professor p2, professor p3
WHERE p1.`name` = '이상미' AND p1.hiredate = p2.hiredate AND p3.name = '이영택' AND p2.salary < p3.salary


-- 12. 101번 학과 학생들의 평균 몸무게 보다  
--   몸무게가 적은 학생의 학번과,이름과, 학과번호, 몸무게를 출력하기
SELECT s2.studno, s2.name, s2.major1, s2.weight
FROM student s1 join student s2
ON s1.major1 = 101
GROUP BY s2.studno
HAVING AVG(s1.weight) > s2.weight

-- 13. score 테이블과, scorebase 테이블을 이용하여 학점별 인원수,학점별평균값의 평균  조회하기
SELECT sb.grade, count(sc.studno), AVG((sc.kor+sc.math+sc.eng)/3)
FROM score sc, scorebase sb
WHERE ROUND((sc.kor+sc.math+sc.eng)/3) BETWEEN sb.min_point AND sb.max_point
GROUP BY SB.GRADE

SELECT * from scorebase

-- 14. 고객의 포인트로 상품을 받을 수 있을때 필요한 상품의 갯수를 조회하기

-- 15. 교수번호,이름,입사일, 입사일이 늦은 사람의 인원수 조회하기
--  입사일이 늦은 순으로 정렬하여 출력하기

-- 16.  major 테이블에서 학과코드, 학과명, 상위학과코드, 상위학과명 조회하기
-- 모든 학과가 조회됨. => 상위학과가 없는 학과도 조회됨.


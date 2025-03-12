-- 1. 학년의 평균 몸무게가 70보다 큰 학년의 학년와 평균 몸무게 출력하기
SELECT grade, AVG(weight)
FROM student
GROUP BY grade;

SELECT grade, AVG(weight)
FROM student
GROUP BY grade
HAVING AVG(weight) > 70;

 2. '학년별로 평균체중이 가장 적은 학년'의   학년과 평균 체중을 출력하기
SELECT grade, AVG(weight)
FROM student
GROUP BY grade
HAVING AVG(weight) <= ALL (SELECT AVG(weight) FROM student GROUP BY grade)


 3. 전공테이블(major)에서 공과대학(deptno=10)에 소속된  학과이름을 출력하기
SELECT major.`name`
FROM major
WHERE part = (SELECT code FROM major WHERE NAME = '공과대학')

-- 4. '자신의 학과 학생들'의 평균 몸무게 보다 몸무게가 적은   학생의 학번과,이름과, 학과번호, 몸무게를 출력하기
SELECT studno, NAME, major1, weight, (SELECT AVG(weight) FROM student s2 WHERE s1.major1 = s2.major1)
FROM student s1
WHERE weight < (SELECT AVG(weight) FROM student s2 WHERE s1.major1 = s2.major1);

SELECT s1.studno, s1.name, s1.major1, s1.weight, AVG(s2.weight)
FROM student s1, student s2
WHERE s1.major1 = s2.major1
GROUP BY s1.studno
HAVING s1.weight < avg(s2.weight)


 
-- 5. 학번이 220212학생과 학년이 같고 키는  210115학생보다  큰 학생의 이름, 학년, 키를 출력하기
SELECT NAME, grade, height, (SELECT height FROM student WHERE studno = 210115) 기준키
FROM student
WHERE grade = (SELECT grade FROM student WHERE studno = 220212)
 AND height > (SELECT height FROM student WHERE studno = 210115)
 
-- 6. 컴퓨터정보학부에 소속된 모든 학생의 학번,이름, 학과번호, 학과명 출력하기
SELECT s.studno, s.name, s.major1, m.name
FROM student s join major m
ON s.major1 = m.code
WHERE s.major1 IN (
	SELECT m1.code FROM major m1 WHERE m1.part = (
		SELECT m2.code from major m2 WHERE m2.`name` = '컴퓨터정보학부'
		)
);


-- 7. '4학년학생 중 키가 제일 작은 학생'보다  키가 큰 학생의 학번,이름,키를 출력하기
SELECT studno, NAME, height
FROM student
WHERE height > (SELECT MIN(height) FROM student WHERE grade=4);


-- 8. 학생 중에서 생년월일이 가장 빠른 학생의  학번, 이름, 생년월일을 출력하기
SELECT studno, NAME, min(birthday)
FROM student

그 사람이 여럿이면 다 나오게 하기
 9. 학년별  생년월일이 가장 빠른 학생의 학번, 이름, 생년월일,학과명을 출력하기
SELECT grade, studno, NAME, min(birthday)
FROM student
GROUP BY grade;

10. 학과별 입사일 가장 오래된 교수의 교수번호,이름,입사일,학과명 조회하기
SELECT p.NO, p.NAME, max(p.hiredate), m.name
FROM professor p, major m
WHERE p.deptno = m.code;
GROUP BY m.name

SELECT p.NO, p.NAME, max(p.hiredate), m.name
FROM professor p join major m
ON p.deptno = m.code;

-- 11. 4학년학생 중 키가 제일 작은 학생보다  키가 큰 학생의 학번,이름,키를 출력하기


package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
/*
 *  1. dept 테이블을 이용해, 서울지역 레코드만 dept_seoul 테이블로 생성
 *  2. dept_seoul tb에 deptno, dname, loc 레코드 추가
 *  (60, '특수영업부', '서울')
 *  3. deptno이 60인 레코드 특수영업1부로 수정
 *  4. dept_seoul 출력
 */
public class Exam02 {
	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException{
		Connection conn = DBConnection.getConnection();
		Statement stmt = conn.createStatement();
		String sql = "create table dept_seoul as select * from dept where loc = '서울'";
		stmt.execute(sql);
		
		sql = "insert into dept_seoul values (60, '특수영업부', '서울')";
//		sql = "insert into dept_seoul (deptno, dname, loc) values (60, '특수영업부', '서울')";
		stmt.execute(sql);
		System.out.println("*특수영업부 추가*");
		sql = "select * from dept_seoul";
		ResultSet rs = stmt.executeQuery(sql);
		while(rs.next()) {
			System.out.printf("deptno : %s, dname : %s, loc : %s\n", rs.getString("deptno"), rs.getString("dname"), rs.getString("loc"));
		}
		
		sql = "update dept_seoul set dname = '특수영업1부' where deptno = 60";
		stmt.execute(sql);
		
		sql = "select * from dept_seoul";
		rs = stmt.executeQuery(sql);
		System.out.println("*특수영업1부로 변경*");
		while(rs.next()) {
			System.out.printf("deptno : %s, dname : %s, loc : %s\n", rs.getString("deptno"), rs.getString("dname"), rs.getString("loc"));
		}
		stmt.execute("drop table dept_seoul");
	}
}
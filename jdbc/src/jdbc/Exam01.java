package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

// 교수테이블에서 번호, 이름, id, 입사일, 급여, 보너스, 학과코드 출력

public class Exam01 {
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		Class.forName("org.mariadb.jdbc.Driver");
		Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://localhost:3306/gdjdb",
				"gduser",
				"1234");
		Statement stmt = conn.createStatement();
//		ResultSet rs = stmt.executeQuery("select no, name, id, hiredate, salary, bonus, deptno from professor");
		ResultSet rs = stmt.executeQuery("select * from professor");
		int i = 1;
		while(rs.next()) { // 자바는 실행된 컬럼의 순서만 앎
			System.out.printf("%-2d- 번호:%d", i++, rs.getInt("no"));
			System.out.printf(", 이름:%-4s", rs.getString("name"));
			System.out.printf(", id:%-8s", rs.getString("id"));
			System.out.printf(", 입사일:%s", rs.getString("hiredate"));
			System.out.printf(", 급여:%d", rs.getInt("salary"));
			System.out.printf(", 보너스:%3d", rs.getInt("bonus"));
			System.out.printf(", 학과코드:%d\n", rs.getInt("deptno"));
		}
	}

}

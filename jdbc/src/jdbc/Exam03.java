package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

/*
 * 학생의 학번, 이름, 학년, 학과코드, 학과명, 지도교수명 출력
 * 출력시 Header에 컬럼명 출력
 */
public class Exam03 {
	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException {
		Connection conn = DBConnection.getConnection();
		String sql = "select s.studno '학번', s.name '이름', s.grade '학년', s.major1 '학과코드', m.name '학과명', p.name '지도교수' "
				+ "from student s, major m, professor p "
				+ "where s.major1=m.code and s.profno=p.no";
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(sql);
		ResultSetMetaData rsmd = rs.getMetaData();
		int colCnt = rsmd.getColumnCount();
		System.out.println("조회된 컬럼 수 " + colCnt);
		for(int i = 1; i <= colCnt; i++) {
			System.out.printf("%-15s", rsmd.getColumnLabel(i));
		}
		System.out.println();
		while(rs.next()) {
			for(int i = 1; i <= colCnt; i++) {
				System.out.printf("%-15s", rs.getString(i));
			}
			System.out.println();
		}
		
		
		
		
	}

}

package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;

/*
 * ResultSet executeQuery() : select 문장 실행
 * int executeUpdate() : select 문장 이외 구문 실행
 * boolean execute() : 모든 SQL 문장 사용 가능
 * 
 */
public class JDBCEx06_execute {
	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException {
		Connection conn = DBConnection.getConnection();
//		String sql = "select * from student";
		String sql = "delete from depttest2";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
		if(pstmt.execute()) { // SQL 실행 후, select 구문인 경우 true 리턴
			ResultSet rs = pstmt.getResultSet();
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
		else { // select 외 구문일 경우 
			System.out.println("변경된 레코드 건 수 : " + pstmt.getUpdateCount());
		}
	}
}
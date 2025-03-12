package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

/*
 * ResultSetMetaData
 * 	- 조회된 컬럼명, 컬럼 개수 등의 정보 저장 객체
 */
public class JDBCEx05_MetaData {
	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException {
		String sql = "select * from student";
		Connection conn = DBConnection.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(sql);
		// rs : db에서 전달한 데이터 정보
		ResultSet rs = pstmt.executeQuery();
		// rsmd : 결과 데이터의 정보를 저장하고 있는 객체
		ResultSetMetaData rsmd = rs.getMetaData();
		int colCnt = rsmd.getColumnCount(); // 조회된 컬럼의 개수
		System.out.println("조회된 컬럼수 : " + colCnt);
		System.out.printf("%-10s", "컬럼명");
		System.out.printf("%-10s", "컬럼타입");
		System.out.println("NULL 허용");

		for(int i = 1; i <= colCnt; i++) {
			System.out.printf("%-10s", rsmd.getColumnName(i)); // getColumnname(int i) 조회된 i번 컬럼의 이름
			System.out.printf("%s(%d)\t", rsmd.getColumnTypeName(i), // getColumnTypeName(int i) 조회된 i번 컬럼의 타입
					rsmd.getPrecision(i));							// 조회된 i번 컬럼의 타입의 크기
			System.out.printf("%-10s\n", (rsmd.isNullable(i) == 0) ? "NOT NULL" : "NULL"); // 조회된 i번 컬럼이 null 허용여부
		}
	}
}
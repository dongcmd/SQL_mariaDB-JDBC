package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class JDBCEx04_PreparedStatement {
	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException {
		Connection conn = DBConnection.getConnection();
		String sql = "create table login " +
				"(id varchar(10) primary key, password varchar(10))";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		int result = pstmt.executeUpdate();
		System.out.println("login tb create : " + result);
		
		// 데이터 추가
		sql = "insert into login(id, password) values (?, ?)";
		pstmt = conn.prepareStatement(sql); // sql 문자열 db에 전달
		pstmt.setString(1, "hongkd"); // 1번 ?에 "hongkd" 파라미터로 전달
		pstmt.setString(2, "1234"); // 2번 ?에 "1234" 파라미터로 전달
		result = pstmt.executeUpdate(); // hongkd, 1234 데이터가 db에 저장
		System.out.println("hongkd insert : " + result);
		
		pstmt.setString(1, "leemy");
		pstmt.setString(2, "5678");
		result = pstmt.executeUpdate();
		System.out.println("leemy insert : " + result);
		
		// login tb 조회
		sql = "select * from login";
		pstmt = conn.prepareStatement(sql);
		ResultSet rs = pstmt.executeQuery();
		while(rs.next()) {
			System.out.print("id : " + rs.getString(1));
			System.out.println(", password : " + rs.getString(2));
		}
		
		sql = "drop table login";
		pstmt = conn.prepareStatement(sql);
		result = pstmt.executeUpdate();
		System.out.println("login tb drop : " + result);
		
				
	}

}

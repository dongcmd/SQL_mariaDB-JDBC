package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

/*
 * PreparedStatement 예제
 * 		Statement의 하위 인터페이스
 * 		setInt(순서, 값) => 자료형을 인식
 */
public class JDBCEx03_PreparedStatement {
	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException {
		Connection conn = DBConnection.getConnection();
		PreparedStatement pstmt = conn.prepareStatement(
				"select * from student where grade = ?");
		Scanner sc = new Scanner(System.in);
		System.out.println("검색할 학년 입력 ㄱ");
//		int grade = sc.nextInt();
		int grade = 1;
		// setInt(int i, int v) i : ?의 순서(인덱스 1부터 시작), v : ?에 들어갈 값
		pstmt.setInt(1, grade);
		ResultSet rs = pstmt.executeQuery();
		System.out.println("학번\t이름\t학년\t키\t몸무게\t학과코드");
		
		while(rs.next()) {
			System.out.printf("%s\t%s\t%3s\t%5.2f\t%5.2f\t%-5s\n"
					, rs.getString("studno")
					, rs.getString("name")
					, rs.getString("grade")
					, rs.getDouble("height")
					, rs.getDouble("weight")
					, rs.getString("major1")
					);
		}
	}
}

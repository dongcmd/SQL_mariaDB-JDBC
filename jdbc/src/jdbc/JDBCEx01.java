package jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
/*
 * JDBC : 자바 애플리케이션과 DBMS를 연결하기 위한 도구
 * 	1. 드라이버 파일 연결 : classpath 연결 - Build Path 메뉴 이용
 * 	2. JDBC 관련 패키지 : java.sql.*  (SQLException 예외처리 필수)
 *  3. 드라이버 클래스 로드하기
 *  4. DBMS와 Java를 연결하여 객체 생성
 */

public class JDBCEx01 {
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		// 1. Class.forName(String s) : s에 해당하는 클래스를 찾아 클래스 파일을 메모리 로드
		//		mariadb : org.mariadb.jdbc.Driver
		//		oracle : oracle.jdbc.driver.OracleDriver
		Class.forName("org.mariadb.jdbc.Driver");
		
		// 4. conn = DB와 연결 객체
		//	localhost : IP주소.
		//	3306 : port 번호.  (오라클은 1921)
		//	gdjdb : MariaDB에서 설정한 데이터베이스 이름
		// "gduser", "1234" : DB사용자, 비밀번호
		Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://localhost:3306/gdjdb", "gduser", "1234");
		System.out.println("jdbc 연결완");
		// SQL 명령문을 DB에 전달하기 위한 객체(stmt)
		Statement stmt = conn.createStatement();
		// ResultSet executeQuery(String s) : s를 SQL 문장으로 실행해 ResultSet으로 리턴
		// ResultSet : select 구문의 결과를 저장하는 객체
		ResultSet rs = stmt.executeQuery("select * from student");
		int i = 1;
		while(rs.next()) { // 레코드 한개씩 조회
			// getString(String s) : s컬럼의 값을 문자열로 리턴
//			System.out.print(i++ +" - 학번 : " + rs.getString("studno"));
			System.out.print(i++ +" - 학번 : " + rs.getString(1));
			System.out.print(", 이름 : " + rs.getString("name"));
			System.out.print(", 학년 : " + rs.getString("grade"));
			System.out.println(", 학과코드 : " + rs.getString("major1"));
		}
	}
}
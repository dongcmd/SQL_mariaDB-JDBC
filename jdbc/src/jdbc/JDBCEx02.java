package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
/*
 * 	ResultSet executeQuery(String s) : s(select 구문) 실행시 호출. DB로 부터 조회된 레코드 리턴 
 * 		  int executeUpdate(String s) : 실행 후 변경(추가, 변경, 삭제)된 레코드의 개수 리턴
 * 											(DDL) create, drop, alter
 * 											(DML) insert, update, delete 구문에서 사용
 */
public class JDBCEx02 {
	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException{
		Connection conn = DBConnection.getConnection();
		Statement stmt = conn.createStatement();
		String sql = "create table jdbctest (id int primary key, name varchar(100))";
		int result = stmt.executeUpdate(sql); // sql 명령문 실행
		System.out.println("1 결과 : " + result); // 0
		
		sql = "insert into jdbctest values (1, '홍길동')";
		result = stmt.executeUpdate(sql); // sql 명령문 실행
		System.out.println("2 결과 : " + result); // 1
		// 2, '김삿갓' / 3, '이몽룡' 추가
		
		sql = "insert into jdbctest values (2, '김삿갓'), (3, '이몽룡')";
		result = stmt.executeUpdate(sql); // sql 명령문 실행
		System.out.println("3 결과 : " + result); // 2
		
		sql = "select * from jdbctest";
		ResultSet rs = stmt.executeQuery(sql);
		System.out.println("id\tname");
		while(rs.next()) {
			System.out.println(rs.getString(1) + "\t" + rs.getString(2));
		}
		
		sql = "delete from jdbctest";
		result = stmt.executeUpdate(sql);
		System.out.println("4 결과 : " + result); // 3
		
		// jdbctest tb drop 하기
		sql = "drop table jdbctest";
		result = stmt.executeUpdate(sql);
		System.out.println("5 결과 : " + result); // 0
	}
}

package jdbc;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
/*
 * 	외부 파일에서 db관련 설정 내용 저장
 */
public class DBConnection  {
	public static Connection getConnection() throws SQLException, ClassNotFoundException, IOException{
		/*
		 *  Properties : Hashtable의 하위 클래스 (String K, String V). 제네릭표현 X
		 *  			 FileInputStream과 연동하여 Properties 객체로 값 저장.
		 */
		Properties pro = new Properties();
		FileInputStream fis = new FileInputStream("jdbc.properties");
		pro.load(fis); 
		Class.forName(pro.getProperty("driver"));
		
		Connection conn = DriverManager.getConnection(
				pro.getProperty("url"),
				pro.getProperty("user"), pro.getProperty("password"));
		return conn;
	}
}

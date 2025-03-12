import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

/* 모든 sql구문을 처리하기
 * [결과]
sql 구문을 입력하세요(종료:exit)
select * from student where grade = 1
조회된 레코드 수 : 5

studno	name	id	grade	jumin	birthday	tel	height	weight	major1	major2	profno	
240111	강진	kangjin2702	1	0502233234567	1998-02-23	055)333-1234	183	71	101	null	null	
240212	곽종인	kwakjong	1	0508023234567	1998-08-02	051)426-2345	178	65	102	null	null	
240313	박동인	kimdongin	1	0510023234567	1998-10-02	053)566-3456	173	75	103	null	null	
241113	최정현	kimjunghyun	1	0602084234567	1998-02-08	02)6122-4567	170	80	201	null	null	
241213	장영	kimyoung	1	0512083234567	1998-12-08	031)122-5678	183	95	202	null	null	
sql 구문을 입력하세요(종료:exit)

*/
public class Test1 {
	public static void main(String[] args) throws ClassNotFoundException, SQLException, IOException {
		Scanner scan = new Scanner(System.in);
//		while(true) {
			System.out.println("sql 구문을 입력하세요(종료:exit)");
			String sql = "select * from major";
//			String sql = scan.nextLine();
			if (sql.equalsIgnoreCase("exit")) { System.out.println("프종");  //break;
			}
					
			Connection conn = jdbc.DBConnection.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql);
			if(pstmt.execute()) { // select 구문일 경우
				ResultSet rs = pstmt.getResultSet();
				ResultSetMetaData rsmd = rs.getMetaData();
				int colCnt = rsmd.getColumnCount();
				
				Statement stmt = conn.createStatement();
				ResultSet rs2 = stmt.executeQuery("select count(*) from " + rsmd.getTableName(1));
				rs2.next();
				System.out.println("조회된 레코드 수 : " + rs2.getString(1));
				rs.beforeFirst();
				for(int i = 1; i <= colCnt; i++) 
					System.out.printf("%15s", rsmd.getColumnLabel(i));
								
				System.out.println();
				while(rs.next()) {
					for(int i = 1; i <= colCnt; i++) 
						System.out.printf("%15s", rs.getString(i));
					System.out.println(rs.getRow());
				}
				while(rs.next()) {
					for(int i = 1; i <= colCnt; i++) 
						System.out.printf("%15s", rs.getString(i));
					System.out.println(rs.getRow());
				}
			} else  // select 외 구문일 경우
				System.out.println("변경된 레코드 건 수 : " + pstmt.getUpdateCount());
//		}
	}
}

데이터베이스 프로그래밍 기초
=======================
데이터베이스 기초 문법은 TIL_DB에 수록되었으니 참고바랍니다.  
# 5. JSP에서 JDBC 프로그래밍하기   
## 5.1. 드라이버 준비   
데이터베이스에 연결하려면 해당 DBMS를 연결할 수 있는 jar 파일이 필요하다.      
   
* **MySql** : ```mysql-connector-java-5.1.35-bin.jar```
   
## 5.2. JDBC 프로그래밍 코딩 스타일
**JDBC 프로그램 실행 순서**  
   
1. JDBC 드라이버 로딩
2. 데이터베이스 커넥션 구함
3. 쿼리 실행을 위한 Statement 객체 생성  
4. 쿼리 실행 
5. 쿼리 실행 결과 사용 
6. Statement 종료
7. 데이터베이스 커넥션 종료

위 순서에 맞게 작성을 해주어야 한다.

**Statement 사용**
```
// 1. JDBC 드라이버 로딩
  Class.forName("com.mysql.jdbc.Driver");

  String MEMBERID = null;
  String NAME = null;
  String EMAIL= null;

  Connection conn = null;
  Statement stmt = null;
  ResultSet rs = null;
	
  try{
//DB에 연결할 URL , DB_id , DB_pw 지정
	String jdbcDriver = "jdbc:mysql://localhost:3306/chap14?serverTimezone=UTC"; 
//String jdbcDriver = "jdbc:oracle:thin@127.0.0.1:1521>ORCL";  
	String dbUser="jspexam";
	String dbPass="jsppw";
	  
// 쿼리문 지정 (나중에 해도 된다 그냥 정의한 것)
	String query = "SELECT * FROM MEMBER_DTO ORDER BY MEMBERID";
	
// 2. DB 커넥션 생성 (DB와 연결된 Connection 객체 반환)
	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass); // 생성못하면 SQLException 발생

// 3. Statement 생성
	stmt = conn.createStatement();
	
// 4. 쿼리 실행
	rs = stmt.executeQuery(query);
	
// 5. 쿼리 실행 결과 출력
	while(rs.next()){
    MEMBERID = rs.getString("MEMBERID")
		NAME = rs.getString("NAME")
    EMAIL = rs.getString("EMAIL")
	}
	} catch(SQLException ex){
		  out.print(ex.getMessage());
		  ex.printStackTrace();
	} finally { 
    
// 6. 사용한 Statement 종료
		if(rs != null) 
    try{
      rs.close();
    } catch(SQLException ex){
    }
		if(stmt != null)
    try{
      stmt.close();
    } catch(SQLException ex){
    }
		
// 7. 커넥션 종료
		if(conn != null) try{conn.close();} catch(SQLException ex){}
  }
```
**PreparedStatement 사용**   
```
	request.setCharacterEncoding("utf-8");

	String memberID = request.getParameter("memberID");
	String password = request.getParameter("password");
	String name = request.getParameter("name");
	String email = request.getParameter("email");
	
	Class.forName("com.mysql.jdbc.Driver");
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try{
		String jdbcDriver = "jdbc:mysql://localhost:3306/chap14?serverTimezone=UTC";
		String dbUser="jspexam";
		String dbPass="jsppw"; 
		
		String query = "INSERT INTO MEMBER_DTO VALUES(?, ?, ?, ?)";
		
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		pstmt = conn.prepareStatement(query);
		pstmt.setString(1, memberID);
		pstmt.setString(2, password);
		pstmt.setString(3, name);
		pstmt.setString(4, email);
		
		pstmt.executeUpdate();
		
	} catch(SQLException ex){
		ex.getMessage();
		ex.getStackTrace();
	} finally{
		if(pstmt != null) try{pstmt.close();} catch(SQLException ex){}
		if(conn != null) try{conn.close();} catch(SQLException ex){}
	}
```
**PreparedStatement** 는 주로 Insert에 사용되며 ```?```를 사용해서 값을 동적으로 변경할 수 있다.     
그리고 특이점은 PreparedStatement 객체를 생성할 때 쿼리문을 미리 준비시켜 놓는다.     
```
pstmt = conn.prepareStatement(query); // 쿼리 준비
...
pstmt.setString(1, memberID);
pstmt.setString(2, password);
pstmt.setString(3, name);
pstmt.setString(4, email);
...
pstmt.executeUpdate(); // 쿼리 DB에 사용 
```
**비교**
```
Class.forName("com.mysql.jdbc.Driver");
String jdbcDriver = "jdbc:mysql://localhost:3306/chap14?serverTimezone=UTC"; 
conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass); // 생성못하면 SQLException 발생
stmt = conn.createStatement();
rs = stmt.executeQuery(query);
종료 구문
```
```
Class.forName("com.mysql.jdbc.Driver");
String jdbcDriver = "jdbc:mysql://localhost:3306/chap14?serverTimezone=UTC"; 
conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass); // 생성못하면 SQLException 발생
pstmt = conn.prepareStatement(query); // 쿼리 준비
...
pstmt.executeUpdate(); // 쿼리 DB에 사용 
종료 구문
```
## 5.3. Long VARCHAR 타입 값 지정하기
```PreparedStatement```에서 Long VARCHAR 타입의 값을 지정할 때에는 메소드 사용방법이 다르다.  
```
setCharacterStream(int index, Reader reader, int length)
```
Reader로부터 length 글자 수만큼 데이터를 읽어와 저장한다.  
```
PreparedStatement pstmt = null;
try{
  String value = "...";
  pstmt = conn.prepareStatement(...);
  java.io.StringReader reader = new java.io.StringReader(value);
  pstmt.setCharacterStream(1, reader, value.length() );
  ...
} catch(SQLException ex){
  ...
} finally {
  ...
  if (pstmt != null) try {pstmt.close();} catch(SQLException ex) {}
}
```
**텍스트 파일로부터 데이터를 읽어 올 때**
```
PreparedStatement pstmt = null;
FileReader reader =null;
try {
  pstmt = conn.prepareStatement(...);
  reader = new java.io.FileReader(파일경로);
  pstmt.setCharacterStream(1, reader);
  ...
} catch(SQLException ex){
  ...
} finally {
  ...
  if (pstmt != null) try {pstmt.close();} catch(SQLException ex) {}
  if (pstmt != null) try {pstmt.close();} catch(IOException ex) {}
}
```
# 6. 웹 어플리케이션 구동 시 JDBC 드라이버 로딩하기  
'웹 어플리케이션 구동 시 JDBC 드라이버 로딩하기'라는 말은 말 그대로 처음부터 
```Class.forName("com.mysql.jdbc.Driver")```를 자동으로 실행하게끔 설정하는 것이다.  
```
package jdbc;

import javax.servlet.http.HttpServlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;

public class MySQLDriverLoader extends HttpServlet {

	public void init(ServletConfig config) throws ServletException{
		try {
			Class.forName("com.mysql.jdbc.Driver");
		}catch (Exception ex) {
			throw new ServletException(ex);
		}
	}
}
```
**web.xml**
```
	<servlet>
		<servlet-name>mysqlDriverLoader</servlet-name>
		<servlet-class>jdbc.MySQLDriverLoader</servlet-class>
		<load-on-startup>1</load-on-startup>
	</servlet>
```
xml에 이같은 코드를 입력해 놓으면 웹 어플리케이션 실행시 자동으로 해당 클래스를 실행하도록 하는 것이다. 
정확히는 모르겠지만 ```init()``` 메소드를 실행하는 것 같다.

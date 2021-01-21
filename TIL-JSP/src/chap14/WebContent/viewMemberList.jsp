<%@page import="org.apache.jasper.tagplugins.jstl.core.Catch"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원 목록</title>
</head>
<body>

MEMBER 테이블의 내용
<table width="100%" border="1">
	<tr>
		<td>이름</td>
		<td>아이디</td>
		<td>이메일</td>
	</tr>
<%
	// 1. JDBC 드라이버 로딩
	Class.forName("com.mysql.jdbc.Driver");

	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	try{
		String jdbcDriver = "jdbc:mysql://localhost:3306/chap14?serverTimezone=UTC";
		String dbUser="jspexam";
		String dbPass="jsppw";
		
		String query = "SELECT * FROM MEMBER_DTO ORDER BY MEMBERID";
		
	// 2. DB 커넥션 생성 (DB와 연결된 Connection 객체 반환)
	conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	// 생성못하면 SQLException 발생
	
	// 3. Statement 생성
	stmt = conn.createStatement();
	
	// 4. 쿼리 실행
	rs = stmt.executeQuery(query);
	
	// 5. 쿼리 실행 결과 출력
	while(rs.next()){
%>
	<tr>
		<td><%= rs.getString("MEMBERID") %> </td>
		<td><%= rs.getString("NAME") %> </td>
		<td><%= rs.getString("EMAIL") %> </td>
	</tr>
<%		
	 }
	}catch(SQLException ex){
		out.print(ex.getMessage());
		ex.printStackTrace();
	} finally { // 도중에 에러 발생하면 종료 여기서 적당한 값을 받은 변수들에 대해서 해제함
		// 6. 사용한 Statement 종료
		if(rs != null) try{rs.close();} catch(SQLException ex){}
		if(stmt != null) try{stmt.close();} catch(SQLException ex){}
		
		// 7. 커넥션 종료
		if(conn != null) try{conn.close();} catch(SQLException ex){}
	}
%>	
</table>

</body>
</html>
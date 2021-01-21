<%@page import="org.apache.jasper.tagplugins.jstl.core.Catch"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.SQLException"%>
<%@ page import="java.io.Reader"%>
<%@ page import="java.io.IOException"%>

<%
	String memberID = request.getParameter("memberID");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원 정보</title>
</head>
<body>

<%
	Class.forName("com.mysql.jdbc.Driver");

	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	
	try{
		String jdbcDriver = "jdbc:mysql://localhost:3306/chap14?serverTimezone=UTC";
		String dbUser="jspexam";
		String dbPass="jsppw";
		
		String query = "SELECT * FROM MEMBER_HISTORY where MEMBERID = '"+memberID+"'";
		
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
	
		stmt = conn.createStatement();
	
		rs = stmt.executeQuery(query);
	
		if(rs.next()){
%>	
<table border="1">
	<tr>
		<td>아이디</td><td><%= rs.getString("MEMBERID") %> </td>
	</tr>
	<tr>
		<td>히스토리</td>
		<td>
<%
			String history = null;
			Reader reader = null;
			try{
				reader = rs.getCharacterStream("HISTORY");
				
				if(reader != null){
					StringBuilder buff = new StringBuilder();
					char[] ch = new char[512];
					int len = -1;
					
					while((len = reader.read(ch)) != -1 ){
						buff.append(ch, 0, len);
					}
					history = buff.toString();
				}
			}catch(IOException ex){
				out.println("익셉션 발생:" + ex.getMessage());
			} finally{
				if(reader != null) try{reader.close();} catch(IOException ex){} 
			}
%>		
		<%= history %>
		</td>
	</tr>
</table>
<%
	} else {
%>
<%= memberID %>에 해당하는 정보가 존재하지 않습니다.  
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

</body>
</html>
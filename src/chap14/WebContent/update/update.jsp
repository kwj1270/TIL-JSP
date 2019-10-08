<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.SQLException"%>

<%
	request.setCharacterEncoding("utf-8");
	String memberID = request.getParameter("memberID");
	String name = request.getParameter("name");
	
	int updateCount = 0;
	
	Class.forName("com.mysql.jdbc.Driver");
	
	Connection conn = null;
	Statement stmt = null;
	
	try{
		String jdbcDriver = "jdbc:mysql://localhost:3306/chap14?serverTimezone=UTC";
		String dbUser="jspexam";
		String dbPass="jsppw"; 
		
		String query = "update MEMBER_DTO set NAME = '" + name +"'"+
					"where MEMBERID = '"+memberID+"'";
		
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		stmt = conn.createStatement();
		updateCount = stmt.executeUpdate(query);
		
	} catch(SQLException ex){
		ex.getMessage();
		ex.getStackTrace();
	} finally{
		if(stmt != null) try{stmt.close();} catch(SQLException ex){}
		if(conn != null) try{conn.close();} catch(SQLException ex){}
	}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>이름 변경</title>
</head>
<body>
<% if(updateCount > 0) {%>
<%= memberID %>의 이름은 <%= name %>(으)로 변경
<%} else{ %>
<%= memberID %>가 존재하지 않음
<% } %>
</body>
</html>
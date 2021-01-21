<%@page import="java.sql.PreparedStatement"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.Catch"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.SQLException"%>

<%
	String idValue = request.getParameter("id");

	// Class.forName("com.mysql.jdbc.Driver"); 초기 설정함

	Connection conn = null;
	PreparedStatement pstmtItem = null;
	PreparedStatement pstmtDetail = null;
	
	String jdbcDriver = "jdbc:mysql://localhost:3306/chap14?serverTimezone=UTC";
	String dbUser="jspexam";
	String dbPass="jsppw";
	
	Throwable occuredException = null;
	
	try{
		int id = Integer.parseInt(idValue);
		
		conn = DriverManager.getConnection(jdbcDriver, dbUser, dbPass);
		conn.setAutoCommit(false);
		
		pstmtItem = conn.prepareStatement("INSERT INTO item VALUES(?, ?)");
		pstmtItem.setInt(1, id);
		pstmtItem.setString(2, "상품이름" + id);
		pstmtItem.executeUpdate();
		
		if(request.getParameter("error") != null){
			throw new Exception("의도적인 익셉션 발생");
		}
		
		pstmtDetail = conn.prepareStatement("INSERT INTO item_detail VALUES(?, ?)");
		pstmtDetail.setInt(1, id);
		pstmtDetail.setString(2, "상세 설명" + id);
		pstmtDetail.executeUpdate();
		
		conn.commit();
	} catch(Throwable e){
		if(conn != null){
			try{
				conn.rollback();
			} catch(SQLException ex){}
		}
		occuredException = e;
	} finally {
		if(pstmtItem != null){
			try{ pstmtItem.close();} catch(SQLException ex){}
		}
		
		if(pstmtDetail != null){
			try{ pstmtDetail.close();} catch(SQLException ex){}
		}			
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ITEM 값 입력</title>
</head>
<body>	

<% if(occuredException != null) {%>
에러가 발생하였습니다. : <%= occuredException.getMessage()  %>
<% } else { %>
데이터가 성공적으로 들어감
<% } %>

</body>
</html>
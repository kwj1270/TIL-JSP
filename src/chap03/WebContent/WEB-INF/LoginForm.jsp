<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그인 화면 입니다.</title>
</head>
<body>
	<form action="/identification/RequestForm.jsp" method="post">
		아이디 : <input type="text" maxlength="20" size="10" placeholder="아이디를 입력해주세요" required autofocus>
		비밀번호 : <input type="password" maxlength="20" size="10" placeholder="패스워드를 입력해주세요" required>
		<input type="submit" value="로그인" width="10" height="10">
	</form>
</body>
</html>
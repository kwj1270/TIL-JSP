JSP로 시작하는 웹 프로그래밍-3
=======================
# 5. request 기본 객체
```request``` 기본 객체는 JSP 페이지에서 가장 많이 사용되는 기본 객체로서  
웹 브라우저의 **요청**과 관련이 있다.
  
웹 브라우저에 웹 사이트의 주소를 입력하면,  
웹 브라우저는 해당 웹 서버에 연결한 후 요청 정보를 전송하는데,  
이 **요청 정보를 제공하는 것**이 바로 **request 기본 객체**이다.  
즉 request 기본 객체는 '요청 정보'라고 보면된다.    

**request 기본 객체가 제공하는 기능**   
  
* 클라이언트(웹 브라우저)와 관련된 정보 읽기 기능
* 서버와 관련된 정보 읽기 기능
* 클라이언트가 전송한 요청 파라미터 읽기 기능
* 클라이언트가 전송한 요청 헤더 읽기 기능
* 클라이언트가 전송한 쿠키 읽기 기능
* 속성 처리 기능

## 5.1. 클라이언트 정보 및 서버 정보 읽기
request 기본 객체를 이용하여  
웹 클라이언트(웹 브라우저)가 전송한 정보와 서버 정보를 구할 수 있는 메소드들이 있다.`
```
getRemoteAddr()         | String  | 웹 서버에 연결한 클라이언트(웹 브라우저)의 IP주소를 구한다.
getContentLength()      | long    | 클라이언트가 전송한 요청 정보의 길이를 구한다. (알 수 없으면 -1)
getCharacterEncoding()  | String  | 클라이언트가 요청 정보를 전송할 때 사용한 캐릭터 인코딩을 구한다.
getContentType()        | String  | 클라이언트가 요청 정보를 전송할 때 사용한 컨텐츠의 타입을 구한다.
getProtocol()           | String  | 클라이언트가 요청한 프로토콜을 구한다.
getMethod()             | String  | 웹 브라우저가 정보를 전송할 때 사용한 방식을 구한다.
getRequestURI()         | String  | 웹 브라우저가 요청한 URL에서 경로를 구한다.
getContextPath()        | String  | JSP 페이지가 속한 웹 어플리케이션의 컨텍스트 경로를 구한다.
getServerName()         | String  | 연결할 때 사용한 서버 이름을 구한다.
getServerPort()         | int     | 서버가 실행중인 포트 번호를 구한다.
```
**에제**
```
<% @page contentType ="text/html; charset=utf-8" %>
<html>
<head><title>클라이언트 및 서버 정보</title></head>
<body>

클라이언트IP = <%= request.getRemoteAddr() %><br>
요청정보길이 = <%= request.getContentLength() %><br>
요청정보 인코딩 = <%= request.getCharacterEncoding() %><br>
요청정보 컨텐츠타입 = <%= request.getContentType() %><br>
요청정보 프로토콜 = <%= request.getProtocol() %><br>
요청정보 정보방식 = <%= request.getMethod() %><br>
요청URI = <%= request.getRequestURI() %><br>
컨텍스트 경로 = <%= request.getContextPath() %><br>
서버이름 = <%= request.getServerName() %><br>
서버포트 = <%= request.getServerPort() %><br>

</body>
</html>
```
```
http://localhost:8080/chap03/requestInfo.jsp

request.getServerName() : localhost:
request.getServerPort() : 8080
request.getRequestURI() : /chap03/requestInfo.jsp
```
## 5.2. 요청 파라미터 처리
### 5.2.1. HTML 폼과 요청 파라미터
```
<form action="chap03/viewParameter.jsp" method="post">
이름: <input type="text" name="name" size="10"><br>
주소: <input type="text" name="address" size="30"><br>
좋아하는 동물:
  <input type="checkbox" name="pet" value="dog">강아지
  <input type="checkbox" name="pet" value="cat">고양이
  <input type="checkbox" name="pet" value="pig">돼지
<br>
<input type="submit" value="전송">
</form> 
```       
입력 요소의 ```name``` 속성은    
웹 브라우저가 서버에 전송하는 요청 파라미터의 이름으로 사용된다.     
예를 들어, 이름 입력 요소와 주소 입력에 각각 "홍길동"과 "전주시"를 입력한 후 전송 버튼을 누르면     
    
**파라미터**
```
name=홍길동
address=전주시
```
```파라미터이름=값```형식으로 파라미터 목록을 웹 서버에 전송한다.    
이제 웹서버에서는 요청 파라미터를 이용해서 알맞은 기능을 구현해야 한다.  
  
### 5.2.2. request 기본 객체의 요청 파라미터 관련 메서드
request 기본 객체는 웹 브라우저가 전송한 파라미터를 읽어올 수 있는 메서드를 제공하고 있다.  
```
getParameter(String name)       | String                | 이름이 name 인 파라미터를 구한다. (존재X는 NULL)
getParameterValues(String name) | String[]              | 이름이 name 인 모든 파라미터의 값을 배열로 구한다.
getParameterNames()             | java.util.Enumeration | 웹 브라우저가 전송한 파라미터의 이름 목록을 구한다.
getParameterMap()                | java.util.Map         | 웹 브라우저가 전송한 파라미터의 맵을 구한다.

맵은 <파라미터 이름, 값>쌍으로 구성된다.
```
이제 예제를 통해서 전체 메소드의 동작 방식을 알아보자    
  
**요청 전송 폼 예시**
```
<% @page contentType="text/html; charset=utf-8" %>
<html>
<head><title>폼 생성</title></head>
<body>

<form action="chap03/viewParameter.jsp" method="post">
이름: <input type="text" name="name" size="10"><br>
주소: <input type="text" name="address" size="30"><br>
좋아하는 동물:
  <input type="checkbox" name="pet" value="dog">강아지
  <input type="checkbox" name="pet" value="cat">고양이
  <input type="checkbox" name="pet" value="pig">돼지
<br>
<input type="submit" value="전송">
</form>
</body>
</html>
```
**요청 처리 JSP 예시**
```
<% @page contentType="text/html; charset=utf-8" %>
<% @page import="java.util.Enumeration" %>
<% @page import="java.util.Map" %>
<%
  request.setCharacterEncoding("utf-8");
%>
<html>
<head><title>요청 파라미터 출력</title></head>
<body>
<b>request.getParameter() 메서드 사용</b><br>
name 파라미터 = <%= request.getParameter("name") %><br>
address 파라미터 = <%= request.getParameter("address") %>
<p>
<b>request.getParameterValues() 메서드 사용</b><br>
<%
  String[] values = request.getParameterValues();
  if(values !=null){
    for(int i = 0; i < values.length ; i++){
%>
  <%= values[i] %>
<%
    }
  }
%>
<p>
<b>request.getParameterNames() 메서드 사용</b><br>
<%
  Enumeration paramEnum = request.getParameterNames();
  while(paramEnum.hasMoreElements()){
    String name= (String)paramEnum.nextElement();
%>
  <%= name%>
<%
  }  
%>
<p>
<b>getParameterMap() 메서드 사용</b><br>
<%
  Map parameterMap = request.getParameterNames();
  String[] nameParam = (String[])parameterMap.get("name") // 키 값 넣으면 된다.
  if(nameParam != null){
%>
  name = <%= nameParam[0] %>
<%
  }
%>
</body>
</html>
```
```
name="name"     텍스트 필드에는 홍길동 입력
name="address"  텍스트 필드에는 전주시 입력
name="pet"      체크박스에는 강아지, 고양이 클릭(체크)
```
**결과**
```
request.getParameter() 메서드 사용
name 파라미터 = 홍길동
address 파라미터 = 전주시

request.getParameterValues() 메서드 사용
dog cat

request.getParameterNames() 메서드 사용
name address pet

request.getParameterMap() 메서드 사용
name = 홍길동
```
위 코드를 하나씩 분석해보자  
   
**getParameterValues()**
매개변수 ```(String name)``` 에 ```"name"```과 ```"adress"```를 주었다.    
이는 기존 ```<input> 요소```에서의 **name 속성의 값**을 의미한다.    
그리하여 기존 ```<input> 요소```의 ```value값```을 가져와 출력을 하는데      
텍스트 타입은 텍스트 필드에 입력된 값이 value의 값이 되니 이를 출력하고 있다.  
  
**getParameterNames()**
```getParameterNames()```는 모든 요소의 ```name 속성의 값```을 의미하고  
이를 ```java.util.Enumeration```

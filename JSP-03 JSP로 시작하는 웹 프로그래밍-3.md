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
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Map" %>
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
  String[] values = request.getParameterValues("pet");  //.getParameterValues();
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
  Map parameterMap = request.getParameterMap();
  String[] nameParam = (String[])parameterMap.get("name"); // 키 값 넣으면 된다.
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
이를 ```java.util.Enumeration```형식으로 반환한다.    
 ```java.util.Enumeration```은 열거형을 의미하는 인터페이스로      
 ```iterator``` 반복자와 비슷한 기능을 가지고 있는 컬렉션프레임워크에 접근하는 인터페이스다.     
 내장된 메소드는 ```hasMoreElements()``` ```nextElement()```로서      
 ```hasMoreElements()```사용시 현재 번지에 저장된 값이 있는지 없는지 여부를 판단하는 것이고   
 ```nextElement()``` 사용시 현재 번지의 값을 리턴하고 다음 위치로 이동하는 메소드이다.      
흔히 다음 번지에 저장된 값을 찾고 사용하는 것으로 햇갈리기 쉬운데 사실 내부적으로 이렇게 동작한다.       
       
**getParameterMap()**   
```getParameterMap```은 자바스크립트의 객체(또는 맵)처럼 ```Key```와 ```Value``` 형태로 값을 리턴한다(Map)     
그래서 이를 ```get(Key값)```을 입력하면 해당 하는 ```Value``` 값이 반환된다.     
여기서 ```Value```는 일반적인 값 이외에도 배열이나 객체를 저장해도 되므로    
안정성을 위하여 ```String[] nameParam = (String[])parameterMap.get("name")```와 같이 ```String배열```에 저장시킨다.   
  
### 5.2.3. GET 방식 전송과 POST 방식 전송
웹 브라우저는 ```GET 방식```과 ```POST 방식```의 두 가지 방식 중 한 가지를 이용해서 파라미터를 전송한다.  
전송 방식에 따라 동작하는 방법이 많이 다르니 기억해두자
  
**GET 방식**
```
<form action="전송경로" method="get">...</form>
__________________________________________________
주소창 결과)

http://localhost:8080/chap03/viewParameter.jsp?name=%ED%..중략..&pet=dog&pet=cat
```    
이렇듯 ```GET 방식```은 URL의 경로 뒤에 물음표```(?)```와 함께 쿼리 문자열을 보낸다.          
여기서 사용된 쿼리 문자열은 바로 전송하는 파라미터의 데이터의 값이라고 생각하면 된다.        
```GET 방식```은 이러한 특징이 있기에 따로 폼요소를 사용하지 않고 위에 결과처럼 문자열을 붙여서 사용하는 방법도 있다.       
  
**GET 방식 사용방법**  
  
1. <a> 태그의 링크 태그에 쿼리 문자열 추가(href=""에 쿼리 문자열)
2. <form> 태그의 method 속성 값 (method="get/post")
3. 웹 브라우저에 주소에 직접 쿼리 문자열을 포함
    
```  
GET /chap03/viewParameter.jsp?name=%ED%..중략..&pet=dog&pet=cat HTTP/1.1        // <-- 여기 파라미터 붙임
HOST: localhost:8080  
Connection: keep-alive
Accept: text/html,application/xhtml+xml,...생략
User-Agent: Mozlia/5.0 ...생략
Accept-Encoding:gzip, deflate
Accept-Language: en-US;q=0.8,en;q=0.5
Cache-Control: max-age=0   
```  
또한, ```GET 방식```을 이용해서 파라미터를 전송시, 요청 데이터의 요청줄에 파라미터를 포함시킨다.      
이는 한편으로 보안에 문제가 생길 수 있는 요소이다.        
       
**POST 방식**   
```
<form action="전송경로" method="post">...</form>
__________________________________________________
주소창 결과)

http://localhost:8080/chap03/viewParameter.jsp
```
```GET 방식```과 다르게 ```POST```방식은 요청 데이터에 파라미터를 포함시키지 않는다.   
```  
POST /chap03/viewParameter.jsp HTTP/1.1        // <-- 여기 파라미터 붙임
HOST: localhost:8080  
Connection: keep-alive
Conntent-Length: 30
Accept: text/html,application/xhtml+xml,...생략
Origign: localhost:8080  
User-Agent: Mozlia/5.0 ...생략
Content-Type:application/x-www-form-urlencodeed
Referer: http://localhost:8080/chap03/form.jsp
Accept-Encoding:gzip, deflate
Accept-Language: en-US;q=0.8,en;q=0.6
Cache-Control: max-age=0   
Cookie:JSESSIONID=8D2476E3EB99C478A04BB59CEBC3858C

name=cbk&address=seoul&pet=cat
``` 
또한 요청 데이터의 요청줄에도 파라미터의 값을 포함시키지 않는다.      
단, 마지막에 헤더 형식이 아닌 단순 ```이름&값``` 형식으로 파라미터 값을 추가시킨다.      
    
```GET 방식``` 웹브라우저, 웹 서버 또는 웹 컨테이너에 따라 전송할 수 있는 파라미터 값의 길이에 제한이 있을수 있다.         
반면에 ```POST```방식은 데이터 영역을 이용해서 데이터를 전송하기 때문에      
웹 브라우저나 웹 서버 등에 상관없이 전송할 수 있는 파라미터의 길이에 제한이 없다.    
또한, ```GET 방식```과 달리 URL에 쿼리 문자열이 없기에 비교적 보안적이라고 할 수 있다.  
  
### 5.2.4. 요청 파라미터 인코딩
**인코딩** : 웹 브라우저가 웹서버에 파라미터를 전송할 때 알맞은 캐릭터 셋을 이용해서 파라미터 값을 변환 시키는 것      
**디코딩** : 웹 서버가 요청받은 인코딩 된 파라미터 값을 알맞은 캐릭터 셋을 통해 원래의 파라미터 값으로 변환 시키는 것      
  
인코딩 방식은 ```요청 방식```에 따라 다르다.    
   
**GET 인코딩 방식**   
```   
1. <a> 태그의 링크 태그에 쿼리 문자열 추가(href=""에 쿼리 문자열)  | 웹 페이지 인코딩 사용   
2. <form> 태그의 method 속성 값 (method="get/post")               | 웹 페이지 인코딩 사용   
3. 웹 브라우저에 주소에 직접 쿼리 문자열을 포함                    | 웹 브라우저마다 다름    
```
**웹 페이지 인코딩 사용** 이란 말은 ```pageEncoding```이나 ```contentType의 charset=""```을 의미한다.       
그러나 주소에서 직접 쿼리 문자열을 사용하는 ```GET 방식```을 사용할 경우 브라우저 마다 처리 방식이 다르다.   
    
**GET 디코딩 방식**   
```GET 방식```은 일반적으로 디코딩을 설정하는 ```request.setCharacterEncoding(캐릭터 셋)```을 사용하지 못한다.   
톰캣에서는 ```GET 방식```으로 넘어온 파라미터의 값을 기본적으로 ```UTF-8```로 처리한다.    
하지만 ```UTF-8```이 아닌 다른 캐릭터 셋일 경우 추가 설정을 해주어야 한다.         
    
* server.xml 파일에서 ```<Connector>```의 ```useBodyEncodingForURI``` 속성의 값을 ```true```로 한다.     
      
기본적으로 제공하는  ```<Connector>```태그에는 ```useBodyEncodingForURI```가 없으므로 이를 추가하고 값을 넣어주자     
```
<Connector port="8080" protocol="HTTP/1.1"
           connectionTimeout="20000"
           redirectPort="8443"
           useBodyEncodingForURI="true" 또는 URIEncoding 속성을 사용할 수도 있다.  
>   
```
이로인해 ```GET 방식```도 디코딩을 설정하는 ```request.setCharacterEncoding(캐릭터 셋)```을 사용할 수 있게 된다.   
  
**POST 인코딩 방식**      
```post 방식```은 기본적으로 웹 페이지의 인코딩 방식을 따른다.      
즉, ```pageEncoding```이나 ```contentType의 charset=""```을 사용한다는 것이다.    
  
**POST 디코딩 방식**     
```post 방식``` 일반적으로 디코딩을 처리해주는 ```request.setCharacterEncoding(캐릭터 셋)```을 사용한다.
```
<%
  request.setCharacterEncoding("utf-8");
  String name=requset.getParameter("addresss");
%>
```
  
## 5.3. 요청 헤더 정보의 처리
HTTP 프로토콜은 헤더 정보에 부가적인 정보를 담도록 하고 있다.    
예를 들어, 웹 브라우저는 웹 브라우저의 종류, 선호하는 언어에 대한 정보를 헤더에 담아서 전송한다.    
   
requset 기본 객체는 이러한 헤더 정보를 읽어올 수 있는 기능을 제공하고 있다.  
```
getHeader(String name)        | String                | 지정한 헤더의 값을 구한다.    
getHeaders(String name)       | java.util.Enumertaion | 지정한 헤더의 목록을 구한다.
getHeaderNames()              | java.util.Enumeration | 모든 헤더의 이름을 구분한다.
getIntHeader(String name)     | int                   | 지정한 헤더의 값을 정수로 읽어온다.
getDateHeader(String name)    | long                  | 지정한 헤더의 값을 시간값으로 읽어온다.
                                                      | 단 시간은 1970년 1월 1일 기준 밀리세컨드 단위
```
```getHeader(String name)```은 ```name```에 알맞은 헤더의 이름을 입력하면 그 값을 String으로 리턴한다.     
```getHeaders(String name)```은 ```name```에 알맞은 헤더의 이름을 입력하면 헤더의 목록을 리턴한다.    
```getHeaderNames() ```은 모든 헤더의 이름을 반환한다.    
```getIntHeader(String name)``` ```name```에 해당되는 헤더의 값을 ```int```형으로 리턴한다.   
```getDateHeader(String name)``` ```name```에 해당되는 헤더의 값을 ```long```형으로 리턴한다.  
정확히 말하면 ```현재시간 - 1970년 1월 1일``` 시간의 밀리세컨드 단위 초의 값을 나타낸다.     
  
**간단한 사용법**
```
<%
  Enumeration headerEnum = request.getHeaderNames();
  while(headerEnum.hasMoreElements()){
    String headerName = (String)headerEnum.nextElement();
    String headerValue = request.getHeader(headerName);
%>
  <%= headerName %> = <%= headerValue %> <br>
<%
  }
%>
```

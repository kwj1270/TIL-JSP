JSP로 시작하는 웹 프로그래밍 정리
=======================
# 1. 
page 디렉티브는 JSP 페이지에 대한 정보를 입력하기 위해서 사용된다.  
```
<% @page 속성 = "값" 속성2 = "값2" ... %>

디렉티브 이름이 page인 것을 'page 디렉티브' 라고 한다.
```
```
____________________________________________________________________________________________________________________________________
| 속성                               | 설명                                                       | 기본 값                         |   
|____________________________________|____________________________________________________________|_________________________________|
|contentType                         | JSP가 생성할 문서의 MIME 타입과 캐릭터 인코딩(차순)을 지정  | text/html                       |
|import                              | JSP 페이지에서 사용할 자바 클래스를 지정한다.               |                                 | 
|session                             | JSP 페이지가 세션을 사용할지의 여부를 정한다.               | true                            |
|buffer                              | JSP 페이지의 출력 버퍼 크기를 지정, "none"시에 사용X        | 최소 8KB (입력시 KB 입력해야함)  |
|autoFlush                           | 자동 버퍼 비우기(출력) 여부를 판단                          | true (false시 에러 발생)         |
|info                                | JSP 페이지에 대한 설명을 입력                               |                                 |
|errorPage                           | JSP 페이지를 실행하는 도중에 에러 발생시 보여줄 페이지 지정  |                                 | 
|isErrorPage                         | 현재 페이지가 에러페이지인지의 여부를 지정                  | false                           |  
|pageEncoding                        | JSP 페이지 소스 코드의 캐릭터 인코딩을 지정 (우선순위)      |                                 |
|isELIgnored                         | 표현 언어에 대한 해석 여부를 지정 (true 면 해석 X)          | false                           |
|deferredSyntaxAllowedAsLiteral      | #{ 문자가 문자열 값으로 사용되는 여부를 지정                | false                           |
|trimDirectiveWhitespaces            | 출력 결과에서 템플릿 텍스트의 공백 문자 제거 여부를 지정     | false                           |
|____________________________________|____________________________________________________________|_________________________________|
```
참고로 인코딩은    
1. ```pageEncoding``` 1순위    
2. ```contentType``` 2순위    
3. 둘 다 없으면 기본 값인 ISO-8859-1을 캐릭터 셋으로 사용.   
   
둘 다 있는데 값이 다르면  
```pageEncoding``` 속성은 JSP 파일을 인코딩하고   
```contentType``` 속성은 응답 결과를 인코딩한다.  

디코딩은
```
<%
requset.setCharacterEncoding("UTF-8");
%>
```
  
# 2.
JSP에서 문서의 내용을 동적으로 생성하기 위해 사용되는 것이 스크립트 요소이다.  
  
* **표현식** : 값을 출력한다. (<%= %>)  
* **스크립트릿** : 자바 코드를 실행한다. (<% %>)  
* **선언부** : 자바 메서드(함수)를 만든다. (<%! %>)  

# 3.
```request``` 기본 객체는 웹 브라우저의 요청과 관련이 있다.
**클라이언트 정보**
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
   
**요청 파라미터 처리**  
request 기본 객체는 웹 브라우저가 전송한 파라미터를 읽어올 수 있는 메서드를 제공하고 있다.  
```
getParameter(String name)       | String                | 이름이 name 인 파라미터를 구한다. (존재X는 NULL)
getParameterValues(String name) | String[]              | 이름이 name 인 모든 파라미터의 값을 배열로 구한다.
getParameterNames()             | java.util.Enumeration | 웹 브라우저가 전송한 파라미터의 이름 목록을 구한다.
getParameterMap()                | java.util.Map         | 웹 브라우저가 전송한 파라미터의 맵을 구한다.

맵은 <파라미터 이름, 값>쌍으로 구성된다.
```
    
```getParameterNames()```는 ```java.util.Enumeration```을 반환하니 아래와 같이 사용
```
<%
  Enumeration paramEnum = request.getParameterNames();
  while(paramEnum.hasMoreElements()){
    String name= (String)paramEnum.nextElement();
%>  
  <%= name%>
<%
  }  
%>
```
  
```getParameterMap()```는 ```java.util.Map```을 반환하니 아래와 같이 사용
```
<%
  Map parameterMap = request.getParameterMap();
  String[] nameParam = (String[])parameterMap.get("name"); // 키 값 넣으면 된다.
  if(nameParam != null){
%>
  name = <%= nameParam[0] %>
<%
  }
%>
```
  
# 4.
**GET 방식**  
  
1. <a> 태그의 링크 태그에 쿼리 문자열 추가(href=""에 쿼리 문자열)
2. <form> 태그의 method 속성 값 (method="get")
3. 웹 브라우저에 주소에 직접 쿼리 문자열을 포함
  
요청데이터 요청줄에 파라미터 추가됨 이는 주소창에 그대로 드러난다.    
   
```GET 방식``` 웹브라우저, 웹 서버 또는 웹 컨테이너에 따라 전송할 수 있는 파라미터 값의 길이에 제한이 있을수 있다.         

**POST 방식**   
1. ```<form action="전송경로" method="post">...</form>```

요청데이터 요청줄에 파라미터 추가됨 이는 주소창에 드러나지 않아서 보안에 조금 더 유리하다고 평가된다.   
   
```POST```방식은 데이터 영역을 이용해서 데이터를 전송하기 때문에  
웹 브라우저나 웹 서버 등에 상관없이 전송할 수 있는 파라미터의 길이에 제한이 없다.    
     
# 5.  
**인코딩** : 웹 브라우저가 웹서버에 파라미터를 전송할 때 알맞은 캐릭터 셋을 이용해서 파라미터 값을 변환 시키는 것      
**디코딩** : 웹 서버가 요청받은 인코딩 된 파라미터 값을 알맞은 캐릭터 셋을 통해 원래의 파라미터 값으로 변환 시키는 것 

**GET 인코딩 방식**   
```   
1. <a> 태그의 링크 태그에 쿼리 문자열 추가(href=""에 쿼리 문자열)  | 웹 페이지 인코딩 사용   
2. <form> 태그의 method 속성 값 (method="get/post")               | 웹 페이지 인코딩 사용   
3. 웹 브라우저에 주소에 직접 쿼리 문자열을 포함                    | 웹 브라우저마다 다름    
```
  
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
   
1. ```pageEncoding``` 1순위    
2. ```contentType``` 2순위    
3. 둘 다 없으면 기본 값인 ISO-8859-1을 캐릭터 셋으로 사용.   
   
둘 다 있는데 값이 다르면  
```pageEncoding``` 속성은 JSP 파일을 인코딩하고   
```contentType``` 속성은 응답 결과를 인코딩한다.  

**POST 디코딩 방식**     
```post 방식``` 일반적으로 디코딩을 처리해주는 ```request.setCharacterEncoding(캐릭터 셋)```을 사용한다.
```
<%
requset.setCharacterEncoding("utf-8");
%>
```

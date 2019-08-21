JSP로 시작하는 웹 프로그래밍-4
=======================
# 6. response 기본 객체
response 기본 객체는 웹 브라우저에 보내는 응답 정보를 담는다.    
  
**response 기본 객체가 응답 정보와 관련해서 제공하는 기능**
  
* 헤더 정보 입력
* 리다이렉트 하기
  
이외에 몇 가지 기능이 더 있으나, JSP 페이지에서는 거의 사용되지 않는다.

## 6.1. 웹 브라우저에 헤더 정보 전송하기
```response 기본 객체```는 응답 정보에 헤더를 추가하는 기능을 제공한다.
```
헤더 값 추가)

addHeader(String name, String value)    | name 헤더에 value 값을 추가한다.
addIntHeader(String name, int value)    | name 헤더에 정수 값 value를 추가한다.
addDateHeader(String name, long date)   | name 헤더에 date를 추가한다.(ms 단위)
______________________________________________________________________________________
헤더 값 변경)

setHeader(String name, String value)    | name 헤더의 기존 값을 value 값으로 지정한다. 
setIntHeader(String name, int value)    | name 헤더의 기존 값을 정수 값 value로 지정한다.
setDateHeader(String name, long date)   | name 헤더의 기존 값을 date로 지정한다.(ms 단위)
______________________________________________________________________________________
해더 존재 유무 파악)

containsHeader(String name)             | 이름이 name인 헤더를 포함하고 있을 경우 true, 없으면 false 
```

## 6.2. 웹 브라우저 캐시 제어를 위한 응답 헤더 입력   
새로운 내용을 DB에 추가했는데도 웹 브라우저에 출려되는 내용이 바뀌지 않는 경우가 있다.  
이는 웹 브라우저가 서버가 생성한 결과를 출력하지 않고 캐시에 저장된 데이터를 출력하기 때문이다.     
```
만약 짧은 간격으로 같은 웹 페이지에 접속한다고 가정을하면 로딩을 2번이나 해야하는 번거러움이 있다.  
그래서 Cache 라는 것을 만들어서 기존 처음 접속한 웹페이지의 정보를 저장해 놓는다.
하지만 이러한 방법은 장점이 될 수도 단점이 될 수도 있다.  
장점으로는 같은 웹 페이지를 접속시 로딩 횟수와 시간을 줄이는 것이고  
단점으로는 변동 사항이 생겼더라도 캐시에 저장된 이전 브라우저의 정보를 사용하기에 수동적으로 갱신해야한다.     
```  
그러므로 내용이 자주 바뀌지 않는 사이트는 웹 브라우저 캐시를 사용해서 보다 빠른 응답을 제공받고    
반대로 내용이 자주 바뀌는 사이트는 웹 브라우저 캐시를 사용하지 않아야 한다.    
    
이러한 캐시는 ```response 객체```의 응답 헤더 메소드를 통해서 제어하고 관리할 수 있다.  
```
헤더            | 내용
________________|____________________________________________________________________________________________
Cache-Control   | HTTP 1.1 버전에서 지원하는 헤더
                | 헤더의 값을 "no-cache"로 지정하면 웹 브라우저는 응답 결과를 캐시하지 않는다. 
                | 단, 웹브라우저에 따라 뒤로가기를 눌렀을 경우 캐시 저장소에 보관된 응답 내용을 사용하기도 한다.
                | 그래서 응답 결과가 캐시 저장소 자체에 보관되지 않도록 하려면,
                | "no-cahche"에 이어서 "no-store"를 추가한다. 

pragma          | HTTP 1.0 버전에서 지원하는 헤더
                | 헤더의 값을 "no-cache"로 지정하면 웹 브라우저는 응답 결과를 캐시에 저장하지 않는다. 

Expires         | HTTP 1.0 버전에서 지원하는 헤더
                | 응답 결과의 만료일을 지정한다. 
                | 만료일을 현재 시간보다 이전으로 설정함으로써 캐시에 보관되지 않도록 할 수 잇다.
                | 만료일은 1970년 1월 1일을 기준으로 밀리세컨드가 얼마나 지나는지로 결정한다.(long 타입으로)

```   
최근 웹 브라우저는 HTTP 1.1 버전을 지원하지만  
지원 하지 않는 웹 브라우저가 존재할 가능성이 있으니 모두 사용해주는 편이 좋다.  
그리고 앞서 말했듯이 '헤더'이기에 ```response.addHeader()```나 ```response.setHeader```를 사용해야 한다. 
  
**예시**
```
<%
  response.setHeader("Cache-Control","no-cache");
  response.addHeader("Cache-Control","no-store");
  response.setHeader("pragma","no-cache");
  response.setDateHeader("Expires", 1L); //1의 long 타입이고 1970년 1월 1일의 0.001초 후 를 의미
%>
```

## 6.3. 리다이렉트를 이용해서    
response 기본 객체에서 많이 사용되는 기능 중 하나는 리다이렉트 기능이다.    
리다이렉트는 웹 서버가 웹 브라우저에게 다른 페이지로 이동하라고 응답하는 기능이다.   
즉, 리다이렉트 기능은 웹 서버 측에서 웹 브라우저에게 어떤 페이지로 이동하라고 지정하는 것이다.  
예를 들면 사용자가 로그인에 성공한 후 메인 페이지로 자동으로 이동하는 기능이 이에 해당한다.    
    
* response.sendRedirect(String location경로)
  
```
<%
  //JSP 코드
  ...
  response.sendRedirect("이동할 페이지 경로");
%>
```
```response``` 기본 객체는 ```sendRedirect(String location경로)``` 메서드를 이용해  
웹 브라우저가 리다이렉트 하도록 지시할 수 있다.  

**예시**
```
<% @page contentType="text/html; charset=utf-8" %>
<%
  String id = request.getParameter("memberId");
  if(id !==null && id.equals("modvirus")){
    response.sendRedirect("/chap03/index.jsp");
  } else {
%>
  <html>
  <head><title>로그인에 실패</title></head>
  <body>
  잘못된 아이디입니다.
  </body>
  </html>
<%  
  }
%>
```
위 예시는 로그인 처리를 나타내는 예시이다.   
로그인이 성공하면 리다이렉트를 통해 ```"/chap03/index.jsp"```로 이동하라고 지시를 내린다.  
로그인이 실패할 경우 '로그인 실패' HTML을 생성해서 보여준다.  
  
```request.getParameter("https://github.com/kwj1270/TIL-JSP")```  
같은 서버 주소에 위치한 페이지를 리다이렉트뿐만 아니라
다른 서버 주소에 위치한 페이지로 이동하도록 지정할 수도 있다.  
   
```request.getParameter("/chap03/index.jsp?name=%EC%9E%90%EB%BO%94")```   
리다이렉트는 URL을 통해 페이지를 이동시키는 작업을 수행하므로 ```GET 방식```으로 보내진다.   
이럴때 파라미터의 값을 넘길일이 있다면 위와 같이 인코딩 작업을 해주어야한다.  
개발자가 인코딩 작업을 손으로 직접 계산해야 한다면 매우 번거롭고 괴롭겠지만  
**java.net.URLEncoder 클래스**를 사용하여 **encode() 클래스 메서드**를 사용하면 이를 해결할 수 있다.   
사용법은 ```URLEncoder.encode(바꿀 값 , 변경할 캐릭터 셋)```이다.  
  
**예시**  
```
<% @page contentType="text/html; %>
<% @page import="java.net.URLEncoder" %>
<%
  String value = "자바";
  String encodedValue = URLEncoder.encode(value, "utf-8");
  response.sendRedirect("/chap03/index.jsp?name="+encodedValue); //문자열+문자열
%>
```

***
# 7. JSP 주석
JSP의 주석은 HTML영역과 자바영역이 따로 구분되어져 있기에 각각 언어에 맞는 주석을 사용해주어야 한다.
스크립트릿과 선언부의 코드 블록은 자바 코드이므로 자바의 주석을 사용할 수잇다.(```//```, ```/* */```)
JSP 코드 자체를 주석처리 하고 싶다면 ```<%-- 내용 --%>```으로 주석처리를 해주어야한다.  
```
<%
  // 주석 처리할 내용
  
  /*
  주석 처리할  내용 
  */
%>

<%!
  // 주석 처리할 내용
  
  /*
  주석 처리할  내용 
  */
%>

<%-- 주석 처리할 내용 --%>
```

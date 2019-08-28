표현 언어(Expression Language)
=======================
표현 언어(Expression Language)는 다른 형태의 스크립트 언어로서 스크립트 요소 중의 하나이다.  
표현 언어는 표현식보다 간결하고 편리하기 때문에 많이 사용된다.     
# 1. 표현 언어란?
표현 언어(Expression Language)는 값을 표현하는데 사용하는 스크립트 언어로, JSP의 스크립트 요소를 보완하는 역할을 한다.   

* JSP의 네 가지 기본 객체가 제공하는 영역의 속성 사용
* 수치 연산, 관계 연산, 논리 연산자 제공
* 자바 클래스 메서드 호출 기능 제공
* 쿠키, 기본 객체의 속성 등 JSP를 위한 표현 언어의 기본 객체 제공 
* 람다식을 잉요한 함수 정의와 실행  
* 스트림 API를 통한 컬렉션 처리
* 정적 메서드 실행
    
표현 언어를 사용하면 JSP 표현식을 사용하는 것보다 간결한 코드를 사용해서 값을 출력할 수 있다.    
```
표현식)

<%= member.getAddress().getZipcode() %>
___________________________________________
표현언어)

${member.address.zipcode}
```

## 1.1. EL의 구성
EL은 다음과 같이 ```$```와 ```{}```그리고 표현식을 사용하여 값을 표현한다.    
```
${expr}
```
expr 부분에는 표현 언어가 정의한 문법에 따라 값을 표현하는 식이 온다.  
```
<jsp:include page="/module/${skin.id}/header.jsp" flush="true" />
```
기본 표현식을 대신 할 수도 있으며 액션 태그에서도 사용 가능하다.  
```
<b>${sessionScope.member.id}</b>님 환영합니다.  
```  
EL은 JSP의 스크립트 요소(스크립트릿, 표현식, 선언부)를 제외한 나머지 부분에서 사용될 수 있으며,     
EL을 통해서 표현식보다 편리하게 값을 출력할 수 있다.     
        
## 1.2. ${} 표현 언어와 #{} 표현 언어
### 1.2.1. ${} 표현 언어와 
```
<%
  Member m = new Member();
  m.setName("이름1");
%>
<c:set var="in" value="<%= m %>" />
<c:set var="name" value="&{m.name}" /> <!-- m.get("name") --><!-- 이 시점에 EL 변수 값 대입 -->
<% m.setName("이름2"); %>
${m.name} <%-- name의 값은 "이름1" --%>
```
```<c:set>``` JSTL 태그는 ```EL 변수```를 생성해주는 기능을 제공한다.      
위 코드에서 EL 변수 ```name```의 값으로 ```${m.name}```을 지정했다.     
그리고 ```${}```으로 지정했으니 선언하는 시점에서 값이 대입이 된다.     
그래서 먼저 m에 정의된 값이 ```"이름1"```이니 이를 ```EL 변수```의 값이 "이름1"로 대입시키고        
```m```의 값을 바꾸더라도 ```EL 변수```의 값을 바꾼것이 아니기에 ```EL 변수```의 값은 그대로이다.     
   
### 1.2.2. #{} 표현 언어
```
<%
  Member m = new Member();
  m.setName("이름1");
%>
<c:set var="in" value="<%= m %>" />
<c:set var="name" value="#{m.name}" /> <!-- m.get("name") -->
<% m.setName("이름2"); %> <!-- 이 시점에 EL 변수 값 대입 -->
${m.name} <%-- name의 값은 "이름2" --%>
<% m.setName("이름3"); %> <!-- 이 시점에 EL 변수 값 대입 -->
${m.name} <%-- name의 값은 "이름3" --%>
```  
위 코드에서 EL 변수 ```name```의 값으로 ```#{m.name}```을 지정했다.          
그리고 ```#{}```으로 지정했으니 선언하는 시점에서 대입을 하는 것이 아니라       
값을 호출하는 시점에서 해당하는 값을 가져와서 계산한다고 봐야 한다. (참조 변수와 비슷하다고 생각을 하면 된다.)        
즉, 간단히 말하면 ```#{}```가 가리키는 값이 변동 되면 ```${}```로 사용되는 EL변수의 값도 변동되어있다.       
더 간단히 말하면 값이 필요할 때 계산한다.      
       
다만, ```#{expr}```은 곧바로 값이 생성되는 것이 아니기 때문에 JSP의 템플릿 텍스트에서는 사용할 수 있다.    
즉, ```#{expr}```로 ```EL 변수```의 '값'을 설정하고 해당 ```EL 변수```를 ```${}```로 호출해야 사용 가능하고    
```#{expr}``` 자체만으로는 사용할 수 가 없다는 뜻이다.   
  
또한, JSP에서 ```#{expr}```은 ```Deferred Expression```을 허용하는 태그의 속성에만 위치할 수 있다.   
   
***
# 2. EL 기초
EL은 일종의 스크립트 언어로 자료 타입, 수치 연산자, 논리 연산자, 비교 연산자 등을 제공한다.     
        
## 2.1. EL의 데이터 타입과 리터럴
EL은 Boolean 타입, 정수 타입, 실수 타입, 문자열 타입 그리고 널 타입의 5가지 타입을 제공하고 있다.     
     
* 불리언(Boolean) 타입 : true와 false가 있다.
* 정수 타입 : 0~9로 이루어진 값을 정수로 사용하고 음수는 ```-```가 붙는다 (long 타입이다.) 
* 실수 타입 : 0~9로 이루어져 있으며, 소수점```.```을 사용할 수 있고,  
3.24e3과 같이 지수형으로 표현 가능하다. EL에서 실수 타입은 double이다.  
* 문자열 타입 : 따옴표(```'```, ```"```)로 둘러싼 문자열. 이스케이프 문자를 지원한다. (String 타입이다.)  
* 널 타입 : null
  
## 2.2. EL의 기본 객체
JSP는 웹 어플리케이션을 구현하는 데 필요한 요청, 응답, 세션 등에 쉽게 접근할 수 있도록 기본 객체를 제공한다.  
JSP는 EL 에서 사용할 수 있는 기본 객체도 제공하고 있다.  
```
pageContext         | pageContext 기본 객체와 동일
pageScope           | pageContext 기본 객체에 저장된 속성의 <속성, 값> 매핑을 저장한 Map 객체
requestScope        | request 기본 객체에 저장된 속성의 <속성, 값> 매핑을 저장한 Map 객체
sessionScope        | session 기본 객체에 저장된 속성의 <속성, 값> 매핑을 저장한 Map 객체
applicationScope    | application 기본 객체에 저장된 속성의 <속성, 값> 매핑을 저장한 Map 객체
param               | 요청 파라미터의 <파라미터 이름, 값> 매핑을 저장한 Map 객체, 파라미터의 값은 String이다.
paramValues         | 요청 파라미터의 <파라미터 이름, 값> 매핑을 저장한 Map 객체, 파라미터의 값은 String[]이다.
header              | 요청 정보의 <헤더이름, 값> 매핑을 저장한 Map 객체, request.getHeader()와 동일
headerValues        | 요청 정보의 <헤더이름, 값> 매핑을 저장한 Map 객체, request.getHeaders()와 동일
cookie              | <쿠키 이름, Cookie> 매핑을 저장한 Map 객체, request.getCookies()로 구한 배열로부터 매핑 생성
initParam           | 초기화 파라미터의 <이름, 값> 매핑을 저장한 Map 객체. application.getInitParameter()와 동일
```   
cookie는 쿠키 이름을 ```Key```로 설정하고 동명의 쿠키 자체를 ```value```로 저장한다고 생각하면 된다.   
위 기본객체들은 단순히 사용하는 것이 아니라 위 기본객체에```.key값```을 입력하면 해당 ```key```의 값을 반환한다.   
   
**LE 기본객체 예시**  
```
<%@ page contentType="text/html; charset=utf-8" %>
<%
    request.setAttribute("name", "김우재");
%>
<html>
<head><title>EL object</title></head>
<body>

요청 URI : ${pageContext.request.requestURI}<br>   // pageContext.getRequest().getRequestURI();
request의 name 속성 : ${requestScope.name}<br>     // request.getAttribute("name");   
code 파라미터 : ${param.code}                      // request.getParameter(code);

</body>
</html>
```
**결과**
```
요청 URI : /chap11/useELObject.jsp
request의 name 속성 : 최범균
code 파라미터 : 
```
우선 위의 예시에서 사용한 3가지 EL 기법을 살펴보면 
  
1. gettter 메서드를 간략하게 줄인다.  
2. getAttribute("값")에서 메서드를 생략하고 값만 넣는다.
3. getParameter("값")에서 메서드를 생략하고 값만 넣는다.  
   
이렇듯 EL은 상황에 따라 메서드의 일부를 생략할지 메서드를 생략하고 값을 쓸지 다르므로 생각하면서 사용하자.  
   
또한, 결과를 보면 code 파라미터 값이 존재하지 않지만, null을 출력하지 않았다.     
이는 EL의 특징으로 EL은 값이 존재하지 않는 경우 아무것도 출력하지 않는다.    
  
그리고 위 예시에 사용된 기본 객체 말고도 앞서 정의한 다른 기본 객체를 사용할 수 있다.  
예를 들면, 이름이 "ID"인 쿠키의 값을 출력하고자 하면 아래와 같이 사용하면 된다.  
```
${cookie.ID.value}
```
EL의 ```cookie``` 기본 객체는 <쿠키이름, Cookie 객체> Map 객체이기에    
```cookie.ID``` 는 이름이 "ID"인 ```Cookie 객체```를 리턴하고 ```.value```로 ```getValue()```메서드를 호출한 것이다.    
그리고 만약 이름이 "ID"인 쿠키가 존재하지 않으면 EL의 특징으로 아무것도 출력하지 않는다.    

***
# 3. 대주제
> 인용
## 3.1. 소 주제
### 3.1.1. 내용1
```
내용1
```

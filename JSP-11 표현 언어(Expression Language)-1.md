표현 언어(Expression Language)-1
=======================
표현 언어(Expression Language)는 다른 형태의 스크립트 언어로서 스크립트 요소 중의 하나이다.  
표현 언어는 표현식보다 간결하고 편리하기 때문에 많이 사용된다.     
# 1. 표현 언어란?
표현 언어(Expression Language)는 값을 표현하는데 사용하는 스크립트 언어로,  
JSP의 스크립트 요소를 보완하는 역할을 한다.    

* JSP의 네 가지 기본 객체가 제공하는 영역의 **속성** 사용
* 수치 연산, 관계 연산, 논리 연산자 제공
* 자바 클래스 메서드 호출 기능 제공
* 쿠키, 기본 객체의 속성 등 JSP를 위한 표현 언어의 기본 객체 제공 
* 람다식을 이용한 함수 정의와 실행  
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
<c:set var="m" value="<%= m %>" />
<c:set var="name" value="${m.name}" /> <!-- m.get("name") --><!-- 이 시점에 EL 변수 값 대입 -->
<% m.setName("이름2"); %>
${name} <%-- name의 값은 "이름1" --%>
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
<c:set var="m" value="<%= m %>" />
<c:set var="name" value="#{m.name}" /> <!-- m.get("name") -->
<% m.setName("이름2"); %> <!-- 이 시점에 EL 변수 값 대입 -->
${name} <%-- name의 값은 "이름2" --%>
<% m.setName("이름3"); %> <!-- 이 시점에 EL 변수 값 대입 -->
${name} <%-- name의 값은 "이름3" --%>
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

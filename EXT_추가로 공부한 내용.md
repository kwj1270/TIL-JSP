
시험 ->   
서블릿 url 매핑   
url 매핑 했을시에 여러개의 컨트롤러 나누는 것    
서블릿 라이프 사이클    
Request/Response 의 상속구조, Servlet 상속 구조       
글 작성자의 IP주소 가져오기  
스크립트 4가지   
지시자, 페이지, 태그라이브러리, 인클루드   
세션, 쿠키    
JSP, 9개의 내장객체 (4개)    
포워드, 리다이렉트     
get/post 차이점 , 서블릿에서 어떻게 사용할 것인지   
el 태그    
mvc 패턴     
에러페이지, 에러코드, 처리방법, 예외처리       
검색, db 쿼리, crud, while,   
db 연결 코드들    
      
requset 나 session에 담아서 포워딩   
   
세션 타임아웃    

# Servlet 이란?  
자바를 사용하여 웹 페이지를 동적으로 생성하는 서버측 **프로그램** 혹은 그 사양을 말하며 흔히 `서블릿`이라 부른다.    
자바 서블릿은 웹 서버의 성능 향상을 위해 사용되는 일종의 **자바 클래스**이다.   
서블릿은 JSP와 비슷한점이 많지만, HTML을 전혀 사용하지 않는다.   


# Servlet URL 매핑
```java
@WebServlet("/Hello")
```
```java
@WebServlet(urlPatterns = {"/main", "/test", "/join"}) // 배열 선언도 가능  
```
xml을 이용한 설정방법은 있으나 여기에대해서 배우지는 않았다.  
  
# 서블릿 라이프 사이클    
  
`init` -> `service` -> `doPost` -> `doGet` -> `destory`        
     
1. 요청이 오면, Servlet 클래스가 로딩되어 요청에 대한 Servlet 객체가 생성됩니다.(싱글턴)   
2. 서버는 init() 메소드를 호출해서 Servlet을  초기화 합니다.
3. service() 메소드를 호출해서 Servlet이 브라우저의 요청을 처리하도록 합니다.
4. service() 메소드는 특정 HTTP 요청(GET, POST 등)을 처리하는 메서드 (doGet(), doPost() 등)를 호출합니다.
5. 서버는 destroy() 메소드를 호출하여 Servlet을 제거합니다.


# Request/Response 의 상속구조
Servlet 은 최상단  
* `Servlet` - `GenericServlet` - `HttpServlet`
* `ServletRequest` -> `HttpServletRequest`
* `ServletResponse` -> `HttpServletResponse`
   
`GenericServlet` = `ServletRequest` -> `HttpServletRequest` = `HttpServlet`  
`GenericServlet` = `ServletResponse` -> `HttpServletResponse` = `HttpServlet`  

# GET POST 차이 

* **GET :** 
  HttpRequset Header 에 URL이 붙어서간다.   
  쿼리스트링  
  데이터양에 제한이 있다, 2048   
* **POST :**
  HttpRequset Body 에 데이터가 붙어서 전달,
  데이터 제한 없으며 최소한의 보안 효과  
  get보다 느리다. 
  
# URL 분리

* URL : `http://localhost:7777/BackEndProject/Hello`   
* QueryString : `?`
* parameterName: 파라미터 이름
* parameterValue : =value
* 파라미터 구분자 : `&`

# 글 작성자의 IP주소 가져오기  

```java
request.getRemoteAddr()
```

# 스크립트 4요소  
* 스크립트릿(Scriptlet) : `<% %>`
* 표현식(Expression) : `<%= %>`
* 선언부(Declaration) : `<%! %>`  
* `<%@ directive{지시어 속성} %>` : 
  page 지시어 import를 제외하고 다른 속성들은 한번만 나와야한다
  * `<%@ page contentType="text/html;charset=utf-8"%>`
  * `<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>`
  * `<%@ include file="loginCheck.jsp" %>`
* 주석 : `<%-- --%>`

# EL 태그 
Map 또는 getter를 가진 빈이이어 한다.  

* `${map, map의 키}`   
* `${javabean, bean프로퍼티}`   
* `${userinfo["name"]}`, `${userinfo.name}`   

내장객체
* requestScope
* seesionScope
* applicationScope
* pageContext

이 외에도  
* param
* cookie

프로퍼티만으로 사용한다면  
`pageScope > requsetScope > sessionScope > applicationScope` 순으로 찾는다.  
  
예시  
`${cookie.id.value}`     
  
연산자  
대부분의 연산자를 지원하며 `empty`도 지원한다.   

* 값이 null : true 
* 값이 빈 문자열 "" : true
* 길이가 0인 배열 : true
* 빈 Map 객체 : true
* 빈 Collection : true

# JSTL  
C priefx, `http://java.sun.com/jsp/jstl/core`     
`<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core">`    

`<c:if test="${a eq b}"></c:if>`
`<c:forEach item="${items}" var="row"></c:forEach>`
`<c:set></c:set>`
`<c:choose><c:when></c:when><c:otherwise></c:otherwise></c:choose>`

# 쿠키 / 세션   
## 쿠키 
**쿠키**
* 서버에서 **사용자의 컴퓨터에 저장**하는 정보파일
* 사용자의 명령이 없어도 HttpRequest header에 자동 등록된다.  
* key / value 형태의 String 
* 브라우저 마다 저장되는 쿠키는 다르다.  

**사용처**
* 세션관리 : 세션도 쿠키의 일종, 사용자 아이디/접속시간/장바구니 정보 저장  
* 개인화 : 사용자마다의 쿠키 데이터를 통해 적절한 추천 서비스 제공  
* 트래킹 : 쿠키를 통해 사용자의 행동과 패턴을 분석하고 기록  

**Cookie 구성 요소**   
* 이름 : 여러 쿠키를 구분하는 식별자 역할 
* 값 : 쿠키의 이름과 매핑되는 값 
* 유효기간 : 쿠키의 유효기간 
* 도메인 : 쿠키를 전송할 도메인 
* 경로 : 쿠키를 전송할 요청 경로  
  
**쿠키의 동작 순서**   
* 클라이언트가 페이지 요청 
* 서버가 Http Response header에 쿠키 넣어 보냄 
* 브라우저는 넘겨받은 쿠키를 PC에 저장 
* 클라이언트가 페이지 요청시 쿠키 같이 보냄  
* 브라우저가 종료되어도 쿠키는 라이프타임동안 종료 안됨  

**쿠키의 특징**
* 이름, 값, 만료일, 경로 정보로 구성되어 있다.  
* 클라이언트에 총 300개의 쿠키를 저장할 수 있다.  
* 하나의 도메인당 20개의 쿠키를 가질 수 있다.  
* 하나의 쿠키는 4KB까지 저장가능하다.  

**자바 코드**
* 생성 : Cookie cookie new Cookie(key, value);
* 값변경 : cookie.setValue(String value); 
* 값얻기 : String value = cookie.getValue();
* 도메인 변경 : cookie.setDomain(domain);  
* 도메인 얻기 : cookkie.getDomain();  
* 패스 변경 : cookie.setPath(path);  
* 패스 얻기 : cookkie.getPath();  
* 유효시간 변경 : cookkie.setMaxAge(age);, cookkie.setMaxAge(0);   
* 유효시간 얻기 : cookkie.getMaxAge();  
* 보내기 : response.addCookie(cookie)
* 쿠키 얻기 : request.getCookies();

## 세션 
방문자가 웹 서버에 접속한 상태 저장 
메모리에 Object 형태로 저장
메모리 허용하는 한 제한없이 저장 가능 

**세션의 동작 순서**   
* 클라이언트가 페이지 요청
* 세션 ID 확인 
* 세션 ID 존재 안하면 만들어서 반환해줌
* 브라우저는 세션 아이디를 쿠키를 이용해 저장 
* 클라이언트 재 접속시 이 쿠키를 이용하여 세션값 서버에 전달 및 갱신 

**세션의 특징**
* 웹 서버에 웹 컨테이너 상태를 유지하기 위한 정보로 사용 
* 서버에 저장되는 쿠키 
* 브라우저 닫을시, 세션도 삭제 -> 보안 굿 
* 데이터 제한 없음
* 클라이언트 고유 SessionID 발급
* `JSESSIONID=세션값` 으로 사용

* 생성 : request.getSession();
* 저장 : session.setAttribute(키,값)
* 얻기 : session.getAttribute(키) 
* 제거 : session.removeAttribute(키) / session.invalidate()   
* 생성시간 : session.getCreationTime()
* 마지막 접근 시간 : session.getLastAccessedTime()  



# MVC
* Model : 비즈니스 로직을 처리하는 모든 것, data를 알맞게 처리하고 이를 다시 Controller에게 넘긴다.  
* View : 화면 표시만 담당한다., 로직은 1도 없어야 한다.     
* Controller : 로직을 처리하기 위한 model을 호출한다.   
*  

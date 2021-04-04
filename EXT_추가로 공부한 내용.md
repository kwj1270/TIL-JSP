
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


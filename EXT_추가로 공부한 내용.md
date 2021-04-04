
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

# Servlet URL 매핑
```java
`@WebServlet("/Hello")`
```
```java
@WebServlet(urlPatterns = {"/main", "/test", "/join"}) // 배열 선언도 가능  
```
xml을 이용한 설정방법은 있으나 여기에대해서 배우지는 않았다.  
  
# 서블릿 라이프 사이클    
  


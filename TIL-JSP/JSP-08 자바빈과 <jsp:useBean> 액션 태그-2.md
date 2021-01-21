자바빈과 <jsp:useBean> 액션 태그-2
=======================
# 3. <jsp:useBean> 액션 태그를 이용한 자바 객체 사용
JSP 페이지의 주된 기능은 데이터를 보여주는 기능이다.  
게시판의 글 목록 보기, 글 읽기, 회원 정보 보기 등의 기능이 이에 해당한다.  
JSP 에서 이런 종류의 데이터들은 자바빈과 같은 클래스에 담아서 값을 보여주는 것이 일반적이다. (DTO)    
```
<%
  MemberInfo mi = new MemberInfo();
  mi.setId("kwj1270");
  mi.setName("김우재");
%>
이름 - <%= mi.getName() %>, 아이디 - <%= mi.getId() %>
```
JSP 규약은 JSP 페이지에서 번번히 사용되는 자바빈 객체를 위한 액션 태그를 제공하고 있다.     
이들 액션 태그를 사용하면 자바빈 객체를 생성하거나(```<jsp:uesBean>```),    
자바빈의 프로퍼티를 출력하거나 (```<jsp:getBean>```),     
자바빈의 프로퍼티의 값을 변경할 수 있다.(```<jsp:setBean>```)     
  
## 3.1. <jsp:useBean> 액션 태그를 사용하여 객체 생성하기  
```<jsp:uesBean>``` 액션 태그는 JSP 페이지에서 사용할 자바빈 객체를 지정할 때 사용한다.     
   
**<jsp:uesBean> 구조**
```
<jsp:uesBean id="[자바빈이름]" class="[자바빈클래스이름]" scope="[범위]" />
```
  
* id : JSP 페이지에서 자바빈 객체에 접근할 때 사용할 이름을 지정한다. (참조 변수 이름 설정)      
* class : 패키지 이름을 포함한 자바빈 클래스의 완전한 이름을 입력한다. (중요한 것은 풀 이름)    
* scope : 자바빈 객체를 저장할 영역을 지정한다. 기존에 영역 공부했을시의 기본 객체를 입력하면 된다.(기본은 page)  
          (page, request, session, application 이 있다.) 
  
**예시** 
```
<jsp:uesBean id="info" class="chap08.member.MemberInfo" scope="request" />
```
**동작 원리 1**
```
MemberInfo info = new MemberInfo();
request.setAttribute("info", info);   // value 는 Object 이기에 아무거나 저장가능  
```  
예시를 보면 알 수 있듯이 ```id=""```로 지정한 값은 참조변수의 이름이 된다.       
하지만 우리가 가장 중요하게 볼 점은 바로 ```request.setAttribute()```이다.      
```scope```로 인해 ```request``` 기본 객체에 속성과 값을 넣는데      
```key```로 들어가는 부분이 참조변수 이름의 "" 문자열 형태이다.    
  
**동작 원리 2**
```
MemberInfo info = (MemberInfo)request.getAttribute("info");
if(info == null){
  info = new MemberInfo();
  request.setAttribute("info", info);   // value 는 Object 이기에 아무거나 저장가능  
}
```  
사실 진짜 동작 원리는 ```id=""``` 지정한 이름이  속성(Attribute)에 존재하고 값이 있다면  
기존 속성을 이용하고 없을 경우 새로 생성해서 사용한다.  
    
**실제 동작 예시**    
```
<%@ page contentType="text/html; charset=utf-8" %>
<jsp:useBean id="member" scope="request" class="chap08.member.MemberInfo" />
<%
  member.setId("kwj1270");
  member.setName("김우재");
%>
<jsp:forward page="/uesObject.jsp" />
```
```
<%@ page contentType="text/html; charset=utf-8" %>
<jsp:useBean id="member" scope="request" class="chap08.member.MemberInfo" />
<html>
<head><title>인사말</title></head>
<body>
<%= member.getName() %> (<%= member.getId() %>) 회원님
안녕하세요
</body>
</html>
```
**결과**
```
김우재(kwj1270) 회원님 안녕하세요 
```
일단 두번째 코드에서 동작이 가능한 이유는    
```<jsp:useBean id="member" scope="request" class="chap08.member.MemberInfo" />```를 했다.        
하지만 앞서 ```id="member"``` 값이 기존 속성에 존재하면 새로 사용하지 않고 기존 것을 사용한다.          
그러므로 ```MemberInfo member = request.getAttribute("member")``` 동작을 취하게 되어 기존 값을 그대로 사용할 수 있었다.      
    
물론 첫번째 코드에서 두번째 코드로 넘어가는 방법이 아닌     
처음부터 두번째 코드를 실행하는 방식으로 한다면 출력 결과는 NULL이 나왔을 것이다.    
```
null(null) 회원님 안녕하세요
```
  
**추가로**
```<jsp:uesBean>``` 액션 태그에서 ```class=""``` 대신에 ```type=""```을 사용해도 된다.   
```
<jsp:useBean id="member" scope="request" type="chap08.member.MemberInfo" />  
```
단, ```type=""```은 지정한 영역에 이미 객체가 존재한다고 가정한다.     
즉, 속성에 이미 존재하지 않으면 에러를 발생시키고 존재한다면 기존 것을 사용하겠다는 의미이다.    
```
MemberInfo member = (MemberInfo)request.getAttribute("member");
if(member == null){
  // 에러 발생
}
```
주로 연결된 페이지에서 사용하며 코드의 안정성을 높일 수도 있다.      
   
## 3.2. <jsp:setProperty> 액션 태그와 <jsp:getProperty> 액션 태그       
### 3.2.1. <jsp:setProperty> 액션 태그       

```<jsp:setProperty>``` 액션 태그를 사용하면 생성한 자바빈 객체의 프로퍼티 값을 변경할 수 있다.     
필자 : 어찌보면 ```자비빈 참조변수.set프로퍼티(값);```을 대체하는 것이다.           
     
**<jsp:setProperty>**  
```
<jsp:setProperty name="[자바빈(참조변수)]" property="인스턴스 변수명" value="값">
```
  
* name : 프로퍼티의 값을 변경할 자바빈 객체의 이름을 지정한다. (<jsp:uesBean> 액션태그의 id 속성에서 지정한 값)      
* property : 값을 지정할 프로퍼티의 이름을 지정한다. (값을 바꿀 인스턴스 변수이름)      
* value : 프로퍼티 값을 지정한다. 표현식(```<%= %>```)이나 EL(```${값}```)을 사용할 수 있다.       
        
**예시**
```
<%@ page contentType="text/html; charset=utf-8" %>
<jsp:useBean id="member" scope="request" class="chap08.member.MemberInfo" />
<jsp:setProperty name="member" property="name" value="김우진">
<html>
<head><title>인사말</title></head>
<body>
<%= member.getName() %> (<%= member.getId() %>) 회원님
안녕하세요
</body>
</html>
```
**결과**
```
김우진(kwj1270) 회원님 안녕하세요 
```
  
### 3.2.2. <jsp:setProperty> 액션 태그와 파라미터  
```<jsp:setProperty>``` 액션 태그에서 ```value=""``` 대신에 ```param=""```을 사용할 수 있다.     
이는 값을 파라미터 값을 프로퍼티 값으로 지정하게끔 해주는 속성이다.    
  
**예를 들면**
```
request 파라미터의 중에 ```memberId``` 가 있고 값은 "Hpunch" 라고 가정하고

<%@ page contentType="text/html; charset=utf-8" %>
<jsp:useBean id="member" scope="request" class="chap08.member.MemberInfo" />
<jsp:setProperty name="member" property="id" param="memberId">
<html>
<head><title>인사말</title></head>
<body>
<%= member.getName() %> (<%= member.getId() %>) 회원님
안녕하세요
</body>
</html>
```
**결과**
```
김우재(Hpunch) 회원님 안녕하세요 
```  
점점 많아지는 내용때문에 헷갈릴만 하기에 해석을 하겠다.   
우선 ```request```로 넘어온 파라미터의 중에 ```memberId``` 가 있고 값은 "Hpunch" 가 있다고 가정을하고       
```<jsp:setProperty name="member" property="id" param="memberId">``` 에서          
```param=""```은 파라미터의 속성 이름중에 ```memberId```이 있는지 찾고 있으면       
```memberId```의 값을 이름이 ```"id"```프로퍼티에 해당 값을 대입시킨다.             
     
**추가(매우 중요)**      
```property=""```에 ```*```를 넣어도 되는데 이는 모든 파라미터의 이름과 같은 프로퍼티의 값을 지정하는 것이다.    
즉 프로퍼티에 id,name 속성 이름이 있고 파라미터에도 id,name 이 있으면      
같은 이름에 맞는 프로퍼티에 파라미터 속성의 값을 넣어준다.      
프로퍼티에 대한 일치하는 모든 파라미터의 값을 사용하기에 ```value=""```이나 ```param=""```을 기술하지는 않는다.      
```
<jsp:setProperty name="[자바빈/참조변수]" property="*" />
____________________________________________________________
<jsp:setProperty name="member" property="*" />
```
  
만약 프로퍼티에는 id,name,password 가 있고 파라미터에 id,name,pw 가 있으면?      
이름이 다르기 때문에 id,name 끼리만 값을 복사 할 수 있다.          
예제는 마지막에 총 복습으로 한번에 할 때 확인하자     
  
### 3.2.3. <jsp:getProperty> 액션 태그         
```<jsp:getProperty>``` 액션 태그는 자바빈 객체의 프로퍼티 값을 출력할 때 사용된다.     
필자: ```<jsp:getProperty>``` 액션 태그는 ```자바빈 참조변수.get프로퍼티()```를 사용한 것이다.   
```  
<jsp:getProperty name="[자바빈/참조변수]" property="인스턴스 변수명" />
____________________________________________________________
<jsp:getProperty name="member" property="name" />
```

## 3.3. <jsp:setProperty> 액션 태그와 <jsp:getProperty> 액션 태그 예시
**membershipForm.jsp**
```
<%@ page contentType="text/html; charset=utf-8" %>
<html>
<head><title>회원 가입 입력 폼</title></head>
<body>
<form action="/chap08/processJoining.jsp" method="post">
<table border="1" cellpadding="0" cellspacing="0">
<tr>
  <td>아이디</td>
  <td colspan="3"><input type="text" name="id" size="10"></td>
</tr>
<tr>
  <td>이름</td>
  <td><input type="text" name="name" size="10"></td>
  <td>이메일</td>
  <td><input type="text" name="email" size="10"></td>
</tr>
<tr>
  <td colspan="4" align="cetner">
  <input type="submit" value="회원가입">
  </td>
</tr>  
</table>
</form>
</body>
</html>
```
**processJoining.jsp**  
```
<%@ page contentType="text/html; charset=utf-8" %>
<%
  request.setCharacterEncoding("utf-8");
%>
<jsp:uesBean id="memberInfo" class="chap08.member.MemberInfo" scope="page" />
<jsp:setProperty name="memberInfo" property="*" />
<jsp:setProperty name="memberInfo" property="password" value="<%= memberInfo.getId() %>" />
<html>
<head><title>가입</title></head>
<body>

<table width="400" border="1" cellpadding="0" cellspacing="0">
<tr>
  <td>아이디</td>
  <td><jsp:getProperty name="memberInfo" property="id" /></td>
  <td>암호</td>
  <td><jsp:getProperty name="memberInfo" property="password" /></td>
</tr>
<tr>
  <td>이름</td>
  <td><jsp:getProperty name="memberInfo" property="name" /></td>
  <td>이메일</td>
  <td><jsp:getProperty name="memberInfo" property="email" /></td>
</tr>  
</table>

</body>
</html>
```
이번 예제에서 알아야 할 점은 ```<jsp:setProperty>``` 액션 태그를 사용함으로써    
요청 파라미터의 값을 간단하게 자바빈 객체의 프로퍼티에 저장할 수 있다는 점이다.     
만약 ```<jsp:setProperty>``` 액션 태그를 사용하지 않았다면 아래와 같은 코드를 작성해야한다.       
```  
//<jsp:setProperty name="memberInfo" property="*" />  
memberInfo.setId(request.getParameter("id"));
memberInfo.setName(request.getParameter("name"));
memberInfo.setEmail(request.getParameter("email"));
```
이러한 이유로 사용자가 입력한 폼 값을 자바빈 객체에 저장할 때에는      
```<jsp:setProperty>``` 액션 태그를 사용할 수 있도록 **파라미터의 이름과 자바빈 프로퍼티의 이름을 맞춘다.**    
  
## 3.4. 자바빈 프로퍼티 타입에 따른 값 매핑
자바빈 프로퍼티 ```width```의 타입이 ```int``` 일 경우를 생각해보자,     
```
<jsp:setProperty name="someBean" property="width" value="100" />
```
우선 ```value="100"``` 으로 기술 되어 있고 100은 문자열로 처리되어있다.  
이 경우 ```<jsp:setProperty>``` 액션 태그는 값을 어떻게 처리할까?  
  
```<jsp:setProperty>``` 액션 태그는 프로퍼티 타입에 따라서 알맞게 값을 처리한다.    
즉, ```value="100"```으로 문자열로 기술되어있어도 100으로 처리해준다.    
정확히는 ```래퍼클래스.valueOf(String)```으로 처리해주기에 문자열을 알맞은 값으로 매핑 시켜준다.     

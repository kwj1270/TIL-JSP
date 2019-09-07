자바빈과 <jsp:useBean> 액션 태그 정리
=======================
자바빈이란? (개인적으로 생각하는)    
```DTO``` 와 같이 ```인스턴스 변수들```과 인스턴스 변수에 맞는 ```getter/setter``` 메소드가 존재하는 클래스   

# 1.
자바빈은 속성(데이터), 변경 이벤트, 객체 직렬화를 위한 '표준'이다.    
JSP는 이 중에서 속성(데이터)을 표현하기 위한 용도로 사용 된다. 
```
public class BeanClassName implements java.io.Serializable{
  private String value  // 이 부분을 프로퍼티라 한다.

  public BeanClassName(){
  ...
  }
  
  public String getVlaue(){
    return value;
  }
  
  public void setVlaue(String value){
    this.vlaue = vlaue;
  }
  
}
```
자바빈 규약을 따르는 클래스를 **자바빈**이라 부른다.      
멤버와 생성자 그리고 ```getter/setter``` 메소드가 존재한다.
    
메서드 이름은 되도록 프로퍼티를 기준으로 ```set``` 과 ```get```을 붙인다.       
프로퍼티(인스턴스 변수)가 ```boolean 형```이라면 ```getter``` 에서 ```get``` 대신에 ```is``` 를 붙인다.
```
public void setFinished(boolean finished);
public boolean isFinished();
```
  
프로퍼티에 (인스턴스 변수) 당연히 배열이 올 수 있고 당연히 반환형과 매개변수에 배열을 사용할 수 있다.  
단, 배열을 이용하기에 **오버라이딩** 으로 부분적으로 접근할 수 있는 방법도 기술해주면 좋다.  
```
public int[] getMark(){...};
public void setMark(int[] values){...};

// 오버 라이딩 배열 요소 하나에 접근 
public int getMark(int index);
public void setMark(int value, int index);
```
  
프로퍼티를 작성할 때는 프로퍼티가 어떠한 목적을 위해서 어떤 동작을 하는지에 대해서 생각을 해야한다.   
주로 프로퍼티 값에는 ```읽기 전용 프로퍼티```와 ```읽기/쓰기 프로퍼티```가 존재한다.   
  
* 읽기 전용 프로퍼티: get 또는 is 메서드만 존재하는 프로퍼티  
* 읽기/쓰기 프로퍼티: get/set 또는 is/set 메서드가 존재하는 프로퍼티  
  
읽기 전용에서 프로퍼티의 값을 조작하여 새로운 값으로 반환하는 메소드를 정의해도 된다.   

# 2.
JSP는 자바빈 객체를 위한 액션 태그를 제공하고 있다. 

```<jsp:uesBean>``` 액션 태그는 JSP 페이지에서 사용할 자바빈 객체를 지정할 때 사용한다.       
주관적인 생각으로 객체에 대한 ```참조변수 생성``` 및  기본 객체의```속성```을 생성해주는 태그이다.      
```
<jsp:uesBean id="[자바빈이름]" class="[자바빈클래스이름]" scope="[범위]" />
```  
  
* id : JSP 페이지에서 자바빈 객체에 접근할 때 사용할 이름을 지정한다. (참조 변수 이름 설정)      
* class : 패키지 이름을 포함한 자바빈 클래스의 완전한 이름을 입력한다. (중요한 것은 패키지 포함 완전한 이름)    
* scope : 자바빈 객체를 저장할 영역을 지정한다. 기존에 영역 공부했을시의 기본 객체를 입력하면 된다.(기본은 page)  
          (page, request, session, application 이 있다.) 
  
즉 단순히 말해서 ```<jsp:uesBean id="[자바빈이름]" class="[자바빈클래스이름]" scope="[범위]" />``` 는   
```클래스 참조변수 = new 참조변수();```와```request.setAttribute("참조변수", 참조변수);``` 동시에 동작한 것이다.
```
MemberInfo info = new MemberInfo();
request.setAttribute("info", info);   // value 는 Object 이기에 아무거나 저장가능  
```
그리고 속성을 생성하는 것이기에 만약 기존에 있던 이름이 있다면 기존 속성을 그대로 이용한다.     
추가로 ```<jsp:uesBean>``` 액션 태그에서 ```class=""``` 대신에 ```type=""```을 사용해도 된다.     
단, ```type=""```은 지정한 영역에 이미 객체가 존재한다고 가정한다.       
즉, 속성에 이미 존재하지 않으면 에러를 발생시키고 존재한다면 기존 것을 사용하겠다는 의미이다.     
```
<jsp:uesBean id="[자바빈이름]" type="[자바빈클래스이름]" scope="[범위]" />
```

# 3. 
```<jsp:setProperty>``` 액션 태그를 사용하면 생성한 자바빈 객체의 프로퍼티 값을 변경할 수 있다.       
중요한 것은 **자바빈 객체를 바꾸는 것이 아닌 그 객체 내에 있는 프로퍼티(인스턴스 변수)의 값을 바꾸는 것**이다.  
즉, 속성에 저장된 값이 아닌 그 저장된 값의 프로퍼티를 바꾼다는 표현이 맞다.  
```
<jsp:setProperty name="[자바빈(참조변수)]" property="인스턴스 변수명" value="값">
```
* name : 프로퍼티의 값을 변경할 자바빈 객체의 이름을 지정한다. (<jsp:uesBean> 액션태그의 id 속성에서 지정한 값)      
* property : 값을 지정할 프로퍼티의 이름을 지정한다. (값을 바꿀 인스턴스 변수이름)      
* value : 프로퍼티 값을 지정한다. 표현식(```<%= %>```)이나 EL(```${값}```)을 사용할 수 있다. 
   
```<jsp:setProperty>``` 액션 태그에서 ```value=""```를 사용하지 않고 ```param=""```을 사용할 수 있다.       
이는 파라미터와 프로퍼티의 이름이 같을 경우 ```프로퍼티의 값 = 파라미터 값```으로 할당시키는 속성이다.         
같은 이름을 가진 프로퍼티에 값을 할당해주는 것이니  ```value=""```는 사용하지 않는 것이다.    
```
<jsp:setProperty name="[자바빈/참조변수]" property="인스턴스 변수명" param="파라미터 이름" />
```
  
```param=""```은 ```property="인스턴스 변수명"```으로 정해진 하나의 프로퍼티에 대해서 동작을 한다.   
```property=""```에 ```*```를 넣어도 되는데 이는 모든 파라미터의 이름과 같은 프로퍼티의 값을 지정하는 것이다.      
프로퍼티에 대한 일치하는 모든 파라미터의 값을 사용하기에 ```value=""```이나 ```param=""```을 기술하지는 않는다.   
```
<jsp:setProperty name="[자바빈/참조변수]" property="*" />
```
  
# 4. 
```<jsp:getProperty>``` 액션 태그는 자바빈 객체의 프로퍼티 값을 출력할 때 사용된다.     
```  
<jsp:getProperty name="[자바빈/참조변수]" property="인스턴스 변수명" />
```
```<jsp:getProperty>``` 액션 태그는 ```자바빈 참조변수.get프로퍼티()```를 사용한 것이다.   

# 5.
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

# 6.
자바빈 프로퍼티 ```width```의 타입이 ```int``` 일 경우를 생각해보자,     
```
<jsp:setProperty name="someBean" property="width" value="100" />
```
우선 ```value="100"``` 으로 기술 되어 있고 100은 문자열로 처리되어있다.  
이 경우 ```<jsp:setProperty>``` 액션 태그는 값을 어떻게 처리할까?  
  
```<jsp:setProperty>``` 액션 태그는 프로퍼티 타입에 따라서 알맞게 값을 처리한다.    
즉, ```value="100"```으로 문자열로 기술되어있어도 100으로 처리해준다.    
정확히는 ```래퍼클래스.valueOf(String)```으로 처리해주기에 문자열을 알맞은 값으로 매핑 시켜준다.     

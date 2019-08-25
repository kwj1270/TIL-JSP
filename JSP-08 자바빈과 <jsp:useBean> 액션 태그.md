자바빈과 <jsp:useBean> 액션 태그
=======================
우선 처음 공부 했을시에 자바빈에 대한 개념이 명확하지 않았기에 필자가 생각하는 자바빈에 대해서 얘기해보자 한다.  
필자가 생각하는 자바빈은 '클래스'를 의미하는 것이다.   
클래스 중에서도 어떠한 주제를 가지고 데이터를 저장하고 사용할 수 있는 클래스를 의미한다.  
어찌보면 ```DTO``` 와 개념적으로 비슷하다고 보면 된다.    
예를 들면 Student 클래스라면 학생과 관련된 변수가 존재하고 이러한 변수를 설정하는 getter 와 setter 메소드가 존재한다.  
이제 이러한 개념을 기억하고 공부를 시작해보자.  
# 1. 자바빈(JavaBean)
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
    this.vlaue - vlaue;
  }
  
}
```
자바빈 규약을 따르는 클래스를 **자바빈**이라 부른다.    
일반 적으로 멤버와 생성자 그리고 getter 와 setter 메서드가 존재한다.    
그리고 여러 프로퍼티가 존재할 경우 해당하는 getter 와 setter 메서드를 생성해 주어야한다.    
   
## 1.1. 자바빈과 프로퍼티
프로퍼티는 자바빈에 저장되는 값을 나타낸다.(인스턴스 변수를 의미한다.)        
메서드 이름은 이러한 프로퍼티를 기준으로 ```set``` 과 ```get```을 붙인다.     
물론 이름이 달라도 상관없지만 명확하게 나타내기 위해서 같게 해주는 것이 편리하다.   
(```set``` 에서는 매개변수를 사용하는데 매개변수의 이름은 아무거나 지정해줘도 된다.)     
```
public void setMaxAge(int value);
public int getMaxAge();
```
  
이것은 하나의 암묵적인 룰인데 프로퍼티(인스턴스 변수)가 ```boolean 형```이라면  
getter 에서 ```get``` 대신에 ```is``` 를 붙인다.
```
public void setFinished(boolean finished);
public boolean isFinished();
```
  
당연한 얘기일지 모르지만 자바빈 프로퍼티는 배열로 사용할 수도 있기에      
매개변수로 배열을 그리고 반환형을 배열로 설정할 수도 있다.     
```
public int[] getMark();
public void setMark(int[] values);
```
그리고 이러한 배열을 이용하기에 **오버라이딩**으로 부분적으로 접근할 수 있는 방법도 기술해주면 좋다.
주로 인덱스 값을 넣어서 해당하는 값을 get 하거나 set 할 수 있게끔 해준다  .     
이 때 반환형과 매개변수는 배열형태가 아닌 단일 데이터형으로 해주자.     
```
public int getMark(int index);
public void setMark(int value, int index);
```

이제 프로퍼티에 대해서 이야기를 해볼텐데      
프로퍼티를 작성할 때는 프로퍼티가 어떠한 목적을 위해서 어떤 동작을 하는지에 대해서 생각을 해야한다.   
주로 프로퍼티 값에는 ```읽기 전용 프로퍼티```와 ```읽기/쓰기 프로퍼티```가 존재한다.  
     
* 읽기 전용 프로퍼티: get 또는 is 메서드만 존재하는 프로퍼티  
* 읽기/쓰기 프로퍼티: get/set 또는 is/set 메서드가 존재하는 프로퍼티  
  
사실 프로퍼티를 정의하고 용도에 맞는 메서드를 정의하는 것인데 설명에는 다 정의되어있다는 가정하에 기술되어있다.  
  
읽기 전용 프로퍼티같은 경우 꼭 해당하는 프로퍼티가 존재하지 않아도 되는데 예를 들면 아래와 같다.  
```
public class Temperature{
  private double celsius;

  public double getCelsius(){
    return celsius;
  }

  public void setCelsius(double celsius){
    this.celsius = celsius;
  }

  //읽기 전용 프로퍼티 fahrenheit
  public double getFahrenheit(){
    return celsius * 9.0 / 5.0 + 32.0;
  }
}
```
사실 존재하지 않는 프로퍼티(인스턴스 변수)에 대해서 이를 읽기 전용 프로퍼티라 말하기는 애매하지만  
이렇듯 읽기 전용으로 메서드를 정의해서 이를 사용할 수 있기도 하다.  

***
# 2. 예제에서 사용할 자바빈 클래스
예제에서 사용하는 것이기에 넘어가려 했지만 유용한 정보들이 많아서 기술해보려 한다.    
    
**Memberinfo.java**
```
package chap08.member;

import java.util.Date;

public class MemberInfo{
  
  private String id;
  private String password;
  private String name;
  private Date registerDate;
  private String email;

  public string getId(){
    return id;
  }
  
  public void setId(String id){
    this.id = id;
  }
  
  public string getPassword(){
    return id;
  }

  public void setPassword(String password){
    this.password = password;
  }
  
  public string getName(){
    return name;
  }

  public void setName(String name){
    this.name = name;
  }

  public Date getRegisterDate(){
    return registerDate;
  }
  
  public void setRegisterDate(Date registerDate){
    this.registerDate = registerDate;
  }
  
  public string getEmail(){
    return email;
  }
  
  public void setEmail(String email){
    this.email = email;
  }
}
```
소스 코드를 작성 했다면, 명령 프롬프트를 열고 Memberinfo.java 클래스를 컴파일 하자.
  
1. cd C\apache-tomcat-버전\webapps\chap08\WEB-INF\    
2. mkdir classes    
  * WEB-INF 폴더에 classes 하위 폴더를 생성한다. 직접 디렉토리로 이동해 생성해주어도 된다.     
3. jvavc -encoding UTF-8 -d classes src\chap08\member\MemberInfo.java     
   
컴파일에 성공하면, ```chap08\WEB-INF\classes\chap08\member``` 폴더에 ```MemberInfo.class``` 파일이 생성된다.   
    
**javac 옵션**    
```
-encoding : 소스 코드의 인코딩을 지정한다. 위에서는 UTF-8 로 지정했다.
-d        : 컴파일 결과로 생성될 클래스 파일의 위치를 지정한다. 실제 클래스 파일은 패키지에 맞는 폴더에 생성된다.  
            위에서는 src\chap08\member\MemberInfo.java 을 사용했다.  
            소스코드 파일을 나타내는 src 폴더를 제외하면 chap08\member는 MemberInfo.java의 패키지를 나타낸다.  
            즉, chap08.member.MemberInfo를 나타내므로 해당 디렉토리가 없으면 생성 해주고  
            자바 파일을 가지고 javac를 했기에 해당 디렉토리에 MemberInfo.class 파일을 생성한다.  
            
이 외에도

-source   : 소스 코드의 자바 버전을 지정한다. (1.7이나 1.8과 같은 자바 버전을 지정한다.)
-target   : 클래스 파일이 호환될 자바 버전을 지정한다.(1.7이나 1.8과 같은 자바 버전을 사용한다.)
-cp       : 컴파일 할때 사용할 클래스 패스를 지정한다. (현재 디렉토리와 사용할 클래스의 위치가 다를 때 사용.)
-classpath: -cp 와 동일
```

***
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

## 3.3. <jsp:setProperty> 액션 태그와 <jsp:getProperty> 액션 태그       

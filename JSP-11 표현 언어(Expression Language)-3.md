표현 언어(Expression Language)-3
=======================
# 3. EL에서 객체의 메서드 호출
```JSP 2.2/EL 2.2``` 버전 부터 객체의 메서드를 직접 호출할 수 있다.  
```
${m.getName()}    <%-- JSP2.1 또는 그 이전버전에서는 컴파일 에러 -->
```
이러한 문법적 지식을 가지고 클래스를 하나 만들어 보겠다.    
  
**Thermomter 클래스 예시**  
```
package chap11;

import java.util.HashMap;
import java.util.Map;

public class Thermometer {

  private Map<String, Double> locationCelsiusMap = 
    new HashMap<String, Double>();

  public void setCelsius(String location, Double value){
    locationCelsiusMap.put(location, value);
  }
  
  public Double getCelsius(String location){
    return locationCelsiusMap.get(location);
  }
  
  public Double getFahrenheit(String location){
    Double celsius = getCelsius(location);
    if(celsius == null) {
      return null;
    }
    return celsius.doubleValue() * 1.8 + 32.0;
  }
  
  public String getInfo(){
    return "온도계 변환기 1.1";
  }
 
}
```
이제 해당 java 파일을 클래스로 만들어 주자  
  
1. 명령 프롬프트를 실행한다.  
2. 다음 명령어로 폴더를 이동한다.  
```cd c:\apache-tomcat-8.0.2\webapps\chap11\WEB-INF```
3. classes 폴더를 생성한다.   
```mkdir classes```
4. javac 명령어를 컴파일 한다.    
```javac -d classes src\chap11\Thermometer.java```
5. classes\chap11 폴더에 Thermometer.class 파일이 생성되었는지 확인한다.  
  

**theremoeter.jsp**
```
<%@ page import="chap11.Thermometer" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%
  Thermometer thermometer = new Thermometer();
  request.setAttribute("t", thermometer);
%>
<html>
<head><title>온도 변환 예제</title></head>
<body>
  ${t.setCelsius('서울',27.3)}
  서울 온도: 섭씨 ${t.getCelsius('서울')}도 / 화씨 ${t.getFahrenheit('서울')}
  
  <br/>
  정보: ${t.info}
</body>
</html>
```
```import```로 앞서 정의한 클래스를 지정했으므로 우리는 이제 해당 클래스를 이용할 수 있다.    

JSP 2.2 버전부터는 ```setCelsius(String location, Double value)``` 나 ```Double getFahrenheit(String location)```와 같이  
리턴 타입이 ```void```이거나 파라미터 개수가 한개 이상 존재하는 메서드를 EL에서 호출할 수 있다.    
그래서 해당 JSP에서 EL 구문을 이용해서  ```{t.setCelsius()}``` ```${t.getCelsius()}``` ```${t.getFahrenheit()}``` 사용했다.

***
# 4. EL에서 정적 메서드 호출하기 1
JSP의 표현식은 자바의 클래스를 마음대로 사용할 수 있다.  
```
<%
  SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
  Date date = new Date();
%>
...
오늘은 <%= formatter.format(date) %> 입니다.  
```
EL은 위코드처럼 직접 자바 코드를 사용할 수 없기 때문에 값을 처리하는 방식에 한계가 생긴다.  
이런 한계를 줄이기 위해 EL은 자바 클래스의 정적 메서드를 호출할 수 있는 두가지 방법을 제공하고 있다.    
   
## 4.1. 예제에서 사용할 클래스 작성
```
package util;

import java.util.text.DecimalFormat;

public class FormatUtil{
  
  public static String number(long number, String pattern){
    DecimalFormat format = new DecimalFormat(pattern);
    return format.format(number);
  }
  
}
```
EL에서 클래스의 메서드를 사용하기 위해서는 클래스의 메서드를 **static**으로 정의해야하며,  
```static```이 아닌 메서드는 사용할 수 없다.  
   
## 4.2. 함수를 정의한 TLD 파일 작성
TLD는 Tag Library Descriptor의 약자로서  이 파일은 태그 라이브러리에 대한 설정 정보를 담고 있다.  

이번에 사용할  TLD 파일은 ```el-functions.tld```로 아래와 같다.
    
**chap\WEB-INF\tlds\el-functions.tld**  
```
<?xml version="1.0" encoding="utf-8" ?>
<taglib xmlns="http://java.sun.com/xml/ns/javaee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://java.sun.com/xml/ns/javaee
    http://java.sun.com/xml/ns/javaee/web-jsptaglibrary_2_1.xsd"
  version="2.1">
<description>EL에서 함수실행</description> 
<tlib-version>1.0</tlib-version>
<short-name>ELfunctions</short-name>

<function>
  <description>숫자 포맷팅</description>
  <name>formatNumber</name>
  <function-class>util.FormatUtil</function-class>
  <function-signature>
    java.lang.String number(long, java.lang.String)
  </function-signature>
</function>

</taglib>
```
TLD 파일은 WEB-INF\tlds 폴더나 WEB-INF\jsp 폴더와 같은 곳에 위치시켜야 한다.
   
## 4.3. web.xml 파일에 TLD 내용 추가하기
TLD 파일을 작성한 다음에는 web.xml 파일에 TLD 파일 설정을 추가해야 한다.   
  
**chap11\WEB-INF\web.xml**
```
<?xml version="1.0" encoding="utf-8" ?>           
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
            http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
         version="3.1">
         
 <jsp-config>
   <taglib>
     <taglib-uri>
       /WEB-INF/tlds/el-functions.tld
     </taglib-uri>
     <taglib-location>
       /WEB-INF/tlds/el-functions.tld
     </taglib-location>
   </taglib>
 </jsp-config>  

</web-app>
```
JSP 페이지는 ```<taglib-uri>```에 명시한 식별자를 이용해서 태그 라이브러리를 사용한다.  
    
## 4.4. EL에서 함수 사용하기
함수를 정의한 태그 라이브러리를 사용할 준비가 되었으므로 EL에서 함수를 사용할 수 있다.  
이때 사용하는 것은 ```taglib 디렉티브``` 이다.
```
<%@ taglib prefix="pre" uri="..." %>
...
${pre:functionName(arg1, arg2, ..)}
...
```
```taglib 디렉티브```는 앞서 ```web.xml``` 파일에서 설정한 태그 라이브러리를 JSP 페이지에서 사용한다는 것을 명시한다.    
```taglib 디렉티브```의 ```prefix``` 속성은 태그 라이브러리를 구분할 때 사용할 접두어를 나타낸다.  
EL에서 태그 라이브러리에 정의된 함수를 사용하려면 ```${prefix로 지정한 접두어:함수이름(인자..)}```의 코드를 사용한다.  
  
함수이름은 클래스에 존재하는 함수의 이름을 사용하는 것이 아니라     
TLD 파일에서 <function> 태그의 자식 태그인 <name> 태그에서 지정한 이름과 동일해야하다.  
물론, 인자는 함수 그대로의 인자를 생각해서 넣으면 된다.    

```
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="elfunc" uri="/WEB-INF/tlds/el-functions.tld" %>
<%
  request.setAttribute("price",12345);
%>
<html>
<head><title>EL 함수 호출</title></head>
<body>

가격은 <b> ${elfunc:formatNumber(price, '#,##O')}</b> 입니다.

</body>
</html>
```
   
***
# 5. EL에서 정적 메서드 호출하기2 
앞서 3장에서 EL에서 클래스의 정적 메서드를 호출하기 위해 할 것이 많았다.       
```TLD``` 파일을 작성해야하고, ```web.xml``` 파일도 설정해야 하고, ```taglib 디렉티브```도 설정해야한다.  
메서드를 호출할 때에도 TLD 파일에 설정한 이름을 사용해야 한다.   

그러나 EL 3.0 버전은 이러한 복잡한 과정이 없이 정적 메서드를 호출할 수 있는 기능을 추가했다.    
즉, 간단하게 JSP 코드만 작성하면 된다.  

```
<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="util.FormatUtil" %>
<%
  request.setAttribute("price", 12345L);
%>
<html>
<head><title>EL 함수 호출</title></head>
<body>

가격은 <b>${FormatUtil.number(price, '#,##O')}</b>원 입니다.   

</body>
</html>
```
간단하게 ```import```구문만 하면 정적 메서드를 사용할 수 있다.  
이뿐만 아니라 ```java.lang 패키지```는 기본적으로 임포트하므로 바로 사용할 수도 있다.  
```
${Long.parseLong("10")}
```
   
***
# 6. 람다식 사용하기
람다식도 EL 3.0에서 새롭게 추가 된것이다.    
람다식은 함수처럼 파라미터를 가진 코드 블록이다.     
   
**구조**
```
(파라미터1, 파라미터2) -> EL 식
```
**예시**
```
${greaterThan = (a, b) -> a > b ? true : false ; "}
___________________________________________________________
${greaterthan(1,3)}
<%--(1, 3) -> 1 > 3 ? true : false ; "" 으로 동작한다. --%>
```
일단 변수의 값을 대입하는 할당 연산자를 사용했는데 할당 연산자는 값을 바로 출력한다.  
그래서 세미콜론 연산자를 같이 사용해서 빈문자열을 출력하도록 했다.   
하지만 여기서 중요한 점은 람다를 사용했다는 점과 greaterThan은 함수처럼 사용 가능하다는 점이다. 
```
${((a, b) -> a > b ? true : false)(1,3)}
<%-- 익명 함수 생성 --%>
```
물론 특정 변수를 사용하지 않고도 바로 호출 할 수도 있다.
```
${ factorial = (n) -> n ==1 ? 1 : n * factorial(n-1) ; " }
${ factorial(5) }
```
람다식은 재귀호출도 가능하다.  람다식 안에 람다를 호출하면 된다.  
```
<%-- 람다식의 파라미터가 한 개인 경우 파라미터의 괄호를 생략해도 된다. --%>
${ factorial = n -> n ==1 ? 1 : n * factorial(n-1) ; " }
${ factorial(5) }
```
람다식의 파라미터가 한 개인 경우에는 파라미터의 괄호를 생략해도 된다.   

JSP로 시작하는 웹 프로그래밍-2
=======================
# 3. page 디렉티브
```jsp
<% @page 속성 = "값" 속성2 = "값2" ... %>

디렉티브 이름이 page인 것을 'page 디렉티브' 라고 한다.
```
page 디렉티브는 JSP 페이지에 대한 정보를 입력하기 위해서 사용된다.  
page 디렉티브를 사용하면    
    
1. JSP가 어떤 문서를 생성하는지
2. 어떤 자바 클래스를 사용하는지
3. 세션에 참여하는지
4. 출력 버퍼의 존재여부  
  
와 같이 JSP 페이지를 실행하는 데 필요한 정보를 입력할 수 있다. 


## 3.1. page 디렉티브의 속성
```
____________________________________________________________________________________________________________________________________
| 속성                               | 설명                                                       | 기본 값                         |   
|____________________________________|____________________________________________________________|_________________________________|
|contentType                         | JSP가 생성할 문서의 MIME 타입과 캐릭터 인코딩(차순)을 지정  | text/html                       |
|import                              | JSP 페이지에서 사용할 자바 클래스를 지정한다.               |                                 | 
|session                             | JSP 페이지가 세션을 사용할지의 여부를 정한다.               | true                            |
|buffer                              | JSP 페이지의 출력 버퍼 크기를 지정, "none"시에 사용X        | 최소 8KB (입력시 KB 입력해야함)  |
|autoFlush                           | 자동 버퍼 비우기(출력) 여부를 판단                          | true (false시 에러 발생)         |
|info                                | JSP 페이지에 대한 설명을 입력                               |                                 |
|errorPage                           | JSP 페이지를 실행하는 도중에 에러 발생시 보여줄 페이지 지정  |                                 | 
|isErrorPage                         | 현재 페이지가 에러페이지인지의 여부를 지정                  | false                           |  
|pageEncoding                        | JSP 페이지 소스 코드의 캐릭터 인코딩을 지정 (우선순위)      |                                 |
|isELIgnored                         | 표현 언어에 대한 해석 여부를 지정 (true 면 해석 X)          | false                           |
|deferredSyntaxAllowedAsLiteral      | #{ 문자가 문자열 값으로 사용되는 여부를 지정                | false                           |
|trimDirectiveWhitespaces            | 출력 결과에서 템플릿 텍스트의 공백 문자 제거 여부를 지정     | false                           |
|____________________________________|____________________________________________________________|_________________________________|
```
### 3.1.1. contentType 속성과 캐릭터 셋
```contentType = "값"```은 JSP 페이지가 생성할 문서의 타입을 지정한다.
```
TYPE

또는

TYPE; charset = 캐릭터 셋
```
```contentType```은 JSP가 생성할 문서의 MIME 타입을 입력한다.  
JSP에서 주로 사용하는 MIME 타입은 ```"text/html"```이고 필요에 따라  
```"text/xml"```, ```application/json``` 등의 MIME 타입을 사용하기도 한다.   
   
```contentType```은 캐릭터 인코딩을 지정할 수 있는데 이는 ```pageEncoding = 값``` 속성이 없을 때 차순으로 지정한다.  
그래서 캐릭터셋을 생략할 수도 있는데 만약 ```pageEncoding```도 없을 경우에는 인코딩은 ```ISO-8859-2```로 지정된다.  
하지만 우리는 한국인이므로 다국어를 지원하는 ```UTF-8```을 사용하도록 정의하자.
   
**예시**   
```jsp
<% @page contentType = "text/html; charset=utf-8" %>
```
참고로 인코딩 디코딩은 보내는쪽, 받는쪽 양 측의 형식이 맞아야 한다.   
  
### 3.1.2. import 속성
자바에서 외부 클래스를 사용하기 위해서 ```import``` 구문을 사용하듯이 (패키지.클래스 이름을 단순 이름으로 생략)   
JSP에서도 page 디렉티브의 ```import```속성을 사용해서 클래스의 단순 이름을 사용할 수있다.  
     
**예시**
```jsp
<% @page import="java.util.Date"%>
...중략
<%
  Date now = new Date();
%>

또는

<% @page import="java.util.*" %>
...중략
<%
  Date now = new Date();
%>
```
자바와 마찬가지로 ```.*``` 을 사용하면 해당 패키지에 속한 클래스의 이름을 단순히 사용가능하다.  

### 3.1.3. trimDirectiveWhitespaces 속성
웹 브라우저에 사용가능한 코드가 있다고 가정시  
```page 디렉티브```는 웹 브라우저에서 '소스보기'를 하면 공백으로 사라진다.
```jsp
                                <--- 여기가 공백으로 처리됨
<html>
<head>
</head>
<body>
</body>
</html>
```
```<% @page trimDirectiveWhitespaces="true" %>```를 사용하게 되면 웹 브라우저에서 '소스보기'에도 공백이 사라지지 않는다.    
    
**예시**  
```jsp
<% @page contentType="text/html; charset=utf-8" %>
<% @page trimDirectiveWhitespaces="true" %>
<html>
<head>
</head>
<body>
</body>
</html>
```
**결과**
```jsp
<html>
<head>
</head>
<body>
</body>
</html>
```

### 3.1.4. JSP 페이지의 인코딩과 pageEncoding 속성
우선 BOM의 개념부터 알아보자   
  
**BOM**
```
BOM 은 ByteOrderMark의 약자로서 유니코드 인코딩에서 
바이트의 순서가 리틀 엔디언인지 빅 엔디언인지의 여부를 알려주는 16비트 값이다.
```
  
웹 컨테이너가 JSP 페이지를 읽어올 때 사용할 캐릭터 셋을 결정하는 기본 과정은 다음과 같다.      
    
**파일이 BOM으로 시작하지 않을 경우**
```
1. 기본 인코딩을 이용해서 파일을 처음부터 읽고 page 디렉티브의 pageEncoding="값" 이 있는지 검색한다.  
   단, pageEncoding 속성을 찾기 이전에 ASCII 문자 이외의 글자가 포함되어 있지 않은 경우에만 적용
   
2. pageEncoding속성이 값을 갖고 있다면, 파일을 읽어올 때 속성값을 캐릭터 셋으로 사용한다.

3. pageEncoding속성이 없다면, contentType의 '캐릭터 셋'을 검색한다.  
   단, contentType 속성을 찾기 이전에 ASCII 문자 이외의 글자가 포함되어 있지 않은 경우에만 적용

4. contentType속성에도 '캐릭터 셋' 값이 없다면 기본 값인 ISO-8859-1을 캐릭터 셋으로 사용한다.  
```
**파일이 BOM으로 시작할 경우**
```
1. BOM울 이용해서 결정된 인코딩을 이용하여 파일을 읽고, 
   page 디렉티브의 pageEncoding 속성을 검색한다.

2. 만약 pageEncoding 속성의 값과 BOM을 이용해서 결정된 인코딩이 다르면 에러를 발생시킨다.    
```
위 두 과정은 JSP 규약에 명시된 과정으로서,  
웹 컨테이너는 위 과정을 제품별로 최적화 할 수 도 있지만 기본 과정은 위와 비슷하다.    
즉, JSP 파일을 읽을 때는 page 디렉티브의 ```pageEncoding``` 과 ```contentType의 캐릭터 셋```을 사용한다.  
  
만약 ```pageEncoding```과 ```contentType``` 양쪽에 서로 다른 인코딩 방식 있다면?  
```
<% @page contentType="text/html; charset=euc-kr" %>
<% @page pageEncoding="utf-8" %>
```
```pageEncoding``` 속성은 JSP 파일을 인코딩하고
```contentType``` 속성은 응답 결과를 인코딩한다.
  
***
# 4. 스크립트 요소 
JSP의 스크립트 요소는 세 가지가 있다.
* 스크립트릿(Scriptlet)
* 표현식(Expression)
* 선언부(Declaration)  
   
 스크립트 요소는 JSP 프로그래밍에서 로직을 수행하는데 필요하다.  
 스크립트 코드를 사용해서 프로그램이 수행해야 하는 기능을 구현할 수 있다.
 
## 4.1. 스크립트 릿
스크립트릿(Scriptlet)은 JSP 페이지에서 자바 코드를 실행할 때 사용하는 코드 블록이다.     
  
**구조**
```jsp
<%
   자바 코드1 ;
   자바 코드2 ;
   자바 코드3 ;
%>

즉, <% 자바코드 %>
```
스크립트릿의 코드 블록은 ```<% 자바코드 %>```으로 이루어 진다.    
   
**예시**  
```jsp
<%
   int sum = 0;
   for(int i = 1; i <= 10; i++){
    sum = sum+i;
   }
%>
<%= sum%>
```
## 4.2. 표현식
표현식(Expression)은 어떤 값을 출력 결과에 포함시키고자 할 때 사용된다.      
     
**구조**
```jsp
<%= 값%>
```
표현식은 ```<%= 출력할 값 %>```으로 이루어 진다.    
변수뿐만 아니라 숫자, 문자열 등의 값을 표현식에서 사용할 수도 있다.   
  
**예시**
```jsp
1부터 10까지의 합은
<%= 1 + 2 + 3 + 4 + 5 + 6 + 7 + 8 + 9 + 10 %>
입니다.
```
## 4.3. 선언부
JSP 페이지의 스크립트릿이나 표현식에서 사용할 수 있는 **메서드**를 작성할 때 사용한다.
  
**구조**
```jsp
<%!
    public 리턴타입 메서드이름(매개변수 목록){
        자바코드1;
        자바코드2;
        ...
        return 값;
    }
%>
```
**예시**
```jsp
<%!
    public int multiply(int a , int b){
        int c = a*b;
        return c;
    }
%>
... 중략
10 * 25 = <%= multiply(10,25) %>
```
메서드의 이름에는 규칙이 있다.  
* 메서드 이름의 첫 글자는 문자 또는 밑줄```_```로 시작해야 한다.
* 첫 글자를 제외한 나머지는 문자와 숫자 그리고 밑줄의 조합이어야 한다.
* 메서드 이름은 대소문자를 구분한다.  
  
메서드를 정의햇으면 ```표현식``` 또는 ```스크립트릿```에서 메서드를 호출해서 사용하면 된다.    

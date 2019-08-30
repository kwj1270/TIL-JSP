표현 언어(Expression Language)-4
=======================
# 7. 스트림 API 사용하기
EL 은 for 나 while 같은 반복문을 제공하지 않는다.    
이런 이유로 EL 3.0 버전 이전에는 JSTL 의 ```<c:forEach>``` 태그와 ```<c:set>``` 태그를 사용해야 한다.  

EL 3.0 버전에는 컬렉션 객체를 위한 스트림 API가 추가 되었고 이를 통해 코드를 간단히 작성할 수 있다.  
```
<c:set var="lst" value="<%= java.util.Arrays.asList(1, 2, 3, 4, 5) %>" />
<c:set var="sum" value="${1st.stream().sum()}" />
```
또한, 위 코드는 세미콜론 연산자를 함께 사용하면 JSTL 태그를 사용하지 않고 EL 만으로 코드를 작성할 수 잇다.   
```
${lst=[1, 2, 3, 4, 5] ; sum = 1st.stream().sum(); "}
```
## 7.1. 스트림 API 기본
```
collection.stream()       // 콜렉션에서 스트림 생성
          .map(x -> x*x)  // 중간 연산 (스트림 변환)  
          .toList()       // 최종 연산 (결과 생성)
```
컬렉션 객체에 대해 stream()을 실행하면 스트림 객체를 생성한다.  
스트림은 이어지는 연산에 원소를 차례대로 제공한다.  
즉, 간단히 말하면 연산시에 collection 에 저장된 각 원소들을 하나 하나씩 사용하여 계산한다는 의미이다.    
  
스트림 객체의 중간 연산 메서드는 새로운 스트림 객체를 생성하는데, 이 과정에서 변환을 수행한다.    
쉽게 말해 각각의 요소들을 연산하여 새로운 값을 얻어내고 이를 통해 스트림 객체를 생성한다는 뜻이다.     
  
최종 연산은 스트림에서 데이터를 읽어와 최종 결과를 생성한다.  
중간 연산은 최종 연산을 하기 전까지 여러번 수행할 수 있으며,
최종 연산은 딱 한번만 수행할 수 있다.  
```
${lst.stream()                  // 1st 리스트의 각 요소들을 스트림 객체로 생성한다.  
     .filter(x -> x % 2 == 0 )  // 필터의 인자로 들어간 함수의 정의에 맞는 요소들만 걸러낸다.
     .map( x -> x*x)            // 맵의 인자로 들어간 함수의 정의대로 요소들을 변형시킨다.  
     .toList()}                 // 스트림 객체를 리스트 객체로 변형 시킨다.  
```

그리고 물론, 중간 연산을 취하지 않고 최종연산만 사용해도 된다.   
```
lst.stream().sum()
```
  
## 7.2. stream()을 이용한 스트림 생성
```java.util.Collection``` 타입의 객체에 대해 ```stream()``` 메서드를 실행하면 EL 스트림 객체를 생성한다.     
필자 : 대부분의 컬렉션 프레임 워크는 ```Collection 인터페이스```를 구현하기에 EL 스트림 객체를 생성할 수 있다.     
```
${lst = [1, 2, 3, 4, 5]; "}
${lst.stream().sum()}
```

EL은 Map 타입의 값에 대해 ```Stream()```을 지원하지 않는다.      
정확히 말하면 Map 컬렉션 프레임 워크는  ```Collection 인터페이스``` 구현하지 않기에 사용할 수 없는 것이다.      
만약 Map에 ```stream()```을 사용하고 싶다면    
```Map.entrySet()```과 같이 Map 에서 컬렉션 타입 객체를 생성한 다음에 그 객체의 ```stream()``` 메서드를 사용하면 된다.   
```
<%
  java.util.Map<String, String> map = new java.util.HashMap<>();
  map.put("code1", "코드1");
  map.put("code2", "코드2");
  request.setAttribute("map", map);        
%>
${map.entrySet().stream()
                .map(entry -> entry.value)
                .toList}
```
Map의 ```entrySet()```은 ```java.util.Entry```의 집합을 리턴하므로,  
EL의 ```stream()``` 메서드가 생성하는 스트림 객체의 원소 타입은 ```Entry```가 된다.  

```
stream() 메서든느 실제 자바 컬렉션 API 에서 제공하는 메서드가 아니라 EL 에서 제공하는 메서드이다. 
자바 8은 컬렉션에 대해 stream()메서드를 제공하지만, 자바 8 에서 EL을 실행하는 경우
stream()은 자바 8의 stream() 메서드가 아닌 EL 의 stream() 메서드를 실행한다.  

<%
  여기서 실행하면 자바의 stream()
%>

${ 여기서 실행하면 EL의 stream() }
```
  
## 7.3. filter()를 이용한 걸러내기
```filter()```는 값을 걸러낼 때 사용한다.     
```filter()``` 메서드는 람다식을 파라미터로 갖고 이 람다식은 한 개 파라미터를 갖고 결과로 ```Boolean```을 리턴한다.     
```filter()``` 메서드는 스트림의 각 원소에 대해 람다식을 실행하고 그 결과가 ```true```인 원소를 제공하는 새로운 스트림을 생성한다.      
```
collection.stream()                     스트림 생성
          .filter(x -> x % 2 == 0)      각 원소에 대해 filter()의 람다식을 실행해서
                                        람다식이 true인 각각의 원소를 갖는 새로운 스트림 생성
          .toList()                     filter()로 생성된 스트림을 통해 새로운 List 생성
```
위 코드는 짝수만 포함하는 새로운 스트림을 만들고 이를 통해 새로운 리스트 객체를 만든다.  
  
## 7.4. map()을 이용한 변환
map()은 원소를 변환한 새로운 스트림을 생성한다.    
map() 메서드는 람다식을 파라미터로 갖는다.    
이 람다식은 한 개 파라미터를 갖고 결과로 파라미터를 변환한 새로운 값을 리턴한다.   
map() 메서드는 스트림의 각 원소에 대해 람다식을 실행하고 람다식의 결과로 구성된 새로운 스트림을 생성한다.  
```
collection.stream()                     스트림 생성
          .map(x -> x * x)              각 원소에 대해 map()의 람다식을 실행해서
                                        람다식 조건에 따라 각각의 원소를 변환하고 
                                        변환된 값들을 갖는 새로운 스트림 생성                    
          .toList()                     map()으로 생성된 스트림을 통해 새로운 List 생성
```
map() 메서드는 컬렉션에 포함된 원소에서 특정 값을 추출하는 용도에 적합하다. 
```
${ageList = members.stream().map(mem - > mem.age).toList() ; "}
```
위 코드의 재미있는점은 컬렉션 프레임워크에 있는 객체를 하나 꺼내고 그 객체의 age를 리턴했다.     
그리고 그것들을 리스트 객체로 묶어서 최종 연산을 진행 했으니 리스트에는 각 객체들의 나이가 있을 것이다.    
```
${ageList = members.stream().map(mem - > mem.age).filter(x -> x >= 20).averge().get(); "}
```
위 코드의 ```filter()``` 메서드와 ```average()``` 메서드 그리고 ```get()``` 메서드를 사용했다.    
```filter()```를 통해 20세 이하의 사람의 나이만 존재하도록 걸러내고 또한, 이들의 평균 값을 계산했다.  
후에 배우지만 ```averge()```는 Optional 타입을 리턴하기에 값을 얻기 위해 ```get()```을 사용했다.  
```
${ageList = members.stream().filter(x -> x >= 20).map(mem - > mem.age).averge().get(); "}
```
이렇게 순서를 바꿔도 괜찮다.  
  
## 7.5. sorted()를 이용한 정렬
```sorted()```를 사용하면 스트림을 정렬할 수 있다.  
```
${ vals = [20, 17, 30, 2, 9, 23] ;
   sortedVals = vals.stream().sorted().toList()}
```
그렇지만 ```sorted()```가 모든 타입의 원소를 정렬할 수 있는 것은 아니다.  
```
public class Member{
  private String name;
  private int age;
  
  public Member(String name, int age){
    this.name = name;
    this.age = age;
  }
  
  public String getName(){return name;}
  public int getAge(){return age;}

}
```
```
<%
  List<Member> memberList = Arrays.asList(
      new Member("홍길동", 20), new Member("이순신", 54),
      new Member("유관순", 19), new Member("왕건", 42)
  );
  request.setAttribute("members", memberList);        
%>
${ members.stream().sorted().toList() } <%-- 에러 ! --%>
```
에러가 발생한 이유는 ```Member 클래스```가 ```Comperable 인터페이스```를 구현하고 있지 않기 때문이다.    
```sorted()``` 메서드는 원소를 정렬할 때 ```Comperable 인터페이스```에 정의된 기능을 사용하기 때문에,    
이 인터페이스를 구현하지 않은 타입의 원소는 정렬할 수 없다.    
기본 데이터형의 래퍼 클래스인 ```Integer```, ```Long```, ```String``` 과 같은 타입은 이미 오름차순에 맞게 ```Comperable```을 구현하고 있다.   
       
만약 ```Comperable 인터페이스```를 구현하고 있지 않은 원소를 정렬해야 하거나,   
사용자 정의대로 정렬 순서를 지정하고 싶은 경우에는 ```sorted()``` 메서드에 값을 비교할 때 사용할 람다식을 전달하면 된다.     
```
${ vals = [20, 17, 30, 2, 9, 23];
   sortedVals = vals.stream().sorted((x1, x2) -> x1 < x2 ? 1 : -1 ).toList() }
```
일단 **내림차순을 위한 정렬 코드**이다.    
sorted()의 람다식은 두 개의 파라미터를 갖는다.         
첫 번째 파라미터와 두 번째 파라미터를 비교해서,     
첫 번째 파라미터가 정렬 순서상 앞에 위치해야 하면 음수를 리턴하고    
뒤에 위치해야 하면 양수를 리턴한다.     
여기서는 음수를 양수를 리턴했으니 뒤에 위치 시킨 것이다.    
반대로 ```(x1, x2) -> x1 > x2 ? 1 : -1 )``` 일 경우는 오름차순으로 정렬 된다.       
     
이제 앞서 정의했던 Member 클래스에 대해서 정렬을 해보겠다.    
```
<%
  List<Member> memberList = Arrays.asList(
      new Member("홍길동", 20), new Member("이순신", 54),
      new Member("유관순", 19), new Member("왕건", 42)
  );
  request.setAttribute("members", memberList);        
%>
${ sortedMem = members.stream()
                      .sorted((m1, m2) -> m1 > m1.age.compareTo(m2.age))
                      .toList() ; " } 
```
그리고 이 예제를 실행하려면 ```Member.java```를 컴파일 해서 클래스 파일을 만들어 주어야 한다.     
``` javac -d classes src\chap11\Member.java```    
   
## 7.6. limit()을 이용한 개수 제한
```limit()``` 은 지정한 개수를 갖는 새로운 스트림을 생성한다.  
```sorted()``` 와 ```limit()```을 함께 사용하면 값을 정렬하고 그 결과 중에서 앞에 n개만 걸러낼 수 있다.  
```
${ nums.stream().sorted().limit(3).toList() }
```
   
## 7.7. toList()와 toArray()를 이용한 결과 생성
```toList()``` 는 자바 리스트 객체를 생성하고,  
```toArray()```는 자바 배열 객체를 생성한다.  
```
${ lst = member.stream().map(m -> m.name).toList(); " }
${ arr = member.stream().map(m -> m.age).toArray(); " }
```
EL 에서 ${ 리스트타입값 } 과 ${ 배열타입값 } 은 서로 다르게 출력한다.      
    
**1. 리스트 타입의 경우 각 원소의 값을 문자열로 변환해서 출력한다.**    
```
<%
  List<Member> memberList = Arrays.asList(
      new Member("홍길동", 20), new Member("이순신", 54),
      new Member("유관순", 19), new Member("왕건", 42)
  );
  request.setAttribute("members", memberList);        
${ members.stream().map( m -> m.name ).toList() }  <%-- [홍길동, 이순신, 유관순, 왕건] 출력 --%>
%>
```
이 경우 ```"[홍길동, 이순신, 유관순, 왕건]"```을 EL의 결과로 출력한다.  

**2. 배열 타입의 경우 배열 객체의 문자열 표현을 출력한다.**  
```
<%
  List<Member> memberList = Arrays.asList(
      new Member("홍길동", 20), new Member("이순신", 54),
      new Member("유관순", 19), new Member("왕건", 42)
  );
  request.setAttribute("members", memberList);        
${ members.stream().map( m -> m.name ).toArray() }  <%-- Ljava.;an.Object;@7385bOf9 출력 --%>
%>
```
   
## 7.8. count() 를 이용한 개수 확인
```count()``` 연산은 스트림의 원소 개수를 리턴한다.  
```
${members.stream().count()}
```
```count()```의 결과의 자료형은 ```Long``` 이다.
   
## 7.9. Optional 타입
원소가 하나도 없는 스트림에서 최소값을 구하면, 원소가 하나도 없으므로 최소값 자체가 존재하지 않는다.
이렇게 결과 값이 존재하거나 존재하지 않는 경우가 있을 때 사용하는 타입이 ```Optional``` 이다.  
즉, 결과 값의 존재 유무에 따라 동작을 달리한다는 것을 의미한다.      

* get() : 값이 존재할 경우 값을 리턴한다. 값이 존재하지 않으면 ELExeption을 발생한다.  
* orElse(other) : 값이 존재하면 해당 값을 리턴하고, 값이 존재하지 않으면 other 를 리턴한다.
* orElseGet((()-> T) other) : 값이 존재하면 해당 값을 리턴하고, 존재하지 않으면 람다식 other를 실행한 결과를 리턴한다.  
* ifPresent(((x)-> void) consumer) : 값이 존재하면 람다식 consumer를 실행하고 존재하는 값을 람다식의 파리미터로 전달한다.  
  
```Optional``` 객체는 결과 값을 구할 때는 ```get()```을 사용한다.   
```
${[1, 2, 3].stream().min().get()}
```
  
값이 존재하지 않는 ```Optional``` 에 대해 ```get()```을 실행하면 ```EXException```이 발생한다.  
```
${[].stream().min().get()}
빈 스트림이므로 EXException 에러 발생
```
    
따라서 값이 존재하지 않을 수도 있다면, ```get()``` 대신 ```orElse()```를 사용해서 값이 없을 때 다른값을 사용해야 한다.
```
${[].stream().min().orElse('없음')}                 -> 없음 출력
${[1, 2, 3].stream().min().orElse('없음')}          -> 값이 있으니 결과값(1) 출력
```
  
orElse() 대신 orElseGet()을 사용해도 된다. orElseGet()은 값 대신 값을 생성하는 람다식을 사용한다.  
```
${[].stream().min().orElseGet(()-> -1)}             -> 값이 없으므로 -1 출력              
```
  
값이 존재할 때 코드를 실행하고 싶다면 ```ifPresent()```를 사용한다.  
```ifPresent()````는 결과 값을 받아 코드를 실행할 람다식을 파라미터로 갖는다.  
```
${minValue = '-'; "}
${ [1, 2, 3].stream().min().ifPresent(x -> (minValue = x))}
최소값은 ${minVlaue} 입니다. 
```
위 코드에서 주의점은 람다 연산자가 대입 연산자보다 우선순위가 높기에 괄호를 사용해 주어야 한다.  
  
## 7.10. sum() 과 average()를 이용한 수치 연산 결과 생성
스트림이 숫자로 구성된 경우 ```sum()```을 이용해서 합을 구할 수 있다.
```
${ [1, 2, 3, 4, 5].stream().sum() } <%--15 출력--%> 
```
  
```average()```는 값의 평균을 구한다. 
```average()```와 ```sum()```의 차이점이 있다면 ```Optional``` 타입을 리턴한다.  
그래서 ```average()```를 사용하면 리턴하는 값에 대해서 ```Optional``` 처리 메서드를 사용해주어야 한다.   
```
${ [1, 2, 3, 4, 5].stream().average().get() } <%--2.5 출력--%> 
```
스트림의 원소가 없는 경우 average()는 값이 없는 Optional 을 리턴한다.  
```
${ [].stream().average().get() } <%--'없음' 출력--%> 
```
다음은 average() 사용 예를 보여주고 있다.  
```
${ [1, 2, 3, 4, 5].stream().average().get() }
${ [1, 2, 3, 4, 5].stream().average().orElse(null) }
${ [].stream().average().orElse(O) }
${ [].stream().average().orElse("null") }
${ [1].stream().average().ifPresent(x -> someObject.add(x)) }
```
    
## 7.11. min() 과 max()를 이용한 최소/최대 구하기
스트림 원소가 Long 이나 String 같이 Comperable 인터페이스를 구현하고 잇다면  
```min()``` 과 ```max()```를 통해 '최소 값', '최대 값'을 구할 수 있다.    
```
${ someLongVals.stream().min().get() }
```
```average()```와 동일하게 ```min()```, ```max()``` 메서드도 ```Optional``` 타입을 리턴한다.      
만약 크기를 구하는 규칙이 달라야 한다면 ```sorted()``` 처럼 크기 비교를 위한 람다식을 사용할 수 있다.    
```
<%
  List<Member> memberList = Arrays.asList(
      new Member("홍길동", 20), new Member("이순신", 54),
      new Member("유관순", 19), new Member("왕건", 42)
  );
  request.setAttribute("members", memberList);        
${ maxAgeMemOpt = members.stream()
                          .max((m1, m2) -> m1.age.comapareTo(m2.age)) ; " } 
${ maxAgeMemOpt.get().name } (${maxAgeMemOpt.get().age}세)                          
%>
```
```min()``` 이나 ```max()```는 ```Optional``` 타입을 리턴하므로 실제 값을 구할 때는 ```get()```이나 ```orElse()```등을 이용해서 구한다.
      
## 7.12. anyMatch(), allMatch(), noneMatch()를 이용한 존재 여부 확인
```anyMatch()```는 스트림에 조건을 충족하는 요소가 존재하는지 검사할 때 사용한다.    
조건을 축족하는지 검사하기 위해 ```(S) - > Boolean 타입``` 람다식을 사용한다.     
```
${ lst = [1, 2, 3, 4, 5] ; " }

<%-- 4보다 큰 원소가 존재하는지 확인 --%>
${ matchOpt = lstStream().anyMatch( v -> v > 4 ) ; " }
${ matchOpt.get() } <%--true--%>
```
```anyMatch()``` 메서드는 ```Optional``` 객체를 리턶나다.         
조건을 충족하는 값이 존재할 경우 ```Optional```은 ```true```를 값으로 갖고 존재하지 않으면 ```false```를 값으로 갖는다.     
   
원소가 처음부터 없는 빈 스트림에 대해 ```anyMatch()```를 시행하면 ```값이 없는 Optional```을 리턴한다.    
```
${ matchOpt = [].stream.anyMatch( v -> v > 4 ) ; " }
${ matchOpt.orElse(false) } <%--값이 없는 Optional인 경우 false를 리턴--%>
${ matchOpt.get() } <%--matchOpt는 값이 없는 Optional이므로 ELException 발생--%>
```  
위 코드에서 ```[]``` 리스트 객체의 스트림은 원소가 없으므로, ```anyMatch()``` 메서드는 값이 없는 ```Optional```을 리턴한다.    
따라서, ```matchOpt.get()```을 실행하면 ```ELException 발생```이 발생한다.       
원소가 없는 스트림에 대해 ```false```를 구하려면 위 코드처럼 ```orElse()```로 값을 구해서 ```ELException``` 발생을 방지하자     
     
```anyMatch()```가 스트림에서 한 원소라도 조건을 충족할 대 ```true``` 값으로 갖는 ```Optional```을 리턴한다면,      
```allMatch()```는 스트림의 모든 원소가 조건을 충족할 때 ```true```를 값으로 갖는다.     
```
${lst = [1, 2, 3, 4, 5]; lst.stream().allMatch( x -> x > 5).get()}  <%--false--%>
```
```noneMatch()```는 조건을 충족하는 원소가 한 개도 존재하지 않을 때 ```true```를 갖는 ```Optional```을 리턴한다.  
```
${lst = [1, 2, 3, 4, 5]; lst.stream().noneMatch( x -> x > 5).get()}  <%--true--%>
```
    
마지막으로 ```allMatch()``` 와 ```noneMatch()``` 모두 빈 스트림에 대해 값이 없는 ```Optional```을 리턴한다.(에러 발생)    
따라서, ```anyMatch()```와 마찬가지로 스트림에 값이 없을 가능성이 있다면    
```get()``` 대신 ```orElse()```나 ```ifPresent()```등을 사용해서 값이 없어도 에러가 발생하지 않도록 해야 한다.    
  
***
# 8. 표현 언어 비활성화 방법
JSP 규약은 ${expr} 이나 #{expr}과 같은 EL을 비활성화시키는 세 가지 방법을 제공하고 있다.  
  
* web.xml 파일에 비활성화 옵션 설정하기
* JSP 페이지에 비활성화 옵션 지정하기
* web.xml 파일을 서블릿 2.3 또는 2.4 버전에 맞게 작성하기
   
## 8.1. web.xml 파일에 EL 비활성화 옵션 추가하기
EL을 비활성화 시키는 첫 번째 방법은 web.xml 파일에서 EL을 비활성화 시켜주는 옵션을 추가하는 것이다.  
```
<?xml version="1.0" encoding="utf-8"?>
<web-app ...>
 ...
 <jsp-config>
  ...
  <jsp-property-group>
    <url-pattern>/oldversion/*</url-pattern>
    <el-ignored>true</el-ignored>
  </jsp-property-group>  
</web-app>
```
```<jsp-property-group>``` 태그의 ```<el-ignored>```를 ```true```로 설정하면  
```<url-pattern>``` 태그로 명시한 URL 패턴에 해당하는 JSP는 EL을 모두 일반 문자로 처리한다.            
즉, 위 코드에서는  ```/oldversion``` 경로에 위치한 JSP 파일은 EL 식을 일반 문자열로 처리한다. 
  
EL 중에서 ```${expr}``` 형식은 그대로 EL로 처리하고  
```#{expr}``` 형식의 EL만 문자열로 처리하고 싶다면 web.xml 파일에 
```<deferred-syntax-allowed-as-literal>``` 태그의 값을 ```true```로 지정해주면 된다.    
```
<?xml version="1.0" encoding="utf-8"?>
<web-app ...>
 ...
 <jsp-config>
  ...
  <jsp-property-group>
    <url-pattern>/oldversion/*</url-pattern>
    <el-ignored>true</el-ignored>
  </jsp-property-group>  
  
  <jsp-property-group>
    <url-pattern>/oldversion2_4/*</url-pattern>
    <deferred-syntax-allowed-as-literal>
          true
    </deferred-syntax-allowed-as-literal>
  </jsp-property-group>  

</web-app>
```

### 2.1.1. 내용1
```
내용1
```   

***
# 3. 대주제
> 인용
## 3.1. 소 주제
### 3.1.1. 내용1
```
내용1
```

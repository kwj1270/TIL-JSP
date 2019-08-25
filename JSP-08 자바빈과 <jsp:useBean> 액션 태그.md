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

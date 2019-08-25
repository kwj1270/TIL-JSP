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
프러퍼티는 자바빈에 저장되는 값을 나타낸다.(인스턴스 변수를 의미한다.)        
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









### 1.1.1. 내용1
```
내용1
```
## 1.2. 소 주제
### 1.2.1. 내용1
```
내용1
```

***
# 2. 대주제
> 인용
## 2.1. 소 주제
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

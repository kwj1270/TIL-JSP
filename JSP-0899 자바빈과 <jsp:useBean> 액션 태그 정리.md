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

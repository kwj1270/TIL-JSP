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


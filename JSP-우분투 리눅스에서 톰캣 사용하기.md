JSP-우분투 리눅스에서 톰캣 사용하기
=======================
현재 한국에서 사용하는 OS 는 대부분 MS의 Window를 사용하고 있다.  
하지만 실질적으로 서버용으로는 유닉스나 리눅스를 사용하는 경우가 더 많기에  
우리는 리눅스에서 웹 서버를 구동시키는 방법을 알아볼 가치가 있다.  
# 1. 톰캣 설치
리눅스에 톰캣을 설치하는 방법은 2가지이다 .  
  
1. apt-get install tomcat8
2. wget http://mirror.navercorp.com/apache/tomcat/tomcat-9/v9.0.29/bin/apache-tomcat-9.0.29.tar.gz

## 1.1. apt-get install tomcat8
1. 터미널 접속
2. root로 접속하거나 sudo 사용
3. JDK가 깔려있어야 하므로 ```java-version```을 입력하여 JDK가 설치되었는지 확인
없을 경우 JDK를 설치할 수 있도록 한다.
4. ```sudo apt-get update``` 및 ```sudo apt-get upgrade``` 진행
5. ```apt-get install tomcat8``` 입력하여 톰캣을 설치하자
6.  ```systemctl status tomcat8```을 입력하여 톰캣 재실행 
7. url에 자신의 ip 및 포트번호(8080) 입력 -> ```ip주소:8080``` 
8. 

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

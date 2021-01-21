웹 프로그래밍 기초 정리
=======================
# 1.   
**URL** : ```https://github.com/kwj1270```와 같은 주소를 의미     
**웹 페이지** : 웹 브라우저의 주소줄에 URL을 입력시 웹 브라우저에 출력되는 내용    
  
그리고 우리가 흔히 홈페이지라고 부르는 웹 사이트는 이런 웹 페이지의 묶음이다. (웹 어플리케이션)  
       
# 2.     
웹 서버는 URL 해당하는 HTML 문서를 전송하는데,      
HTML 문서를 받은 웹 브라우저는 정해진 규칙에 따라 HTML 문서를 분석해서 알맞은 화면을 생성한다.    
이 때 웹 서버와 웹 브라우저가 HTML문서를 주고 받을 때는 HTTP라는 방식을 사용한다.    
**요청**
```
(요청 데이터)

GET / HTTP/1.1                            요청 줄
HOST:www.daum.net                         헤더
Connection: keep-alive
Accept: text/html
User-Agent: Mozlia/5.0 ...생략
Accept-Encoding:gzip, deflate,sdch
Accept-Language: ko,en-US;q=0.8,en;q=0.6
________________________________________________

                  요청 데이터 
 웹 브라우저      -------->       웹 서버
```
**응답**
```
(응답 데이터)

HTTP/1.1 200 OK                           응답줄
Date: Wed,22 Apr 2015 12:53:38 GMT        헤더
Expires: Sat, 01, Jan 1970 22:00:00 GMT
Content-Type: text/html;charset=UTF-8
Content-Language: ko

<!DOCTYPE html>                           몸체
<html lang = "ko">
...생략
</html>

___________________________________________________

                  응답 데이터 
 웹 브라우저      <--------       웹 서버     

```
# 3.    
아파치/톰캣/IIS == 웹 서버 == **WAS (웹 어플리케이션 서버)**    
웹을 위한 연결, 프로그래밍 언어, 데이터베이스 연동과 같이 어플리케이션을 구현하는데 필요한 기능을 제공한다.

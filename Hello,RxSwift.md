# Hello, RxSwift 🥵



### RxSwift란?

> **‘RxSwift is a library for composing asynchronous and event-based code by using observable sequences and functional style operators, allowing for parameterized execution via schedulers.’**

-By Marin Todorov. ‘RxSwift - Reactive Programming with Swift.’ Apple Books.-

RxSwift(Reactive eXtension Swift)란 **관찰 가능한 연속성(순차적)형태**와 **함수형태의 연산자**를 이용하서 **비동기&이벤트를 위한 코드**로 구성하고 있는 라이브러리 이다.

다시 표현하자면,

> **RxSwift는 '본질적'으로 코드가 '새로운 데이터에 반응'하고 '순차적으로 분리 된' 방식으로 처리함으로써 '비동기식' 프로그램 개발을 간소화합니다.**

이라고 한다.

### 왜 RxSwift를 사용하는가?

1. 비동기 적인 측면으로 접근하기 쉽다.

   RxSwift없이 비동기 적인 측면에 접근한다면,

   - 비동기 실행 코드를 이해하기 힘듦
   - 비동기 실행에 관한 명학한 추론을 하기가 힘듦

2. MVVM과 밀접한 연관

   [MVVM](https://www.notion.so/MVVM-c85782d6f0c448aeabe787f4269aedbe)

   MVVM의 배경: 데이터 바인딩을 제공하는 플렛폼에서 만들어진 이벤트 중심 프로그램을 위해 특별히 개발

   RxSwift는 이와 연관성이 높다.

<img src="https://blog.kakaocdn.net/dn/c8d4Ht/btqEh7N9oPj/ke1mtMVA4QRdKNE6syBMWK/img.png" width=800px/>
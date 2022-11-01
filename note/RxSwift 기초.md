# 🌱 RxSwift 기초

### 1. observalbles

- `Observable<T>` 클래스는 RX코드의 기반이다
- `T` 형태의 데이터 snapshot을 전달 할 수 있는 일련의 이벤트를 비동기 적으로 생성하는 기능이다.
- 다시 말하면, 다른 클래스에서 만든 값을 시간에 따라 읽을 수 있다.
- 하나 이상의 observers(관찰자)가 실시간으로 어떤 이벤트에 반응하고 앱 UI를 업데이트 하거나 생성하는지를 처리하고 활용할 수 있게 한다.
- ObservalbleType 프로토콜은 매우 간단하다. 다음 세가지 유형의 이벤트만 Observalble은 방출하며 따라서 observers(관찰자)는 이들 유형만 수신할 수 있다.
  - `next` : **최신/다음 데이터를 ‘전달’**하는 이벤트
  - `completed` : 성공적으로 일련의 이벤트들을 종료시키는 이벤트. 즉 Observable(생산자)가 성공적으로 자신의 생명주기를 완료했으며, **추가적으로 이벤트를 생성하지 않을 것**임을 의미
  - `error` : Observable이 에러를 발생하였으며, 추가적으로 이벤트를 생성하지 않을 것임을 의미**(에러와 함께 완전 종료)**

```swift
API.download(file: "<http://www>...")
 	.subscribe(onNext: { data in
 		... append data to temporary file
 	},
 	onError: { error in 
 		... display error to user
 	},
 	onCompleted: {
 		... use downloaded file
 	})
```

### 2. Operators

- observableType과 Observable 클래스의 구현은 보다 복잡한 논리를 구현하기 위해 함께 구성되는 비동기 작업을 추상화하는 많은 메소드가 포함되어 있다.
- 이러한 Operator(연산자)들은 주로 비동기 입력을 받아 부수작용 없이 출력만 생성하므로 퍼즐 조각과 같이 쉽게 결합할 수 있다.
- 다음은 방향전환에 대한 Rx연산자를 적용시킨 코드이다.

```swift
UIDevice.rx.orientation
 	.filter { value in
 		return value != .landscape
 	}
 	.map { _ in
 		return "Portrait is the best!"
 	}
 	.subscribe(onNext: { string in
 		showAlert(text: string)
 	})
```

- UIDevice.rx.orientation이 .landscape 또는 .portrait 값을 생성 할 때 마다, Rx는 각각의 연산자를 데이터의 형태로 방출함
  - filter는 value가 들어오면 .landscape가 아닌 값만 내놓는다. landscape 모드라면 나머지 코드는 진행되지 않는다.
  - 만약 .portrait값이 들어온다면, map연산자는 해당 방향값을 택할 것이며 이것을 String출력으로 변환할 것이다. ("Portrait is the best!")
  - 마지막으로 subscribe를 통해 결과로 next 이벤트가 구현된다. String 값이 전달하고, 해당 텍스트로 alert을 화면에 표시하는 메소드를 호출한다.
  - 최종적으로 .portrait값일때 Portrait is the best! 라는 alert를 띄우는 코드가 완성된다.
- 연산자들은 언제나 입력된 데이터를 통해 결과값을 출력하므로, 단일 연산자가 독자적으로 할 수 있는 것보다 쉽게 연결 가능해 훨씬 많은 것을 당성할 수 있다.

(스케줄러는 나중에 공부하겠습니다!..ㅎ)

## 💡참고자료 링크

https://github.com/fimuxd/RxSwift/blob/master/Lectures/01_HelloRxSwift/Ch.1 Hello RxSwift.md

# 🚀 Subjects

- 실시간으로 Observable에 새로운 값을 수동으로 추가하고 subscriber에게 방출하는 것
- Observable이자 Observer인것

### Subject의 종류

- Subject = Observable + Observer와 같이 행동한다.
- `.next` 이벤트를 받고, 수신할때 마다 Subscriber에 방출한다.

### PublishSubjects

- 빈 상태로 시작하여 새로운 값만을 subcriber에 방출한다.
- 구독된 순간 새로운 수신을 알리고 싶을 때 용이하다.
- 구독을 멈추거나, `.completed`, `.error` 이벤트를 통해 Subject가 완전 종료될 때까지 지속된다.

![https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/03_Subjects/1. publishsubject.png](https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/03_Subjects/1.%20publishsubject.png)

- 그림의 첫째줄은 subject를 배포한 것 이다. 두 번째 줄과 세 번째 줄이 subscriber들이다.
- 아래로 향하는 화살표는 이벤트 방출, 위로 향하는 화살표느 구독을 선언하는 것이다.
- 두번째 줄 subscriber은 `1`다음 구독을 하여 `1` 이벤트를 받지 못하고 `2`, `3`만 받는다.
- 세번째 줄 subscriber은 같은 원리로 `3`만 받는다.
- 아래 코드는 위 사진의 동작을 구현한 것이다.

```swift
let subject = PublishSubject<String>()
subject.onNext("Is anyone listening?") //배포도 안해서 이벤트를 받지 못함

let subscriptionOne = subject //첫째줄 배포
   .subscribe(onNext: { (string) in
       print(string)
   })
//이벤트 1, 2
subject.on(.next("1"))
subject.onNext("2")

// 두번째줄 subscriber
let subscriptionTwo = subject
   .subscribe({ (event) in
       print("2)", event.element ?? event)
   })

// subject를 2개의 subscriber이 구독하고 있어 2개다 실행된다.
subject.onNext("3")
// print
//3
//2) 3

subscriptionOne.dispose() //두번째줄 subscriber 구독해제(dispose)
subject.onNext("4") // 세번째 줄 subscriber만 작동
//print
//2) 4

subject.onCompleted() //completed 이벤트 사용으로 subject종료

subject.onNext("5") //subject가 종료되어 안나옴

subscriptionTwo.dispose() //세번째줄 subscribe 구독해제(dispose)

//subject를 completed한 후
let disposeBag = DisposeBag()

subject
   .subscribe {
       print("3)", $0.element ?? $0)
}
   .disposed(by: disposeBag)

subject.onNext("?")
```

- 위의 출력 결과는 아래와 같다.

```swift
1
2
3
2) 3
2) 4
2) completed
3) completed
```

- 위 코드에서 마지막 부분의 작동 순서를 보자
  1. subject를 구독
  2. disposed
  3. onNext 이벤트
- 마지막 부분의 `3) completed`를 보면 subject가 `.completed`나 `.error`과 같은 완전동종료 이벤트를 받은 후에도 `.completed` 이벤트만 방출한다는 것을  할 수 있다.
- subject가 종료되었을 때에 존재하는 구독자에게만 종료 이벤트를 줄 뿐만 아니라 그후 구독한 subscriber에게도 종료 이벤트를 알려주는 특성이 있다.

### BehaviorSubjects

- 하나의 초기값을 가진 상태로 시작하여, 새로운 subscriber에게 초기값 또는 최신값을 방출
- 이 subject는 마지막 `.next` 이벤트를 새로운 구독자에게 반복한다는 점만 빼면 `PublishSubject`와 유사하다.

![https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/03_Subjects/2. behaviorsubject.png](https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/03_Subjects/2.%20behaviorsubject.png)

- 첫 번째 이벤트가 발생한 후 첫번째 구독자가 구독을 시작했지만 `publishSubject`와 다르게 직전값 `1`을받는다.
- 두번째 역시 `2`이후에 구독을 했지만 직전값인 `2`를 받는다.

```swift
enum MyError: Error {
   case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
   print(label, event.element ?? event.error ?? event)
}

example(of: "BehaviorSubject") {

   let subject = BehaviorSubject(value: "Initial value")
   let disposeBag = DisposeBag()
}
```

- 발생할 수 있는 `error`들을 `enum`으로 만듬
- 제네릭을 사용하여 라벨과 이벤트를 받아 이벤트 내에 값이 있다면 값을, 에러가 있다면 에러를, `nil`이면 이벤트만 출력할 수 있는 print 메소드
- BehaviorSubject를 초기값을 입력하게 만든다.
  - BehaviorSubject는 항상 최신의 값을 방출하기 때문에 초기 값 없이는 만들수 없다.
  - 만약 초기값을 줄 수 없다면 PublishSubject를 써야한다.

```swift
subject.onNext("X")

subject
   .subscribe{
       print(label: "1)", event: $0)
   }
   .disposed(by: disposeBag)

subject.onError(MyError.anError)

subject
   .subscribe {
       print(label: "2)", event: $0)
   }
   .disposed(by: disposeBag)
```

- 출력은 다음과 같다.

```swift
1) X
1) anError
2) anError
```

- 실행 순서를 보자면
  - 생성한 subject에 `.onNext`로 `“X”`를 추가한다. 이렇게 하면 subject를 구독하기 전 최신값은 `“X”`가 된다.
  - subject를 `1)`라벨을 사용한 프린트로 구독한다.
  - `.onError`로 방금 지정한 `anError`을 이벤트로 추가한다.
  - 마지막 subscribe로 구독한다면 마지막 이벤트인 `anError`을 출력하여 `anError`이 2개 출력된다.

### ReplaySubjects

- 버퍼를 두고 초기화하며, 버퍼 사이즈 만큼 값들을 유지하면서 새로운 subscriber에게 방출한다.
- subject생성시 선택한 특정 크기까지 방출하는 최신 요소를 일시적으로 캐시하거나 버퍼한다. 그런 다음 해당 버퍼를 새 구독자에게 방출한다.

![https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/03_Subjects/3. replaysubject.png](https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/03_Subjects/3.%20replaysubject.png)

- 위 그림은 버퍼 사이즈가 `2`인 ReplaySubject이다.
- 두번째 줄 subscriber은 subject와 함께 구독했으므로 subject 값을 그대로 받게 된다.
- 세번째 줄 subscriber은 subject가 두개의 이벤트를 받은 후 구독하였지만 버퍼사이즈가 `2`인 만틈 값을 받을 수 있다.

<aside> 💡 **!(주의) Replaysubject는 각 버터들이 메모리를 가지고 있어 이미지나 array같이 메모리 크기를 차지하는 값을 큰 사이즈의 버퍼로 가지는것은 메모리에 엄청난 부하를 준다.**

</aside>

```swift
let subject = ReplaySubject<String>.create(bufferSize: 2)
let disposeBag = DisposeBag()

subject.onNext("1")
subject.onNext("2")
subject.onNext("3")

subject
   .subscribe {
       print(label: "1)", event: $0)
   }
   .disposed(by: disposeBag)

subject
   .subscribe {
       print(label: "2)", event: $0)
   }
   .disposed(by: disposeBag)
1) 2
1) 3
2) 2
2) 3
```

- 위 코드를 본다면
  - 버퍼가 `2`인 `ReplaySubject`를 만들고
  - `.onNext`로 1, 2, 3 이벤트를 추가
  - 첫번째 subscriber은 버퍼가 `2`인 subject를 구독하였으므로 `2`, `3`출력
  - 두번째 subscriber역시 `2`, `3`출력

```swift
subject.onNext("4")

subject.subscribe {
		print(label: "3)", event: $0)
}
.disposed(by: disposeBag)
```

- 위 코드를 추가한 후 출력결과

```swift
1) 2
1) 3
2) 2
2) 3
1) 4
2) 4
3) 3
3) 4
```

- 위 코드를 추가함으로써
  - 새로운 `“4”` 이벤트를 추가함. 이로써 위에 이미 구독한 구독자들은 `4`를 출력
  - 새로운 구독자가 구독을 하면 최근 2개의 이벤트인 `3`, `4` 를 출력한다.
- 만약 error 이벤트를 추가한 후 구독자가 구독한다면?

```swift
subject.onNext("4")
subject.OnError(MyError.anError)

subject.subscribe {
		print(label: "3)", event: $0)
}
.disposed(by: disposeBag)
1) 2
1) 3
2) 2
2) 3
1) 4
2) 4
1) anError
2) anError
3) 3
3) 4
3) anError
```

- 위와 같이 이미 `.onError`로 완전종료를 하였는데도 마지막 구독자에게 버퍼된 값을 주는것을 알 수 있다.
- 이와 같은 문제는 error을 추가한 후 dispose를 하여 이벤트 재방출을 막을 수 있다.
- 다만, `ReplaySubject`에 명시적으로 `dispose()`를 호출하는 것은 적절하지 않다. 왜냐하면 만약 subject의 구독을 disposeBag에 넣고, 이 subject의 소유자가 할당 해재되면 이 모든것들이 dispose 될 것이기 때문이다. (뭔지 모르겠음)

### Variables

- `BehaviorSubject`를 래핑하고, 현재의 값을 상태로 보존한다. 가장 최신/초기 값만을 새로운 subscriber에 방출한다.
- 현재 값은 `value` 프로퍼티를 통해서 알 수 있다.
- value 프로퍼티를 `Variable`의 새로운 요소로 가지기 위해선 일반적인 subject나 observable과는 다른 방법으로 추가해야 한다. 즉 `.onNext(_:)`를 쓸 수 없다.
- 다른 Subject와 대조되는 Variable의 또 다른 특성은, 에러가 발생하지 않을 것임을 **보증**한다는 것이다. 따라서 `.error` 이벤트를 `Variable`에 추가할 수 없다.
- `Variable`은 할당 해재되었을 때 자동적으로 완료되기 때문에 수종적으로 `.completed`를 할 필요도, 할수도 없다.
- 정리하자면,
  - value 프로퍼티를 통해 새로운 요소를 추가한다. 따라서 `.onNext(_:)`를 쓸 수 없다.
  - 에러가 발생하지 않음을 보증한다. 따라서 `.error`이벤트를 추가할 수 없다.
  - 할당 해재되었을 때 자동적으로 완료된다. 따라서 `.completed`를 쓸 필요가 없고 쓸수도 없다.

```swift
let variable = Variable("Initial value")
let disposeBag = DisposeBag()

variable.value = "New initial value"

variable.asObservable()
   .subscribe {
       print(label: "1)", event: $0)
   }
   .disposed(by: disposeBag)
```

- 주석에 따라 하나씩 살펴보자면
  - 초기값을 가지는 variable을 만든다. 이때 타입 유추가 가능하다
  - variable에 새 값`New initial value`를 추가한다
  - variable의 구독을 위해서는 `asOnservable()`을 호출하여 variable이 subject처럼 읽힐 수 있도록 한다.

```swift
variable.value = "1"

variable.asObservable()
   .subscribe {
       print(label: "2)", event: $0)
   }
   .disposed(by: disposeBag)

variable.value = "2"
1) 1
2) 1
1) 2
2) 2
```

- 코드를 추가하고 보자면
  - 새로운 값 `1`을 variable에 추가한다.
  - variable에 새 구독자 `2)`를 추가한다.
  - 새로운 값 `2`를 variable에 추가한다.
- `.error`나 `.completed`이벤트를 variable에 추가할 방법은 없다

## PublishRelay, BehaviorRelay, Variable

`PublishRelay`는 `PublishSubject`를 래핑해서 가지고 있음

`BehaviorRelay`는 `BehaviorSubject`를 래핑해서 가짐.

### 둘다 variable의 공통점

- `ObservableType`을 상속한다.
- error나 complete를 통해 완전종료 불가
- 새로운 element를  갖기 위해서 observable이나 subject에서 사용했던 onNext(_:) 키워드 사용 불가
- relay를 subject처럼 구독하고 싶을때 사용하는 `asObservable`메소드가 있다.

### 두 relay간의 차이점

- `BehaviorRelay`는 variable처럼 `BehaviorSubject`의 현재값을 알 수 있는 value라는 프로퍼티를 가진다.
- 하지만 `PublishRelay`에는 이 프로퍼티가 없다.

### 그렇다면 BehaviorRelay와 Variable의 차이

- `BehaviorRelay`는 `accept(E)`가 생기고, value가 get-Only property(값을 가져올 수만 있는 프로퍼티)가 되었다는 차이점이 있다.

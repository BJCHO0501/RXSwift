# 🔄 Transforming Operators

- 변환 연산자는 subscurber를 통해 observable에서 데이터르 준비하는 것 같은 모든 상황에 쓰일 수  있다.

### toArray

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming Operators/1. toArray.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming%20Operators/1.%20toArray.png?raw=true)

- Observable의 독립적 요소들을 array로 넣는 가장 편한 방법이 `toArray`를 사용하는 것 이다.
- observable의 요소들을 array로 묶어 `.next`이벤트를 통해 subscriber에 방출한다.

### map

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming Operators/2. map.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming%20Operators/2.%20map.png?raw=true)

- swift의 표준 라이브러리의 `map`과 같게 동작한다.
- 위 map은 각 요소에 2를 곱하는 클로저를 갖는다.

## 내부 Observable 변환하기

- 만약 Observable 속성을 갖는 Observable은 어떻게 사용할 수 있을까?

```swift
struct Student {
     var score: BehaviorSubject<Int>
 }
```

- Student는 BehaviorSubject<Int> 속성의 score이라는 속성을 갖는 struct다.
- RxSwift는 flatMap 연산자 내에 몇가지 연산자를 가지고 있다. 이들은 observable내부로 들어가서 observable 속성들과 작업한다.
- 뭔지는 모르겠지만 어려운 개념이라고 한다.

### flatMap

- 공식 문서의 설명을 봐보면

> `Observable sequence` 의 각 요소를 `Observable sequence`에 투영하고 `Observable sequence`를 `Observable sequence`로 병합한다.

- 뇌정지가 올거같은 공식 설명이다.

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming Operators/3. flatmap.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming%20Operators/3.%20flatmap.png?raw=true)

(여기서 부터는 그냥 이해하는 목적으로 봅시다.)

- 첫 째줄의 Observable이 마지막 줄의 구독자에 가기까지의 과정을 보여주고 있다.
- 첫 Observable은 Int타입의 value 값을 가지고 있다. 각각의 고유한 값은 `01` = `1`, `02` = `2`, `03` = `3`을 의미한다.
- `01`부터 시작하여 `flatMap`은 객체를 수신하고 value속성에 접근하여 10을 곱한다. 그리고 01로 부터 변환된 새 값을 새 Observale (01의 경우 flatMap 아래 첫 번째 줄)에 투영한다. 이렇게 subsciber(마지막줄)에게 줄 onservable까지 내려간다.
- 이후 `01`의 값 속성이 4로 변경된다. 이 부분은 그림에서 표현하지 않았다. 다만, `01`의 값이 바뀌었다는 증거는 해당 Observable에서 값이 40으로 변형된 것을 보고 확인할 수 있다.
- 첫 째줄의 Observable에서 방출하는 다음 값은 `02`다. 역시 `flatMap` 이 받는다. 이 값은 20으로 전환되고 역시 새 Observable에 투영된다. 이 후 `02`의 값은 5로 바뀔것이고, 이 값 역시 50으로 전환된다.
- 최종적으로 03을 `flatMap`이 받아 변환시킨다.

```swift
let disposeBag = DisposeBag()
     
// 1
let ryan = Student(score: BehaviorSubject(value: 80))
let charlotte = Student(score: BehaviorSubject(value: 90))

// 2
let student = PublishSubject<Student>()

// 3
student
   .flatMap{
       $0.score
   }
   // 4
   .subscribe(onNext: {
       print($0)
   })
   .disposed(by: disposeBag)

// 5
student.onNext(ryan)    // Printed: 80

// 6
ryan.score.onNext(85)   // Printed: 80 85

// 7
student.onNext(charlotte)   // Printed: 80 85 90

// 8
ryan.score.onNext(95)   // Printed: 80 85 90 95

// 9
charlotte.score.onNext(100) // Printed: 80 85 90 95 100
```

- 이해를 돕기위한 예제이다. 순서대로 봐보자.

  - `ryan`과 `charlotte`이라는 두개의 `Stdent` 인스턴트를 만든다.

  - `Student`타입의 **source subject**를 만든다.

  - `flatMap`을 사용해서 `student` subject와 subject가 갖는 score값에 접근한다.

  - `.next` 이벤트의 요소를 구독하여 프인트되게 한다. 이때까지는 아무것도 출력되지 않는다.

  - `ryan`이라는 student 인스턴스를 `.onNext` 이벤츠를 통해 추가한다. 이렇게 하면 `ryan`의 `score`값이 출력된다.

  - `ryan`의 `score`값을 변경하면 `ryan`의 새 점수가 출력된다.

  - 또 다른 

    ```
    student
    ```

    인 

    ```
    chalotte
    ```

    을 추가하자. 이러면 chalotter의 점수가 출력된다.

    - 왜냐하면 `flatMap` 은 **source가 되는 observable에 추가된 각 요소에 대해서 생성한 모든 observable 정보를 가지고** 있기 때문이다.

  - `charlotte`의 값을 바꾸면  당연히 새로 입력된 값이 프린트 된다.

- 요약하자면, `flatMap`은 **각 Observable의 변화를 계속 지켜본다.**

### flatMapLatest

- 아마 상기의 `flatMap`에서 가장 최신의 값을 확인하고 싶을때도 있을거라고 한다. 이때 `flatMapLatest`를 사용할 수 있다.

- ```
  flatMapLatest
  ```

   = 

  ```
  map
  ```

   \+ 

  ```
  switchLatest
  ```

  - `map`과 `switchLatest` 연산자를 합친 것이 `flatMapLatest`라고 할 수 있다.
  - `switchLatest`는 가장 최근의 observable 에서 값을 생성하고 이전 observable을 구독 해제한다.

> observable sequence의 각 요소들을 observable sequence들의 새로운 순서로 투영한 다음, observable sequence들의 observable sequence 중 가장 최근의 observable sequence 에서만 값을 생성한다.

- 여전히 뭔소린지 모르겠는 공식문서

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming Operators/4. flatMapLatest.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming%20Operators/4.%20flatMapLatest.png?raw=true)

**여기도 다시 공부해야 할것 같다.**

- `flatMapLatest`는 `flatMap`과 같이, observable 속성 내의 observable 요소까지 접근한다.
- 각각의 변환된 요소들은 구독자에게 제공될 새로운 observable로 flatten 된다. `flatMapLatest`가 `flatMap`과 다른 점은, 자동적으로 이전 observable을 구독해지한다는 것이다.
- `01`은 `flatMapLatest`에 의해 수신되고, 그 값을 10으로 변환한 뒤, `01`에 대한 새로운 observable에 값으로 투영된다. 여기까진 `flatMap`과 동일하다. 하지만 `flatMapLatest`는 이후 `02`를 받고 이 것을 `02`에 대한 observable로 전환한다. 왜냐하면 여기까진 이게 최신의 값이기 때문에.
- `01`의 값이 변경되었을 때, `flatMapLatest`는 변경된 값을 무시한다.
- 이 과정은 `flatMapLatest`가 `03`을 받을 때도 반복된 후, 해당 sequence를 스위치 한다. 그리고 이전 것인 `02`를 역시 무시한다.
- target observable의 결과값으로는 오직 가장 최근의 observable에서 나온 값만 받게 된다.

```swift
let disposeBag = DisposeBag()
     
let ryan = Student(score: BehaviorSubject(value: 80))
let charlotte = Student(score: BehaviorSubject(value: 90))

let student = PublishSubject<Student>()

student
   .flatMapLatest {
       $0.score
}
   .subscribe(onNext: {
       print($0)
   })
   .disposed(by: disposeBag)

student.onNext(ryan)
ryan.score.onNext(85)

student.onNext(charlotte)

// 1
ryan.score.onNext(95)
charlotte.score.onNext(100)

/* Prints:
	80 85 90 100
*/
```

- 자 여기서 달라진 점이 한가지 있다. 바로 `ryan`의 값을 `95`로 변경한 부분은 무시되었다는 점이다.
- 이는 가장 최근에 추가한 `student`가 `charlotte`이기 때문에 `ryan`의 변경이 무시된것 이다.

## 이벤트 관찰하기

- observable을 observable의 이벤트로 변환해야할 수 있다.
- 보통 observable 속성을 가진 observable 항목을 제가할 수 없고, 외부적으로 observable이 종료되는 것을 방지하기 위해 error이벤트를 처리하고 싶을 때 사용할 수 있다.

### meterialize

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming Operators/5. materialize.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming%20Operators/5.%20materialize.png?raw=true)

- `materialize`는 observable의 이벤트를 방출시켜준다.
- 예를들어 `Observable<Int>`라는 타입이 `materialize`를 거치면 `Observable<Event<Int>>`가 된다.

### dematerialize

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming Operators/6. dematerialize.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/07_Transforming%20Operators/6.%20dematerialize.png?raw=true)

- `dematerialize`는 event를 요소로 바꿔준다. `materialize`와 반대라 생각하면 쉽다.
- `Observable<Event<Int>>` → `dematerialize` → `Observable<Int>`

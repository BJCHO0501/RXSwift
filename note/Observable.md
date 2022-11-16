# 🥽 Observable(관찰 가능한)

### observalble 이란?

- Rx의 심장
- `observable` = `observable sequence` = `sequence` : 각각의 단어를 계속 보게 될건데 다 같은말이다.
- 여기있는 모든것이 비동기적(asynchronous)이다.
- Observable 들은 일정 기간 동안 계속해서 이벤트를 생성하며, 이러만 과정을 보통 **emitting(방출)**이라고 표현한다.
- 각각의 이벤트들은 숫자나 커스텀한 인스턴스 등과 같은 값을 가질 수 있으며, 또는 탭과 같은 제스처를 인식할 수도 있다.

### Observable의 생명주기

![https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/02_Observables/1. marble.png](https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/02_Observables/1.%20marble.png)

- next 이벤트를 통해 각각의 요소를 방출하는 것

![https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/02_Observables/2. lifecycle1.png](https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/02_Observables/2.%20lifecycle1.png)

- 이 Observable은 새 개의 tap 이벤트를 방출한 뒤 완전 동료됨. 이것이 completed 이벤트이다.

![https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/02_Observables/3. lifecycle2.png](https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/02_Observables/3.%20lifecycle2.png)

- 상단의 예시들과 다른게 에러가 발생한것이다.
- Observable이 완전 종료되었다는 면은 같지만, `error` 이벤트를 통해 종료된 것이다.

### Observalble 만들기

1. just, of, from

   1. **just**

      ```swift
      let one = 1
      let two = 2
      let three = 3
      
      let observable: Observable<Int> = Observable<Int>.just(one)
      ```

      - one 정수를 이용하여 just method를 통해 Int 타입의 Observable sequence를 만드는 코드이다.
      - `just` 는 `Observable`의 타입 메소드로소 이름에서 추측할 수 있듯이 오직 하나의 요소를 포함하는 Observable sequence를 생성한다.

   2. **of**

      ```swift
      let observable2 = Observable.of(one, two, three)
      ```

      - `of`연산자는 주어진 값들의 **타입 추론**을 통해 Observable sequence를 생성한다.
      - 그래서 `observable2`의 타입은 `Observable<Int>`로 타입이 된다.
      - 따라서 어떤 array를 Observable array로 만들고 싶다면, array를 `of`연산자에 집어 넣으면 된다.

      ```swift
      let observable3 = Observable.of([one, two, three])
      ```

      - observable3의 타입은 Observable<[Int]>
      - 이렇게 하면 `just`연산자를 쓴것과 같이 [1, 2, 3]을 **단일요소**로 가지게 된다.

   3. **from**

      ```swift
      let observable4 = Observable.from([one, two, three])
      ```

      - observable4의 타입은 `Observable<Int>`
      - from 연산자는 일반적인 **array 각각 요소들을 하나씩** 방출한다
      - from 연산자는 **오직 array**만 사용한다

# 💧Filtering Operators

- Filtering Operator(필터링 연산자)는 **`.next`**이벤트를 통해 받아오는 값을 선택적으로 취할 수 있게 한다.

## Ignoring operators

- 말 그대로 무언가를 무시하는 연산자들 이다.

### .ignoreElements()

![https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/05_Filtering Operators/1.ignoreElements.png](https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/05_Filtering%20Operators/1.ignoreElements.png)

- ignoreElements는 `.next` 이벤트를 무시한다.
- `completed`나 `.error`같은 정지 이벤트는 허용한다.

### .elementAt

![https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/05_Filtering Operators/2. elementAt.png](https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/05_Filtering%20Operators/2.%20elementAt.png)

- Observable에서 방출된 `n`번째 요소만 처리하려는 경우 `elementAt()`을 쓸 수 있다.
- 받고 싶은 요소에 해당하는 index만을 방출하고 나머지는 무시한다.

### .filter

- `filter`은 필터링 요구사항이 한가지 이상일때 사용할 수 있다

![https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/05_Filtering Operators/3.filter.png](https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/05_Filtering%20Operators/3.filter.png)

- 그림에 filter을 거지면 3보다 작은 요소만 출력하라고 선언했기 때문에 `1`, `2`만 필터된다.

## Skipping operators

### .skip

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering Operators/4. skip.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering%20Operators/4.%20skip.png?raw=true)

- 확실히 몇개의 요소를 skip 하고 싶을때 사용한다.
- 첫번째 부터 `n`번째 요소를 skip한다.

### .skipWhile

- `.skipWhile` 은 어떤 요소를 skip하지 않을 때까지 skip하고 종료하는 연산자이다.
- `skipWhile`은 skip할 로직을 구성하고 해당 로직이 `false` 되었을 때 방출한다. `filter`와 반대이다.

![https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/05_Filtering Operators/5.skipWhile.png](https://raw.githubusercontent.com/fimuxd/RxSwift/master/Lectures/05_Filtering%20Operators/5.skipWhile.png)

- 위 그림을 보면 `1`은 조건에 true기 때문에 skip된다.
- `2`는 조건에서 `false`이기 때문에 skip되지 않는다. 이때 `skipWhile`은 더이상 skip하지 않는다.
- `skipWhile`이 skip하지 않아 3은 조건에 `true`인데도 불구하고 방출된다.

### .skipUntil

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering Operators/6.skipUntil.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering%20Operators/6.skipUntil.png?raw=true)

- `skipUntil`은 다른 observable이 시동할 때까지 현재 observable에 방출하는 이벤트를 skip한다.
- 간단하게 다른 observable이 .next이벤트를 방출하기 전까지는 기존 observable에서 방출하는 이벤트들을 무시하는 것이다.

```swift
let disposeBag = DisposeBag()
     
let subject = PublishSubject<String>()
let trigger = PublishSubject<String>()

subject
   .skipUntil(trigger)
   .subscribe(onNext: {
       print($0)
   })
   .disposed(by: disposeBag)
```

- 위 코드와 같이 `.skipUntil(원하는 Observable)` 형태로 사용할 수 있다.

## Taking operators

- taking은 skipping의 반대 개념이다.
- 어떤 요소를 취하고 싶을때 사용할 수 있다.

### .take

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering Operators/7.take.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering%20Operators/7.take.png?raw=true)

- `.take(n)`은 처음부터 `n`만큼의 값을 취한다.

### .takeWhile

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering Operators/8.takeWhile.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering%20Operators/8.takeWhile.png?raw=true)

- `takeWhile`은 `skipWhile`처럼 작동한다.
- 구문에 설정한 로직에서 `true`에 해당하는 값을 방출한다.

### .enumerated

- 방출된 요소의 index를 참고하고 싶은 경우 사용할 수 있다.
- Observable에서 나오는 각 요소의 index와 값을 포함하는 튜플을 생성하게 된다.

```swift
let disposeBag = DisposeBag()
     
Observable.of(2,2,4,4,6,6)
   .enumerated()
   .takeWhile({ index, value in
       value % 2 == 0 && index < 3
   })
   .map { $0.element }
   .subscribe(onNext: {
       print($0)
   })
   .disposed(by: disposeBag)
```

- `enumerated`를 사용하면 index, value를 사용할수 있게 되어 위 코드처럼 활용 가능하다.

### .takeUntil

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering Operators/9.takeUntil.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering%20Operators/9.takeUntil.png?raw=true)

- `takeUntil`은 `skipUntil`와 유사하게 동작한다.
- trigger가 되는 Observable이 구독되기 전까지의 이벤트 값만 받는다.

## Distinct operators

- 중복해서 이어지는 값을 막아주는 연산자이다.

### .distinctUntilChanged

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering Operators/10.distincUntilChanged.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering%20Operators/10.distincUntilChanged.png?raw=true)

- 이름에서 유추할 수 있듯이 중복되는 값이 이어질때 이를 막는 연산다이다.
- 위 그림에서 `2`는 중복되는 값이 **이어지기** 때문에 1개만 나온다.
- 하지만 1은 값이 중복이긴 하지만 이어지지 않기 때문에 2개의 1 모두 출력된다.

### .distinctUntilChanged(_:)

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering Operators/11.distincUntilChanged().png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/05_Filtering%20Operators/11.distincUntilChanged().png?raw=true)

- `distinctUntilChanged`는 기본적으로 구현된 오지겡 따라 같음을 확인하는데 커스텀한 비교로직을 구현할 수도 있다.
- 그럼인 `value`라 명명된 값을  서로 비교하여 중복되는 값을 제외하고 있다.

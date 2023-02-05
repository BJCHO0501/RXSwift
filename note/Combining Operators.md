# 💠 Combining Operators

- 병합 연산을 하는 병합 연사자들.

## 앞에 붙이기

- observable로 작업할 때 가장 중요하게 확인해야 할 것은 observer가 초기값을 받는지 여부이다.

### startWith(_:)

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/1.prefixing.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/1.prefixing.png?raw=true)

- `현재 위치`나 `네트워크 연결 상태` 같이 현재 상태가 필요한 상황이 있다. 이럴때 현재 상채와 함께 초기의 값을 붙일 수 있다.

### Observable.concat(_:)

- `Observable.concat(_:)`은 두개의 sequence를 묶을 수 있다.

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/2.concat.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/2.concat.png?raw=true)

```swift
let first = Observable.of(1, 2, 3)
let second = Observable.of(4, 5, 6)

let observable = Observable.concat([first, second])

observable.subscribe(onNext: {
   print($0)
})

/* Prints:
1
2
3
4
5
6
*/
```

- 위 코드를 살펴보면
  - `first`와 `second` Observable생성
  - `Observable.concat([first, second])`로 두 sequebce결합
  - 출력
- `startWith`보다 읽기 편하다

### concat(_:)

- 만일 Observable이 같은 요소라면,

```swift
let germanCities = Observable.of("Berlin", "Münich", "Frankfurt")
let spanishCities = Observable.of("Madrid", "Barcelona", "Valencia")

let observable = germanCities.concat(spanishCities)
observable.subscribe(onNext: { print($0) })
```

- 위와같이 사용하는 것도 가능하다.
- 위 코드는 `Observable.concat(_:)` 과 동일하게 작동한다.

### concatMap(_:)

- `flatMap` 과 밀접한 관련이 있다.
- `flatMap`을 통과하면 `Observable` sequence가 구독을 위해 리턴되고, 방출된 observable들은 합쳐지게 된다.
- `concatMap`은 각각의 sequence가 다음 sequence가 구독되기 전에 합쳐진다는 것을 보증한다.

```swift
let sequences = ["Germany": Observable.of("Berlin", "Münich", "Frankfurt"),
                "Spain": Observable.of("Madrid", "Barcelona", "Valencia")]

let observable = Observable.of("Germany", "Spain")
   .concatMap({ country in
       sequences[country] ?? .empty() })

_ = observable.subscribe(onNext: {
   print($0)
})

//print
Berlin
Münich
Frankfurt
Madrid
Barcelona
Valencia
```

- 위처럼 두 Observable이 합쳐진다.

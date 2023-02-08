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

## 합치기

### merge()

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/3.merging.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/3.merging.png?raw=true)

- sequence를 합치기 가장 쉬운 방법은 merge다.
- `marge()` observable은 각각의 요소들이 도착하는대로 받아서 방출한다.

### merge(maxConcurrent:)

- 합칠 수 있는 sequence의 수를 제한하기 위해 사용할 수 있다.
- maxConcurrent 수에 도달하때 까지 변동은 계속 일어난다.
- limit에 도달한 이후에 들어오는 observable을 대기열에 넣는다. 그리고 현재 sequence 중 하나가 완료되자마자 구독을 시작한다.

## 요소 결합하기

### combineLatest(::resultSelector:)

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/4. combiningElements.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/4.%20combiningElements.png?raw=true)

- 내부(결합된) sequence들은 값을 방출할 때마다, 제공한 클로저를 호출하며 우리는 각각의 내부 sequence들의 최종값을 받는다.

```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()

let observable = Observable.combineLatest(left, right, resultSelector: { lastLeft, lastRight in
   "\\(lastLeft) \\(lastRight)"
})

let disposable = observable.subscribe(onNext: {
   print($0)
})

// 2
print("> Sending a value to Left")
left.onNext("Hello,")
print("> Sending a value to Right")
right.onNext("world")
print("> Sending another value to Right")
right.onNext("RxSwift")
print("> Sending another value to Left")
left.onNext("Have a good day,")

// 3
disposable.dispose()

/* Prints:
> Sending a value to Left
> Sending a value to Right
Hello, world
> Sending another value to Right
Hello, RxSwift
> Sending another value to Left
Have a good day, RxSwift
*/
```

- 위 코드를 보면 클로저를 사용하여 받은 값들을 가공한후 방출하는 것을 볼 수 있다.

### combineLatest**(*,*,resultSelector:)**

• `combineLatest` 계열에는 다양한 연산자들이 있다. 이들은 2개부터 8개까지의 sequence를 파라미터로 가진다. 앞서 언급한대로, sequence 요소의 타입이 같을 필요는 없다.

```swift
let choice:Observable<DateFormatter.Style> = Observable.of(.short, .long)
let dates = Observable.of(Date())

let observable = Observable.combineLatest(choice, dates, resultSelector: { (format, when) -> String in
   let formatter = DateFormatter()
   formatter.dateStyle = format
   return formatter.string(from: when)
})

observable.subscribe(onNext: { print($0) })
```

- 위와같이 클로저의 부수 작용을 통해 데이터를 가공하여 사용 가능하다.

### **combineLatest([],resultSelector:)**

- array내의 최종 값들을 결합하는 형태도 있다.

```swift
let observable = Observable.combineLatest([left, right]) { strings in
   strings.joined(separator: " ")
}
```

### zip

- 또 다른 결합 연산자로는 `zip`이 있다.

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/5. zip.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/5.%20zip.png?raw=true)

```swift
enum Weather {
   case cloudy
   case sunny
}

let left:Observable<Weather> = Observable.of(.sunny, .cloudy, .cloudy, .sunny)
let right = Observable.of("Lisbon", "Copenhagen", "London", "Madrid", "Vienna")

let observable = Observable.zip(left, right, resultSelector: { (weather, city) in
   return "It's \\(weather) in \\(city)"
})

observable.subscribe(onNext: {
   print($0)
})

/* Prints:
It's sunny in Lisbon
It's cloudy in Copenhagen
It's cloudy in London
It's sunny in Madrid
*/
```

- 코드를 보자면

  - `Weather` enum을 만들고, 두개의 Observable을 만든다.
  - `zip(_:_:resultSelector:)`를 이용하여 두개의 Observable을 병합한다.

- ```
  zip(_:_:resultSelector:)
  ```

  은 다음과 같이 동작한다.

  - 제공된 observable을 구독한다.
  - 각각의 observable이 새 값을 방출하길 기다린다.
  - 각각의 새 값으로 클로저를 호출한다.

- ```
  Vienna
  ```

  가 출력되지 않은 이유는?

  - 이것은 zip계열 연산자의 특징이다.
  - 이들은 일련의 observable이 새 값을 각자 방출할 때까지 기자리다가, 둘중 하나가 완료되면 `zip`역시 완료된다.
  - 이 말은 위의 `left` observable과 같이 더 길어 값이 남아있어도 기다리지 않는 것이다.
  - 이렇게 sequence에 따라 단계별로 작동하는 방법을 가르켜 indexed sequencing이라 한다.

## Triggers

- 여러개의 observable을 한번에 받는 경우가 있을 것이다. 이럴 때 다른 observable들로부터 데이터를 받는 동안 어떤 observable은 단순히 방아쇠 역할을 할 수 있다.

### withLatestFrom(_:)

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/6. trigger.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/6.%20trigger.png?raw=true)

```swift
let button = PublishSubject<Void>()
let textField = PublishSubject<String>()

let observable = button.withLatestFrom(textField)
_ = observable.subscribe(onNext: { print($0) })

textField.onNext("Par")
textField.onNext("Pari")
textField.onNext("Paris")
button.onNext(())
button.onNext(())
```

- 코드를 보면
  - `button`과 `textField`라는 두개의 PublishSubject를 만든다.
  - `button`에 대해서 `withLatestFrom(textField)`를 호출한 뒤, 구독한다.
  - `button`에 새 이벤트가 추가되기 직전에 `textField`가 추가된 최신값인 `Paris`가 출력된다. 그 전의 값들은 무시된다.

### sample(_:)

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/7. withLatestFrom.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/7.%20withLatestFrom.png?raw=true)

- `withLatestFrom(_:)`과 거의 똑같이 작동하지만, 한 번만 방출한다. 즉 여러번 새로운 이벤트를 통해 방아쇠 당기기를 해도 한번만 작동한다.
- `withLatestFrom(_:)`은 데이터 observable을 파라미터로 받고, `sample(_:)`은 trigger observable을 파라미터로 받는다. 주의하자.

## Switches

### amb(_:)

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/8.switches.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/8.switches.png?raw=true)

- `amb(_:)`에서 amb는 **ambigous(모호한)**이라 생각하면 된다.
- 두가지 sequence의 이벤트 중 어떤 것을 구독할지 선택할 수 있게 한다.

```swift
let left = PublishSubject<String>()
let right = PublishSubject<String>()

let observable = left.amb(right)
let disposable = observable.subscribe(onNext: { value in
	print(value)
})

left.onNext("Lisbon") //left 먼저 요소를 방출하여 right구독 해지됨
right.onNext("Copenhagen")
left.onNext("London")
left.onNext("Madrid")
right.onNext("Vienna")

disposable.dispose()

//print
Lisbon
London
Madrid
```

- 코드를 보면
  - `left`와 `right`를 사이에 모호하게 작동할 observable을 만든다.
  - 두 개의 observable에 모두 데이터를 보낸다.
- `amb(_:)` 연산자는 `left`, `right` 두 개의 observable모두 구독한다. 그후 둘중 어떤 것이든 요소를 방출하는 것을 기다리다가 처음 요소를 방출한 observable외 다른 observable의 구독을 중단하고 처음 동작한 observable에 대해서만 요소를 늘어놓는다.
- 처음에 어떤 observable에 관심이 있는지 알 수 없기 떄문에 일단 둘다 모호하게 구독한 후 시작한 다음 결정하는 것이다.

### switchLatest()

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/9.switchlatest.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/9.switchlatest.png?raw=true)

- 사진을 보면 알겠지만 마지막으로 방출한 observable의 요소들만 방출하는 것이다.

```swift
let one = PublishSubject<String>()
let two = PublishSubject<String>()
let three = PublishSubject<String>()

let source = PublishSubject<Observable<String>>()

let observable = source.switchLatest()
let disposable = observable.subscribe(onNext: { print($0) })

source.onNext(one)
one.onNext("Some text from sequence one")
two.onNext("Some text from sequence two")

source.onNext(two)
two.onNext("More text from sequence two")
one.onNext("and also from sequence one")

source.onNext(three)
two.onNext("Why don't you see me?")
one.onNext("I'm alone, help me")
three.onNext("Hey it's three. I win")

source.onNext(one)
one.onNext("Nope. It's me, one!")

disposable.dispose()

//print
Some text from sequence one
More text from sequence two
Hey it's three. I win
Nope. It's me, one!
```

- 코드를 따라가 보면
  - `one`, `two`, `three`라는 subject를 생성한 후 이들을 `Observable<String>`을 요소로 받는 subject `source`를 생성한다.
  - `source`에 `one`을 추가한 후 `one`에 값을 추가해본다.
  - 위와같이 `two`, `three`도 값을 추가해본다
- source observable로 들어온 마지막 sequence의 아이템만 구독하는 것을 볼 수 있다. 이것이 `switches` 와 `swichLatest`의 차이점이다.
- 이는 전에 쓴 `flatMapLatest`와 유사하다

## sequence내의 요소들간 결합

### reduce(*:*:)

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/10.reduce.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/10.reduce.png?raw=true)

- 방출하는 sequence들을 연산하여 방출한다.

```swift
let source = Observable.of(1, 3, 5, 7, 9)

// 1
let observable = source.reduce(0, accumulator: +)
observable.subscribe(onNext: { print($0) } )

// 주석 1은 다음과 같은 의미다.
// 2
let observable2 = source.reduce(0, accumulator: { summary, newValue in
   return summary + newValue
})
observable2.subscribe(onNext: { print($0) })
```

- `reduce`는 제공된 초기값부터 시작해서 observable이 값을 방출할 때마다 이 값을 가공한다.

### scan(_:accumulator:)

![https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining Operators/11. scan.png?raw=true](https://github.com/fimuxd/RxSwift/raw/master/Lectures/09_Combining%20Operators/11.%20scan.png?raw=true)

- 그냥 보기에는 `reduce`와 비슷해보인다.

```swift
let source = Observable.of(1, 3, 5, 7, 9)

let observable = source.scan(0, accumulator: +)
observable.subscribe(onNext: { print($0) })

/* Prints:
1
4
9
16
25
*/
```

- 출력의 다른점이라 하면 **중간값**들이 나온다는 것이다.
- `scan`은 리턴값이 Observable이다.

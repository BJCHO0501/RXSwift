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
      - 이렇게 하면 `just`연산자를 쓴것과 같이 [1, 2, 3]을 **단일요prpr소**로 가지게 된다.

   3. **from**

      ```swift
      let observable4 = Observable.from([one, two, three])
      ```

      - observable4의 타입은 `Observable<Int>`
      - from 연산자는 일반적인 **array 각각 요소들을 하나씩** 방출한다
      - from 연산자는 **오직 array**만 사용한다

### Observable 구독

- Observable 실제로 sequence 정의일 뿐이다. Observable은 subscribe, 즉 구독되기 전에는 아무런 이벤트토 보내지 않는다. **그저 정의**일 뿐이다.

1. **.subscribe()**

   ```swift
   let one = 1
   let two = 2
   let three = 3
   
   let observable = Observable.of(one, two, three)
   	observable.subscribe({ (event) in
   			 print(event)
   		})
    	
    	/* Prints:
    	 next(1)
    	 next(2)
    	 next(3)
    	 completed
    	*/
   ```

   - .subscribe는 escaping 클로저로 `Int`타입을 `Event`로 갖는다. escaping에 대한 리턴값은 없으며 `.subscribe`은 `Disposable`을 리턴한다.
   - 프린트된 값을 보면, Observable은
     - 1. 각각의 요소들에 대해 `.next` 이벤트를 방출했다.
     - 1. 최종적으로 `.completed`를 방출했다.
   - Observable을 이용하다보면, 대부분의 경우 Observable이 `.next`이벤트를 통해 방출하는 요소에 가장 관심가지게 될 것이다.

2. **subscribe(onNext:)**

   - 상기의 코드를 다음과 같이 바꿔보면

   ```swift
   observable.subscribe { event in
    	if let element = event.element {
    		print(element)
    	}
    }
    
    /* Prints:
     1
     2
     3
    */
   ```

   - 아주 자주 쓰이는 패턴이기 떄문에 RxSwift에는 이 부분에 대한 죽약형들이 있다.
   - 즉, Observable이 방풀하는 `.next`, `.error`, `.completed` 같은 각각의 이벤트들에 대해 `subscribe` 연산자가 있다.

   ```swift
   observable.subscribe(onNext: { (element) in
    	print(element)
    })
    
    /* Prints:
     1
     2
     3
    */
   ```

   - `.onNext` 클로저는 `.next`이벤트만을 argument로 취한 뒤 핸들링할 것이고, 다른 것들은 모두 무시하게 된다.

   1. **empty()**

      - 지금까지는 하나 또는 여러개의 요소를 가진 Observable만 만들었다. 그렇다만 요소를 가지지 않는 Observable은 어떻게 될까? `empty` 연산자를 이용하면 된다.

      ```swift
      let observable = Observable<Void>.empty()
           
           observable.subscribe(
               
               // 1
               onNext: { (element) in
                   print(element)
           },
               
               // 2
               onCompleted: {
                   print("Completed")
           }
           )
      
      /* Prints:
        Completed
      */
      ```

      - Observable은 반드시 특정 타입으로 정의되어야 한다.
      - 이 예제의 경우 가지고 있는 요소가 없어 타입 추론을 할것이 없기 때문에 **타입을 명시적**으로 정의해줘야 하며 이는 **Void**타입이 적절하다.
      - 실행과정을 살펴보면
        - 1. `.next` 이벤트를 핸들링 한다
        - 1. `.completed` 이벤트는 어떤 요소를 가지지 않으므로 단순히 메시지만 프린트 한다.
      - 그렇가면 empty Observable의 용도는 무엇일까?
        - 즉시 종료할 수 있는 Observable을 리턴하고 싶을때
        - 의도적으로 0개의 값을 가지는 Observable을 리턴하고 싶을때

   2. **.naver()**

      - `empty`와는 반대로 `naver`연산자가 있다.

      ```swift
      let observable = Observable<Any>.never()
           
           observable
               .subscribe(
                   onNext: { (element) in
                       print(element)
               },
                   onCompleted: {
                       print("Completed")
               }
           )
      ```

      - 위와같이 하면 Completed 조차 프린트 되지 않는다.

   3. **.range()**

      ```swift
      //1
      let observable = Observable<Int>.range(start: 1, count: 10)
      
      observable
         .subscribe(onNext: { (i) in
             
             //2
             let n = Double(i)
             let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
             print(fibonacci)
         })
      ```

      - 하나씩 살펴보자면
        - 1. range 연산자를 이용해서 start부터 count 크기 만큼 값을 같는 Observable을 생성한다.
        - 1. 각각 방출된 요소에 대한 번째 피보나치 숫자를 계산하고 출력한다.

### Disposing과 종료

- **Observable은 subscription을 받기 전까진 아무짓도 하지 않는다!**
- 즉, subscription이 Observable이 이벤트를 방출하도록 해줄 방아쇠 역할을 한다는 의미이다.
- 따라서 Observable에 대한 구독을 취소함으로써 Observable을 수종적으로 종료시킬 수 있다.

1. .dispose()

   ```swift
   // 1
   let observable = Observable.of("A", "B", "C")
   
   // 2
   let subscription = observable.subscribe({ (event) in
      
      // 3
      print(event)
   })
   
   subscription.dispose()
   ```

   - 작동 과정
     - 1. 어떤 String의 `Observable`을 생성한다.
     - 1. 이 Observable을 구독해본다. 여기서는 `subscripe`를 이용해서 `Disposable`을 리턴하도록 한다.
     - 1. 출력된 각각의 이벤트들을 프린트 한다.
   - 여기서 구족을 취소하고 싶으면 dispose()를 호출하면 된다. 구독을 취소하거나 dispose 한 뒤에는 이벤트 방출이 정지된다.
   - 현재 `observable` 안에는 3개의 요소만 있으므로 `dispose()`를 호출하지 않아도 `Completed` 가 프린트 되지만, 요소가 무한히 있다면 dispose()를 호출해야 `Completed` 가 프린트 된다.

2. **DispposeBag()**

   - 각각의 구독에 대해서 일일히 관리하는 것은 효율적이지 못하기 때문에, RxSwift에서 제공하는 DisposedBag 타입을 이용할 수 있다.
   - DisposeBag에는 (보통은 `.disposed(by:)` method를 통해 추가된) disposables를 가지고 있다.
   - disposable은 dispose bag이 할당 해제하려고 할 떄마다 dispose()를 호출한다.

   ```swift
   let disposeBag = DisposeBag()
   
   // 2
   Observable.of("A", "B", "C")
      .subscribe { // 3
          print($0)
      }
      .disposed(by: disposeBag) // 4
   ```

   - 순서대로 보자면
     - 1. dispose bag을 만든다
     - 1. Observable을 만든다
     - 1. 방출하는 이벤트를 포린팅한다
     - 1. subscribe로부터 방출된 리턴값을 disposeBag에 추가한다
   - 왜 이런짓을 하는걸까?
     - 만약 dispose bag을 subscription에 추가하거나 수동적으로 dispose를 호출하는 것을 빼먹는다면, 당연히 메모리 누수가 일어난다.

3. **.create(:)**

   - 앞서 .next 이벤트를 이용해서 Observable을 만들었듯이, .create연산자로 만드는 다른 방법이 있다.

   ```swift
   let disposeBag = DisposeBag()
        
   Observable<String>.create({ (observer) -> Disposable in
      // 1
      observer.onNext("1")
      
      // 2
      observer.onCompleted()
      
      // 3
      observer.onNext("?")
      
      // 4
      return Disposables.create()
   })
   ```

   - `create`는 escaping 클로저로, escaping에서는 `AnyObserver`를 취한 뒤 `Disposable`을 리턴한다.
   - AnyObserver란 generic 탕비으로 Observable swquence에 값을 쉽게 추기할 수 있다. 추가한 값은 subscriber에 방출된다.
   - 실행 순서를 보자면
     1. `.next` 이벤드를 Observer에 추가한다. `.onNext(_:)`는 `on(.next(_:))`를 편리하게 쓰는 용도
     2. `.completed` 이벤트를 Observer에 추가한다.
     3. 추가로 `.next`이벤츠를 추가한다.
     4. disposable을 리턴한다
   - 여기서 두번째 이벤트인 `?` 는 subscriber에 방출될까?

   ```swift
   let disposeBag = DisposeBag()
        
   Observable<String>.create({ (observer) -> Disposable in
      // 1
      observer.onNext("1")
      
      // 2
      observer.onCompleted()
      
      // 3
      observer.onNext("?")
      
      // 4
      return Disposables.create()
   })
      .subscribe(
          onNext: { print($0) },
          onError: { print($0) },
          onCompleted: { print("Completed") },
          onDisposed: { print("Disposed") }
   ).disposed(by: disposeBag)
   
   /* Prints:
     1
     Completed
     Disposed
   */
   ```

   - 위 코드와 같이 `.onCompleted()`를 통해 해당 Observable은 종료되었으므로, 두번째 `onNext(_:)`는 방출되지 않는다.
   - 여기서 `.onCompleted`와 `Disposables`를 지운다면 `1`과 `?`가 모두 찍힐것이다.
   - 하지만 종료를 위한 이벤트를 방출하진 않고 `disposed`도 하지 않기 때문에 결과적으로 메머리 낭비가 발생하게 될 것이다.

## observable factory

- subscriber를 기다리는 Observable을 만드는 대신,각 subscriber에게 새롭게 Observable 항목을 제공하는 Observable factory를 만드는 방법도 있다.

```swift
let disposeBag = DisposeBag()
     
// 1
var flip = false

// 2
let factory: Observable<Int> = Observable.deferred{
   
   // 3
   flip = !flip
   
   // 4
   if flip {
       return Observable.of(1,2,3)
   } else {
       return Observable.of(4,5,6)
   }
}

for _ in 0...3 {
   factory.subscribe(onNext: {
       print($0, terminator: "")
   })
       .disposed(by: disposeBag)
   
   print()
}
/* Prints:
123
456
123
456
*/
```

- 실행 순서를 본다면
  1. Observable이 리턴할 `Bool`값을 생성한다.
  2. `deferred`연산자를 이용해서 `Int` factory Observable을 생성한다.
  3. `factory`가 구독할 `flip`을 전환한다. (false → true)
  4. `flip`의 값을 따라 다른 Observable을 리턴하도록 한다.
- 이후 해당 factory의 구독을 4번 반복한 값을 출력해볼 수 있다.
  - factory를 구독할 때마다, 두개의 Observable이 번갈아가머 출력된다.
- `.deferred`는 **Observable을 리턴하는 메소드**이다. subscribe될때 `.deferred`가 실행되어 리턴 값인 Observable이 나오게 된다.ing

## Traits 사용

- Trait은 Observalble 보다 약간 하위의 Observable이다.
- 선택적으로 사용하여 코드의 가독성을 높힐 수 있다.

### 종류

- `Single`, `Maybe`, `Completable`라는 세가지 Trait이 있다.

### Single

- `.success(value)` 또는 `.error` 이벤트를 방출한다.
- `.success(value)` = `.next` + `.completed`

### Completable

- `.complete`d 또는 `.error` 만을 방출하며, 이 외 어떠한 값도 방출하지 않는다.

### Maybe

- `success(value)`, `.completed`, `.error` 만을 방출한다.
- `Single`, `Completable`을 썪어놓은 것

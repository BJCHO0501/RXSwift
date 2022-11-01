# ✨RxCocoa



### RxCocoa란?

- RxCocoa는 RxSwift의 동반 라이브러리로, UIKit과 Cocoa 프레임워크 기반 개발을 지원하는 모든 클래스를 보유하고 있다.

  - RxSwift는 일반적인 Rx API라서, Cocoa나 특정 UIKit 클래스에 대한 아무런 정보가 없다.
  - 그래서 RxCocoa를 사용해 편리하게 사용 가능하다

- 예를들어, RxCocoa를 이용하여 UISwift의 상태를 확인하는 것은 다음과 같이 매우 쉽다!

  ```swift
  toggleSwitch.rx.isOn
   	.subscribe(onNext: { enabled in
   		print( enabled ? "It's ON" : "it's OFF")
   	})
  ```

  - RxCocoa는 rx.isOn과 같은 프로퍼티를 UISwitch 클래스에 추가해주며, 이를 통해 이벤트 시퀀스를 확인할 수 있다.

- RxCocoa는 UITextField, URLSession, UIViewController 등에 rx를 추가하여 사용한다.

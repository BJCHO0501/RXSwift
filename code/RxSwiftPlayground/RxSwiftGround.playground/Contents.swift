import UIKit
import RxSwift

// MARK: - just, of, from

let one = 1
let two = 2
let three = 3

let observable1: Observable<Int> = Observable<Int>.just(one)

//타입 추론함
let observable2 = Observable.of([one, two, three])

//배열 요소를 하나씩 반환
let observable3 = Observable.from([one, two, three])

// MARK: - subscribe(onNext:_)

observable1
    .subscribe(onNext: {
    print($0)
})

observable2
    .subscribe(onNext: {
    print($0)
})

observable3
    .subscribe(onNext: {
    print($0)
})

// MARK: - empty()

let emptyObservable = Observable<Void>.empty()

emptyObservable.subscribe(
    onNext: {
        print($0)
    },
    onCompleted: {
        print("Completed")
    }
)


import UIKit
import RxSwift
import RxCocoa

// MARK: - just, of, from
//
//let one = 1
//let two = 2
//let three = 3
//
//let observable1: Observable<Int> = Observable<Int>.just(one)
//
////타입 추론함
//let observable2 = Observable.of([one, two, three])
//
////배열 요소를 하나씩 반환
//let observable3 = Observable.from([one, two, three])
//
//// MARK: - subscribe(onNext:_)
//
//observable1
//    .subscribe(onNext: {
//    print($0)
//})
//
//observable2
//    .subscribe(onNext: {
//    print($0)
//})
//
//observable3
//    .subscribe(onNext: {
//    print($0)
//})
//
//// MARK: - empty()
//
//let emptyObservable = Observable<Void>.empty()
//
//emptyObservable.subscribe(
//    onNext: {
//        print($0)
//    },
//    onCompleted: {
//        print("Completed")
//    }
//)
//
//// MARK: - .never()
//
//let neverObservable = Observable<Any>.never()
//
//neverObservable.subscribe(
//    onNext: {
//        print($0)
//    },
//
//    onCompleted: {
//        print("Completed")
//    }
//)
//
//// MARK: - .range()
//
//let rangeObservable = Observable<Int>.range(start: 1, count: 10)
//
//rangeObservable.subscribe(
//    onNext: {
//        print("range: \($0)")
//    },
//    onCompleted: {
//        print("Completed")
//    }
//)

// MARK: - Disposing

//let disposeBag = DisposeBag()
//
//let disposeObservable = Observable.of(4)
//
//disposeObservable.subscribe(
//    onNext: {
//        print($0)
//    },
//    onDisposed: {
//        print("Disposed")
//    }
//).disposed(by: disposeBag)

// MARK: - PublishSubjects

//print("=============PublishSubjects=============\n")

//let subject = PublishSubject<String>()
//     subject.onNext("Is anyone listening?")
//
//     let subscriptionOne = subject
//         .subscribe(onNext: { (string) in
//             print(string)
//         })
//     subject.on(.next("1"))
//     subject.onNext("2")
//
//     // 1
//     let subscriptionTwo = subject
//         .subscribe({ (event) in
//             print("2)", event.element ?? event)
//         })
//
//     // 2
//     subject.onNext("3")
//
//     // 3
//     subscriptionOne.dispose()
//     subject.onNext("4")
//
//     // 4
//     subject.onCompleted()
//
//     // 5
//     subject.onNext("5")
//
//     // 6
//     subscriptionTwo.dispose()
//
//     let disposeBag = DisposeBag()
//
//     // 7
//     subject
//         .subscribe {
//             print("3)", $0.element ?? $0)
//     }
//         .disposed(by: disposeBag)
//
//     subject.onNext("?")

// MARK: - BehaviorSubjects

//print("=============BehaviorSubjects=============\n")

enum MyError: Error {
    case anError
}

func print<T: CustomStringConvertible>(label: String, event: Event<T>) {
    print(label, event.element ?? event.error ?? event as Any)
}
//
//let subject = BehaviorSubject(value: "Initial value")
//let disposeBag = DisposeBag()
//
//subject.onNext("X")
//
//subject
//   .subscribe{
//       print(label: "1)", event: $0)
//   }
//   .disposed(by: disposeBag)
//
//subject.onError(MyError.anError)
//
//subject
//   .subscribe {
//       print(label: "2)", event: $0)
//   }
//   .disposed(by: disposeBag)

// MARK: - ReplaySubjects

//print("=============ReplaySubjects=============\n")
//
//let subject = ReplaySubject<String>.create(bufferSize: 2)
//let disposeBag = DisposeBag()
//
//
//subject.onNext("1")
//subject.onNext("2")
//subject.onNext("3")
//
//subject
// .subscribe {
//     print(label: "1)", event: $0)
// }
// .disposed(by: disposeBag)
//
//subject
// .subscribe {
//     print(label: "2)", event: $0)
// }
// .disposed(by: disposeBag)
//
//subject.onNext("4")
//subject.onError(MyError.anError)
//subject.dispose()
//
//subject
//    .subscribe {
//        print(label: "3)", event: $0)
//    }
//    .disposed(by: disposeBag)

// MARK: - Variables

//print("=============BehaviorRelay=============\n")
//
//let variable = BehaviorRelay(value: "first")
//let disposeBag = DisposeBag()
//
//var brhavior = variable.value
//
//
//variable.asObservable()
//    .subscribe {
//        print(label: "1)", event: $0)
//    }
//    .disposed(by: disposeBag)
//
//brhavior.append("asdfa")
//variable.accept(brhavior)

// MARK: - ignorElement

//Observable.of(1, 3, 4, 3)
//    .ignoreElements()
//    .subscribe({
//        print($0)
//    })
//    .disposed(by: disposeBag)

// MARK: - elementAt

//Observable.of(1,2,3)
//    .element(at: 0)
//    .subscribe({
//        print($0)
//    })
//    .disposed(by: disposeBag)


// MARK: - filter
//Observable.of(1, 2, 3, 4, 5, 6)
//    .filter { $0 < 4 }
//    .subscribe(
//        onNext: {
//            print($0)
//        }
//    )
//    .disposed(by: disposeBag)

// MARK: - flatMapLast

//struct Student {
//    var score: BehaviorSubject<Int>
//}
//
//let disposeBag = DisposeBag()
//
//let ryan = Student(score: BehaviorSubject(value: 80))
//let charlotte = Student(score: BehaviorSubject(value: 90))
//
//let student = PublishSubject<Student>()
//
//student
//    .flatMapLatest {
//        $0.score
//    }
//    .subscribe(onNext: {
//        print($0)
//    })
//    .disposed(by: disposeBag)
//
//student.onNext(ryan)
//ryan.score.onNext(85)
//
//student.onNext(charlotte)
//
//// 1
//ryan.score.onNext(95)
//charlotte.score.onNext(100)


// MARK: - concatMap

let sequences = ["Germany": Observable.of("Berlin", "Münich", "Frankfurt"),
              "Spain": Observable.of("Madrid", "Barcelona", "Valencia")]

let observable = Observable.of("Germany", "Spain")
 .concatMap({ country in
     sequences[country] ?? .empty() })

_ = observable.subscribe(onNext: {
 print($0)
})


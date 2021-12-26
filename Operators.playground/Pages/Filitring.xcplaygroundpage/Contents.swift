

import Foundation
import Combine

///Most operators in this chapter have parallels with a try prefix, for example, filter vs. tryFilter. The only difference between them is that the latter provides a throwing closure. Any error you throw from within the closure will terminate the publisher with the thrown error. For brevity’s sake, this chapter will only cover the non-throwing variations, since they are virtually identical.

var subscriptions = Set<AnyCancellable>()
//MARK: - 1- Filtering basics
//let numbers = (1...10).publisher
//numbers.filter{$0.isMultiple(of: 3)}
//  .sink { n in
//      print("\(n) is a multiple of 3!")
//}.store(in: &subscriptions)


///Many times in the lifetime of your app, you have publishers that emit identical values in a row that you might want to ignore. For example, if a user types "a" five times in a row and then types "b", you might want to disregard the excessive "a"s.Combine provides the perfect operator for the task: removeDuplicates:
//MARK: - 2- removeDuplicates
//let words = "hey hey there! want to listen to mister mister ?".components(separatedBy: " ").publisher
//
//    words
//    .removeDuplicates()
//    .sink(receiveValue:  { print($0)})
//    .store(in: &subscriptions)

 //MARK: - 3- Compacting and ignoring
///Quite often, you’ll find yourself dealing with a publisher emitting Optional values. Or even more commonly, you’ll want to perform some operation on your values that might return nil, but who wants to handle all those nils ?!


//let strings = ["a", "1.24", "3",
//                "def", "45", "0.23"].publisher
//strings
//   .compactMap { Int($0) }
//   .sink(receiveValue: {
//// 3
//print($0) })
//   .store(in: &subscriptions)

/*1. Create a publisher that emits a finite list of strings.
 2. Use compactMap to attempt to initialize a Float from each individual string. If Float’s initializer doesn’t know how to convert the provided string, it returns nil.
 3. Only print strings that have been successfully converted to Floats.*/

///All right, why don’t you take a quick break from all these values... who cares about those, right? Sometimes, all you want to know is that the publisher has finished emitting values, disregarding the actual values. When such a scenario occurs, you can use the ignoreOutput operator:
// I dont care about the out , but i want to check publisher has been finshed emitting
//MARK: -  4- IgnoreOutput
//
//// 1
// let numbers = (1...10_000).publisher
//// 2
// numbers
//   .ignoreOutput()
//   .sink(receiveCompletion: { print("Completed with: \($0)") },
//         receiveValue: { print($0) })
//   .store(in: &subscriptions)


///In this section, you’ll learn about two operators that also have their origins in the Swift standard library: first(where:) and last(where:). As their names imply, you use them to find and emit only the first or the last value matching the provided predicate, respectively.

//MARK: - 5- first(where:)

///This operator is interesting because it’s lazy, meaning: It only takes as many values as it needs until it finds one matching the predicate you provided. As soon as it finds a match, it cancels the subscription and completes.
//// 1
//let numbers = (1...9).publisher
//
//// 2
//numbers
//  .first(where: { $0 % 2 == 0 })
//  .print("numbers")
//  .sink(receiveCompletion: { print("Completed with: \($0)") },
//        receiveValue: { print($0) })
//  .store(in: &subscriptions)

//"Completed with: 2



//As opposed to first(where:), this operator is greedy since it must wait for all values to emit to know whether a matching value has been found. For that reason, the upstream must be a publisher that completes at some point.
//MARK: - 6- last(where:)
//let numbers = (1...9).publisher
//// 2
// numbers
//   .last(where: { $0 % 2 == 0 })
//   .sink(receiveCompletion: { print("Completed with: \($0)") },
//         receiveValue: { print($0) })
//   .store(in: &subscriptions
////"Completed with: 8



//MARK: - EXAMPLE

//let numbers = PassthroughSubject<Int,Never>()
//
//numbers
//    .last(where: {$0 % 2 == 0})
//    .sink(receiveCompletion: { print("Completed with: \($0)") },
//             receiveValue: { print($0) })
//          .store(in: &subscriptions)
//       numbers.send(1)
//       numbers.send(2)
//       numbers.send(3)
//       numbers.send(4)
//       numbers.send(5)
//As expected, since the publisher never completes, there’s no way to determine the last value matching the criteria.
//To fix this, add the following as the last line of the example to send a completion through the subject:


//numbers.send(completion: .finished)

//MARK: - 7- Dropping values
/*Dropping values is a useful capability you’ll often need to leverage when working with publishers. For example, you can use it when you want to ignore values from one publisher until a second one starts publishing, or if you want to ignore a specific amount of values at the start of the stream.
 Three operators fall into this category, and you’ll start by learning about the simplest one first — dropFirst.*/
//MARK: - A Drop(first:)
//let numbers = (1...10).publisher
//numbers
//    .dropFirst(8)
//    .sink { print($0)}
//    .store(in: &subscriptions)
// it will print out just two numbers 9 and 10
//MARK: - B- drop(while:)
/*Moving on to the next operator in the value dropping family – drop(while:). This is another extremely useful variation that takes a predicate closure and ignores any values emitted by the publisher until the first time that predicate is met. As soon as the predicate is met, values begin to flow through the operator:*/
//// 1
//  let numbers = (1...10).publisher
//// 2
//  numbers
//    .drop(while: { $0 % 5 != 0 })
//    .sink(receiveValue: { print($0) })
//    .store(in: &subscriptions)
/*The first difference is that filter lets values through if you return true in the closure, while drop(while:) skips values as long you return true from the closure.
 The second, and more important difference is that filter never stops evaluating its condition for all values published by the upstream publisher. Even after the condition of filter evaluates to true, further values are still "questioned" and your closure must answer the question: "Do you want to let this value through?".
 On the contrary, drop(while:)’s predicate closure will never be executed again after the condition is met. To confirm this, replace the following line:*/

//MARK: - C- drop(untilOutputFrom:).
/*The final and most elaborate operator of the filtering category is
 drop(untilOutputFrom:).
 Imagine a scenario where you have a user tapping a button, but you want to ignore all taps until your isReady publisher emits some result. This operator is perfect for this sort of condition.
 It skips any values emitted by a publisher until a second publisher starts emitting values, creating a relationship between them:*/
//// 1
// let isReady = PassthroughSubject<Void, Never>()
// let taps = PassthroughSubject<Int, Never>()
//// 2
// taps
//   .drop(untilOutputFrom: isReady)
//   .sink(receiveValue: { print($0) })
//   .store(in: &subscriptions)
//// 3
// (1...5).forEach { n in
//   taps.send(n)
//if n == 3 {
//     isReady.send()
//   }
//}

/*This section tackles the opposite need: receiving values until some condition is met, and then forcing the publisher to complete. For example, consider a request that may emit an unknown amount of values, but you only want a single emission and don’t care about the rest of them.The prefix family of operators is similar to the drop family and provides prefix(_:), prefix(while:) and prefix(untilOutputFrom:). However, instead of dropping values until some condition is met, the prefix operators take values until that condition is met.*/
//MARK: - Perfix family
    //MARK: - A- PERFIX()
//// 1
//  let numbers = (1...10).publisher
//// 2
//  numbers
//    .prefix(2)
//    .sink(receiveCompletion: { print("Completed with: \($0)") },
//          receiveValue: { print($0) })
//    .store(in: &subscriptions)
//MARK: - B- prefix(while:)
/*Just like first(where:), this operator is lazy, meaning it only takes up as many values as it needs and then terminates. This also prevents numbers from producing additional values beyond 1 and 2, since it also completes.
 Next up is prefix(while:), which takes a predicate closure and lets values from the upstream publisher through as long as the result of that closure is true. As soon as the result is false, the publisher will complete:*/
//// 1
//  let numbers = (1...10).publisher
//// 2
//  numbers
//    .prefix(while: { $0 < 3 })
//    .sink(receiveCompletion: { print("Completed with: \($0)") },
//          receiveValue: { print($0) })
//    .store(in: &subscriptions)

/*With the first two prefix operators behind us, it’s time for the most complex one: prefix(untilOutputFrom:). Once again, as opposed to drop(untilOutputFrom:) which skips values until a second publisher emits, prefix(untilOutputFrom:) takes values until a second publisher emits.
 Imagine a scenario where you have a button that the user can only tap twice. As soon as two taps occur, further tap events on the button should be omitted:*/
//MARK: - C prefix(untilOutputFrom:)
//// 1
// let isReady = PassthroughSubject<Void, Never>()
// let taps = PassthroughSubject<Int, Never>()
//// 2
// taps
//   .prefix(untilOutputFrom: isReady)
//   .sink(receiveCompletion: { print("Completed with: \($0)") },
//         receiveValue: { print($0) })
//   .store(in: &subscriptions)
//(1...5).forEach { n in
//    taps.send(n)
//  if n == 2 {
//      isReady.send()
//    }
//}

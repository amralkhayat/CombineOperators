import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()
                   //Transforming operation 
// MARK: - collction
//["A", "B", "C", "D", "E"].publisher
//    .collect()
//    .sink(receiveCompletion: { print($0) },
//          receiveValue: { print($0) })
//    .store(in: &subscriptions)
//MARK: - MAP
//let publisher = [1, 2, 3, 4, 5].publisher
//      publisher.map {$0 + 2}
//      .collect()
//.sink(receiveCompletion: { print($0) },
//          receiveValue: { print($0) })
//    .store(in: &subscriptions)

//MARK: -  tryMap

//Just("Directory Name that does not exist")
//    .tryMap{try FileManager.default.contentsOfDirectory(atPath: $0) }
//    .sink(receiveCompletion: {print($0)},
//          receiveValue: {print($0)})
//    .store(in: &subscriptions)
//MARK: - FlatMap
/*The flatMap operator can be used to flatten multiple upstream publishers into a single downstream publisher — or more specifically, flatten the emissions from those publishers.*/
//struct Chatter {
//    let name: String
//    let message: CurrentValueSubject<String, Never>
//    init (name: String, message: String){
//        self.name = name
//        self.message = CurrentValueSubject(message)
//    }
//}
////1
//let charlotte = Chatter(name: "Charlotte", message: "Hi, I'm Charlotte!")
//let james = Chatter(name: "James", message: "Hi, I'm James!")
//
//let chat =  CurrentValueSubject<Chatter,Never>(charlotte)
//  chat
//    .flatMap(maxPublishers: .max(2)) { $0.message }
//    .sink(receiveValue: {print($0)})
//    .store(in: &subscriptions)
//charlotte.message.value = "Charlotte: How's it going?"
//chat.value =  james
//
//james.message.value = "James: Doing great. You?"
//charlotte.message.value = "Charlotte: I'm doing fine thanks."
//
//let morgan = Chatter(name: "Morgan",
//                     message: "Hey guys, what are you up to?")
//chat.value = morgan
//
//charlotte.message.value = "Did you hear something?"

/// Replacing upstream output
// MARK: - replaceNil(with:)
/*As depicted in the following marble diagram, replaceNil will receive optional values and replace nils with the value you specify:
 There is a subtle but important difference between using ?? and replaceNil. The ?? operator can return another optional, while replaceNil cannot. Change the usage of replaceNil to the following,*/

//["A", nil, "C"].publisher
//   .replaceNil(with: "-" )
//   .map{$0!}// 2
//   .sink(receiveValue: {print($0)})
//   .store(in: &subscriptions)

//MARK: - replaceEmpty(with:)
/*You can use the replaceEmpty(with:) operator to replace — or really, insert — a value if a publisher completes without emitting a value.*/

/*The Empty publisher type can be used to create a publisher that immediately emits
 a .finished completion event. It can also be configured to never emit anything by passing false to its completeImmediately parameter, which is true by default. This publisher is useful for demo or testing purposes, or when all you want to do is signal completion of some task to a subscriber. Run the playground and its completion event is printed:*/

//let empty = Empty<Int,Never>()
//empty
//    .replaceEmpty(with: 10)
//  .sink(receiveCompletion: { print($0) },
//        receiveValue: { print($0) })
//  .store(in: &subscriptions)


///Incrementally transforming output

//MARK: - Scan
//let range = (0...5).publisher
//    .scan(0) { return $0 + $1}
//
//    range.sink { print ("\($0)", terminator: " ") }
//    .store(in: &subscriptions)
//
///*0,1,2,3,4,5
//0+0 = 0
//0+1 = 1
//1+2 = 3
//3+3 = 6
//6+ 4 = 10
//10 + 15
//
// */

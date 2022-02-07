
import Combine
var subscriptions = Set<AnyCancellable>()
//MARK: - 1- Prepending
/*You’ll start slowly here with a group of operators that are all about prepending values at the beginning of your publisher. In other words, you’ll use them to add values that emit before any values from your original publisher.
 There is three types of prepending are  prepend(Output...), prepend(Sequence) and prepend(Publisher).*/

   //MARK: - A- prepend(Output...)
/*This variation of prepend takes a variadic list of values using the variadic ... syntax. This means it can take any number of values, as long as they’re of the same Output type as the original publisher*/
//let publisher = [3,4].publisher
//         publisher
//           .prepend(1,2)
//           .sink(receiveValue: { print($0) })
//             .store(in: &subscriptions)

// output will be
/*
 1
 2
 3
 4
 */
  //MARK: - B- prepend(Sequence)
/*This variation of prepend is similar to the previous one, with the difference that it takes any Sequence-conforming object as an input. For example, it could take an ( Array or a Set).*/
//
//    let publisher = [5, 6, 7].publisher
//    publisher
//      .prepend([3, 4])
//      .prepend(Set(1...2))
//      .sink(receiveValue: { print($0) })
//      .store(in: &subscriptions)
    // output will be
    /*
     1
     2
     3
     4
     5
     6
     7
     */
   //MARK: - C- prepend(Publisher)
   /*The two previous operators prepended lists of values to an existing publisher. But what if you have two different publishers and you want to glue their values together? You can use prepend(Publisher) to add values emitted by a second publisher before the original publisher’s values.*/
//  let publisher1 = [3, 4].publisher
//  let publisher2 = [1, 2].publisher
//   publisher1
//    .prepend(publisher2)
//    .sink(receiveValue: { print($0) })
//    .store(in: &subscriptions)


//  let publisher1 = [3, 4].publisher
//  let publisher2 = PassthroughSubject<Int, Never>()
//  publisher1
//    .prepend(publisher2)
//    .sink(receiveValue: { print($0) })
//    .store(in: &subscriptions)
//publisher2.send(1)
//publisher2.send(completion: .finished)
/*Well, think about it — how can Combine know the prepended publisher, publisher2, has finished emitting values? It doesn’t, since it has emitted values, but no completion event. For that reason, a prepended publisher must complete so Combine knows it has finished prepending and can continue to the primary publisher.*/


//MARK: - 2- Appending
/*This next set of operators deals with concatenating events emitted by publishers with other values. But in this case, you’ll deal with appending instead of prepending, using append(Output...), append(Sequence) and append(Publisher). These operators work in a similar way as their prepend counterparts*/
     //MARK: - A- append(Output...)
/*append(Output...) works similarly to its prepend counterpart: It also takes a variadic list of type Output but then appends its items after the original publisher has completed with a .finished event*/
       
//          let publisher = [1].publisher
//
//          publisher
//            .append(2, 3)
//            .append(4)
//            .sink(receiveValue: { print($0) })
//            .store(in: &subscriptions)
    // THE output will be
     /*
      1
      2
      3
      4
      */
     //MARK: - B- append(Sequence)
/*This variation of append takes any Sequence-conforming object and appends its values after all values from the original publisher have emitted.*/

//        let publisher = [1, 2, 3].publisher
//         publisher
//           .append([4, 5]) // 2
//           .append(Set([6, 7])) // 3
//           .append(stride(from: 8, to: 11, by: 2)) // 4
//           .sink(receiveValue: { print($0) })
//           .store(in: &subscriptions)

     //MARK: - C-append(Publisher)
    /*The last member of the append operators group is the variation that takes a Publisher and appends any values emitted by it to the end of the original publisher.*/
//
//        // 1
//          let publisher1 = [1, 2].publisher
//          let publisher2 = [3, 4].publisher
//        // 2
//          publisher1
//            .append(publisher2)
//            .sink(receiveValue: { print($0) })
//            .store(in: &subscriptions)

//MARK: -  3- switchToLatest
 /*Joking aside, switchToLatest is complex but highly useful. It lets you switch entire publisher subscriptions on the fly while canceling the pending publisher subscription, thus switching to the latest one.
  You can only use it on publishers that themselves emit publishers.*/

//        let publisher1 = PassthroughSubject<Int, Never>()
//        let publisher2 = PassthroughSubject<Int, Never>()
//        let publisher3 = PassthroughSubject<Int, Never>()
//
//
//        let publishers = PassthroughSubject<PassthroughSubject<Int,Never>, Never>()
//        publishers
//           .switchToLatest()
//           .sink(receiveCompletion: { _ in print("Completed!") },
//                 receiveValue: { print($0) })
//           .store(in: &subscriptions)
//
//         publishers.send(publisher1)
//         publisher1.send(1)
//         publisher1.send(2)

//         publishers.send(publisher2)
//   WHY WE HAVE SEND VALUE TO Publisher1 to prove when we send the second publisher the first one has been cancled
//         publisher1.send(3)
//         publisher2.send(4)
//         publisher2.send(5)
//
//         publishers.send(publisher3)
//         publisher2.send(6)
//         publisher3.send(7)
//         publisher3.send(8)
//         publisher3.send(9)
//
//         publisher3.send(completion: .finished)
//         publishers.send(completion: .finished)

        // outPut
        //1
        //2
        //4
        //5
        //7
        //8
        //9
        //Completed!

/*1. Create three PassthroughSubjects that accept integers and no errors.
 2. Create a second PassthroughSubject that accepts other PassthroughSubjects.
 For example, you can send publisher1, publisher2 or publisher3 through it.
 3. Use switchToLatest on your publishers. Now, every time you send a different publisher through the publishers subject, you switch to the new one and cancel the previous subscription.
 4. Send publisher1 to publishers and then send 1 and 2 to publisher1.
 5. Send publisher2, which cancels the subscription to publisher1. You then send 3 to publisher1, but it’s ignored, and send 4 and 5 to publisher2, which are pushed through because publisher2 is the current subscription.
 6. Send publisher3, which cancels the subscription to publisher2. As before, you send 6 to publisher2 and it’s ignored, and then send 7, 8 and 9, which are pushed through the subscription.
 7. Finally, you send a completion event to the current publisher, publisher3, and another completion event to publishers. This completes all active subscriptions.*/
//MARK: -  3- merge(with:)
//This operator interleaves emissions from different publishers of the same type, like so
 
//// 1
//  let publisher1 = PassthroughSubject<Int, Never>()
//  let publisher2 = PassthroughSubject<Int, Never>()
//// 2
//  publisher1
//    .merge(with: publisher2)
//    .sink(receiveCompletion: { _ in print("Completed") },
//          receiveValue: { print($0) })
//    .store(in: &subscriptions)
//// 3
//  publisher1.send(1)
//  publisher1.send(2)
//  publisher2.send(3)
//  publisher1.send(4)
//  publisher2.send(5)
//// 4
//  publisher1.send(completion: .finished)
//  publisher2.send(completion: .finished)

//// OUTPUT
//1
//2
//3
//4
//5
//Completed

/*1. Create two PassthroughSubjects that accept and emit integer values and will not emit an error.
 2. Merge publisher1 with publisher2, interleaving the emitted values from both. Combine offers overloads that let you merge up to eight different publishers.
 3. You add 1 and 2 to publisher1, then add 3 to publisher2, then add 4 to publisher1 again and finally add 5 to publisher2.
 4. You send a completion event to both publisher1 and publisher2.*/
//MARK: -  3- combineLatest
//combineLatest is another operator that lets you combine different publishers. It also lets you combine publishers of different value types.which can be extremely useful. However, instead of interleaving the emissions of all publishers, it emits a tuple with the latest values of all publishers whenever any of them emit a value.One catch though: The origin publisher and every publisher passed to combineLatest must emit at least one value before combineLatest will emit anything.
//    // 1
//      let publisher1 = PassthroughSubject<Int, Never>()
//      let publisher2 = PassthroughSubject<String, Never>()
//    // 2
//      publisher1
//        .combineLatest(publisher2)
//        .sink(receiveCompletion: { _ in print("Completed") },
//              receiveValue: { print("P1: \($0), P2: \($1)") })
//        .store(in: &subscriptions)
//    // 3
//      publisher1.send(1)
//      publisher1.send(2)
//      publisher2.send("a")
//      publisher2.send("b")
//      publisher1.send(3)
//      publisher2.send("c")
//    // 4
//      publisher1.send(completion: .finished)
//      publisher2.send(completion: .finished)
// output
//P1: 2, P2: a
//P1: 2, P2: b
//P1: 3, P2: b
//P1: 3, P2: c
//Completed

/*1. Create two PassthroughSubjects. The first accepts integers with no errors, while the second accepts strings with no errors.
 2. Combine the latest emissions of publisher2 with publisher1. You may combine up to four different publishers using different overloads of combineLatest.
 3. Send 1 and 2 to publisher1, then "a" and "b" to publisher2, then 3 to publisher1 and finally "c" to publisher2.
 4. Send a completion event to both publisher1 and publisher2.*/
//You might notice that the 1 emitted from publisher1 is never pushed through combineLatest. That’s because combineLatest only combines once every publisher emits at least one value. Here, that condition is true only after "a" emits, at which point the latest emitted value from publisher1 is 2. That’s why the first emission is (2, "a")


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

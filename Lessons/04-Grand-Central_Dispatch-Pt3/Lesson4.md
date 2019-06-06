# Grand Central Dispatch (Part 3)

<!-- INSTRUCTOR Notes:

1) for initial exercise...
- answers to Part 2 are below each question...

2) for Activity 1:
- instructor notes are below exercise...
 -->

## Minute-by-Minute

| **Elapsed** | **Time**  | **Activity**              |
| ----------- | --------- | ------------------------- |
| 0:00        | 0:05      | Objectives                |
| 0:05        | 0:15      | Initial Exercise           |
| 0:20        | 0:15      | Overview / TT I                 |
| 0:35        | 0:20      | In Class Activity I       |
| 0:55        | 0:10      | BREAK                     |
| 1:05        | 0:15      | Overview / TT II              |
| 1:15        | 0:35      | In Class Activity II      |
| TOTAL       | 1:50      |                           |

## Why you should know this or industry application (optional) (5 min)

Explain why students should care to learn the material presented in this class.

## Learning Objectives (5 min)
By the end of this lesson, you should be able to...

1. Identify and describe:
<!-- - when to use __*Synchronous*__ and __*Asynchronous*__
- __*Sync*__ and __*Deadlocks*__
- __*Critical Section*__
- __*Thread Safety*__
- GCD's provided __*serial*__ and __*concurrent*__ DispatchQueues
- __*QoS Priority*__
- how the __*Main Queue*__ fits in GCD -->

2. Implement
<!-- - create queues
- default initialer -->

## Initial Exercise (10 min)

### Part 1 - As A Class

- Highlights of WWDC 2019 so far...

### Part 2 - As A Class

- Review of GCD subtopics and questions from previous class...

</br>

&nbsp;&nbsp;&nbsp;&nbsp; ![gcd_queues](assets/gcd_queues.png) </br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *Source:*
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; https://www.objc.io/issues/2-concurrency/concurrency-apis-and-pitfalls/

## Overview/TT I (20 min)

<!-- OUTLINE:

Inferring QoS
Creating Serial & Concurrent Queues
Custom queues
Default Queues
Issues

Delaying Work with dispatch_after?
Handling Background Tasks with dispatch_sync?
Making Your Singletons Thread-Safe? -->


### Creating Serial Queues

From our previous lesson, the example below illustrates how easy it is to create `DispatchQueues`.

Here, we create a new `DispatchQueue` called `myQueue` with a *label* (identifier) of `"com.makeschool.mycoolapp.networking"`:

```Swift
  let myQueue = DispatchQueue(label: "com.makeschool.mycoolapp.networking")
 ```
This example invokes the __*default initializer*__ for a `DispatchQueue`.

If you do not expressly define your `DispatchQueue` with the `.concurrent` attribute, GCD will __*by default*__ create a __*serial*__ queue (wherein each task must complete before the next task is able to start).

### Creating Concurrent Queues

It's just as easy to create a **concurrent**`DispatchQueue`.

To create a concurrent queue, pass the `.concurrent` attribute to your new queue:

```Swift
  let myQueue = DispatchQueue(label: "com.makeschool.mycoolapp.networking", attributes: .concurrent)
 ```

### QoS Priority Levels (Quick Review)

A `Quality of Service (QoS)` class categorizes work to be performed on a `DispatchQueue`.

Concurrent queues are so common that Apple has provided six different global concurrent queues, depending on the `Quality of Service (QoS)` the queue should have &mdash; four primary QoS classes and two special QoS classes.

If we look "under the hood", we can see all six QoS classes defined in the `QoSClass enum`:

![QoSClass_enum](assets/QoSClass_enum.png) </br>


When using a __*concurrent*__ dispatch queue, you'll need to tell GCD how important the tasks are that get sent to the queue so that it can properly prioritize execution of your task against all other tasks competing for resources.

By specifying a QoS to work, you indicate its importance, and the system prioritizes it and schedules it accordingly.

Remember that higher-priority work has to be performed faster, takes more system resources to complete, and requires more energy than lower-priority work.



Note: Global queues are always concurrent and first-in, first-out.


If you just need a concurrent queue but don't want to manage your own, you can use the global class method on DispatchQueue to get one of the pre-defined global queues:

let queue = DispatchQueue.global(qos: .userInteractive)

As mentioned above, Apple offers six quality of service classes:




<!-- TODO: insert table here, with the 2 add'l QoS levels from Ray W bk -->



<!-- IDEAS FROM RAY W: - TODO: 1) check these against prior lesson for redundancy 2) boil down
Concurrent queues are so common that Apple has provided six different global concurrent queues, depending on the Quality of service (QoS) the queue should have.

When using a concurrent dispatch queue, you'll need to tell iOS how important the tasks are that get sent to the queue so that it can properly prioritize the work that needs to be done against all the other tasks that are clamoring for resources.

Remember that higher-priority work has to be performed faster, likely taking more system resources to complete and requiring more energy than lower-priority work.

If you just need a concurrent queue but don't want to manage your own, you can use the global class method on DispatchQueue to get one of the pre-defined global queues:

let queue = DispatchQueue.global(qos: .userInteractive)

As mentioned above, Apple offers six quality of service classes:

Note: Global queues are always concurrent and first-in, first-out. -->





<!-- TODO: insert code showing how to create a queue with QoS levels -->

![QoS_classes](assets/QoS_classes.png) </br>


Special Quality of Service Classes

In addition to the primary QoS classes, there are two special types of QoS (described in Table 4-2). In most cases, you won’t be exposed to these classes, but there is still value in knowing they exist.


![special_QoS_classes](assets/special_QoS_classes.png) </br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *Source:*
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html


### Creating QoS priority

Need a concurrent queue but don't want to have to manage your own? Then just *use the global class method* on `DispatchQueue` to use one of the __*pre-defined global queues:*__

```Swift
  let queue = DispatchQueue.global(qos: .userInteractive)
 ```
But if you wish to create your own concurrent `DispatchQueue`, you can specify to the system your *target* QoS level in its initializer:

```Swift
  let queue = DispatchQueue(label: "com.makeschool.mycoolapp.networking",
                          qos: .userInitiated,
                          attributes: .concurrent)
 ```

### QoS Inference and Promotion

Accurately specifying appropriate QoS classes for the work your app performs &mdash; as in the example above &mdash; ensures that your app is responsive and energy efficient.

But behavior that QoS levels are __*not static*__ &mdash; GCD pays attention to the types of tasks being submitted to a queue and will adjust the QoS level as it deems necessary.

If you submit a task with a higher QoS than the queue has, GCD will increase the queue's QoS level to match the higher level of the task you submitted.

In addition, all tasks enqueued will also have their priorities raised.

Though there is a vast number of scenarios in which QoS inference and promotion might occur, common examples are:
- where the QoS of a task (or operation) and the QoS of a queue do not match
- the QoS of an operation and that of its dependent operation do not match
- an task (or operation) has no QoS assigned

> NOTE: Apple applies numerous rules governing how QoS inference and promotion occurs with regard to queues and operations. For more info, review the source material.


&nbsp;&nbsp;&nbsp; *Source:* </br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; [Prioritize Work with Quality of Service Classes](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html)


### Tasks & Captured Closure Variables

Tasks sent to `DispatchQueues` are most often closures.

But the rules of closures do not change when used with `DispatchQueues` &mdash; you must still must properly handle a closure's captured variables if you plan to use them later.

However, how GCD manages `DispatchQueues` effects the timing of events, especially the order in which the lifecycle of dependent references ends.

Remember: When using `DispatchQueues`, capturing references *weakly* or *strongly* should be based on your needs &mdash; especially with regard to using `self`.

#### Example Scenario:

Consider that when your app starts, it must contact a remote resource to update the app's state (ex: for In-App Purchase, Email updates, news feeds).

This task:
- is not user-initiated
- does not need to happen immediately
- depends on networking I/O

Thus, it would be a good candidate to be sent to the global utility queue.

```Swift  
  DispatchQueue.global(qos: .utility).async { [weak self] in
    guard let self = self else { return }
    // Perform some work here
    // ...
    // Switch back to the main queue to
    // update your UI
    DispatchQueue.main.async {
      self.textLabel.text = "Data up to date"
    }
  }
```

Note that *strongly* capturing self in a GCD async closure will not cause a retain cycle because the entire closure will be deallocated as soon as it completes.

But it *will* extend the lifetime of `self`.

In other words, if you make a network request from a view controller that has been dismissed in the meantime, the closure will still get called:
- if you capture the view controller __*weakly*__ it will be `nil`.
- but if you capture it __*strongly*__ the view controller will remain alive until the closure finishes its work.


## In Class Activity I (25 min)

### Part 1 - Observing QoS on Two Queues

1. Run the following code in a playground and observe its output:

```Swift  
  import Foundation

  let queue1 = DispatchQueue(label: "com.makeschool.queue1", qos: DispatchQoS.userInitiated)
  let queue2 = DispatchQueue(label: "com.makeschool.queue2", qos: DispatchQoS.userInitiated)

  queue1.async {
      for i in 0..<10 {
          print("🍎 ", i)
      }
  }

  queue2.async {
      for i in 100..<110 {
          print("🐳 ", i)
      }
  }
```

2. Change the QoS levels of the queues to match the following:

```Swift
  let queue1 = DispatchQueue(label: "com.makeschool.queue1", qos: DispatchQoS.userInitiated)
  let queue2 = DispatchQueue(label: "com.makeschool.queue2", qos: DispatchQoS.utility)
 ```
 **Q:** How has the output changed and why?

 3. Change the QoS levels of the queues in various ways and observe the results

### Part 2 - Observing QoS on Two Queues plus Main Queue

 1. Run the following code in a playground and observe its output:

 ```Swift

   import Foundation

   let queue1 = DispatchQueue(label: "com.makeschool.queue1", qos: DispatchQoS.userInitiated)
   let queue2 = DispatchQueue(label: "com.makeschool.queue2", qos: DispatchQoS.utility)

   queue1.async {
       for i in 0..<10 {
           print("🍎 ", i)
       }
   }

   queue2.async {
       for i in 100..<110 {
           print("🐳 ", i)
       }
   }

   for i in 100..<110 {
       print("😬 ", i)
   }

  ```

  **Q:** What can you learn from the output here?


## Overview/TT II (optional) (20 min)

### Dispatch Groups

What if you need to process a group of tasks?

And what if, on completion of that task group, you want to execute some other code that is dependent on the group's completion?


For just such a scenario, Apple provides the `DispatchGroup` class, which allows you to:
- group tasks
- track the completion of a group of tasks

A `DispatchGroup` is a group of tasks that you monitor as a single unit. It allos you to group together multiple tasks and either wait for them to complete or to receive a notification once they complete.

Key points about dispatch group tasks:
- tasks do not all have to run at the same time.
- they can even run on __*different queues.*__
- they can be __*asynchronous*__ or __*synchronous.*__


Using `DispatchGroup` is simple. Steps include:
1. create the group
2. provide the group as an argument
3. invoke desired `DispatchGroup` functions/behaviors

#### Simple Example:

In this code snippet, we (1) create a dispatch group called `myDispatchGroup` and (2) assign `myDispatchGroup` as the group argument to three tasks.
- Note that one of the three tasks is on a separate queue.

```Swift  
  let myDispatchGroup = DispatchGroup()
  myQueue.async(group: myDispatchGroup) { ... fetch data, images, etc. ... }
  myQueue.async(group: myDispatchGroup) { ... process data .... }
  myOtherQueue.async(group: myDispatchGroup) { ... other work ... }
```

Next, we invoke the `.notify()` function on the group, and tell it to update a textLabel on the `main queue` when all group tasks have completed:

```Swift  
  myDispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
     self?.textLabel.text = "All myDispatchGroup tasks have completed"
  }
```




<!-- TODO: example scenarios? -->



- As seen in the example code above, groups are not hardwired to a single dispatch queue. You can use a single group, yet submit jobs to multiple queues, depending on the priority of the task that needs to be run. DispatchGroups provide a notify(queue:) method, which you can use to be notified as soon as every job submitted has finished.

<!-- TODO: see Apple docs for more text -->





<!-- TODO: insert example here -->


<!--
let group = DispatchGroup()
someQueue.async(group: group) { ... your work ... }
someQueue.async(group: group) { ... more work .... }
someOtherQueue.async(group: group) { ... other work ... }


group.notify(queue: DispatchQueue.main) { [weak self] in
   self?.textLabel.text = "All jobs have completed"
} -->


#### Synchronous waiting
...or "group.wait()"

 You can also wait synchronously for all tasks in the group to finish executing.

blocks your current thread until all the group’s enqueued tasks finish.


can use wait(timeout:) to specify a timeout and bail out on waiting after a specified time.


#### Wrapping asynchronous methods
...or "  group.enter()"

Call enter() to manually notify the group that a task has started.



## In Class Activity II (30 min)

1. The following playground code assigns two tasks to a `DispatchGroup` and invokes `.wait()` function on the `DispatchGroup`:

- Run the code in a playground and observe its output...

```Swift  
  import UIKit
  import PlaygroundSupport

  /*: Tell the playground to continue running, even after it thinks execution has ended.
  You need to do this when working with background tasks. */

  PlaygroundPage.current.needsIndefiniteExecution = true

  let group = DispatchGroup()
  let myGlobalQueue = DispatchQueue.global(qos: .userInitiated)

  myGlobalQueue.async(group: group) {
    print("Start task 1")
    Thread.sleep(until: Date().addingTimeInterval(10))
    print("End task 1")
  }

  myGlobalQueue.async(group: group) {
    print("Start task 2")
    Thread.sleep(until: Date().addingTimeInterval(2))
    print("End task 2")
  }

  if group.wait(timeout: .now() + 5) == .timedOut {
    print("Hey, I've been waiting too long!")
  } else {
    print("All tasks completed")
  }

  /*: Instruct Xcode that the playground page has finished execution. */
  PlaygroundPage.current.finishExecution()
```

 **Q:** Why does it output `"Hey, I've been waiting too long!"` instead of `"All tasks completed"`?

  **Q:** How would you change it to get `"All tasks completed"` as its output?

 2. Make changes so that its output is now `"All tasks completed"`



## After Class
1. Research:
- Thunk
- Review the section "Quality of Service Inference and Promotion" in this reference:
&nbsp;&nbsp;&nbsp; [Prioritize Work with Quality of Service Classes](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html)

Listing 4-3Retrieving the QoS of a GCD dispatch queue


2. Assignment:
-

## Wrap Up (5 min)

- Continue working on your current tutorial
- Complete reading
- Complete challenges

## Additional Resources

1. [Slides]()
2. []()
3. []()
4. []()
5. []()

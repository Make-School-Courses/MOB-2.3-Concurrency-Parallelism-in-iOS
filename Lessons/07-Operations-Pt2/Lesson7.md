# Operations (Part 2)

## Minute-by-Minute

| **Elapsed** | **Time**  | **Activity**              |
| ----------- | --------- | ------------------------- |
| 0:00        | 0:05      | Objectives                |
| 0:05        | 0:15      | Overview                  |
| 0:20        | 0:45      | In Class Activity I       |
| 1:05        | 0:10      | BREAK                     |
| 1:15        | 0:45      | In Class Activity II      |
| TOTAL       | 2:00      |                           |

## Learning Objectives (5 min)

By the end of this lesson, you should be able to...

1. Identify and describe:
- how to use `OperationQueues` to handle the scheduling and execution of `Operations`.


<!-- 1. Identify and describe
1. Define
1. Design
1. Implement -->


<!-- Define and describe:
- Operation
- Operation Queues
- Benefits and Challenges of using Operations and Operation Queues
- the difference between GCD and Operations and Operation Queues
- when to use GCD vs Operations vs Operation Queues
- Subclassing
- Block Operations -->


## Initial Exercise (15 min)

1. Review solutions to "Assignment 2: Solve the Dining Philosophers Problem" (challenge) from previous class: https://github.com/raywenderlich/swift-algorithm-club/tree/master/DiningPhilosophers

- One or more volunteers present their solutions. Opens a class discussion.

<!-- POTENTIAL OUTLINE:
How to implement (subclassing)
OperationQueues
Async Operations

Cancelling
Dependencies

  -->


  <!-- OUTLINE?
  What are they?

  Why use them? benefits

  How they work

  White board

  Syntax examples

  dependencies

  Compared to GCD... when to use them

    examples from Ray W:
    operations allow for the handling of more complex scenarios such as reusable code to be run on a background thread, having one thread depend on another, and even canceling an operation before it's started or completed.

    GCD is great for common tasks that need to be run a single time in the background. When you find yourself building functionality that should be reusable — such as image editing operations — you will likely want to encapsulate that functionality into a class. By subclassing Operation, you can accomplish that goal!

  -->


## How to implement Operation objects (TT I) (20 min)

### Synchronous Versus Asynchronous Operations

Before we explore subclassing `Operation` objects, it will help to understand how Apple has defined the behavior of Synchronous and Asynchronous operations...

*Source:* https://developer.apple.com/documentation/foundation/operation </br>

#### Synchronous Operations

Unlike GCD, `Operation` objects run __*synchronously<sup>1</sup> by default.*__

In a synchronous operation:
- The operation object does not create a separate thread on which to run its task.
- When you call the `start()` method of a synchronous operation directly from your code, the operation executes __*immediately*__ in the __*current thread.*__
- By the time the` start()` method of such an object returns control to the caller, the task itself is complete.

**TIP:** If you always plan to use queues to execute your operations, it is simpler to define them as synchronous.

#### Asynchronous Operations
If you execute operations manually, though, you might want to define your operation objects as asynchronous.<sup>1</sup>

Defining asynchronous operations is useful in cases where you want to ensure that a manually executed operation does not block the calling thread.

An asynchronous operation object:
- Is responsible for scheduling its task on a __*separate*__ thread. The operation could do that by: </br>
&nbsp;&nbsp;&nbsp; - starting a new thread directly </br>
&nbsp;&nbsp;&nbsp; - calling an asynchronous method </br>
&nbsp;&nbsp;&nbsp; - submitting a block to a dispatch queue for execution </br>
- When you call the `start()` method of an asynchronous operation, that method may return before the corresponding task is completed. It does not actually matter if the operation is ongoing when control returns to the caller, only that it could be ongoing.

Defining an asynchronous operation requires more work because you have to monitor the ongoing state of your task and report changes in that state using KVO notifications.

**TIP:** When you add an operation to an operation queue, the queue ignores the value of the `isAsynchronous` property and __*always*__ calls the `start()` method from a separate thread.
- thus, if you always run operations by adding them to an operation queue, there is no reason to make them asynchronous.

> <sup>1</sup> REMEMBER &mdash; Asynchronous and Concurrent do *not* mean the same thing: </br></br>
Serial versus Concurrent is about the __*number of threads*__ available to a queue: </br>
> - __*Serial queues*__ only have a __*single thread*__ associated with them and thus *only allow a single task* to be executed at any given time.
> - __*Concurrent queues*__ can utilize as many threads as the system has available resources for. On a concurrent queue, threads will be created and released as needed. </br>
>
>Synchronous or Asynchronous is about __*waiting*__ &mdash; whether or not the queue on which you run your task has to __*wait*__ for your task to complete before it executes other tasks.
> - you can submit asynchronous (or synchronous) tasks to either a serial queue or a concurrent queue.


### Subclassing the Operation class
The `BlockOperation` class we explored in the previous lesson is handy for simple tasks.  

But for more complex tasks, or to create reusable components, you will need to create your own custom subclasses of the `Operation` class where each subclass instance represents a specific task.

And though the `Operation` class &mdash; and its related pre-defined subclasses (`BlockOperation` and `NSInvocationOperation`) &mdash; provide the *basic* logic to track the execution state of your operation and other Operations benefits, they were designed to be subclassed before they can do any useful work for you.

How you create your subclass depends on whether your operation is designed to execute concurrently or non-concurrently.<sup>1</sup>

**Non-Concurrent Operations** </br>
Non-Concurrent operations perform all of their work on the __*same thread*__, and when the `main()` method returns the operation is moved into the `Finished` state. The queue is then notified of this operation's state and removes the operation from its active pool of operations, freeing resources for the next operation to be executed.

For non-concurrent<sup>1</sup> operations, you typically override only one method:

```Swift  
  func main()
```
<!-- &nbsp;&nbsp;&nbsp;&nbsp; `main()` -->

The `main()` method performs the receiver’s __*non-concurrent*__ task.

The default implementation of this method does nothing; You must override method and place in it the code needed to perform the given task.

*Source:* </br>
https://developer.apple.com/documentation/foundation/operation/1407732-main

__*Things to note*__
- In your implementation, do not invoke `super`.
- Of course, you should also define a custom initialization method to make it easier to create instances of your custom class.
- Optionally, if you do define custom getter and setter methods, you must make sure those methods can be called safely from multiple threads.

__*Example: Non-Concurrent Operation*__

The simple example below shows subclassing `Operation` to create concurrent operation objects and the requirement to override the `main()` method:

```Swift  
  class FilterOperation: Operation {
      let flatigram: Flatigram
      let filter: String

      init(flatigram: Flatigram, filter: String) {
          self.flatigram = flatigram
          self.filter = filter
      }

      override func main() {
          if let filteredImage = self.flatigram.image?.filter(with: filter) {
              self.flatigram.image = filteredImage
          }
      }
  }
```

*Source:* </br>
https://learn.co/lessons/swift-multithreading-lab

**Concurrent Operations** </br>
Concurrent operations can perform some work on a different thread. Thus, returning from the `main()` method can not be used to move the operation into its `Finished` state.

Because of this, when you create a concurrent operation, you are responsible for moving the operation between the `Ready`, `Executing` and `Finished` states.

If you are creating a concurrent operation, you need to override the following methods and properties at a minimum:
- `start()`
- `isAsynchronous`
- `isExecuting`
- `isFinished`

__*The `start()` method*__ <sup>2</sup>
In a concurrent operation, your `start()` method:
- is responsible for starting the operation in an asynchronous manner. Whether you spawn a thread or call an asynchronous function, you do it from this method.

__*The `isAsynchronous` property*__
The `isAsynchronous` property of the `Operation` class tells you whether an operation runs synchronously or asynchronously with respect to the thread in which its `start()` method was called.

By default, this method returns `false`, which means the operation runs synchronously in the calling thread.

__*Note:*__ If you are implementing a concurrent operation, you are not required to override the `main()` method but may do so if you plan to call it from your custom `start() `method.

> <sup>2</sup> The `start()` method has additional responsibilities in a concurrent operation, which we will explore further in upcoming lessons. Same for the `isAsynchronous` property. For further details of both, also see the Apple source referenced below:

*Source:* </br>
https://developer.apple.com/documentation/foundation/operation

__*Example: Concurrent Operation*__

The (elided, non-functioning) code below illustrates the most basic steps needed to subclass `Operation` to create concurrent operation objects:

```Swift  
  class MyConcurrentOperation: Operation {
  override var isAsynchronous: Bool { return true }
  override var isExecuting: Bool { return state == .executing }
  override var isFinished: Bool { return state == .finished }

  ...

  override func start() {
  if self.isCancelled {
  			state = .finished
  		} else {
  			state = .ready
  main()
  		}
  	}
  override func main() {
  if self.isCancelled {
  			state = .finished
  		} else {
  			state = .executing
  		}
  	}
  }
```

## In Class Activity I (30 min)

TODO: create this ...


## Overview/TT II &mdash; OperationQueues (20 min)
The easiest way to execute operations is to use an **operation queue.**

Operation queues are instances of the `OperationQueue` class, and their tasks are encapsulated in concrete instances of the `Operation` class.

You use instances of the `OperationQueue` class to (1) manage the scheduling and execution of an Operation and (2) to set the maximum number of operations that can run simultaneously on a given queue.

```Swift
  class OperationQueue : NSObject
 ```

### How they work

Just as you'd submit a closure of work to a `DispatchQueue` for GCD, instances of the `Operation` class can be submitted to an `OperationQueue` for execution.

This means you can execute tasks concurrently, just like with GCD and `DispatchQueues`, but in an object-oriented fashion.

Though both `OperationQueues` and `DispatchQueues` are high-level abstractions of the queue model built on top of GCD (a low-level C API), `OperationQueues` behave differently from `DispatchQueues` in distinct ways, most notably:

1. **Determining Execution Order** &mdash; Unlike GCD and `DispatchQueues`, `OperationQueues` do *not* strictly conform to First-In-First-Out execution order.

An operation queue acts like a *prioritized FIFO queue*:

- Operations within an operation queue are organized according to their readiness, priority level, and dependencies, and are executed accordingly.

- You can set priority on individual operations. Those with the highest priority get pushed ahead, but not necessarily to the front of the queue &mdash; iOS determines when to actually execute an operation.

- Operations with the *same priority* get executed in the order they were added to the queue &mdash; unless an operation has dependencies, which means you can define that some operations will only be executed after the completion of other operations. *(We'll cover Operation Dependencies in the next class.)*

If all of the queued operations have the same `queuePriority` and are ready to execute when they are put in the queue &mdash; that is, their `isReady` property returns `true` &mdash; they are executed in the order in which they were submitted to the queue. Otherwise, the operation queue always executes the one with the highest priority relative to the other ready operations.

> __*Important Note:*__ Because changes in the readiness of an operation can change the resulting execution order, your code should never rely on the 'queue semantics" to ensure a specific execution order of operations.

2. **No Serial Queues** &mdash; By default, all `OperationQueues` operate concurrently; you *cannot* change their type to *serial* (thought there is a way to execute tasks in operation queues sequentially: by using dependencies between operations).

3. **Developer Control** &mdash; As a developer, you can:

- set the `maxConcurrentOperationCount` for an operation queue

- `cancel` an operation, even if the operation is currently executing

- control how much of the system resources will be given to your operation by setting `qualityOfService` property

- set the priority of your operations by setting your `queuePriority` property of the operation.









An operation queue executes its queued Operation objects based on their priority and readiness. After being added to an operation queue, an operation remains in its queue until it reports that it is finished with its task. You can’t directly remove an operation from a queue after it has been added.


Operation queues retain operations until they're finished, and queues themselves are retained until all operations are finished.

> Suspending an operation queue with operations that aren't finished can result in a memory leak.


Operation queues use the `Dispatch` framework to initiate the execution of their operations. As a result, operations are always executed on a separate thread, regardless of whether they are designated as synchronous or asynchronous. (Thread safe)





### Creating OperationQueues


OperationQueue allows you to add work in three separate ways:
• Pass an Operation.
• Pass a closure.
• Pass an array of Operations.
<!-- To create a queue, you allocate it in your application as you would any other object: -->



### Adding Operations to OperationQueues


<!-- TODO: method 1 addOperation: method -->


<!-- TODO: method 2 -- addOperations:waitUntilFinished: method -->


<!-- TODO: method 3 -- addOperationWithBlock: method -->





<!-- from ray w:

Operations are fully-functional classes that can be submitted to an OperationQueue, just like you'd submit a closure of work to a DispatchQueue for GCD. Because they're classes and can contain variables, you gain the ability to know what state the operation is in at any given point.
 -->

<!--
the OperationQueue class is what you use to manage the scheduling of an Operation and the maximum number of operations that can run simultaneously.


OperationQueue allows you to add work in three separate ways:
• Pass an Operation.
• Pass a closure.
• Pass an array of Operations. -->



<!-- TODO:  

- list priority levels
 -->

## After Class

1. Research:
- [`start()` - Apple docs](https://developer.apple.com/documentation/foundation/operation/1416837-start)
- [Dependencies - Apple docs](https://developer.apple.com/documentation/foundation/operation/1416668-dependencies)
-


## In Class Activity II (optional) (30 min)

## Wrap Up (5 min)

- Continue working on your current tutorial
- Complete reading
- Complete challenges

## Additional Resources

1. [Operation - Apple docs](https://developer.apple.com/documentation/foundation/operation)
2. [OperationQueue - Apple docs](https://developer.apple.com/documentation/foundation/operationqueue)
3. [maxConcurrentOperationCount - Apple docs](https://developer.apple.com/documentation/foundation/operationqueue/1414982-maxconcurrentoperationcount)
4. []()

https://www.raywenderlich.com/5293-operation-and-operationqueue-tutorial-in-swift

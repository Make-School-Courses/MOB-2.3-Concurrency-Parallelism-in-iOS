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

- Funny comic
- Prime the Pump (e.g. think and jot, think pair share, etc)
- Productivity Tip/Tool
- Review of current event (e.g. tech news relevant to your track/topic)
- Quiz on homework or topic(s) of past class
- Concept Test


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


### Asynchronous Versus Synchronous Operations


### Subclassing the Operation class


The `BlockOperation` class we explored in the previous lesson is handy for simple tasks.  

But for more complex tasks, or to create reusable components, you will need to create your own custom subclasses of the `Operation` class where each subclass instance represents a specific task.

And though the `Operation` class &mdash; and its related pre-defined subclasses (`BlockOperation` and `NSInvocationOperation`) &mdash; provide the *basic* logic to track the execution state of your operation and other Operations benefits, they were designed to be subclassed before they can do any useful work for you.

How you create your subclass depends on whether your operation is designed to execute concurrently or non-concurrently.<sup>1</sup>


<!-- Unlike GCD, an operation is run synchronously by default, and getting it to run asynchronously requires more work.  -->



**Non-Concurrent Operations** </br>
For non-concurrent<sup>1</sup> operations, you typically override only one method:

```Swift  
  func main()
```
<!-- &nbsp;&nbsp;&nbsp;&nbsp; `main()` -->

The `main()` function performs the receiver’s __*non-concurrent*__ task.

The default implementation of this method does nothing; You must override method and place in it the code needed to perform the given task.


### Things to note
- In your implementation, do not invoke `super`.
- Of course, you should also define a custom initialization method to make it easier to create instances of your custom class.
- Optionally, if you do define custom getter and setter methods, you must make sure those methods can be called safely from multiple threads.

**Concurrent Operations** </br>

The `isAsynchronous` method of the `Operation` class tells you whether an operation runs synchronously or asynchronously with respect to the thread in which its start method was called. By default, this method returns `false`, which means the operation runs synchronously in the calling thread.


If you are implementing a concurrent operation, you are not required to override the `main()` method but may do so if you plan to call it from your custom `start() `method.


<sup>1</sup> REMEMBER: As discussed earlier, asynchronous does not mean concurrent:


<!--
just because your tasks are asynchronous doesn't mean they will run concurrently. You're actually able to submit asynchronous tasks to either a serial queue or a concurrent queue. Being synchronous or asynchronous simply identifies whether or not the queue on which you're running the task must wait for the task to complete before it can spawn the next task.
On the other hand, categorizing something as serial versus concurrent identifies whether the queue has a single thread or multiple threads available to it. If you think about it, submitting three asynchronous tasks to a serial queue means that each task has to completely finish before the next task is able to start as there is only one thread available.
In other words, a task being synchronous or not speaks to the source of the task. Being serial or concurrent speaks to the destination of the task. -->

*Source:* </br>
https://developer.apple.com/documentation/foundation/operation/1407732-main




<!-- from ray w:

Operations are fully-functional classes that can be submitted to an OperationQueue, just like you'd submit a closure of work to a DispatchQueue for GCD. Because they're classes and can contain variables, you gain the ability to know what state the operation is in at any given point.
 -->




 <!-- TODO:  describe PROPERTIES and - methods to override

 You can override main or start method, main is less flexible but manages state of the operation for you (e.g assumes when main returns its finished), with start you have to do that manually.

 3 Booleans, Finished, Cancelled, Ready

 Finished completion block is called when operation is done

  -->






## In Class Activity I (30 min)

TODO: create this ...


## Overview/TT II &mdash; OperationQueues (20 min)

Operation queues are instances of the `OperationQueue` class, and its tasks are encapsulated in instances of `Operation`.

Just as you'd submit a closure of work to a `DispatchQueue` for GCD, instances of the `Operation` class can be submitted to an `OperationQueue` for execution.


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
-


## In Class Activity II (optional) (30 min)

## Wrap Up (5 min)

- Continue working on your current tutorial
- Complete reading
- Complete challenges

## Additional Resources

1. Links to additional readings and videos

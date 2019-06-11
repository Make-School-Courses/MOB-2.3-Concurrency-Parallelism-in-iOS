# Operations (Part 2)

## Minute-by-Minute [OPTIONAL]

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

## Initial Exercise (15 min)

- Funny comic
- Prime the Pump (e.g. think and jot, think pair share, etc)
- Productivity Tip/Tool
- Review of current event (e.g. tech news relevant to your track/topic)
- Quiz on homework or topic(s) of past class
- Concept Test

## Overview/TT I (20 min)





### How to implement Operation objects
The `Operation` class &mdash; and its related system-defined subclasses (`BlockOperation` and `NSInvocationOperation`) &mdash; provide the *basic* logic to track the execution state of your operation.

But they were designed to be subclassed before they can do any useful work for you.


Just as you'd submit a closure of work to a `DispatchQueue` for GCD, instance of the `Operation` class can be submitted to an `OperationQueue` for execution.


<!-- Each subclass represents a specific task  -->



<!-- from ray w:

Operations are fully-functional classes that can be submitted to an OperationQueue, just like you'd submit a closure of work to a DispatchQueue for GCD. Because they're classes and can contain variables, you gain the ability to know what state the operation is in at any given point.
 -->




How you create your subclass depends on whether your operation is designed to execute concurrently or non-concurrently.

**Non-Concurrent Operations** </br>
For non-concurrent operations, you typically override only one method:
&nbsp;&nbsp;&nbsp;&nbsp; `main()`

Into this method, you place the code needed to perform the given task.

Of course, you should also define a custom initialization method to make it easier to create instances of your custom class. You might also want to define getter and setter methods to access the data from the operation. However, if you do define custom getter and setter methods, you must make sure those methods can be called safely from multiple threads.



**Concurrent Operations** </br>

The `isAsynchronous` method of the `Operation` class tells you whether an operation runs synchronously or asynchronously with respect to the thread in which its start method was called. By default, this method returns `false`, which means the operation runs synchronously in the calling thread.



> REMEMBER: As discussed earlier,







<!-- TODO:  describe PROPERTIES and - methods to override

You can override main or start method, main is less flexible but manages state of the operation for you (e.g assumes when main returns its finished), with start you have to do that manually.

3 Booleans, Finished, Cancelled, Ready

Finished completion block is called when operation is done

 -->








<!-- TODO:  
- list states
- list priority levels
 -->




<!-- OUTLINE?
What are they?

Why use them? benefits

How they work

White board

Syntax examples

dependencies

BlockOperation

Compared to GCD... when to use them

  examples from Ray W:
  operations allow for the handling of more complex scenarios such as reusable code to be run on a background thread, having one thread depend on another, and even canceling an operation before it's started or completed.

  GCD is great for common tasks that need to be run a single time in the background. When you find yourself building functionality that should be reusable — such as image editing operations — you will likely want to encapsulate that functionality into a class. By subclassing Operation, you can accomplish that goal!

-->



## In Class Activity I (30 min)

- I do, We do, You do
- Reading & Discussion Questions in small groups
- Draw a picture/diagram
- Complete Challenges solo or in pair
- Q&A about tutorials
- Pair up and code review
- Pair program
- Formative assessment
- Form into groups
- etc (get creative :D)

## Overview/TT II (optional) (20 min)

## In Class Activity II (optional) (30 min)

## Wrap Up (5 min)

- Continue working on your current tutorial
- Complete reading
- Complete challenges

## Additional Resources

1. Links to additional readings and videos

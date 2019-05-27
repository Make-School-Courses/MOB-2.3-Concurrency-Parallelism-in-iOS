# Grand Central Dispatch

<!-- INSTRUCTOR Notes:
1) xxx -->

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

1. Identify and describe
1. Define
1. Design
1. Implement

## Initial Exercise (15 min)




<!-- TODO: should this be a quiz? on research topics from last After Class? ...or use the playground exercise from prior lesson plans -->

<!-- TODO: quiz questions:
- from last class material
from assigned research
 -->



<!-- - Funny comic
- Prime the Pump (e.g. think and jot, think pair share, etc)
- Productivity Tip/Tool
- Review of current event (e.g. tech news relevant to your track/topic)
- Quiz on homework or topic(s) of past class
- Concept Test -->

## Overview/TT I (20 min)


GCD vs Operations

Dispatch Queues

FIFO

Serial / Concurrent

QoS Priority

Default Queues

Custom Queues

Main Queue

Sync vs async

### GCD vs Operations

In Lesson 1, we mentioned that Apple provides two built-in APIs to handle Concurrency:

- Grand Central Dispatch (GCD)
- Operations

<!-- > We will Operations in upcoming lessons. We will also learn about the differences between GCD and Operations, as well as when to choose one API over the other... -->


which to use? In general, GCD is good to use for simple jobs/tasks, Operations make it easier to do complex jobs/tasks. <complex? the amount of communication between tasks and how closely you want to monitor execution >

Operations are objects that encapsulate data and functionality.

In GCD, you are working with functions.


< How iOS uses GCD - other platforms use x (which was supposed to be in Swift 5, but deferred) >



<!-- TODO: add note about SWift 5 and XXX/Await -- also add this as Research item after class -->


<!-- ### What is GCD?

< GCD is named after Grand Central Station...


### why use it? What does it do?

< purpose -- queues > -->




### What does it do?

GCD works by allowing specific __*tasks*__ in a program that can be run in parallel to be __*queued up*__ for execution and, depending on availability of processing resources, __*scheduling*__ them to execute on any of the available processor cores (referred to as "routing" by Apple). <sup>2</sup>

GCD abstracts the notion of threads, and exposes dispatch queues to handle work items (work items are blocks of code that you want to execute). These tasks are assigned to a dispatch queue, which processes them in a First-In-First-Out (FIFO) order.

At the core of GCD is the idea of work items, which can be dispatched to a queue; the queue hides all thread management related tasks. You can configure the queue, but you won’t interact directly with a thread. This model simplifies the creation and the execution of asynchronous or synchronous tasks.





*Sources:* </br>
-
-


<!-- TODO: move these ideas to next lesson, if not used here... -->
<!-- Most modern programming languages provide for some form of concurrency and Swift is of course no exception. Different languages use widely different mechanisms for handling concurrency. C# and Typescript, for example use an async/await pattern, whereas Swift uses closures to handle what runs on another thread. Swift 5 originally had plans to implement the more common async/await pattern but it was removed from the specification until the next release. -->

<!--
There are two APIs that you'll use when making your app concurrent: Grand Central Dispatch, commonly referred to as GCD, and Operations. These are neither competing technologies nor something that you have to exclusively pick between. In fact, Operations are built on top of GCD!


GCD is Apple's implementation of C's libdispatch library. Its purpose is to queue up tasks — either a method or a closure — that can be run in parallel, depending on availability of resources; it then executes the tasks on an available processor core.
While GCD uses threads in its implementation, you, as the developer, do not need to worry about managing them yourself. GCD's tasks are so lightweight to enqueue that Apple, in its 2009 technical brief on GCD, stated that only 15 instructions are required for implementation, whereas creating traditional threads could require several hundred instructions. -->



### Why use GCD?

- GCD's design improves simplicity, portability and performance.

- It can help you improve your app’s responsiveness by deferring computationally expensive tasks from the foreground (`main` thread) to the background (non-UI threads).

- It’s an easier concurrency model to work with than locks and threads.

#### Threads & Tasks in GCD


Grand Central Dispatch still uses threads at the low level but abstracts them away from the programmer, who will not need to be concerned with as many details.


The way you work with threads is by creating a DispatchQueue. When you create a queue, the OS will potentially create and assign one or more threads to the queue. If existing threads are available, they can be reused; if not, then the OS will create them as necessary.

Thread Pool
<!-- Instead of creating a new thread whenever a task is to be executed (and then destroying it when the task finishes), available threads are taken from the thread pool. Thread creation and destruction is an expensive process, so the thread pool pattern offers considerable performance gains. Letting the library or operating system manage the threads means that you have less to worry about (read: fewer lines of code to write). Besides, the library can optimize the thread management behind the scenes. -->

Tasks in GCD are lightweight to create and queue; Apple states that 15 instructions are required to queue up a work unit in GCD, while creating a traditional thread could easily require several hundred instructions. <sup>2</sup>


A task can be expressed either as a function or as a "block."[14] Blocks are an extension to the syntax of C, C++, and Objective-C programming languages that encapsulate code and data into a single object in a way similar to a closure.[11] GCD can still be used in environments where blocks are not available.[15]

A task in Grand Central Dispatch can be used either to create a work item that is placed in a queue or assign it to an event source. If a task is assigned to an event source, then a work unit is made from the block or function when the event triggers, and the work unit is placed in an appropriate queue. This is described by Apple as more efficient than creating a thread whose sole purpose is to wait on a single event triggering.


< closures and blocks >



### Dispatch Queues

DispatchQueue
An object that manages the execution of tasks serially or concurrently on your app's main thread or on a background thread.



Dispatch Queues are objects that maintain a queue of tasks, either anonymous code blocks or functions, and execute these tasks in their turn. The library automatically creates several queues with different priority levels that execute several tasks concurrently, selecting the optimal number of tasks to run based on the operating environment. A client to the library may also create any number of serial queues, which execute tasks in the order they are submitted, one at a time.[12] Because a serial queue can only run one task at a time, each task submitted to the queue is critical with regard to the other tasks on the queue, and thus a serial queue can be used instead of a lock on a contended resource.


#### FIFO


#### serial queues


#### concurrent queues

	- requires QoS Priority

##### QoS levels


#### Default Queues


#### Custom Queues


### The Main queue




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

### Sync vs async


#### Calling Sync on Current Queue

< never call Sync on main queue >



## In Class Activity II (optional) (30 min)

<!-- TODO: create this...is there a suitable playground from prior lesson?
- set up a situation where students call sync on current queue
 -->



## After Class
1. Research:
-
2. Assignment:
-
<!-- TODO: have students to the Ray W tute on Concurrency -->



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

8. [Grand_Central_Dispatch - wikipedia](https://en.wikipedia.org/wiki/Grand_Central_Dispatch) <sup>2</sup>

https://en.wikipedia.org/wiki/Async/await

https://en.wikipedia.org/wiki/Coroutine

https://gist.github.com/lattner/429b9070918248274f25b714dcfc7619

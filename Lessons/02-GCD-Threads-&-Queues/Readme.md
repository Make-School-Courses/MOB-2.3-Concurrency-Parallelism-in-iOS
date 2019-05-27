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

### Topics for this Session

- GCD vs Operations
- Dispatch Queues
- FIFO
- Serial vs Concurrent
- QoS Priorities
- Default Queues
- Custom Queues
- The Main Queue
- Synchronous vs Asynchronous

### GCD and Operations (cont'd)

In Lesson 1, we introduced the two Apple-provided APIs you use in iOS to manage concurrent tasks *without* working with threads *directly*: **Grand Central Dispatch (GCD)** and **Operations.**

Before we dive deeper into GCD, let's quickly compare the two to begin your understanding of when and how to use them:


|  | Grand_Central_Dispatch | Operations |
| ------------- | ------------- | ------------- |
|  			| A *lightweight* way to represent units of work that are going to be executed concurrently. GCD **uses closures** to handle what runs on another thread. |  Operations are **objects** that encapsulate data and functionality.  |
| **Developer Control**	| You don’t schedule these units of work; the system takes care of scheduling for you. Adding dependencies, cancelling or suspending code blocks is labor intensive | you can add dependency among various operations and re-use, cancel or suspend them.  |
| **When to Use** 			| GCD is good to use for simple, common tasks that need to be run only once and in the background. |   |



**Grand Central Dispatch (GCD)**

a lightweight way to represent units of work that are going to be executed concurrently.
<!-- Uses functions/closures to handle what runs on another thread. -->

<!-- You don’t schedule these units of work; the system takes care of scheduling for you. -->

Adding dependency among blocks can be a headache. Canceling or suspending a block creates extra work for you as a developer!



<!-- In general, GCD is good to use for simple jobs/tasks,

GCD is great for common tasks that need to be run a single time in the background. -->



 **Operations.**

 <!-- Operations are objects that encapsulate data and functionality. -->


Operation adds a little extra overhead compared to GCD, but you can add dependency among various operations and re-use, cancel or suspend them.


Operations make it easier to do complex jobs/tasks. <complex? the amount of communication between tasks and how closely you want to monitor execution >





<!-- > We will Operations in upcoming lessons. We will also learn about the differences between GCD and Operations, as well as when to choose one API over the other... -->


which to use?







< How iOS uses GCD - other platforms use x (which was supposed to be in Swift 5, but deferred) >



<!-- TODO: add note about SWift 5 and XXX/Await -- also add this as Research item after class -->


<!-- ### What is GCD?

< GCD is named after Grand Central Station...


### why use it? What does it do?

< purpose -- queues > -->

highest-level of abstraction...

most developers use a combination of both

since operations are built on GCD, it is important to know GCD first...

> *Note: Where Swift uses closures (functions) to handle the code that runs on another thread, C#, Typescript, Python, JavaScript and other languages use the the more common Async/Await pattern. The original plans for Swift 5.0 included adding the Async/Await pattern, but this was removed from the Swift specification until some future release.*




### What does it do?

GCD works by allowing specific __*tasks*__ in a program that can be run in parallel to be __*queued up*__ for execution and, depending on availability of processing resources, __*scheduling*__ them to execute on any of the available processor cores (referred to as "routing" by Apple). <sup>2</sup>

GCD abstracts the notion of threads, and exposes dispatch queues to handle work items (work items are blocks of code that you want to execute). These tasks are assigned to a dispatch queue, which processes them in a First-In-First-Out (FIFO) order.

At the core of GCD is the idea of work items, which can be dispatched to a queue; the queue hides all thread management related tasks. You can configure the queue, but you won’t interact directly with a thread. This model simplifies the creation and the execution of asynchronous or synchronous tasks.





*Sources:* </br>
-
-


<!-- TODO: move these ideas to next lesson, if not used here... -->

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

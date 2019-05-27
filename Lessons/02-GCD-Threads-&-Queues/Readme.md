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


|  Grand_Central_Dispatch | Operations |
| ------------- | ------------- |
| A *lightweight* way to represent units of work that are going to be executed concurrently. GCD uses **closures** to handle what runs on another thread. |  Operations are **objects** that encapsulate data and functionality. Operations add a little *extra development overhead* compared to GCD. |
| The system takes care of scheduling for you. Adding dependencies, cancelling or suspending code blocks is labor intensive | Allow for greater control over the submitted tasks, including some control over scheduling through adding dependencies among various operations and can re-use, cancel or suspend them.  |
| GCD is good to use for simple, common tasks that need to be run only once and in the background. |  Operations make it easier to do complex tasks. Use them when you need (a) task reusability, (b) considerable communication between tasks, or (c) to closely monitor task execution. |

Apple recommends using the API with the "highest-level of abstraction" (which is Operations), though most developers use a combination of both APIs.

And because Operations are build on top of GCD, it is important to the lower-level API first...

> *Note: Where Swift uses closures (functions) to handle the code that runs on another thread, C#, Typescript, Python, JavaScript and other languages use the the more common Async/Await pattern. The original plans for Swift 5.0 included adding the Async/Await pattern, but this was removed from the Swift specification until some future release.*

### Why use GCD?

GCD's design improves simplicity, portability and performance.

- It can help you __*improve your app’s responsiveness*__ by deferring computationally expensive tasks from the foreground (`main` thread) to the background (non-UI threads).

- It __*simplifies__* the creation and the execution of asynchronous or synchronous tasks.

- It’s a concurrency model that is __*much easier to work with__* than locks and threads.

Though GCD still uses threads in its implementation, developers do not have to manage threads themselves.

GCD's tasks are so lightweight to enqueue that Apple, in its 2009 technical brief on GCD, stated that "only 15 instructions are required for implementation, whereas creating traditional threads could require several hundred instructions." <sup>1</sup>

### What does GCD do?

GCD is Apple's implementation of C's `libdispatch` library. It runs directly in the UNIX layer of iOS.

<!-- Its purpose is to queue up tasks — either a function or a closure — that can be run in parallel, depending on availability of resources; it then executes the tasks on an available processor core. -->

GCD works by allowing specific __*tasks*__ &mdash; functions or closures &mdash; that can be run in parallel to be __*queued up*__ for execution and, depending on availability of processing resources, __*schedule*__ them to execute on any of the available processor cores (referred to as "routing" by Apple). <sup>1</sup>

GCD abstracts the notion of threads, and exposes __*dispatch queues*__ to handle __*work items*__ (*work items* are blocks <sup>2</sup> of code that you want to execute). These tasks are assigned (dispatched) to a dispatch queue, which processes them in a __*First-In-First-Out (FIFO)*__ order.

> <sup>2</sup> Note: Apple's documentation sometimes refers to a `block` in lieu of a `closure` because `block` was the name used in Objective-C. In the context of concurrency in iOS, you can consider `block` and `closure` interchangeable> [action]

*Sources include:* </br>
- wikipedia
- Apple docs

#### Threads, Tasks & DispatchQueues in GCD

Grand Central Dispatch still uses threads at a low level but abstracts them away from the developer.

You work with threads by creating `DispatchQueues`.




DispatchQueue
An object that manages the execution of tasks serially or concurrently on your app's main thread or on a background thread.



the queue hides all thread management related tasks. You can configure the queue, but you won’t interact directly with a thread.



Dispatch Queues are objects that maintain a queue of tasks, either anonymous code blocks or functions, and execute these tasks in their turn.


When you create a queue, the OS will potentially create and assign one or more threads to the queue. If existing threads are available, they can be reused; if not, then the OS will create them as necessary.

**Thread Pools**
Thread creation and destruction are expensive processes. Instead of creating a new thread whenever a task is to be executed, then destroying it when the task finishes, available threads are taken from a thread pool.

Allowing the `libdispatch` library and the operating system to manage threads means developers have much fewer lines of code to write and less to debug; and the library can optimize thread management behind the scenes much better than a developer could.



**Thread Pools**

<!-- Tasks in GCD are lightweight to create and queue; Apple states that 15 instructions are required to queue up a work unit in GCD, while creating a traditional thread could easily require several hundred instructions. <sup>2</sup> -->


**Tasks**
encapsulate code and data into a single object in


A task can be expressed either as a function or as a "block."

Blocks are an extension to the syntax of C, C++, and Objective-C programming languages that encapsulate code and data into a single object in a way similar to a closure.[11] GCD can still be used in environments where blocks are not available.[15]


A task in Grand Central Dispatch can be used either to create a work item that is placed in a queue or assign it to an event source. If a task is assigned to an event source, then a work unit is made from the block or function when the event triggers, and the work unit is placed in an appropriate queue. This is described by Apple as more efficient than creating a thread whose sole purpose is to wait on a single event triggering.






#### FIFO


#### serial queues

The library automatically creates several queues with different priority levels that execute several tasks concurrently, selecting the optimal number of tasks to run based on the operating environment.

A client to the library may also create any number of serial queues, which execute tasks in the order they are submitted, one at a time.[12] Because a serial queue can only run one task at a time, each task submitted to the queue is critical with regard to the other tasks on the queue, and thus a serial queue can be used instead of a lock on a contended resource.

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
2. [Grand_Central_Dispatch - wikipedia](https://en.wikipedia.org/wiki/Grand_Central_Dispatch) <sup>1</sup>
3. [Async/await - wikipedia](https://en.wikipedia.org/wiki/Async/await)
4. [Coroutine - wikipedia](https://en.wikipedia.org/wiki/Coroutine)
5. []()

8.




https://gist.github.com/lattner/429b9070918248274f25b714dcfc7619

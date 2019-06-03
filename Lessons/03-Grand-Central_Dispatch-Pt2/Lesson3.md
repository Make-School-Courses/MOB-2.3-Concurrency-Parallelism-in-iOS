# Grand Central Dispatch (Part 2)

<!-- INSTRUCTOR Notes:

1) for initial exercise...

2) xxxx
 -->

## Minute-by-Minute

| **Elapsed** | **Time**  | **Activity**              |
| ----------- | --------- | ------------------------- |
| 0:00        | 0:05      | Objectives                |
| 0:05        | 0:15      | Overview                  |
| 0:20        | 0:45      | In Class Activity I       |
| 1:05        | 0:10      | BREAK                     |
| 1:15        | 0:45      | In Class Activity II      |
| TOTAL       | 2:00      |                           |

## Why you should know this or industry application (optional) (5 min)

Explain why students should care to learn the material presented in this class.

## Learning Objectives (5 min)

1. Identify and describe
1. Define
1. Design
1. Implement

## Initial Exercise (15 min)


<!-- REVIEW OF SYNC AND ASYNC FRM LAST CLASS?
In synchronous execution by sync method the current thread waits until the task finished before the method call returns. In asynchronous execution by async method, the method call returns immediately. Never call sync method in the main queue which will cause deadlock of the app. -->


<!-- Asynchronous tasks are started by one thread but actually run on a different thread, taking advantage of additional processor resources to finish their work more quickly. (from Apple ) -->


<!-- When NOT to use synchronous

when to use sync  -->


<!-- A synchronous function returns control to the caller after the task is completed.
An asynchronous function returns control to the caller immediately, ordering the task to be done but not waiting for it.
Thus, an asynchronous function does not block the current thread of execution from proceeding on to the next function. -->




## Overview/TT I (20 min)


#### Serial Queues




<!-- A client to the library may also create any number of serial queues, which execute tasks in the order they are submitted, one at a time. -->

Because a serial queue can only run one task at a time, each task submitted to the queue is critical with regard to the other tasks on the queue, and thus a serial queue can be used instead of a lock on a contended resource.



Serial queues only have a single thread associated with them and thus only allow a single task to be executed at any given time.


<!-- TODO: note that main queue is a serial queue  -->
<!-- When your app launches, the system automatically creates a serial queue and binds it to the application’s main thread. All UI tasks have to be run on the main thread. -->
<!-- When user runs app, the system automatically creates a serial dispatch queue which runs app’s main thread. This is called main queue, and task assigned in this queue works one at a time serially. To access in the code:

let mainQueue   = DispatchQueue.main -->

<!-- TODO: insert graphic here -->


<!-- TODO: insert code showing how to create a default (serial) queue -->


<!-- TODO: insert code showing how to create a concurrent queue -->


#### concurrent queues

 A concurrent queue, on the other hand, is able to utilize as many threads as the system has resources for. Threads will be created and released as necessary on a concurrent queue.


	- requires QoS Priority




<!-- from Ray W --  Note: While you can tell iOS that you'd like to use a concurrent queue, remember that there is no guarantee that more than one task will run at a time. If your iOS device is completely bogged down and your app is competing for resources, it may only be capable of running a single task. -->

<!-- TODO: insert graphic here -->

-- Asynchronous doesn't mean concurrent


<!-- from Ray W --  
While the difference seems subtle at first, just because your tasks are asynchronous doesn't mean they will run concurrently. You're actually able to submit asynchronous tasks to either a serial queue or a concurrent queue. Being synchronous or asynchronous simply identifies whether or not the queue on which you're running the task must wait for the task to complete before it can spawn the next task.

On the other hand, categorizing something as serial versus concurrent identifies whether the queue has a single thread or multiple threads available to it. If you think about it, submitting three asynchronous tasks to a serial queue means that each task has to completely finish before the next task is able to start as there is only one thread available.

In other words, a task being synchronous or not speaks to the source of the task.

Being serial or concurrent speaks to the destination of the task.
-->

##### QoS levels


The library automatically creates several queues with different priority levels that execute several tasks concurrently, selecting the optimal number of tasks to run based on the operating environment.

Concurrent queues are so common that Apple has provided six different global concurrent queues, depending on the Quality of service (QoS) the queue should have.

<!-- TODO: insert table here -->



#### Default Queues


#### Custom Queues




Another way that apps consume too many threads is by creating too many private concurrent dispatch queues. Because each dispatch queue consumes thread resources, creating additional concurrent dispatch queues exacerbates the thread consumption problem. Instead of creating private concurrent queues, submit tasks to one of the global concurrent dispatch queues. For serial tasks, set the target of your serial queue to one of the global concurrent queues. That way, you can maintain the serialized behavior of the queue while minimizing the number of separate queues creating threads.

https://developer.apple.com/documentation/dispatch/dispatchqueue


<!-- TODO: Ask questions:
- what would happen if the system (a) runs out of threads, and/or (b) creating too many queues? (hint: are queues limited by cores?)
 -->


 > Note &mdash; When designing tasks for concurrent execution, do not call methods that block the current thread of execution. When a task scheduled by a concurrent dispatch queue blocks a thread, the system creates additional threads to run other queued concurrent tasks. If too many tasks block, the system may run out of threads for your app.

 https://developer.apple.com/documentation/dispatch/dispatchqueue




<!-- TODO: introduce Thread Explosion? -->
 <!-- Many workitems submitted to global concurrent queue
 If workitems block, more threads will be created
 May lead to thread explosion -->


<!-- TODO: Async does NOT mean concurrent -->



## In Class Activity I (30 min)




## Overview/TT II (optional) (20 min)

## In Class Activity II (optional) (30 min)

## After Class
1. Research:
-
2. Assignment:
-

<!-- TODO: do Ray W tutorial? -->



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


https://developer.apple.com/videos/play/wwdc2017/706/

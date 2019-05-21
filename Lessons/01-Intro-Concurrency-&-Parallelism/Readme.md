# Concurrency & Parallelism

## Minute-by-Minute [OPTIONAL]

| **Elapsed** | **Time**  | **Activity**              |
| ----------- | --------- | ------------------------- |
| 0:00        | 0:05      | Objectives                |
| 0:05        | 0:15      | Overview                  |
| 0:20        | 0:45      | In Class Activity I       |
| 1:05        | 0:10      | BREAK                     |
| 1:15        | 0:45      | In Class Activity II      |
| TOTAL       | 2:00      |                           |

## Why you should know this (5 min)

> Why do apps need concurrent activities?

&nbsp;&nbsp;&nbsp;&nbsp;- To keep the UI responsive.

When you create a new iOS app, the app acquires its `main` thread. That `main` thread is responsible for running all of the code that powers the app's user interface.

As you add code on your `main` thread that performs large items of non-UI work &mdash; such as image processing or fetching and transforming data  &mdash; you will find that your UI's performance suffers drastically.

Your user interface will slow down, or maybe even stop entirely.

A common example:
- A table view that will not scroll properly while the app is downloading and transforming images; multiple "busy" indicators are displayed instead of expected images.

The concept of __*Concurrency*__ in iOS is about how to structure your app to avoid such UI performance issues by directing  slow, non-UI tasks to run somewhere other than on the UI thread (aka, the `main` thread).

Concurrency issues loom large in any list of the top mistakes made by iOS developers. They are also the underlying cause of the majority of negative app reviews.

Thus it is not surprising that questions on iOS concurrency are now a standard part of the technical interview process for iOS development jobs.

## Learning Objectives (5 min)

<!-- 1. Identify and describe
1. Define
1. Design
1. Implement -->

## Initial Exercise (15 min)

<!-- - Funny comic
- Prime the Pump (e.g. think and jot, think pair share, etc)
- Productivity Tip/Tool
- Review of current event (e.g. tech news relevant to your track/topic)
- Quiz on homework or topic(s) of past class
- Concept Test -->

## Overview/TT I (20 min)

### Terms & Concepts

We will cover in this course...

- Process
- Thread
- Task
- Multi-Core Systems
- Concurrency
- Parallelism
- Queues (Serial, Concurrent)
- Synchronous vs Asynchronous
- Grand Central Dispatch (GCD)
- Background Tasks
- Quality of Service (QoS)
- Operations
- Dispatch Groups
- Semaphores
- Debugging in Xcode
- Unit Testing & Concurrency

### Challenges

- Deadlocks
- Race Conditions
- Readers-Writers Problem
- Thread Explosions
- Priority Inversion

### Anatomy of an iOS app

#### VMs, Processes, & threads


<!-- - Why learn this?
- Industry examples of usage
- Best practices
- Personal anecdote -->

## In Class Activity I (30 min)

< Movie Theatre game? >

<!-- - I do, We do, You do
- Reading & Discussion Questions in small groups
- Draw a picture/diagram
- Complete Challenges solo or in pair
- Q&A about tutorials
- Pair up and code review
- Pair program
- Formative assessment
- Form into groups
- etc (get creative :D) -->

## Overview/TT II (optional) (20 min)

### Evolution / History

### Concurrency

< on a device with only 1 cpu, this means the OS is "context switching" (aka, "time slicing") between multiple tasks >


### Parallelism


### Processors / Cores

iPhones and iPads have been dual-core since 2011...

- How many cores on an iPhone?

#### queues & tasks

where to tasks run?

Tasks run on threads.
- The UI runs on the Main thread
- The System creates other threads for its own tasks. Your app can use these threads...or create its own threads.


### How to use concurrency?

by structuring apps so that some tasks can run at the same time,

tasks that can run at same time:
- tasks that access different resources
- tasks that only read values


- tasks that modify the same resource must not run at the same time, unless the resource is `threadsafe` (we'll cover thread safety later in the course)






<!-- Performance. Responsiveness. They're not sexy tasks. When done properly, nobody is going to thank you. When done incorrectly, app retention is going to suffer and you'll be dinged during your next yearly performance review.
There are a multitude of ways in which an app can be optimized for speed, performance and overall responsiveness. This book will focus on the topic of concurrency. -->

<!-- your app runs as smoothly as possible and that the end user is not ever forced to wait for something to happen. A second is a minuscule amount of time for most everything not related to a computer. However, if a human has to wait a
 raywenderlich.com 15
Concurrency by Tutorials Chapter 1: Introduction second to see a response after taking an action on a device like an iPhone, it feels like
an eternity. "It's too slow" is one of the main contributors to your app being uninstalled. -->

<!-- Scrolling through a table of images is one of the more common situations wherein the end user will be impacted by the lack of concurrency. If you need to download an image from the network, or perform some type of image processing before displaying it, the scrolling will stutter and you'll be forced to display multiple "busy" indicators instead of the expected image. -->



## In Class Activity II (optional) (30 min)

< ? >

## After Class
1. Research:
-
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

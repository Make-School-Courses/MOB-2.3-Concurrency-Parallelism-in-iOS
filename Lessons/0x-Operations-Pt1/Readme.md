# Operations (Part 1)

## Minute-by-Minute

| **Elapsed** | **Time**  | **Activity**              |
| ----------- | --------- | ------------------------- |
| 0:00        | 0:05      | Objectives                |
| 0:05        | 0:20      | Intro to Operations (TT I)                  |
| 0:20        | 0:45      | In Class Activity I       |
| 1:05        | 0:10      | BREAK                     |
| 1:15        | 0:45      | In Class Activity II      |
| TOTAL       | 2:00      |                           |

## Why you should know this

From the start of this course, we've called out that Grand Central Dispatch (GCD) and Operations are the two built-in APIs from Apple that you use in iOS to manage concurrent tasks (as opposed to working with threads directly).

We have also mentioned that...

- Both technologies are designed to encapsulate units of work and dispatch them for execution.
- Operations are build on top of GCD.
- Apple advises developers to use the highest level of abstraction that is available (which is Operations).
- Most developers implement a combination of GCD and Operations, depending on which suits their specific requirements.

But Operations are not without their own challenges and pitfalls.

As a developer, you need to know:

- The benefits Operations offer &mdash; as well as their challenges and pitfalls.
- The differences between GCD and Operations.
- Under which circumstances might Operations be a better solution than GCD.

## Learning Objectives (5 min)

1. Identify and describe
1. Define
1. Design
1. Implement

<!-- Define and describe:
- Operation
- Operation Queues
- Benefits and Challenges of using Operations and Operation Queues
- the difference between GCD and Operations and Operation Queues
- when to use GCD vs Operations vs Operation Queues
- Block Operations -->


## Initial Exercise (15 min)

- Funny comic
- Prime the Pump (e.g. think and jot, think pair share, etc)
- Productivity Tip/Tool
- Review of current event (e.g. tech news relevant to your track/topic)
- Quiz on homework or topic(s) of past class
- Concept Test

## Intro to Operations (20 min)

### What are `Operations`?

`Operation` (formerly called `NSOperation`) is a class that allows you to encapsulate (wrap) a unit of work into a package you can execute at some time in the future.



Higher lever abstraction over GCD
Object oriented vs functions (GCD)
Operate concurrently but can be serial by using dependencies
An Operation describes a single unit of work
Can be cancelled
Have priorities (veryLow, Low, normal, high, veryHigh)



<!-- OUTLINE?
What are they?

Why use them? benefits

How they work


Compared to GCD... -->



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

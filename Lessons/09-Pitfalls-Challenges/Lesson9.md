# Concurrency Pitfalls & Challenges

<!-- INSTRUCTOR NOTES:
1)  -->


## Minute-by-Minute [OPTIONAL]

| **Elapsed** | **Time**  | **Activity**              |
| ----------- | --------- | ------------------------- |
| 0:00        | 0:05      | Objectives                |
| 0:05        | 0:15      | Overview                  |
| 0:20        | 0:45      | In Class Activity I       |
| 1:05        | 0:10      | BREAK                     |
| 1:15        | 0:45      | In Class Activity II      |
| TOTAL       | 2:00      |                           |

## Why you should know this or industry application (optional) (5 min)

Concurrency gives us many benefits when it comes to solving performance issues. Today we'll learn about three well known problems we can encounter if we are not being careful with our apps.

## Learning Objectives (5 min)

1. Identify and describe
1. Define
1. Design
1. Implement

## Initial Exercise (15 min)


## Race conditions (10 min)

Let's go back to when we first introduced threads.

**Threads that share the same process, also share the same address space.**

This means that each thread is trying to read and write to the same shared resource. This is how we can run into a situation called: **race condition**.

A race condition happens when multiple threads are trying to write to the same variable at the exact same time.

### An example

Situation: We have two threads executing and both of them are trying to update a count variable.

Facts:
- Reads and writes are separate tasks that the computer cannot execute in a single operation.
- Computers work on *clock cycles* in which each tick of the clock allows a single operation to execute. (As reference, an iPhone XS can perform 2,490,000,000 clock cycles per second 😦)

What we do: `count += 1`

What really happens:
1. We load the value of the variable `count` into memory.
1. We increment the value of `count` by one in memory.
1. We write the updated count back to disk.

(Whiteboard drawing + explaining)

Result: Race conditions lead to complicated debugging due to the non-deterministic characteristic of these scenarios.

How can we solve it: Serial queues 👍🏼

If we have a variable that needs to be accessed concurrently, we can wrap reads and writes in a private queue.

```Swift
private let countQueue = DispatchQueue(label: "countqueue")
private var count = 0
public var count: Int {
  get {
    return countQueue.sync {
      count
    }
  }
  set {
    countQueue.sync {
      count = newValue
    }
  }
}
```

Here we are controlling the access to the variable an making sure that only a single thread a t a time can access the variable.

### Thread barrier
Our previous solution is effective for simple situations. But there are times when the shared resource needs more complex logic in its getters and setters. One thing you might try us using locks and semaphores which is sometimes hard to implement without getting more errors. To make up for that we can use a solution from GCD, called **dispatch barrier**.

The main idea is that we create a concurrent queue where we can process all the read tasks we want, they can all run at the same time. But when the variable needs to be written to, then we lock the queue so that submitted tasks complete but no new submissions are run until the update is done.

(whiteboard diagram)

*Implementation*

```Swift
private let countQueue = DispatchQueue(label: "countqueue", attributes: .concurrent)
private var count = 0
public var count: Int {
  get {
    return countQueue.sync {
      count
    }
  }
  set {
    countQueue.async(flags: .barrier) { [unowned self] in
      self.count = newValue
    }
  }
}
```
(explanation of code snippet)

## Deadlock (10 min)

...

## Priority Inversion (10 min)

Priority inversion happens when a queue with a lower quality of service is given a higher system priority than a queue with a higher QoS.

...

## In Class-Activity

### Common questions regarding concurrency in iOS.

In pairs, try to answer as many questions as you can in the time given. Then practice your understanding by taking turns and asking them to each other in an interview format.

1. What is Concurrency?
1. What is Parallelism?
1. What is the difference between an asynchronous and a synchronous task?
1. What is the difference between a serial and a concurrent queue?
1. How does GCD work?
1. Explain the relationship between a process, a thread and a task.
1. How does iOS support multithreading?
1. What is NSOperation? and NSOPerationQueue?
1. what is QoS?
1. Explain priority inversion.
1. Explain dependencies in Operations.
1. When do you use GCD vs Operations?
1. How do we know if we have a race condition?
1. ...

## After Class

1. Research:
-

2. Assignment(s):
-


## Wrap Up (5 min)

- Continue working on your current tutorial
- Complete reading
- Complete challenges

## Additional Resources

1. []()
2. []()
3. []()
4. []()

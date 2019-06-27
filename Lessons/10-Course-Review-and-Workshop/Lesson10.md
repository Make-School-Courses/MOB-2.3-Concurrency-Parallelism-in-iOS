# Course Review & Workshop

<!-- INSTRUCTOR NOTES:
1) For Iniital Exercise:
- Quizlet game location is:
https://quizlet.com/_6u0szm

2)  -->


## Minute-by-Minute

| **Elapsed** | **Time**  | **Activity**              |
| ----------- | --------- | ------------------------- |
| 0:00        | 0:05      | Objectives                |
| 0:05        | 0:50      | Initial Activity          |
| 0:55        | 0:10      | BREAK                     |
| 1:05        | 0:15      | Overview  1                |
| 1:20       | 0:25      | In Class Activity I       |
| TOTAL       | 1:45     |                           |


## Learning Objectives (5 min)

1. Describe:
- the challenges and benefits of unit testing **Asynchronous Operations**
2. Implement basic examples of:
- unit tests of an **Asynchronous Operation** (a background dataTask) using the `XCTestExpectation` class,
<!-- 1. Identify use cases of Operations with dependencies.
1. Implement dependencies.
1. Review Operations by implementing a solution in a project. -->

## Initial Exercise (50 min)

### Part 1 - As a class (20 min)
- Let's review answers to last lesson's list of questions from Activity 1

### Part 2 - In Teams (30 min)

...A Quizlet game....


<!-- INSTRUCTOR NOTES:
1) For Iniital Exercise:
- Quizlet game location is:
https://quizlet.com/_6u0szm
 -->

<!--
## Debugging & Testing

### Debugging -->

<!--
OUTLINE:
- Debug Navigator

- Main Thread Checker

Detect invalid use of AppKit, UIKit, and other APIs from a background thread.


The Main Thread Checker is a standalone tool for Swift and C languages that detects invalid usage of AppKit, UIKit, and other APIs on a background thread. Updating UI on a thread other than the main thread is a common mistake that can result in missed UI updates, visual defects, data corruptions, and crashes.

How the Main Thread Checker Works
At app launch, the Main Thread Checker dynamically replaces the implementations of methods that should only be called on the main thread with a version that prepends the check. Methods known to be safe for use on background threads are excluded from this check.

Example Scenario:

Updating UI from a Completion Handler
Long-running tasks such as networking are often executed in the background, and provide a completion handler to signal completion. Attempting to read or update the UI from a completion handler may cause problems.

Solution
Dispatch the call to update the label text to the main thread.


Performance Impact
The performance impact of the Main Thread Checker is minimal, with a 1–2% CPU overhead and additional process launch time of <0.1 seconds.
Because of its minimal performance overhead, the Main Thread Checker is automatically enabled when you run your app with the Xcode debugger.

-- optional (non-apple text) --

The Main Thread Checker (MTC) was introduced in Xcode 9. Its goal is to simple: to detect improper use of APIs on a background thread. Updating using a background thread can cause unknown bugs, crashes and strange UI behavior that can easily be avoided.


- TSan -->


## Unit Testing Asynchronous Operations (20 min)

### Synchronous Operation Testing
Unit testing is most commonly applied to __*synchronous*__ operations because their outputs can be observed and validated immediately after invoking the function under test.

Whether the output is a function return value, a state change, or the result of methods invoked on a dependency, all of these results occur right away and in the same thread.

And, with __*synchronous*__ operations, when you write the assertions in the `Then` phase of your unit test, you are reasonably guaranteed that the outputs have already been set, so you can safely compare *actual* results against your *expected* ones.

Simple. Only one thread. And no worries that your outputs might not be set prior to test completion.

### Asynchronous Operation Testing
However, modern iOS development requires a great deal of __*asynchronous*__ operations in which results might not come immediately after a function is invoked.

__*Asynchronous*__ operations are operations that do not execute directly within the current flow of code. This might be because they run:
- on a different thread
- in a delegate method
- in a callback

Key examples:
- Networking (most common)
- Core Data
- Resource-expensive screen drawing code or events

Asynchronous operations are typically developed in one of two ways:
- Completion handler block
- Delegate method

Networking is the most common __*asynchronous*__ operation. Fetching data from remote web services has latency &mdash; it takes time to for signals to travel across the globe &mdash; and has many variables that can result in errors or delays.

<!-- The most common asynchronous operation is networking. Fetching data from an API over the network has latency, because data takes time to travel through wires around the globe. There can also be numerous points of failures. The server may be down. Packets can get dropped. Multiplexing can produce errors. Connection may be lost. There are many variables that can result in errors and/or delays.  -->

### Benefits & Challenges
Testing __*asynchronous*__ code comes with the benefit of uncovering poor design decisions and facilitating clean implementations.

The core challenge is that, in typical unit tests, a test is considered over as soon as its function returns.

With __*asynchronous*__ operations:
- Functions do not return their result to the caller immediately but deliver it later via callback functions, blocks, notifications, or similar mechanisms, which makes testing more difficult.
- When the function under test returns, any __*asynchronous*__ code will be ignored because it will run after the test has already finished.

This makes unit testing __*difficult*__ because results can be unpredictable: In the `Then` phase of your unit test, the results may or may not have been set to the outputs for you to observe and verify. When you write your assertions, the test may pass this time (if the outputs have been set), but fail at another time (if the outputs haven’t been set).

It can also result in __*false positives.*__

As a result, asynchronous testing requires special handling.

<!-- tasks might be executed on a different thread than the invoked function yet take extended time to complete before their outputs are set.

the program or information flow is not reflected in the call stack any more. -->

### Expectations
Fortunately, Xcode has built-in support to help with unit testing of __*asynchronous*__ operations.

To test that __*asynchronous*__ operations behave as expected, you create one or more **Expectations** within your test, and then __*fulfill*__ those expectations when the __*asynchronous*__ operation completes successfully.

Apple describes the `XCTestExpectation` class as "An expected outcome in an asynchronous test."

```Swift  
  class XCTestExpectation : NSObject
```

...and the `XCTestExpectation` class's `fulfill()` function is simply described as "Marks the expectation as having been met."


```Swift  
  func fulfill()
```

> Note that it is an error to call the `fulfill()` method on an expectation that has already been fulfilled, or when the test case that vended the expectation has already completed.


### Example Scenario
Steps required to unit test __*asynchronous*__ operations will vary depending on the function(s) under test.

In general, when using the `XCTestExpectation` class, your test method waits until all expectations are fulfilled or a specified timeout expires.

To illustrate a common scenario, here are the general steps you would execute to create a unit test for a background download task using an instance of the the `XCTestExpectation` class: <sup>1</sup>

1.  Create a new instance of `XCTestExpectation`.

2.  Use URLSession's `dataTask(with:)` method to create a background data task that executes your download work on a background thread.

3. After starting the data task, use the `wait(for expectations:_)` function of the `XCtest` class &mdash; with the timeout parameter that you specify &mdash; to set how long the main thread will wait for the expectation to be fulfilled.

```Swift
  /*!
   * @method -waitForExpectations:timeout:
   * Wait on a group of expectations for up to the specified timeout. May return early based on fulfillment
   * of the waited on expectations.
   */
  open func wait(for expectations: [XCTestExpectation], timeout seconds: TimeInterval)
```

4. When the data task completes, its `completion handler` verifies that the downloaded data is non-nil, and fulfills the expectation by calling its` fulfill()` method to indicate that the background task completed successfully.

#### Successful Completion
The fulfillment of the expectation on the background thread provides a point of synchronization to indicate that the background task is complete. As long as the background task fulfills the expectation within the duration specified in the timeout parameter, this test method will pass.

#### Unsuccessful Completion
There are two ways for the test to fail:
- The data returned to the completion handler is `nil`, causing `XCTAssertNotNil(_:_:file:line:)` to trigger a test failure.
- The data task does not call its completion handler before the timeout expires, perhaps because of a slow network connection or other data retrieval problem. As a result, the expectation is not fulfilled before the wait timeout expires, triggering a test failure.

<!--
The core of the problem is that a test is considered over as soon as its function returns. Because of that, any asynchronous code will be ignored, since it’ll run after the test has already finished.
Not only can this make code hard to test, but it can also lead to false positives.


The main challenge of testing concurrent code is that the program or information flow is not reflected in the call stack any more. Functions do not return their result to the caller immediately, but deliver it later via callback functions, blocks, notifications, or similar mechanisms, which makes testing more difficult.


Asynchronous operations present a challenge to unit testing. In the Then phase, the results may or may not have been set to the outputs for you to observe and verify. When you write your assertions, the test may pass this time (if the outputs have been set), but fail at another time (if the outputs haven’t been set).

The most common asynchronous operation is networking. Fetching data from an API over the network has latency, because data takes time to travel through wires around the globe. There can also be numerous points of failures. The server may be down. Packets can get dropped. Multiplexing can produce errors. Connection may be lost. There are many variables that can result in errors and/or delays. As a result, asynchronous testing necessitates some special handling. Fortunately, Xcode has built-in support to help with that. -->


<!--
All the unit tests that you’ve seen so far are for testing synchronous operations. That is, the outputs can be observed and verified immediately after invoking the method on the test subject. The outputs can be function return values, state changes, or methods invoked on a dependency. All of these happen right away in the same thread. When you write the assertions in the Then phase, you’re guaranteed that the outputs have already been set so that you can safely compare the actual v.s. expected. You don’t have to worry about whether the outputs are ready or not. They are ready.

However, a lot of stuff that we do in modern iOS development are asynchronous operations, such as Core Data, networking, or even some expensive drawing code or events. The results will come, but not right away. It takes time for the task to finish, and the outputs be set. In iOS, these asynchronous operations are usually coded in one of two ways:

Completion handler block
Delegate method

Asynchronous operations present a challenge to unit testing. In the Then phase, the results may or may not have been set to the outputs for you to observe and verify. When you write your assertions, the test may pass this time (if the outputs have been set), but fail at another time (if the outputs haven’t been set).

The most common asynchronous operation is networking. Fetching data from an API over the network has latency, because data takes time to travel through wires around the globe. There can also be numerous points of failures. The server may be down. Packets can get dropped. Multiplexing can produce errors. Connection may be lost. There are many variables that can result in errors and/or delays. As a result, asynchronous testing necessitates some special handling. Fortunately, Xcode has built-in support to help with that. -->

## In Class Activity I (60 min)

### Individually
In the [starter app](https://github.com/Make-School-Labs/StarterApp-MOB-2.4-L10), a previous developer created a `testDownloadWebData()` function to unit test a background data task. However, that function is missing critical functionality.

Your task is to complete the `testDownloadWebData()` function so that it successfully validates its targeted background task.

1. Complete the Code

- find the `//TODO:`s left in the function and add or change whatever is needed (*see Example Scenario above for clues*)

2. Run the code and examine results

- What happened? Why?

3. Apply any additional required fixes

- Run it again...

4. Make it fail

Review the Successful and Unsuccessful Completion notes in the Example Scenario above.

- reduce timeout to 0.1


## After Class

1. Assignment(s):
-

## Wrap Up (5 min)

...
<!-- - You pair programmed today's exercise. Make sure both of you get a working copy of the project. -->

## Additional Resources

1. [Slides](https://docs.google.com/presentation/d/1rIQGcpl-siO-VelTIb3J8qH9fVIk3hNswbwjS02TK80/edit#slide=id.p)
2. [Testing Asynchronous Operations with Expectations - from Apple](https://developer.apple.com/documentation/xctest/asynchronous_tests_and_expectations/testing_asynchronous_operations_with_expectations)<sup>1</sup>
3. [XCTestExpectation - from Apple](https://developer.apple.com/documentation/xctest/xctestexpectation)
4. [iOS Unit Testing and UI Testing Tutorial - by raywenderlich](https://www.raywenderlich.com/960290-ios-unit-testing-and-ui-testing-tutorial)

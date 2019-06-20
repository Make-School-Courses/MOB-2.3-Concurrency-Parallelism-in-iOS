# Operations Pt. 3

<!-- INSTRUCTOR NOTES:
1)  -->


## Minute-by-Minute

| **Elapsed** | **Time**  | **Activity**              |
| ----------- | --------- | ------------------------- |
| 0:00        | 0:05      | Objectives                |
| 0:05        | 0:20      | Initial Activity          |
| 0:25        | 0:15      | Overview                  |
| 0:40        | 0:30      | In Class Activity I       |
| 1:10        | 0:10      | BREAK                     |
| 1:20        | 0:30      | In Class Activity I       |
| TOTAL       | 1:50      |                           |


## Learning Objectives (5 min)

1. Identify use cases of Operations with dependencies.
1. Implement dependencies.
1. Review Operations by implementing a solution in a project.

## Initial Exercise (15 min)

- Last chance to review Dining Philosophers Problem.

## Dependencies (10 min)

(Refer to slides)

## In Class Activity I (60 min)

### Pair Programming activity

**We'll do this activity in pairs.** One of you will code while the other guides the activity using this repo. Then at some point you will switch roles.

Open the project given by the instructor. Build it, run it and tap where it says  “Show Tilt Shift”.  What we’ll see is an example of what we want to achieve for a collection of images. It's a blur effect. 🤓

Tilt shifting is a technique used on images to alter the depth of field. This results in a change in focus as you can tell from comparing both images.

Now go back and select “Show Table View”. You’ll notice it’s an empty table. Let’s fix that. 😦

We’ll start using an over simplified approach to then make it better.

Things to note:
- The application of the filter happens in `TiltShiftFilter.swift`.
- The 10 images used are in the Asset Catalog.

Go to `TiltShiftTableViewController.swift` and on the `cellForRowAt` method, get an image to then apply the filter to it.

```Swift
let name = "\(indexPath.row).png"
let inputImage = UIImage(named:name)!
guard let filter = TiltShiftFilter(image:inputImage, radius:3), let output = filter.outputImage else{
  print("Failed to generate image")
  cell.display(image: nil)
  return cell
}
let fromRect = CGRect (origin: .zero, size: inputImage.size)
guard let cgImage = context.createCGImage(output, from: fromRect) else{
  print("Image generation failed")
  cell.display(image:nil)
  return cell
}
cell.display(image: UIImage(cgImage:cgImage))
```

Now run the app and notice how the table takes forever to load and is pretty much unusable. But the images are there now! At least...

*Note: If you are using the simulator change the number of rows to 2 or 3 to make it less slow.*

Can you guess what is it that we need to do to improve the user experience?

If any of you said moving the tilt shifting off the main thread and into a background thread, you are correct ✅

### Using an operation

Let’s move the Core Image operations into an Operation subclass.

Create a new file and call it `TiltShiftOperation`.
Add two properties: `outputImage` and `inputImage`. Both of type `UIImage`.

Don’t forget to include the initializer.
```Swift
init(image: UIImage){
	inputImage = imaghe
	super.init()
}
```

Add this property to you class:
`private static let context = CIContext()`
The reason why this property is *static* is because we don’t want to create a new context with each instance of the operation. CIContext should be reused if possible and it’s also *thread safe*.

Now let’s override the main method. Here goes the long running task we want to do. **Make sure you move the right code into the main method.** (hint: we tried to do this for each cell)

After that is correctly set up. **We need to go back to our table and make it use our operation.** Try running it manually, using the `start()` method.

Build and run. Is this a lot better? How about performance?
Think about what is it that changed and how it’s not good yet.

**Q: What is the problem?**

If you said it’s the `start()` call, correct! When we call the start method directly, we are performing a *synchronous* call on the main thread. So even when we moved out the filtering code into an Operation, we are still not using it correctly to take advantage of it.

Another thing that could have gone really wrong, was if the operation wasn’t ready and we call start on it. Sure crash. ❌

### Adding a UIActivityIndicator

Let’s do things right and inform the user when something is going on. Add a `UIActivityIndicator`  (Main.storyboard -> TiltShiftTableView Controller Scene -> Drag an activity indicator to the enter of the image and center it) Don’t forget to add the IBOutlet in PhotoCell.

Add this computed property for ease of use:
```Swift
var isLoading: Bool{
	get{return activityIndicator.isAnimating}
	set{
		if newValue{
			activityIndicator.startAnimating()
		}else{
			activityIndicator.stopAnimating()
		}
	}
}
```

### Updating the table
Go to `TiltShiftTableViewController` and create a new `OperationQueue`.

Now replace what’s inside `cellForRowAt` , between the image declaration and returning the cell with this:

```Swift
let op = TiltShiftOperation(image: image)
op.completionBlock = {
  DispatchQueue.main.async {
    guard let cell = tableView.cellForRow(at: indexPath) as? PhotoCell else { return }
    cell.isLoading = false
    cell.display(image: op.outputImage)
  }
}
queue.addOperation(op)
```

Build and run. What’s different from the last time? Why?

**SWITCH TIME 🔛**

### Downloading images
Right now the app uses images from the Assets Catalog. Let’s change that so that it downloads images from URLs, which is more realistic anyway.

Create a new file and call it `NetworkImageOperation`

Add this to it

```Swift
final class NetworkImageOperation: AsyncOperation {
  var image: UIImage?
  private let url: URL
  private let completion: ((Data?, URLResponse?, Error?) -> Void)?

  init(url: URL, completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
    self.url = url
    self.completion = completion
    super.init()
  }

  convenience init?(
    string: String,
    completion: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
    guard let url = URL(string: string) else { return nil }
    self.init(url: url, completion: completion)
  }

  override func main() {
    URLSession.shared.dataTask(with: url) {
      [weak self] data, response, error in
      guard let self = self else { return }
      defer { self.state = .finished }
      if let completion = self.completion {
        completion(data, response, error)
        return
      }
      guard error == nil, let data = data else { return }
      self.image = UIImage(data: data)
      }.resume()
  }

}
```

Take some time to check out what's going on with it before moving on.

Go to `TiltShiftTableViewControlle` and get list of URLs form the Photos plist. Yo know how to do this from last term, if you get stuck check it below.

```Swift
private var urls: [URL] = []
override func viewDidLoad() {
  super.viewDidLoad()
  guard let plist = Bundle.main.url(forResource: "Photos",
                                    withExtension: "plist"),
        let contents = try? Data(contentsOf: plist),
        let serial = try? PropertyListSerialization.propertyList(
                          from: contents,
                          format: nil),
        let serialUrls = serial as? [String] else {
        print("Something went horribly wrong!")
        return
}
  urls = serialUrls.compactMap(URL.init)
}
```

**Q: What is compactMap doing?**

Now change `cellForRowAt` to use the `NetworkImageOperation` class and send to it the corresponding element from the urls array.

```Swift
  let op = NetworkImageOperation(url: *right index goes here*)
```
You'll need to change to this as well: `cell.display(image: op.image)`

Build and run. You should see a smoother scroll.

### Using dependencies

What we are here for! Dependencies.

Now that we have an operation that downloads the image and another that applies the filter, let’s combine them together to have one happening after the other. Using dependencies 😎

To start we are going to need a protocol to pass data between operations. Create a new file and call it `ImageDataProvider` and add the following:

```Swift
import UIKit
protocol ImageDataProvider {
  var image: UIImage? { get }
}

```

Both `NetworkImageOperation` and `TiltShiftOperation` should conform to this protocol. You can try doing that in extensions.

```Swift
  extension NetworkImageOperation: ImageDataProvider {}
  extension TiltShiftOperation: ImageDataProvider {
 	 	var image: UIImage? { return outputImage }
  }
```

We know `TiltShiftOperation` needs an image as input. Let’s also make it check if any of its dependencies give the image as output.

Change the guard statement in `main()` to this:

```Swift
let dependencyImage = dependencies
  .compactMap { ($0 as? ImageDataProvider)?.image }
  .first
guard let inputImage = inputImage ?? dependencyImage else {
return
}
```

Because we check in the end for an image, there needs to be a way to initialize a TiltShiftOperation without an input image. The simplest way to default the input image to nil in the init method. Something like this `init(image: UIImage? = nil) {...`

Let’s  go back to 'TiltShiftTableViewcontroller' change what’s in `cellForRowAt` again (this is the last time I promise), specifically the line where we set and declare the operation.

```Swift
let downloadOp = NetworkImageOperation(url: urls[indexPath.row])
let tiltShiftOp = TiltShiftOperation()
tiltShiftOp.addDependency(downloadOp)
```

See how we have now **2 operations and a dependency** that ties them together.

Now instead of setting the completionBlock, set it on the `tiltShiftOp` which is the one giving you back the image.

Replace it with this:
```Swift
tiltShiftOp.completionBlock = {
  DispatchQueue.main.async {
    guard let cell = tableView.cellForRow(at: indexPath)
      as? PhotoCell else { return }
      cell.isLoading = false
      cell.display(image: tiltShiftOp.image)
  }
}

```

**Q: Our tilt shift depends on the download. Does this mean we should only add the download operation to the queue? Or both?**

Figure it out  to get the final implementation.  You should have the tableview working in the end.


## After Class

1. Assignment(s):
- For next class, bring your plan for the final project. This is important since we have two weeks left in the term.

## Wrap Up (5 min)

- You pair programmed today's exercise. Make sure both of you get a working copy of the project.

## Additional Resources

1. [Slides](https://docs.google.com/presentation/d/1ZS9ZQaGVD5bsQ3kkDOBDZY_fRgh45Xgsb1NHPhuXAbI/edit?usp=sharing)
1. Concurrency by Tutorials Book

# CustomCameraDemo

This is a barebones implementation on how to get a custom camera working using AVFoundation in iOS 10.

## Guide

### Setting up Main.storyboard

Create a brand new Xcode project. Open up the `main.storyboard` file and add the following UI elements to the View Controller:

![storyboard](/images/storyboard.png)

1. This is a `UIView`. This is the preview view that shows whatever the iPhone camera is viewing.

2. This is a `UIImageView`. You will make this hold the image of the snapshot you take.

3. This is a `UIButton`. You will make this trigger the snapshot of the current camera's view.

### Creating a Preview View

The preview view shows what the iPhone camera is currently seeing. Create a new Swift file and name it **PreviewView** and update the contents to the following:

```swift
import UIKit
import AVFoundation

final class PreviewView: UIView {

  // 1
  override class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }

  // 2
  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    return layer as! AVCaptureVideoPreviewLayer
  }

  // 3
  var session: AVCaptureSession? {
    get {
      return videoPreviewLayer.session
    }
    set {
      videoPreviewLayer.session = newValue
    }
  }
  
}
```

1. By default, `layerClass` returns a `CALayer`. In order to show what your iPhone's camera is viewing, you'll need to return a `AVCaptureVideoPreviewLayer` class instead. 

2. You create a convenient computed property that returns that layer. 

3. `AVCaptureVideoPreviewLayer` is responsible for showing the camera view, but it cannot do it alone. An `AVCaptureSession` is required to stream it live video data. Here, you create a property that allows `PreviewView` to accept a `AVCaptureSession` object.

Using a setter, you will give your `videoPreviewLayer` the `AVCaptureSession` it needs to start showing your live camera feed.

Before continuing, update the `UIView` in the storyboard to use this custom subclass:

![previewView](/images/previewView.png)

### Part 1/3: Configuring the View Controller's Properties

Open `ViewController.swift` and update the file to the following:

```swift
import UIKit
import AVFoundation

final class ViewController: UIViewController {
  
  // 1
  @IBOutlet fileprivate var previewView: PreviewView!
  @IBOutlet fileprivate var imageView: UIImageView! 

  // 2
  fileprivate let session: AVCaptureSession = {
  	let session = AVCaptureSession()
  	session.sessionPreset = AVCaptureSessionPresetPhoto
  	return session
  }()

  // 3
  fileprivate let output = AVCapturePhotoOutput()
}
```

1. Hook up the `@IBOutlet`s to the storyboard.

2. This is the `AVCaptureSession` that will manage the iPhone's camera. This is the "command center" for `AVFoundation`. You set the `sessionPreset` to photo capturing mode. 

3. `AVCapturePhotoOutput` is the actual class responsible for initiating a request for image capture. You create and hold a reference to that property here.

### Part 2/3: Configuring the View Controller's Life Cycle

At the bottom of `ViewController.swift`, add the following extension:

```swift
// MARK: - View Controller Life Cycle
extension ViewController {

  // 1
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCamera()
  }
  
  // 2
  private func setupCamera() {
    let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    guard let input = try? AVCaptureDeviceInput(device: backCamera) else { fatalError("back camera not available.") }
    session.addInput(input)
    session.addOutput(output)
    previewView.session = session
  }
  
  // 3
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    session.startRunning()
  }
  
  // 4
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    session.stopRunning()
  }
}
```

1. There are more configuration steps before your `AVCaptureSession` is ready to begin managing the camera. You'll do the configuration in `viewDidLoad`.

2. This method bundles the configuration steps. A `AVCaptureSession` needs inputs and outputs. For this demo, your input is the back camera, and your output is the `AVCapturePhotoOutput` you created in the properties section.

> It's possible that the user's device does not have the back camera available (or perhaps it's not functional). The code right now does not handle that gracefully. 

3. `session.startRunning()` tells the `AVCaptureSession` to activate the iPhone's camera and begin managing the video data stream.

4. `session.stopRunning()` tells the `AVCaptureSession` to deactivate the iPhone's camera.

> You always want to stop the session when you don't need the camera. The iPhone's camera uses alot of processing power and doesn't stop until it receives the `stopRunning` command. This means even if you segue to another screen in your app, it will continue to run unless `stopRunning` is called.



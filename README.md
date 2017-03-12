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



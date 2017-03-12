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
  var session: AVCaptureSession? {
    get {
      return videoPreviewLayer.session
    }
    set {
      videoPreviewLayer.session = newValue
    }
  }
  
  // 3
  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    return layer as! AVCaptureVideoPreviewLayer
  }
}
```

1. 

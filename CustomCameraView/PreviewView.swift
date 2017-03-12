//
//  PreviewView.swift
//  CustomCameraView
//
//  Created by Kelvin Lau on 2017-03-12.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit
import AVFoundation

final class PreviewView: UIView {
  
  // 1
  var videoPreviewLayer: AVCaptureVideoPreviewLayer {
    return layer as! AVCaptureVideoPreviewLayer
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
  override class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }
}

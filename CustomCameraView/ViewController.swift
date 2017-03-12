//
//  ViewController.swift
//  CustomCameraView
//
//  Created by Kelvin Lau on 2017-03-12.
//  Copyright © 2017 Kelvin Lau. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  @IBOutlet fileprivate var previewView: PreviewView! {
    didSet {
      previewView.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
      previewView.clipsToBounds = true
    }
  }
  
  @IBOutlet fileprivate var imageView: UIImageView! {
    didSet {
      imageView.clipsToBounds = true
    }
  }
  
  fileprivate let session: AVCaptureSession = {
    let session = AVCaptureSession()
    session.sessionPreset = AVCaptureSessionPresetPhoto
    return session
  }()
  
  fileprivate let output = AVCapturePhotoOutput()
}

// MARK: - View Controller Life Cycle
extension ViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCamera()
  }
  
  private func setupCamera() {
    let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    guard let input = try? AVCaptureDeviceInput(device: backCamera) else { fatalError("back camera not functional.") }
    session.addInput(input)
    session.addOutput(output)
    previewView.session = session
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    session.startRunning()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    session.stopRunning()
  }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension ViewController: AVCapturePhotoCaptureDelegate {
  func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    guard let sampleBuffer = photoSampleBuffer else { fatalError("sample buffer was nil") }
    guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: nil) else { fatalError("could not get image data from sample buffer.") }
    imageView.image = UIImage(data: imageData)
  }
}

// MARK: - @IBActions
private extension ViewController {
  @IBAction func capturePhoto() {
    let captureSettings = AVCapturePhotoSettings()
    captureSettings.isAutoStillImageStabilizationEnabled = true
    output.capturePhoto(with: captureSettings, delegate: self)
  }
}

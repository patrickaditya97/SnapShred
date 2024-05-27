//
//  CameraScreenViewController.swift
//  SnapShred
//
//  Created by Aditya on 5/5/24.
//

import UIKit
import AVFoundation

class CameraScreenViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    var captureSession: AVCaptureSession!
    
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var backInput: AVCaptureInput!
    var frontInput: AVCaptureInput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var photoOutput: AVCapturePhotoOutput?
    
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkPermissions()
        setupAndStartCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.layer.bounds
    }
    
    func setupAndStartCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            
            if self.captureSession.canSetSessionPreset(.photo) {
                self.captureSession.sessionPreset = .photo
            }
            self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
            
            self.setupInputs()
            self.setupOutputs()
            
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    func setupInputs() {
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            fatalError("No Back Camera")
        }
        
        guard let backInput = try? AVCaptureDeviceInput(device: backCamera) else {
            fatalError("Could not create input device from back camera")
        }

        if captureSession.canAddInput(backInput) {
            self.backInput = backInput
            captureSession.addInput(backInput)
        } else {
            fatalError("Could not add back camera input to capture session")
        }
    }
    
    func setupOutputs() {
        let photoOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
            self.photoOutput = photoOutput
        } else {
            fatalError("Could not add output to capture session.")
        }
    }
    
    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.insertSublayer(previewLayer, below: cameraButton.layer)
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
    }
    
    @IBAction func capturePhotoAction(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {return}
        let previewImage = UIImage(data: imageData)
        
        guard let previewViewController = storyboard?.instantiateViewController(withIdentifier: "previewScreen") as? PreviewViewController else { return }
        previewViewController.previewImage = previewImage
        self.present(previewViewController, animated: true)
    }
}

extension CameraScreenViewController {
    func checkPermissions() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        switch cameraAuthStatus {
        case .authorized:
            return
        case .denied:
            abort()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { authorized in
                if(!authorized) {
                    abort()
                }
            })
        case .restricted:
            abort()
        @unknown default:
            fatalError()
        }
    }
}

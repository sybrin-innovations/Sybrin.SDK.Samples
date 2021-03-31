//
//  LivenessDetectionViewController.swift
//  BiometricsExample
//
//  Created by Default on 2021/03/23.
//

import UIKit
import Sybrin_iOS_Biometrics

class LivenessDetectionViewController: UIViewController {
    
    @IBOutlet weak var activeLivenessDetectionButton: UIButton!
    @IBOutlet weak var activePassiveLivenessDetectionButton: UIButton!
    @IBOutlet weak var passiveLivenessDetectionButton: UIButton!
    @IBOutlet weak var passiveLivenessDetectionFromImageButton: UIButton!
    var livenessDetectionQuestions: [LivenessDetectionQuestion] {
        return [
            SmileLivenessDetectionQuestion(),
            BlinkLivenessDetectionQuestion()
        ]
    }
    var imagePicker: ImagePicker { return ImagePicker() }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Liveness Detection"
    }

    @IBAction func activeLivenessDetectionTapped(_ sender: Any) {
        
        SybrinBiometrics.shared.openActiveLivenessDetection(on: self, actions: livenessDetectionQuestions) { (result, message) in
            
            print("Done Launching: \(result) \(!result ? "with message: \(message ?? "")" : "")")
            if let message = message { HelperFunctions.showToast(controller: self, message: message) }
            
        } success: { (model) in
            
            print("Active Liveness Detection Success: \(model.isAlive)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: "You are \(model.isAlive ? "alive" : "not alive")")
            }
            
        } failure: { (message) in
            
            print("Active Liveness Detection Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: message)
            }
            
        } cancel: {
            
            print("Active Liveness Detection Canceled")
            
        }
        
    }
    
    @IBAction func activePassiveLivenessDetectionTapped(_ sender: Any) {
        
        SybrinBiometrics.shared.openActivePassiveLivenessDetection(on: self, actions: livenessDetectionQuestions) { (result, message) in
            
            print("Done Launching: \(result) \(!result ? "with message: \(message ?? "")" : "")")
            if let message = message { HelperFunctions.showToast(controller: self, message: message) }
            
        } success: { (model) in
            
            print("Active Passive Liveness Detection Success: isAlive: \(model.isAlive), liveness confidence: \(model.livenessConfidence)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: "You are \(model.isAlive ? "\(model.livenessConfidence * 100)% alive" : "\((1 - model.livenessConfidence) * 100)% not alive")")
            }
            
        } failure: { (message) in
            
            print("Active Passive Liveness Detection Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: message)
            }
            
        } cancel: {
            
            print("Active Passive Liveness Detection Canceled")
            
        }
        
    }
    
    @IBAction func passiveLivenessDetectionTapped(_ sender: Any) {
        
        SybrinBiometrics.shared.openPassiveLivenessDetection(on: self) { (result, message) in
            
            print("Done Launching: \(result) \(!result ? "with message: \(message ?? "")" : "")")
            if let message = message { HelperFunctions.showToast(controller: self, message: message) }
            
        } success: { (model) in
            
            print("Passive Liveness Detection Success: isAlive: \(model.isAlive), liveness confidence: \(model.livenessConfidence)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: "You are \(model.isAlive ? "\(model.livenessConfidence * 100)% alive" : "\((1 - model.livenessConfidence) * 100)% not alive")")
            }
            
        } failure: { (message) in
            
            print("Passive Liveness Detection Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: message)
            }
            
        } cancel: {
            
            print("Passive Liveness Detection Canceled")
            
        }
        
    }
    
    @IBAction func passiveLivenessDetectionFromImageTapped(_ sender: Any) {
        
        imagePicker.pickImage(self) { [weak self] (image) in
            guard let self = self else { return }
            let image = image.fixOrientation(with: image.imageOrientation).rotateImagePortrait()
            
            HelperFunctions.showToast(controller: self, message: "Please wait")
            self.disableButtons()
            
            SybrinBiometrics.shared.passiveLivenessDetectionFromImage(image: image) { [weak self] (model) in
                guard let self = self else { return }
                
                print("Passive Liveness Detection Success: isAlive: \(model.isAlive), liveness confidence: \(model.livenessConfidence)")
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                    self.enableButtons()
                    HelperFunctions.showToast(controller: self, message: "You are \(model.isAlive ? "\(model.livenessConfidence * 100)% alive" : "\((1 - model.livenessConfidence) * 100)% not alive")")
                }
            
            } failure: { [weak self] (message) in
                guard let self = self else { return }
                
                print("Passive Liveness Detection Failed: \(message)")
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                    self.enableButtons()
                    HelperFunctions.showToast(controller: self, message: message)
                }
            
            }
            
        }
        
    }
    
    func disableButtons() {
        activeLivenessDetectionButton.isEnabled = false
        activePassiveLivenessDetectionButton.isEnabled = false
        passiveLivenessDetectionButton.isEnabled = false
        passiveLivenessDetectionFromImageButton.isEnabled = false
    }
    
    func enableButtons() {
        activeLivenessDetectionButton.isEnabled = true
        activePassiveLivenessDetectionButton.isEnabled = true
        passiveLivenessDetectionButton.isEnabled = true
        passiveLivenessDetectionFromImageButton.isEnabled = true
    }
    
}

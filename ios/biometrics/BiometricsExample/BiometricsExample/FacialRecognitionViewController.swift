//
//  FacialRecognitionViewController.swift
//  BiometricsExample
//
//  Created by Default on 2021/03/23.
//

import UIKit
import Sybrin_iOS_Biometrics

class FacialRecognitionViewController: UIViewController {
    @IBOutlet weak var identifier: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Facial Recognition"
        identifier.delegate = self
        identifier.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        identifier.resignFirstResponder()
    }

    @IBAction func trainFaceTapped(_ sender: Any) {
        guard let identifier = identifier.text, identifier.count > 0 else { return HelperFunctions.showToast(controller: self, message: "Identifier is empty") }
        
        SybrinBiometrics.shared.trainFace(on: self, for: identifier) { (model) in
            
            print("Train Face Success: \(model.trainingTimeTakenMilliseconds)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: "Took \(model.trainingTimeTakenMilliseconds) milliseconds to train")
            }
            
        } failure: { (message) in
            
            print("Train Face Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: message)
            }
            
        } cancel: {
            
            print("Train Face Canceled")
            
        }
        
    }
    
    @IBAction func loadModelTapped(_ sender: Any) {
        guard let identifier = identifier.text, identifier.count > 0 else { return HelperFunctions.showToast(controller: self, message: "Identifier is empty") }
        
        SybrinBiometrics.shared.loadModel(for: identifier) {
            
            print("Load Model Success: \(identifier)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: "Loading model for \(identifier) was successful")
            }
            
        } failure: { (message) in
            
            print("Load Model Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: message)
            }
            
        }
        
    }
    
    @IBAction func recognizeFaceTapped(_ sender: Any) {
        guard let identifier = identifier.text, identifier.count > 0 else { return HelperFunctions.showToast(controller: self, message: "Identifier is empty") }
        
        SybrinBiometrics.shared.openFacialRecognition(on: self, for: identifier) { (result, message) in
            
            print("Done Launching: \(result) \(!result ? "with message: \(message ?? "")" : "")")
            if let message = message { HelperFunctions.showToast(controller: self, message: message) }
            
        } success: { (model) in
            
            print("Facial Recognition Success: \(model.confidence)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: "We are \(model.confidence * 100)% sure you are \(identifier)")
            }
            
        } failure: { (message) in
            
            print("Facial Recognition Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                HelperFunctions.showToast(controller: self, message: message)
            }
            
        } cancel: {
            
            print("Facial Recognition Canceled")
            
        }
        
    }
    
}

extension FacialRecognitionViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

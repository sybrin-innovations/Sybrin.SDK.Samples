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
    @IBOutlet weak var actionsTableView: UITableView!
    var actions: [String] = [
        "Blink",
        "Look down",
        "Look up",
        "Smile",
        "Tilt head left",
        "Tilt head right",
        "Turn head left",
        "Turn head right"
    ]
    var livenessDetectionQuestions: [LivenessDetectionQuestion] {
        var list: [LivenessDetectionQuestion] = []
        
        if actions.contains("Blink") { list.append(BlinkLivenessDetectionQuestion()) }
        if actions.contains("Look down") { list.append(LookDownLivenessDetectionQuestion()) }
        if actions.contains("Look up") { list.append(LookUpLivenessDetectionQuestion()) }
        if actions.contains("Smile") { list.append(SmileLivenessDetectionQuestion()) }
        if actions.contains("Tilt head left") { list.append(TiltHeadLeftLivenessDetectionQuestion()) }
        if actions.contains("Tilt head right") { list.append(TiltHeadRightLivenessDetectionQuestion()) }
        if actions.contains("Turn head left") { list.append(TurnHeadLeftLivenessDetectionQuestion()) }
        if actions.contains("Turn head right") { list.append(TurnHeadRightLivenessDetectionQuestion()) }
        
        return list
    }
    var imagePicker: ImagePicker { return ImagePicker() }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Liveness Detection"
        actionsTableView.delegate = self
        actionsTableView.dataSource = self
    }
    
    @IBAction func resetTapped(_ sender: Any) {
        
        for action in [
            "Blink",
            "Look down",
            "Look up",
            "Smile",
            "Tilt head left",
            "Tilt head right",
            "Turn head left",
            "Turn head right"
        ] {
            if !actions.contains(action) {
                let indexPath = IndexPath(row: self.actions.count, section: 0)
                self.actions.append(action)
                self.actionsTableView.insertRows(at: [indexPath], with: .fade)
            }
        }
        
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
            let image = image.fixOrientation(to: image.imageOrientation).rotateImagePortrait()
            
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

extension LivenessDetectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, result) in
            guard let self = self else { return }
            
            self.actions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

extension LivenessDetectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LivenessActionCell", for: indexPath) as! LivenessDetectionActionTableViewCell
        cell.actionTitle.text = actions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
}

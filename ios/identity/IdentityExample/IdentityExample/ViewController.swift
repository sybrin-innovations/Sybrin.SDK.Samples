//
//  ViewController.swift
//  IdentityExample
//
//  Created by Default on 2021/03/04.
//

import UIKit
import Sybrin_iOS_Identity

class ViewController: UIViewController {
    @IBOutlet weak var countryPicker: UIPickerView!
    var selectedCountry: Country = .SouthAfrica
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        countryPicker.dataSource = self
        countryPicker.delegate = self
        countryPicker.selectRow(Country.allCases.firstIndex(of: selectedCountry) ?? 0, inComponent: 0, animated: false)
    }
    
    @IBAction func scanDriversLicense(_ sender: Any) {
        
        SybrinIdentity.shared.scanDriversLicense(on: self, for: selectedCountry) { (result, message) in
            
            print("Done Launching: \(result) \(!result ? " with message: \(message ?? "")" : "")")
            if let message = message { self.showToast(controller: self, message: message) }
            
        } success: { (model) in
            
            print("Scan Drivers License Success: \(model.licenseNumber ?? "")")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                if let licenseNumber = model.licenseNumber { self.showToast(controller: self, message: "Scanned Drivers License for \(licenseNumber)") }
            }
            
        } failure: { (message) in
            
            print("Scan Drivers License Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.showToast(controller: self, message: message)
            }
            
        } cancel: {
            
            print("Scan Drivers License Canceled")
            
        }

    }
    
    @IBAction func scanGreenBook(_ sender: Any) {
        
        SybrinIdentity.shared.scanGreenBook(on: self) { (result, message) in
            
            print("Done Launching: \(result) \(!result ? " with message: \(message ?? "")" : "")")
            if let message = message { self.showToast(controller: self, message: message) }
            
        } success: { (model) in
            
            print("Scan Green Book Success: \(model.identityNumber ?? "")")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                if let identityNumber = model.identityNumber { self.showToast(controller: self, message: "Scanned Green Book for \(identityNumber)") }
            }
            
        } failure: { (message) in
            
            print("Scan Green Book Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.showToast(controller: self, message: message)
            }
            
        } cancel: {
            
            print("Scan Green Book Canceled")
            
        }

    }
    
    @IBAction func scanIDCard(_ sender: Any) {
        
        SybrinIdentity.shared.scanIDCard(on: self, for: selectedCountry) { (result, message) in
            
            print("Done Launching: \(result) \(!result ? "with message: \(message ?? "")" : "")")
            if let message = message { self.showToast(controller: self, message: message) }
            
        } success: { (model) in
            
            print("Scan ID Card Success: \(model.identityNumber ?? "")")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                if let identityNumber = model.identityNumber { self.showToast(controller: self, message: "Scanned ID Card for \(identityNumber)") }
            }
            
        } failure: { (message) in
            
            print("Scan ID Card Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.showToast(controller: self, message: message)
            }
            
        } cancel: {
            
            print("Scan ID Card Canceled")
            
        }

    }

    @IBAction func scanPassport(_ sender: Any) {
        
        SybrinIdentity.shared.scanPassport(on: self, for: selectedCountry) { (result, message) in
            
            print("Done Launching: \(result) \(!result ? " with message: \(message ?? "")" : "")")
            if let message = message { self.showToast(controller: self, message: message) }
            
        } success: { (model) in
            
            print("Scan Passport Success: \(model.passportNumber ?? "")")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                if let passportNumber = model.passportNumber { self.showToast(controller: self, message: "Scanned Passport for \(passportNumber)") }
            }
            
        } failure: { (message) in
            
            print("Scan Passport Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.showToast(controller: self, message: message)
            }
            
        } cancel: {
            
            print("Scan Passport Canceled")
            
        }

    }
    
}

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Country.allCases.count
    }
    
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Country.allCases[row].fullName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = Country.allCases[row]
    }
    
}

extension ViewController {
    
    func showToast(controller: UIViewController, message : String) {
        DispatchQueue.main.async {
            // Removing the toast container
            if let viewToRemove = controller.view.viewWithTag(100) {
                viewToRemove.removeFromSuperview()
            }
            
            // Creating the taost container
            let toastContainer = UIView(frame: CGRect())
            toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastContainer.alpha = 0.0
            toastContainer.layer.cornerRadius = 25;
            toastContainer.clipsToBounds  =  true
            toastContainer.tag = 100
            
            let toastLabel = UILabel(frame: CGRect())
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font.withSize(12.0)
            toastLabel.text = message
            toastLabel.clipsToBounds  =  true
            toastLabel.numberOfLines = 0
            
            toastContainer.addSubview(toastLabel)
            controller.view.addSubview(toastContainer)
            
            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            toastContainer.translatesAutoresizingMaskIntoConstraints = false
            
            let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
            let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
            let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
            let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
            toastContainer.addConstraints([a1, a2, a3, a4])
            
            let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
            let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
            let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
            controller.view.addConstraints([c1, c2, c3])
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                toastContainer.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 3, options: .curveEaseOut, animations: {
                    toastContainer.alpha = 0.0
                }, completion: {_ in
                    toastContainer.removeFromSuperview()
                })
            })
        }
    }
    
}

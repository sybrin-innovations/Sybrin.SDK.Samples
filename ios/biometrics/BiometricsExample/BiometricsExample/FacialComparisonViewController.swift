//
//  FacialComparisonViewController.swift
//  BiometricsExample
//
//  Created by Default on 2021/03/23.
//

import UIKit
import Sybrin_iOS_Biometrics

class FacialComparisonViewController: UIViewController {
    
    @IBOutlet weak var facesTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var compareFacesButton: UIButton!
    @IBOutlet weak var targetButton: UIButton!
    var targetButtonImage: UIImage?
    var faces: [UIImage] = []
    var busyProcessing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Facial Comparison"
        facesTableView.delegate = self
        facesTableView.dataSource = self
        
        CheckIfAllImagesAreSet()
    }
    
    @IBAction func targetButtonTapped(_ sender: Any) {
        guard !busyProcessing else { return }
        
        let imagePicker = ImagePicker()
        
        imagePicker.pickImage(self) { [weak self] (image) in
            guard let self = self else { return }
            
            self.targetButtonImage = image
            self.targetButton.setImage(image, for: .normal)
            
            self.CheckIfAllImagesAreSet()
        }
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let imagePicker = ImagePicker()
        
        imagePicker.pickImage(self) { [weak self] (image) in
            guard let self = self else { return }
            
            let indexPath = IndexPath(row: self.faces.count, section: 0)
            self.faces.append(image)
            self.facesTableView.insertRows(at: [indexPath], with: .fade)
            
            self.CheckIfAllImagesAreSet()
        }
    }
    
    @IBAction func compareFacesButtonTapped(_ sender: Any) {
        guard let target = targetButtonImage else { return }
        
        HelperFunctions.showToast(controller: self, message: "Please wait")
        disableButtons()
        busyProcessing = true
        
        SybrinBiometrics.shared.compareFaces(target, faces) { [weak self] (model) in
            guard let self = self else { return }
            
            print("Facial Comparison Success: \(model.averageConfidence)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.enableButtons()
                self.busyProcessing = false
                HelperFunctions.showToast(controller: self, message: "We are \(model.averageConfidence * 100)% sure the faces match the target")
            }
            
        } failure: { [weak self] (message) in
            guard let self = self else { return }
            
            print("Facial Comparison Failed: \(message)")
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
                self.enableButtons()
                self.busyProcessing = false
                HelperFunctions.showToast(controller: self, message: message)
            }
            
        }

        
    }
    
    func CheckIfAllImagesAreSet() {
        compareFacesButton.isEnabled = (targetButtonImage != nil && faces.count > 0)
    }
    
    func disableButtons() {
        compareFacesButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    func enableButtons() {
        compareFacesButton.isEnabled = true
        addButton.isEnabled = true
    }
    
}

extension FacialComparisonViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, result) in
            guard let self = self else { return }
            guard !self.busyProcessing else { return }
            
            self.faces.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            self.CheckIfAllImagesAreSet()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
}

extension FacialComparisonViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaceCell", for: indexPath) as! FacialComparisonTableViewCell
        cell.faceImageView.image = faces[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

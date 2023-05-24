//
//  NewCoffeeHouseViewController.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 23.05.2023.
//

import UIKit

final class NewCoffeeHouseViewController: UITableViewController {
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var coffeeHouseImage: UIImageView!
    @IBOutlet var coffeeHouseName: UITextField!
    @IBOutlet var coffeeHouseLocation: UITextField!
    @IBOutlet var coffeeHouseType: UITextField!
    
    private let storageManager = StorageManager.shared
    private var imageIsChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        coffeeHouseName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func saveNewCoffeeHouse() {
        var image: UIImage?
        
        imageIsChanged
            ? (image = coffeeHouseImage.image)
            : (image = UIImage(named: "imagePlaceholder"))
        
        let imageData = image?.pngData()

        let newCoffeeHouse = CoffeeHouse(
            name: coffeeHouseName.text ?? "",
            location: coffeeHouseLocation.text,
            type: coffeeHouseType.text,
            imageData: imageData
        )
        
        storageManager.save(newCoffeeHouse)
    }
}

// MARK: - Table view delegate
extension NewCoffeeHouseViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cameraIcon = UIImage(named: "camera")
            let photoIcon = UIImage(named: "photo")
            
            let actionSheet = UIAlertController(
                title: nil,
                message: nil,
                preferredStyle: .actionSheet
            )
            
            let camera = UIAlertAction(title: "Camera", style: .default) { [unowned self] _ in
                self.chooseImagePicker(source: .camera)
            }
            
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { [unowned self] _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
}

// MARK: - Text field delegate
extension NewCoffeeHouseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        (coffeeHouseName.text?.isEmpty == false)
            ? (saveButton.isEnabled = true)
            : (saveButton.isEnabled = false)
    }
}

// MARK: - Work with image
extension NewCoffeeHouseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        coffeeHouseImage.image = info[.editedImage] as? UIImage
        coffeeHouseImage.contentMode = .scaleAspectFill
        coffeeHouseImage.clipsToBounds = true
        
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}

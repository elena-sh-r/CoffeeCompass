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
    
    var currentCoffeeHouse: CoffeeHouse?
    
    private let storageManager = StorageManager.shared
    private var imageIsChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        saveButton.isEnabled = false
        coffeeHouseName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func saveCoffeeHouse() {
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
        
        if let currentCoffeeHouse = currentCoffeeHouse {
            storageManager.edit(currentCoffeeHouse, newCoffeeHouse: newCoffeeHouse)
        } else {
            storageManager.save(newCoffeeHouse)
        }
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

// MARK: - Setup
extension NewCoffeeHouseViewController {
    private func setupEditScreen() {
        if currentCoffeeHouse != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            
            guard let data = currentCoffeeHouse?.imageData,
                    let image = UIImage(data: data) else { return }
            
            coffeeHouseImage.image = image
            coffeeHouseImage.contentMode = .scaleAspectFill
            coffeeHouseName.text = currentCoffeeHouse?.name
            coffeeHouseLocation.text = currentCoffeeHouse?.location
            coffeeHouseType.text = currentCoffeeHouse?.type
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            topItem.backBarButtonItem?.tintColor = UIColor(
                cgColor: CGColor(
                    red: 204 / 255,
                    green: 153 / 255,
                    blue: 102 / 255,
                    alpha: 1
                )
            )
        }
        
        navigationItem.leftBarButtonItem = nil
        title = currentCoffeeHouse?.name
        saveButton.isEnabled = true
    }
}

// MARK: Text field delegate
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

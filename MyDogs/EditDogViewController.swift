//
//  EditDogViewController.swift
//  MyDogs
//
//  Created by admin on 14/12/2021.
//

import UIKit

class EditDogViewController: UIViewController {
    
    //MARK: Create Object for the Protocol to Pass the Data
    weak var controlDogsDelegate: ControlDogsDelegate?
    
    //MARK: Creat Variables that Will Get Data From Image Collection Class to be Edit
    var dogInformation: DogList?
    var indexPath: NSIndexPath?
    
    //Saving Default Image To Chaeck if User Choose Image
    var currentImage = UIImage()

    //MARK: Connect UIKit
    @IBOutlet weak var dogNameTextField: UITextField!
    @IBOutlet weak var dogColorTextField: UITextField!
    @IBOutlet weak var dogTreatTextField: UITextField!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var deleteDogButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting data inside the IB Outlets
        dogNameTextField.text = dogInformation?.name
        dogColorTextField.text = dogInformation?.color
        dogTreatTextField.text = dogInformation?.treat
        dogImageView.image = UIImage(data: (dogInformation?.photo)!)
        //setting the view
        designView()
        //saveing the current image to check
        currentImage = dogImageView.image!
    }

    //MARK: Action to Select the Photo
    @IBAction func addImageButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        //picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    //MARK: Action to Delete Data
    @IBAction func deleteDogButton(_ sender: UIButton) {
        controlDogsDelegate?.deletingDog(dogList: dogInformation!)
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Action to Dismes View
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Action to Save Data
    @IBAction func saveDogButton(_ sender: UIBarButtonItem) {
        if checkEntry() {
            //send data
            guard let dogName = dogNameTextField.text else { return }
            guard let dogColor = dogColorTextField.text else { return }
            guard let dogTreat = dogTreatTextField.text else { return }
            guard let dogImage = dogImageView.image?.pngData() else { return }
            controlDogsDelegate?.savingDog(name: dogName, color: dogColor, treat: dogTreat, photo: dogImage, indexPath: indexPath)
            //Back To Main View
            dismiss(animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "WARNING", message: "Please Enter Cheanged Values", preferredStyle: .alert)
            alert.view.backgroundColor = .red
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: Function To Check All Entry
    func checkEntry() -> Bool {
        var check = false
        guard let dogName = dogNameTextField.text else { return false }
        guard let dogColor = dogColorTextField.text else { return false }
        guard let dogTreat = dogTreatTextField.text else { return false }
        if dogName != dogInformation?.name && !dogName.isEmpty {
            check = true
        }
        if dogColor != dogInformation?.color && !dogColor.isEmpty {
            check = true
        }
        if dogTreat != dogInformation?.treat && !dogTreat.isEmpty {
            check = true
        }
        if dogImageView.image != currentImage {
            check = true
        }
        return check
    }
    
    //MARK: Function For Designing My View
    func designView() {
        dogNameTextField.layer.borderWidth = 2
        dogNameTextField.layer.borderColor = UIColor.black.cgColor
        dogNameTextField.layer.backgroundColor = UIColor.white.cgColor
        dogNameTextField.layer.cornerRadius = 20
        dogColorTextField.layer.borderWidth = 2
        dogColorTextField.layer.borderColor = UIColor.black.cgColor
        dogColorTextField.layer.backgroundColor = UIColor.white.cgColor
        dogColorTextField.layer.cornerRadius = 20
        dogTreatTextField.layer.borderWidth = 2
        dogTreatTextField.layer.borderColor = UIColor.black.cgColor
        dogTreatTextField.layer.backgroundColor = UIColor.white.cgColor
        dogTreatTextField.layer.cornerRadius = 20
        deleteDogButton.layer.borderWidth = 2
        deleteDogButton.layer.borderColor = UIColor.orange.cgColor
        deleteDogButton.layer.cornerRadius = 25
        addImageButton.titleLabel?.shadowOffset = CGSize(width: 2, height: 2)
        addImageButton.titleLabel?.shadowColor = .white
    }
}

//MARK: We Extend UIImagePickerControllerDelegate so We Can Call the Image Picker
extension EditDogViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Picking Image Function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let userPickedImage = info[.originalImage] as? UIImage else { return }
        //.originalImage can change to .editImage if we set picker.allowsEditing = true
        dogImageView.image = userPickedImage
        picker.dismiss(animated: true)
    }
}

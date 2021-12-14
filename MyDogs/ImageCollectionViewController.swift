//
//  ViewController.swift
//  MyDogs
//
//  Created by admin on 14/12/2021.
//

import UIKit
import CoreData

class ImageCollectionViewController: UICollectionViewController {
    
    //MARK: Create Needed Variables
    var list = [DogList]()
    
    //MARK: Create Needed CoreData Objects
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let save = (UIApplication.shared.delegate as! AppDelegate).saveContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fetching Data From Database
        fetchingAllDogs()
    }
    
    //MARK: Fetching Data From Database
    func fetchingAllDogs() {
        let dogResult: NSFetchRequest<DogList> = DogList.fetchRequest()
        do {
            list = try context.fetch(dogResult)
        }catch {
            print(error)
        }
        collectionView.reloadData()
    }
    
    //MARK: Create Prepare Function to Set Delegates and Send Data to Edit Class
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditSegue" {
            let destination = segue.destination as! UINavigationController
            let editViewController = destination.topViewController as! EditDogViewController
            editViewController.controlDogsDelegate = self
            if let indexPath = sender as? NSIndexPath {
                editViewController.dogInformation = list[indexPath.row]
                editViewController.indexPath = indexPath
            }
        }else {
            let addNewViewCotroller = segue.destination as! AddNewViewController
            addNewViewCotroller.controlDogsDelegate = self
        }
    }

    //MARK: ALL Collection View Needed Functions
    
    //MARK: Create Items Depending on Number of Data
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    //MARK: Creating Our Collection Cells And Append Data to it
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! CustomCollectionViewCell
        cell.dogImageView.image = UIImage(data: list[indexPath.row].photo!)
        cell.dogNameLabel.text = list[indexPath.row].name
        return cell
    }
    //MARK: Go to Edit Page When Cell Clecked
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "EditSegue", sender: indexPath)
    }
}

//MARK: Extension My Protocol to Save the New Data
extension ImageCollectionViewController: ControlDogsDelegate {
    func savingDog(name: String, color: String, treat: String, photo: Data, indexPath: NSIndexPath?) {
        if let ip = indexPath?.row {
            list[ip].name = name
            list[ip].color = color
            list[ip].treat = treat
            list[ip].photo = photo
        }
        else {
            let newItem = DogList(context: context)
            newItem.name = name
            newItem.color = color
            newItem.treat = treat
            newItem.photo = photo
        }
        save()
        fetchingAllDogs()
    }
}

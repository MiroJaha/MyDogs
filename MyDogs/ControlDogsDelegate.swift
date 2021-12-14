//
//  ControlDogs.swift
//  MyDogs
//
//  Created by admin on 14/12/2021.
//

import Foundation

protocol ControlDogsDelegate: AnyObject {
    func savingDog (name: String, color: String, treat:String, photo: Data, indexPath: NSIndexPath?)
}

//
//  PersistentContainerSettable.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 15/05/2016.


import Foundation
import CoreData

public protocol PersistentContainerSettable: class {
    var persistentContainer: NSPersistentContainer! { get set }
}
